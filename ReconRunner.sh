#!/bin/bash

CONFIG_FILE="$HOME/.reconrunner/wordlists-config.json"
BASE_OUTPUT_DIR="reconrunner_output"
SKIP_SAVE=false
SHOULD_CLEANUP=false
PROTOCOL="http"
USE_WILDCARD=false
WILDCARD_DOMAIN=""
version="0.6"

# Function to display help
display_help() {
    echo "ReconRunner"
    echo "Version: 0.6"
    echo ""
    echo "Usage: reconrunner <enum_type> <ip> [--https] [--cw <custom_wordlist>] [--cl <custom_list>] [--wildcard <wildcard_domain>] [--extra <extra_options>] [--skip-save] [-f <file>]"
    echo
    echo "Help:"
    echo "  --help                       Prints this message"
    echo "  dirs --help                  Prints all options for dirs"
    echo "  subs --help                  Prints all options for subs"
    echo "  sql --help                   Prints all options for sql"
    echo
    echo "Available types:"
    echo "  dirs    Directory/file enumeration (tool: gobuster)"
    echo "  subs    Subdomain enumeration (tool: wfuzz)"
    echo "  sql     SQL Injection detection (tool: sqlmap)"
    echo
    echo "Options:"
    echo "  <enum_type>                  The type of enumeration (e.g., dirs, subs, sql)."
    echo "  <ip>                         The target IP address or domain (for dirs and subs)."
    echo "  -u <url>                     The target URL (for sql)."
    echo "  -f <file>                    The request file (for sql)."
    echo "  --https                      (Optional) Use HTTPS protocol instead of HTTP."
    echo "  --cw <custom_wordlist>       (Optional) Use a custom wordlist instead of the default wordlists."
    echo "  --cl <custom_list>           (Optional) Use a custom list of wordlists from the config file."
    echo "  --wildcard <wildcard_domain> (Optional) Use wildcard in the Host header for subdomain enumeration."
    echo "  --extra <extra_options>      (Optional) Additional options for the enumeration tool."
    echo "  --skip-save                  (Optional) Skip saving results to files."
    echo
    echo "Configuration commands:"
    echo "  reconrunner config --add-wordlist <path to wordlist> --to <type>"
    echo "  reconrunner config --remove-wordlist <path to wordlist> --from <type>"
    echo "  reconrunner config --create-list <name>"
    echo "  reconrunner config --remove-list <name>"
    echo "  reconrunner config --list-info"
    echo
    echo "Examples:"
    echo "  reconrunner dirs example.com"
    echo "  reconrunner dirs example.com --https"
    echo "  reconrunner dirs example.com --cw /path/to/custom_wordlist.txt --extra '--delay=500ms'"
    echo
    echo "  reconrunner subs example.com"
    echo "  reconrunner subs example.com --cw /path/to/custom_wordlist.txt --wildcard test-*.example.com --extra '--timeout=30 --rate=100'"
    echo
    echo "  reconrunner sql -u http://example.com/vulnerable.php?id=1"
    echo "  reconrunner sql -f /path/to/request_file.txt"
    exit 0
}

# Function to display tool help
display_tool_help() {
    local tool="$1"
    case "$tool" in
        gobuster)
            echo "Displaying gobuster help..."
            gobuster dir --help
            ;;
        ffuf)
            echo "Displaying ffuf help..."
            ffuf --help
            ;;
        sqlmap)
            echo "Displaying sqlmap help..."
            sqlmap --help
            ;;
        *)
            echo "Error: Unknown tool '${tool}'."
            display_help
            ;;
    esac
    exit 0
}

# Function to clean up on exit
cleanup() {
    if [ "$SHOULD_CLEANUP" = true ]; then
        echo "Cleaning up..."
        [ -f "$TEMP_FILE" ] && rm -f "$TEMP_FILE"
        if [ "$SKIP_SAVE" = false ] && [ "$ENUM_TYPE" != "sql" ]; then
            echo "Results saved in: $OUTPUT_DIR"
        fi
    fi
    exit 1
}

# Trap CTRL+C (SIGINT) signal and call the cleanup function
trap cleanup SIGINT

# Check if the help option is provided for a specific tool
if [ "$#" -gt 1 ] && [ "$2" == "--help" ]; then
    case "$1" in
        dirs)
            display_tool_help "gobuster"
            ;;
        subs)
            display_tool_help "ffuf"
            ;;
        sql)
            display_tool_help "sqlmap"
            ;;
        *)
            echo "Error: Unknown enumeration type '${1}'."
            display_help
            ;;
    esac
fi

# Check if the help option is provided for the script
if [ "$#" -gt 0 ] && [ "$1" == "--help" ]; then
    display_help
fi

# Function to load wordlists from the config file
load_wordlists() {
    local type="$1"
    wordlists=$(jq -r --arg type "$type" '.[$type][]? // empty' "$CONFIG_FILE")
    if [ -z "$wordlists" ]; then
        echo "Error: No wordlists found for type '${type}' in the configuration file."
        exit 1
    fi
    echo "$wordlists"
}


# Function to load wordlists from a custom list
load_custom_wordlists() {
    local list_name="$1"
    custom_list=$(jq -r --arg list "$list_name" '.[$list] // empty' "$CONFIG_FILE")
    if [ -z "$custom_list" ]; then
        echo "Error: No custom list found with the name '${list_name}' in the configuration file."
        exit 1
    fi
    jq -r --arg list "$list_name" '.[$list][]? // empty' "$CONFIG_FILE"
}

# Function to add a wordlist to a specific list
add_wordlist() {
    local type="$1"
    local wordlist="$2"
    jq --arg type "$type" --arg wordlist "$wordlist" '(.[$type]) += [$wordlist]' "$CONFIG_FILE" > "$CONFIG_FILE.tmp" && mv "$CONFIG_FILE.tmp" "$CONFIG_FILE"
    echo "Wordlist '$wordlist' added to '$type'."
}

# Function to remove a wordlist from a specific list
remove_wordlist() {
    local type="$1"
    local wordlist="$2"
    jq --arg type "$type" --arg wordlist "$wordlist" '(.[$type]) |= map(select(. != $wordlist))' "$CONFIG_FILE" > "$CONFIG_FILE.tmp" && mv "$CONFIG_FILE.tmp" "$CONFIG_FILE"
    echo "Wordlist '$wordlist' removed from '$type'."
}

# Function to create a new list
create_list() {
    local name="$1"
    jq --arg name "$name" '.[$name] = []' "$CONFIG_FILE" > "$CONFIG_FILE.tmp" && mv "$CONFIG_FILE.tmp" "$CONFIG_FILE"
    echo "List '$name' created."
}

# Function to remove a list
remove_list() {
    local name="$1"
    jq --arg name "$name" 'del(.[$name])' "$CONFIG_FILE" > "$CONFIG_FILE.tmp" && mv "$CONFIG_FILE.tmp" "$CONFIG_FILE"
    echo "List '$name' removed."
}

# Function to list all wordlists
list_info() {
    echo "Wordlists Configuration:"
    jq -r 'to_entries[] | "\(.key):\n\t\(.value | join("\n\t"))"' "$CONFIG_FILE"
}

# Configuration command handling
if [ "$#" -gt 0 ] && [ "$1" == "config" ]; then
    shift
    case "$1" in
        --add-wordlist)
            if [ "$#" -gt 3 ] && [ "$3" == "--to" ]; then
                add_wordlist "${4,,}" "$2" # convert to lowercase
            else
                echo "Usage: reconrunner config --add-wordlist <path to wordlist> --to <type>"
            fi
            exit 0
            ;;
        --remove-wordlist)
            if [ "$#" -gt 3 ] && [ "$3" == "--from" ]; then
                remove_wordlist "${4,,}" "$2" # convert to lowercase
            else
                echo "Usage: reconrunner config --remove-wordlist <path to wordlist> --from <type>"
            fi
            exit 0
            ;;
        --create-list)
            if [ "$#" -gt 1 ]; then
                create_list "${2,,}" # convert to lowercase
            else
                echo "Usage: reconrunner config --create-list <name>"
            fi
            exit 0
            ;;
        --remove-list)
            if [ "$#" -gt 1 ]; then
                remove_list "${2,,}" # convert to lowercase
            else
                echo "Usage: reconrunner config --remove-list <name>"
            fi
            exit 0
            ;;
        --list-info)
            list_info
            exit 0
            ;;
        *)
            echo "Unknown config command."
            display_help
            ;;
    esac
fi

# Check if the correct number of arguments is provided
if [ "$#" -lt 2 ]; then
    echo "Error: Insufficient arguments provided."
    display_help
fi

# Define ENUM_TYPE based on the first argument
ENUM_TYPE="$1"
shift

# Define IP or URL based on the enumeration type
if [ "$ENUM_TYPE" == "dirs" ] || [ "$ENUM_TYPE" == "subs" ]; then
    IP="$1"
    URL="${PROTOCOL}://${IP}/"
    shift
    FORMAT=""
    SOURCE_TYPE="url"
elif [ "$ENUM_TYPE" == "sql" ]; then
    if [ "$1" == "-u" ]; then
        URL="$2"
        shift 2
        SOURCE_TYPE="url"
    elif [ "$1" == "-f" ]; then
        REQUEST_FILE="$2"
        shift 2
        SOURCE_TYPE="file"
    else
        echo "Usage: reconrunner sql [-u <url> | -f <file>]"
        exit 1
    fi
    FORMAT=""
    while [ "$#" -gt 0 ]; do
        case "$1" in
            --format)
                if [ "$#" -gt 1 ]; then
                    FORMAT="$2"
                    shift 2
                else
                    echo "Usage: reconrunner sql [-u <url> | -f <file>] [--format <format>]"
                    exit 1
                fi
                ;;
            *)
                echo "Unknown option $1"
                exit 1
                ;;
        esac
    done
    FORMATTING=""
    [ "$SOURCE_TYPE" == "url" ] && URL="${URL}/"
    [ -n "$FORMAT" ] && FORMATTING="--output-format=$FORMAT"
else
    echo "Error: Unknown enumeration type '${ENUM_TYPE}'."
    display_help
fi

# Process remaining extra options
EXTRA_OPTIONS=""
CUSTOM_LIST=""
CUSTOM_WORDLIST=""
while [ "$#" -gt 0 ]; do
    case "$1" in
        --extra)
            if [ "$#" -gt 1 ]; then
                EXTRA_OPTIONS="$2"
                shift 2
            else
                echo "Usage: reconrunner [--extra <extra_options>]"
                exit 1
            fi
            ;;
        --wildcard)
            if [ "$#" -gt 1 ]; then
                USE_WILDCARD=true
                WILDCARD_DOMAIN="$2"
                shift 2
            else
                echo "Usage: reconrunner --wildcard <wildcard_domain>"
                exit 1
            fi
            ;;
        --skip-save)
            SKIP_SAVE=true
            shift
            ;;
        --https)
            PROTOCOL="https"
            shift
            ;;
        --cl)
            if [ "$#" -gt 1 ]; then
                CUSTOM_LIST="$2"
                shift 2
            else
                echo "Usage: reconrunner --cl <custom_list>"
                exit 1
            fi
            ;;
        --cw)
            if [ "$#" -gt 1 ]; then
                CUSTOM_WORDLIST="$2"
                shift 2
            else
                echo "Usage: reconrunner --cw <custom_wordlist>"
                exit 1
            fi
            ;;
        *)
            echo "Unknown option $1"
            exit 1
            ;;
    esac
done

# Determine the wordlists to use
determine_wordlists() {
    if [ -n "$CUSTOM_WORDLIST" ]; then
        wordlists="$CUSTOM_WORDLIST"
    elif [ -n "$CUSTOM_LIST" ]; then
        wordlists=$(load_custom_wordlists "$CUSTOM_LIST")
    else
        # Default to 'dns' wordlists if the type is 'subs'
        wordlists=$(load_wordlists "$ENUM_TYPE")
        [ "$ENUM_TYPE" == "subs" ] && wordlists=$(load_wordlists "dns")
    fi

    # Check if wordlists are empty
    if [ -z "$wordlists" ]; then
        echo "Error: No wordlists found for type '${ENUM_TYPE}'."
        exit 1
    fi
}

# Ensure the host is reachable
check_host_reachable() {
    if ! curl -s --head "${URL}" | head -n 1 | grep "HTTP/[12][.][0-9] [23].."; then
        echo "Error: The host ${URL} is not reachable."
        exit 1
    fi
}

# Define `find_next_index` function
find_next_index() {
    local ip="$1"
    local enum_type="$2"
    local ext="$3"
    local index=1
    while [ -f "${BASE_OUTPUT_DIR}/${enum_type}/${ip}_${index}.${ext}" ]; do
        index=$((index + 1))
    done
    echo "$index"
}

# Define `generate_output_file_name` function
generate_output_file_name() {
    local ip="$1"
    local enum_type="$2"
    local index="$3"
    local ext="$4"
    echo "${BASE_OUTPUT_DIR}/${enum_type}/${ip}_${index}.${ext}"
}

# Ensure the host is reachable
[ "$ENUM_TYPE" != "sql" ] && check_host_reachable

# Set flag to clean up since we are proceeding
SHOULD_CLEANUP=true

# Ensure the output directory exists if results are to be saved
if [ "$SKIP_SAVE" = false ] && [ "$ENUM_TYPE" != "sql" ]; then
    mkdir -p "$BASE_OUTPUT_DIR"
    OUTPUT_DIR="$BASE_OUTPUT_DIR/$ENUM_TYPE"
    mkdir -p "$OUTPUT_DIR"
fi

# Determine wordlists to use
determine_wordlists

# Run the appropriate function based on the enumeration type
index=$(find_next_index "$IP" "$ENUM_TYPE" "txt") # Use "txt" for dirs
case "$ENUM_TYPE" in
    dirs)
        for wordlist in $wordlists; do
            output_file=""
            if [ "$SKIP_SAVE" = true ]; then
                echo ""
            else
                output_file=$(generate_output_file_name "$IP" "dirs" "$index" "txt")
                echo ""
            fi
            gobuster dir -u "$URL" -w "$wordlist" -o "$output_file" --no-color -q $EXTRA_OPTIONS
            [ $? -ne 0 ] && echo "Error: error on running gobuster: unable to connect to $URL" && cleanup
            [ "$SKIP_SAVE" = false ] && sed -i 's/\x1b\[[0-9;]*m//g' "$output_file"
            ((index++))
        done
        ;;
    subs)
        index=$(find_next_index "$IP" "subs" "txt") # Use "json" for subs
        for wordlist in $wordlists; do
            output_file=""
            if [ "$SKIP_SAVE" = true ]; then
                echo ""
            else
                output_file=$(generate_output_file_name "$IP" "subs" "$index" "txt")
                echo ""
            fi
            if $USE_WILDCARD; then
                wfuzz -c -w "$wordlist" -u "${PROTOCOL}://${IP}/" -H "Host: ${WILDCARD_DOMAIN//\*/FUZZ}" -f "$output_file" $EXTRA_OPTIONS
            else
                wfuzz -c -w "$wordlist" -u "${PROTOCOL}://${IP}/" -H "Host: FUZZ.${IP}" -f "$output_file" $EXTRA_OPTIONS
            fi
            [ $? -ne 0 ] && echo "Error: error on running ffuf: unable to connect to $URL" && cleanup
            ((index++))
        done
        ;;
    sql)
        if [ "$SOURCE_TYPE" == "url" ]; then
            sqlmap -u "$URL" $FORMATTING $EXTRA_OPTIONS
        elif [ "$SOURCE_TYPE" == "file" ]; then
            sqlmap -r "$REQUEST_FILE" $FORMATTING $EXTRA_OPTIONS
        fi
        [ $? -ne 0 ] && echo "Error: error on running sqlmap: unable to connect to $URL" && cleanup
        ;;
    *)
        echo "Error: Unknown enumeration type '${ENUM_TYPE}'."
        display_help
        ;;
esac

# Final cleanup
cleanup

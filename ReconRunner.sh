#!/bin/bash

CONFIG_FILE="$HOME/.reconrunner/wordlists-config.json"
LOG_FILE="reconrunner.log"
BASE_OUTPUT_DIR="reconrunner_output"

# Function to display help
display_help() {
    echo "Usage: reconrunner <enum_type> <ip> [--https] [--cw <custom_wordlist>] [--cl <custom_list>] [--wildcard <wildcard_domain>] [--extra <extra_options>]"
    echo
    echo "Help:"
    echo "  --help                       Prints this message"
    echo "  dirs --help                  Prints all options for dirs"
    echo "  subs --help                  Prints all options for subs"
    echo
    echo "Available types:"
    echo "  dirs    Directory/file enumeration (tool: gobuster)"
    echo "  subs    Subdomain enumeration (tool: ffuf)"
    echo
    echo "Options:"
    echo "  <enum_type>                  The type of enumeration (e.g., dirs, subs)."
    echo "  <ip>                         The target IP address or domain."
    echo "  --https                      (Optional) Use HTTPS protocol instead of HTTP."
    echo "  --cw <custom_wordlist>       (Optional) Use a custom wordlist instead of the default wordlists."
    echo "  --cl <custom_list>           (Optional) Use a custom list of wordlists from the config file."
    echo "  --wildcard <wildcard_domain> (Optional) Use wildcard in the Host header for subdomain enumeration."
    echo "  --extra <extra_options>      (Optional) Additional options for the enumeration tool."
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
    exit 0
}

# Function to display gobuster help
display_gobuster_help() {
    echo "Displaying gobuster help..."
    gobuster dir --help
    exit 0
}

# Function to display ffuf help
display_ffuf_help() {
    echo "Displaying ffuf help..."
    ffuf --help
    exit 0
}

# Function to log messages
log_message() {
    echo "$1" >> "$LOG_FILE"
}

# Function to clean up on exit
cleanup() {
    echo ""
    echo "Cleaning up..."
    if [ -f "$TEMP_FILE" ]; then
        rm -f "$TEMP_FILE"
    fi
    echo "Results saved in: $OUTPUT_DIR" # Ensure OUTPUT_DIR is logged
    exit 1
}

# Trap CTRL+C (SIGINT) signal and call the cleanup function
trap cleanup SIGINT

# Check if the help option is provided for a specific tool
if [ "$#" -gt 1 ] && [ "$2" == "--help" ]; then
    case "$1" in
        dirs)
            display_gobuster_help
            ;;
        subs)
            display_ffuf_help
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
    jq -r --arg type "$type" '.[$type][]' "$CONFIG_FILE"
}

# Function to load wordlists from a custom list
load_custom_wordlists() {
    local list_name="$1"
    jq -r --arg list "$list_name" '.[$list] | .[]' "$CONFIG_FILE"
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
                add_wordlist "${4,,}" # convert to lowercase
            else
                echo "Usage: reconrunner config --add-wordlist <path to wordlist> --to <type>"
            fi
            exit 0
            ;;
        --remove-wordlist)
            if [ "$#" -gt 3 ] && [ "$3" == "--from" ]; then
                remove_wordlist "${4,,}" # convert to lowercase
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
    display_help
fi

# Enumeration type and base URL
ENUM_TYPE="$1"
IP="$2"
shift 2
PROTOCOL="http"
USE_WILDCARD=false
WILDCARD_DOMAIN=""
EXTRA_OPTIONS=""
CUSTOM_LIST=""

# Function to process extra options
process_extra_options() {
    while [ "$#" -gt 0 ]; do
        case "$1" in
            --https | --cw | --cl | --wildcard | --extra)
                break
                ;;
            *)
                EXTRA_OPTIONS+="$1 "
                shift
                ;;
        esac
    done
}

# Check for --https flag
if [ "$#" -gt 0 ] && [ "$1" == "--https" ]; then
    PROTOCOL="https"
    shift
fi
URL="${PROTOCOL}://${IP}/"

# Check for --wildcard flag
if [ "$#" -gt 0 ] && [ "$1" == "--wildcard" ]; then
    if [ "$#" -gt 1 ]; then
        USE_WILDCARD=true
        WILDCARD_DOMAIN="$2"
        shift 2
    else
        echo "Usage: reconrunner <enum_type> <ip> [--https] [--cw <custom_wordlist>] [--cl <custom_list>] [--wildcard <wildcard_domain>] [--extra <extra_options>]"
        exit 1
    fi
fi

# Check for --cw flag
if [ "$#" -gt 0 ] && [ "$1" == "--cw" ]; then
    if [ "$#" -gt 1 ]; then
        CUSTOM_LIST="$2"
        shift 2
    else
        echo "Usage: reconrunner <enum_type> <ip> [--https] [--cw <custom_wordlist>] [--cl <custom_list>] [--wildcard <wildcard_domain>] [--extra <extra_options>]"
        exit 1
    fi
fi

# Check for --cl flag
if [ "$#" -gt 0 ] && [ "$1" == "--cl" ]; then
    if [ "$#" -gt 1 ]; then
        CUSTOM_LIST="$2"
        shift 2
    else
        echo "Usage: reconrunner <enum_type> <ip> [--https] [--cw <custom_wordlist>] [--cl <custom_list>] [--wildcard <wildcard_domain>] [--extra <extra_options>]"
        exit 1
    fi
fi

# Process any extra options
process_extra_options "$@"

# Function to find the next available index for output files
find_next_index() {
    local base_name="$1"
    local type="$2"
    local highest_index=0
    local pattern="${base_name}-${type}-*.txt"

    for file in ${BASE_OUTPUT_DIR}/${type}/${pattern}; do
        if [[ -f "$file" ]]; then
            index=$(echo "$file" | grep -oP '(?<=-)[0-9]+(?=\.)' | sort -n | tail -n 1)
            if [[ $index -gt $highest_index ]]; then
                highest_index=$index
            fi
        fi
    done

    echo $((highest_index + 1))
}

# Function to generate a unique output file name
generate_output_file_name() {
    local base_name="$1"
    local type="$2"
    local index="$3"
    local extension="$4"
    echo "${BASE_OUTPUT_DIR}/${type}/${base_name}-${type}-${index}.${extension}"
}

# Create the output directory
OUTPUT_DIR="${BASE_OUTPUT_DIR}/${ENUM_TYPE}"
mkdir -p "$OUTPUT_DIR" || { echo "Error: Cannot create directory '$OUTPUT_DIR'"; exit 1; }

# Determine wordlists to use
if [ -n "$CUSTOM_LIST" ]; then
    wordlists=$(load_custom_wordlists "$CUSTOM_LIST")
else
    wordlists=$(load_wordlists "$ENUM_TYPE")
fi

# Run the appropriate function based on the enumeration type
index=$(find_next_index "$IP" "$ENUM_TYPE")

case "$ENUM_TYPE" in
    dirs)
        for wordlist in $wordlists; do
            output_file=$(generate_output_file_name "$IP" "dirs" "$index" "txt")
            log_message "Running gobuster with wordlist: $wordlist"
            gobuster dir -u "$URL" -w "$wordlist" -o "$output_file" --no-color -q $EXTRA_OPTIONS
            # Remove ANSI escape codes and other unwanted characters
            sed -i 's/\x1b\[[0-9;]*m//g' "$output_file"
            ((index++))
        done
        ;;
    subs)
        for wordlist in $wordlists; do
            output_file=$(generate_output_file_name "$IP" "subs" "$index" "json")
            if $USE_WILDCARD; then
                # Replace wildcard domain in the header with 'FUZZ' at the correct location
                ffuf -c -w "$wordlist" -u "${PROTOCOL}://${IP}/" -H "Host: ${WILDCARD_DOMAIN//\*/FUZZ}" -o "$output_file" -of json $EXTRA_OPTIONS
            else
                # Use regular Host header for subdomain enumeration with FUZZ at the end
                ffuf -c -w "$wordlist" -u "${PROTOCOL}://${IP}/" -H "Host: FUZZ.${IP}" -o "$output_file" -of json $EXTRA_OPTIONS
            fi
            ((index++))
        done
        ;;
    *)
        echo "Error: Unknown enumeration type '${ENUM_TYPE}'."
        display_help
        ;;
esac

# Final cleanup
cleanup

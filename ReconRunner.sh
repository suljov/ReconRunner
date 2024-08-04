#!/bin/bash

CONFIG_DIR="$HOME/.reconrunner"
CONFIG_FILE="$CONFIG_DIR/wordlists-config.json"

# Default wordlists configuration in JSON format
DEFAULT_CONFIG='{
    "LFI": [],
    "subs": ["/usr/share/wordlists/seclists/Discovery/DNS/subdomains-top1million-110000.txt", "/usr/share/wordlists/seclists/Discovery/DNS/combined_subdomains.txt"],
    "dirs": ["/usr/share/wordlists/seclists/Discovery/Web-Content/quickhits.txt", "/usr/share/wordlists/seclists/Discovery/Web-Content/directory-list-2.3-medium.txt"],
    "SQL": [],
    "OSinjection": []
}'

# Create config directory and file if they don't exist
mkdir -p "$CONFIG_DIR"
if [ ! -f "$CONFIG_FILE" ]; then
    echo "$DEFAULT_CONFIG" > "$CONFIG_FILE"
fi

# Function to display help
display_help() {
    echo "Usage: reconrunner <enum_type> <ip> [--https] [--cw <custom_wordlist>] [--wildcard <wildcard_domain>] [--extra <extra_options>]"
    echo
    echo "Help:"
    echo "  --help                       Prints this message"
    echo "  dirs --help                  Prints all options for dirs"
    echo "  subs --help                  Prints all options for subs"
    echo
    echo "  reconrunner dirs --help"
    echo "  reconrunner subs --help"
    echo
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

# Function to clean up on exit
cleanup() {
    echo "Cleaning up..."
    if [ -f "$TEMP_FILE" ]; then
        rm -f "$TEMP_FILE"
    fi
    echo "Results saved to: $OUTPUT_FILE"
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
                add_wordlist "$4" "$2"
            else
                echo "Usage: reconrunner config --add-wordlist <path to wordlist> --to <type>"
            fi
            exit 0
            ;;
        --remove-wordlist)
            if [ "$#" -gt 3 ] && [ "$3" == "--from" ]; then
                remove_wordlist "$4" "$2"
            else
                echo "Usage: reconrunner config --remove-wordlist <path to wordlist> --from <type>"
            fi
            exit 0
            ;;
        --create-list)
            if [ "$#" -gt 1 ]; then
                create_list "$2"
            else
                echo "Usage: reconrunner config --create-list <name>"
            fi
            exit 0
            ;;
        --remove-list)
            if [ "$#" -gt 1 ]; then
                remove_list "$2"
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

# Function to process extra options
process_extra_options() {
    while [ "$#" -gt 0 ]; do
        case "$1" in
            --https | --cw | --wildcard | --extra)
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
    USE_WILDCARD=true
    WILDCARD_DOMAIN="$2"
    shift 2
fi

# Check for --extra flag and capture all following options
if [ "$#" -gt 0 ] && [ "$1" == "--extra" ]; then
    shift
    process_extra_options "$@"
    set --
fi

# Check if the host is reachable
if ! curl -s --head "${URL}" | head -n 1 | grep "HTTP/[12][.][0-9] [23].."; then
    echo "Error: The host ${URL} is not reachable."
    exit 1
fi

# Set up output directories after checking reachability
BASE_OUTPUT_DIR="reconrunner_output"
OUTPUT_DIR="${BASE_OUTPUT_DIR}/${ENUM_TYPE}"
mkdir -p "$OUTPUT_DIR"

# Function to generate a unique output file name
generate_output_file_name() {
    local base_name="$1"
    local type="$2"
    local extension="$3"
    local counter=1
    local output_file="${OUTPUT_DIR}/${base_name}-${type}-${counter}.${extension}"
    while [ -f "$output_file" ]; do
        ((counter++))
        output_file="${OUTPUT_DIR}/${base_name}-${type}-${counter}.${extension}"
    done
    echo "$output_file"
}

if [ "$ENUM_TYPE" == "subs" ]; then
    OUTPUT_FILE=$(generate_output_file_name "$IP" "$ENUM_TYPE" "json")
else
    OUTPUT_FILE=$(generate_output_file_name "$IP" "$ENUM_TYPE" "txt")
fi

# Check for --cw flag
CUSTOM_WORDLIST=""
if [ "$#" -gt 0 ] && [ "$1" == "--cw" ]; then
    CUSTOM_WORDLIST="$2"
    shift 2
fi

# Load wordlists based on enumeration type
if [ -n "$CUSTOM_WORDLIST" ]; then
    WORDLISTS=("$CUSTOM_WORDLIST")
else
    WORDLISTS=($(load_wordlists "$ENUM_TYPE"))
fi

# Function to run gobuster with a given wordlist for directory enumeration
run_reconrunner_dirs() {
    local wordlist="$1"
    gobuster dir -u "$URL" -w "$wordlist" -o "$OUTPUT_FILE" --no-color -q $EXTRA_OPTIONS
    # Remove ANSI escape codes and other unwanted characters
    sed -i 's/\x1b\[[0-9;]*m//g' "$OUTPUT_FILE"
    echo "Gobuster results saved to $OUTPUT_FILE"
}

# Function to run ffuf for subdomain enumeration and save output as JSON
run_reconrunner_subs() {
    local wordlist="$1"
    if $USE_WILDCARD; then
        # Replace wildcard domain in the header with 'FUZZ' at the correct location
        ffuf -c -w "$wordlist" -u "${PROTOCOL}://${IP}/" -H "Host: ${WILDCARD_DOMAIN//\*/FUZZ}" -o "${OUTPUT_FILE}" -of json $EXTRA_OPTIONS
        echo "FFUF results with wildcard saved to ${OUTPUT_FILE}"
    else
        # Use regular Host header for subdomain enumeration with FUZZ at the end
        ffuf -c -w "$wordlist" -u "${PROTOCOL}://${IP}/" -H "Host: FUZZ.${IP}" -o "${OUTPUT_FILE}" -of json $EXTRA_OPTIONS
        echo "FFUF results saved to ${OUTPUT_FILE}"
    fi
}

# Run the appropriate function based on the enumeration type
case "$ENUM_TYPE" in
    dirs)
        for wordlist in "${WORDLISTS[@]}"; do
            run_reconrunner_dirs "$wordlist"
        done
        ;;
    subs)
        for wordlist in "${WORDLISTS[@]}"; do
            run_reconrunner_subs "$wordlist"
        done
        ;;
    *)
        echo "Error: Unknown enumeration type '${ENUM_TYPE}'."
        display_help
        ;;
esac

# Final cleanup
cleanup

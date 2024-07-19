#!/bin/bash

# Function to display help
display_help() {
    echo "Usage: reconrunner <enum_type> <ip> [--https] [--cw <custom_wordlist>] [extra_tool_options]"
    echo
    echo "Help:"
    echo "  --help           Prints this message"
    echo "  dirs --help      Prints all options for dirs"
    echo "  subs --help      Prints all options for subs" 
    echo
    echo "reconrunner dirs --help"
    echo "reconrunner subs --help"
    echo
    echo "Available types:"
    echo "  dirs    Directory/file enumeration (tool: gobuster)"
    echo "  subs    Subdomain enumeration (tool: ffuf)"
    echo
    echo "Options:"
    echo "  <enum_type>              The type of enumeration (e.g., dirs, subs)."
    echo "  <ip>                     The target IP address or domain."
    echo "  --https                  (Optional) Use HTTPS protocol instead of HTTP."
    echo "  --cw <custom_wordlist>   (Optional) Use a custom wordlist before the default wordlists."
    echo "  [extra_tool_options]     (Optional) Additional options for the enumeration tool."
    echo
    echo "Examples:"
    echo "  reconrunner dirs 192.168.1.1"
    echo "  reconrunner dirs example.com --https"
    echo "  reconrunner dirs 192.168.1.1 --cw /path/to/custom_wordlist.txt --delay=500ms"
    echo
    echo "  reconrunner subs example.com"
    echo "  reconrunner subs example.com --cw /path/to/custom_wordlist.txt"
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

# Function to check if jq is installed
check_jq() {
    if ! command -v jq &> /dev/null; then
        echo "Error: jq is not installed."
        echo "jq is required for parsing JSON output."
        echo "Do you want to install jq? (y/n)"
        read -r response
        case "$response" in
            [Yy][Ee][Ss]|[Yy])
                echo "Installing jq..."
                sudo apt update && sudo apt install -y jq
                if [ $? -ne 0 ]; then
                    echo "Error: Failed to install jq. Exiting."
                    exit 1
                fi
                ;;
            *)
                echo "jq is required for this script. Exiting."
                exit 1
                ;;
        esac
    fi
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

# Check if the correct number of arguments is provided
if [ "$#" -lt 2 ]; then
    echo "Usage: reconrunner <enum_type> <ip> [--https] [--cw <custom_wordlist>] [extra_tool_options]"
    exit 1
fi

# Enumeration type and base URL
ENUM_TYPE="$1"
IP="$2"
shift 2
PROTOCOL="http"

# Check for --https flag
if [ "$#" -gt 0 ] && [ "$1" == "--https" ]; then
    PROTOCOL="https"
    shift
fi
URL="${PROTOCOL}://${IP}/"

# Check if the host is reachable
if ! curl -L -s --head "$URL" | head -n 1 | grep "HTTP/[12][.][0-9] [23].."; then
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

# Capture extra tool options if provided
EXTRA_OPTIONS="$*"

# List of wordlists for directory enumeration
DIR_WORDLISTS=(
    "/usr/share/wordlists/seclists/Discovery/Web-Content/quickhits.txt"
    "/usr/share/wordlists/seclists/Discovery/Web-Content/directory-list-2.3-medium.txt"
    # Add more wordlists here as needed
)

# List of wordlists for subdomain enumeration
SUBS_WORDLISTS=(
    "/usr/share/wordlists/seclists/Discovery/DNS/subdomains-top1million-110000.txt"
    "/usr/share/wordlists/seclists/Discovery/DNS/combined_subdomains.txt"
    # Add more wordlists here as needed
)

# Prepend the custom wordlist if provided
if [ -n "$CUSTOM_WORDLIST" ]; then
    if [ "$ENUM_TYPE" == "dirs" ]; then
        DIR_WORDLISTS=("$CUSTOM_WORDLIST" "${DIR_WORDLISTS[@]}")
    elif [ "$ENUM_TYPE" == "subs" ]; then
        SUBS_WORDLISTS=("$CUSTOM_WORDLIST" "${SUBS_WORDLISTS[@]}")
    fi
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
    ffuf -c -w "$wordlist" -u "${PROTOCOL}://$IP/" -H "HOST: FUZZ.${IP}" -o "${OUTPUT_FILE}" -of json $EXTRA_OPTIONS
    # Extract subdomain names from the JSON file and save to final output file
    jq -r '.results[].host | select(. | contains("FUZZ"))' "$OUTPUT_FILE" | sed 's/FUZZ\.//g' | sort -u > "${OUTPUT_FILE%.json}.txt"
    echo "FFUF results saved to ${OUTPUT_FILE%.json}.txt"
}

# Inform the user how to cancel
echo
echo "Running ReconRunner..."
echo "To cancel, press CTRL + C"
echo

# Run the appropriate enumeration based on the enum type
case "$ENUM_TYPE" in
    dirs)
        # Run gobuster for each wordlist
        for wordlist in "${DIR_WORDLISTS[@]}"; do
            run_reconrunner_dirs "$wordlist"
        done
        ;;
    subs)
        # Run ffuf for each wordlist
        for wordlist in "${SUBS_WORDLISTS[@]}"; do
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


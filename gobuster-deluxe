#!/bin/bash

# Function to display help
display_help() {
    echo "Usage: $0 <ip> [--https] [--cw <custom_wordlist>] [extra_gobuster_options]"
    echo
    echo "Options:"
    echo "  <ip>                         The target IP address or domain."
    echo "  --https                      (Optional) Use HTTPS protocol instead of HTTP."
    echo "  --cw <custom_wordlist>       (Optional) Use a custom wordlist before the default wordlists."
    echo "  [extra_gobuster_options]     (Optional) Additional options for the gobuster command."
    echo
    echo "Examples:"
    echo "  $0 192.168.1.1"
    echo "  $0 example.com --https"
    echo "  $0 192.168.1.1 --cw /path/to/custom_wordlist.txt"
    echo "  $0 example.com --https --cw /path/to/custom_wordlist.txt --delay=500ms"
    exit 0
}

# Function to clean up and exit
cleanup() {
    echo
    echo "Cleaning up..."
    if [ -f "$OUTPUT_FILE" ]; then
        awk '{print $1}' "$OUTPUT_FILE" > "$OUTPUT_DIR/cleaned_results.txt"
        echo "Clean results saved to: $OUTPUT_DIR/cleaned_results.txt"
        echo "Normal results saved to: $OUTPUT_DIR/gobuster_results.txt"
    fi
    exit 1
}

# Trap CTRL+C (SIGINT) signal and call the cleanup function
trap cleanup SIGINT

# Check if the help option is provided
if [ "$#" -gt 0 ] && [ "$1" == "--help" ]; then
    display_help
fi

# Check if the correct number of arguments is provided
if [ "$#" -lt 1 ]; then
    echo "Usage: $0 <ip> [--https] [--cw <custom_wordlist>] [extra_gobuster_options]"
    exit 1
fi

# Parse arguments
IP=""
PROTOCOL="http"
CUSTOM_WORDLIST=""
EXTRA_OPTIONS=""

while [[ "$#" -gt 0 ]]; do
    case $1 in
        --https) PROTOCOL="https"; shift ;;
        --cw) CUSTOM_WORDLIST="$2"; shift 2 ;;
        --help) display_help ;;
        --*) EXTRA_OPTIONS+="$1 "; shift ;;
        *) IP="$1"; shift ;;
    esac
done

if [ -z "$IP" ]; then
    echo "Usage: $0 <ip> [--https] [--cw <custom_wordlist>] [extra_gobuster_options]"
    exit 1
fi

URL="${PROTOCOL}://${IP}/"
OUTPUT_DIR="./gobuster_output"
OUTPUT_FILE="$OUTPUT_DIR/gobuster_results.txt"

# Check if the host is reachable
if ! curl --output /dev/null --silent --head --fail "$URL"; then
    echo "Error: The host $URL is not reachable."
    exit 1
fi

# Create output directory
mkdir -p "$OUTPUT_DIR"

# List of default wordlists
WORDLISTS=(
    "/usr/share/wordlists/seclists/Discovery/Web-Content/quickhits.txt"
    "/usr/share/wordlists/seclists/Discovery/Web-Content/directory-list-2.3-medium.txt"
    # Add more wordlists here as needed
)

# Prepend custom wordlist if provided
if [ -n "$CUSTOM_WORDLIST" ]; then
    WORDLISTS=("$CUSTOM_WORDLIST" "${WORDLISTS[@]}")
fi

# Function to run gobuster with a given wordlist
run_gobuster() {
    local wordlist="$1"
    gobuster dir -u "$URL" -w "$wordlist" $EXTRA_OPTIONS -q | tee -a "$OUTPUT_FILE"
}

# Display cancel message
echo
echo "To cancel, press CTRL + C"
echo

# Run gobuster for each wordlist
for wordlist in "${WORDLISTS[@]}"; do
    run_gobuster "$wordlist"
done

# Clean the output
awk '{print $1}' "$OUTPUT_FILE" > "$OUTPUT_DIR/cleaned_results.txt"

echo "Results saved to: $OUTPUT_DIR/cleaned_results.txt"


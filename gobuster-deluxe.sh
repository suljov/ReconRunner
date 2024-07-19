#!/bin/bash

# Function to display help
display_help() {
    echo "Usage: gobuster-deluxe <ip> [--https] [--cw <custom_wordlist>] [extra_gobuster_options]"
    echo
    echo "Options:"
    echo "  <ip>                     The target IP address or domain."
    echo "  --https                  (Optional) Use HTTPS protocol instead of HTTP."
    echo "  --cw <custom_wordlist>   (Optional) Use a custom wordlist before the default wordlists."
    echo "  [extra_gobuster_options] (Optional) Additional options for the gobuster command."
    echo
    echo "Examples:"
    echo "  gobuster-deluxe 192.168.1.1"
    echo "  gobuster-deluxe example.com --https"
    echo "  gobuster-deluxe 192.168.1.1 --cw /path/to/custom_wordlist.txt"
    echo "  gobuster-deluxe example.com --https --cw /path/to/custom_wordlist.txt --delay=500ms"
    exit 0
}

# Function to clean up on exit
cleanup() {
    echo "Cleaning up..."
    [ -n "$TEMP_RESULT_FILE" ] && rm -f "$TEMP_RESULT_FILE"
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

# Base URL and output file
IP="$1"
shift
PROTOCOL="http"

# Check for --https flag
if [ "$#" -gt 0 ] && [ "$1" == "--https" ]; then
    PROTOCOL="https"
    shift
fi
URL="${PROTOCOL}://${IP}/"
OUTPUT_DIR="gobuster_output"
OUTPUT_FILE="${OUTPUT_DIR}/gobuster_results.txt"
mkdir -p "$OUTPUT_DIR"

# Check for --cw flag
CUSTOM_WORDLIST=""
if [ "$#" -gt 0 ] && [ "$1" == "--cw" ]; then
    CUSTOM_WORDLIST="$2"
    shift 2
fi

# Capture extra gobuster options if provided
EXTRA_OPTIONS="$*"

# List of wordlists
WORDLISTS=(
    "/usr/share/wordlists/seclists/Discovery/Web-Content/quickhits.txt"
    "/usr/share/wordlists/seclists/Discovery/Web-Content/directory-list-2.3-medium.txt"
    # Add more wordlists here as needed
)

# Prepend the custom wordlist if provided
if [ -n "$CUSTOM_WORDLIST" ]; then
    WORDLISTS=("$CUSTOM_WORDLIST" "${WORDLISTS[@]}")
fi

# Function to run gobuster with a given wordlist
run_gobuster() {
    local wordlist="$1"
    gobuster dir -u "$URL" -w "$wordlist" $EXTRA_OPTIONS -q | tee -a "$OUTPUT_FILE"
}

# Check if the host is reachable
if ! curl -s --head "$URL" | head -n 1 | grep "HTTP/[12][.][0-9] [23].."; then
    echo "Error: The host ${URL} is not reachable."
    exit 1
fi

# Inform the user how to cancel
echo
echo "Running Gobuster Deluxe..."
echo "To cancel, press CTRL + C"
echo

# Run gobuster for each wordlist
for wordlist in "${WORDLISTS[@]}"; do
    run_gobuster "$wordlist"
done

# Clean and save the results
sort "$OUTPUT_FILE" | uniq > "${OUTPUT_DIR}/cleaned_gobuster_results.txt"
mv "${OUTPUT_DIR}/cleaned_gobuster_results.txt" "$OUTPUT_FILE"

echo "Results saved to: $OUTPUT_FILE"

# Gobuster Deluxe

Welcome to **Gobuster Deluxe** - a powerful, enhanced version of the popular Gobuster tool, designed to streamline and improve your directory and file brute-forcing experience. This script automates multiple wordlist usage, offers flexible protocol options, and ensures clean and organized output, all while keeping the user in control with intuitive command-line flags.

## Features

- **Protocol Flexibility**: Easily switch between HTTP and HTTPS protocols.
- **Custom Wordlists**: Start your brute-forcing with your custom wordlist before falling back on default ones.
- **Clean and Organized Output**: Results are automatically cleaned and saved in a user-friendly format.
- **Interactive Control**: Cancel the script anytime with CTRL + C without losing your progress.
- **Robust and User-Friendly**: Includes detailed help and usage instructions.


# Install

```
git clone https://github.com/suljov/Gobuster-deluxe
cd Gobuster-deluxe
chmod +x Gobuster-deluxe.sh
sudo cp Gobuster-deluxe.sh /usr/local/bin/gobuster-deluxe 
```

# Usage

```
$ gobuster-deluxe --help                   
Usage: gobuster-deluxe <ip> [--https] [--cw <custom_wordlist>] [extra_gobuster_options]

Options:
  <ip>                         The target IP address or domain.
  --https                      (Optional) Use HTTPS protocol instead of HTTP.
  --cw <custom_wordlist>       (Optional) Use a custom wordlist before the default wordlists.
  [extra_gobuster_options]     (Optional) Additional options for the gobuster command.

Examples:
  gobuster-deluxe 192.168.1.1
  gobuster-deluxe example.com --https
  gobuster-deluxe 192.168.1.1 --cw /path/to/custom_wordlist.txt
  gobuster-deluxe example.com --https --cw /path/to/custom_wordlist.txt --delay=500ms
```

# Examples

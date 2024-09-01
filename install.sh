#!/bin/bash

# Define the installed version directly in this script
INSTALLED_VERSION="0.6"  # Set this to the current installed version

# Check if reconrunner script exists
if [ -f /usr/local/bin/reconrunner ]; then
    # Load the reconrunner script safely to get the version variable
    version=$(grep -Po '(?<=version=").*?(?=")' /usr/local/bin/reconrunner)

    # Fallback if version is not found from grep
    if [ -z "$version" ]; then
        echo "Version variable not found in reconrunner script."
        exit 1
    fi

    # Compare versions
    if [ "$version" == "$INSTALLED_VERSION" ]; then
        echo "Version $version is up-to-date. Exiting."
        exit 0
    elif [ "$(echo -e "$version\n$INSTALLED_VERSION" | sort -V | head -n 1)" == "$INSTALLED_VERSION" ]; then
        echo "A newer version detected. Continuing with installation..."
        sudo rm /usr/local/bin/reconrunner
    else
        echo "Installed version is newer than the main script version. Exiting."
        exit 0
    fi
else
    echo "reconrunner script not found. Proceeding with installation..."
fi

# Install jq if not installed
if ! command -v jq &> /dev/null; then
    echo "Installing jq..."
    sudo apt update
    sudo apt install -y jq
else
    echo "jq is already installed."
fi

# Make ReconRunner.sh executable and copy it to /usr/local/bin
if [ -f ReconRunner.sh ]; then
    chmod +x ReconRunner.sh
    sudo cp ReconRunner.sh /usr/local/bin/reconrunner
    echo "ReconRunner.sh installed as /usr/local/bin/reconrunner."
else
    echo "ReconRunner.sh not found. Exiting."
    exit 1
fi

# Check if the configuration directory exists; if not, create it
if [ ! -d "$HOME/.reconrunner" ]; then
    mkdir "$HOME/.reconrunner"
    echo "Created directory $HOME/.reconrunner."
fi

# Create the JSON configuration file in the directory if it doesn't exist
CONFIG_FILE="$HOME/.reconrunner/wordlists-config.json"

if [ ! -f "$CONFIG_FILE" ]; then
    echo '{
      "lfi-linux": [
        "/usr/share/wordlists/seclists/Fuzzing/LFI/LFI-etc-files-of-all-linux-packages.txt",
        "/usr/share/wordlists/seclists/Fuzzing/LFI/LFI-gracefulsecurity-linux.txt",
        "/usr/share/wordlists/seclists/Fuzzing/LFI/LFI-LFISuite-pathtotest-huge.txt",
        "/usr/share/wordlists/seclists/Fuzzing/LFI/LFI-LFISuite-pathtotest.txt"
      ],
      "lfi-windows": [
        "/usr/share/wordlists/seclists/Fuzzing/LFI/LFI-gracefulsecurity-windows.txt"
      ],
      "dirs": [
        "/usr/share/wordlists/seclists/Discovery/Web-Content/quickhits.txt",
        "/usr/share/wordlists/seclists/Discovery/Web-Content/directory-list-2.3-medium.txt"
      ],
      "dns": [
        "/usr/share/wordlists/seclists/Discovery/DNS/n0kovo_subdomains.txt",
        "/usr/share/wordlists/seclists/Discovery/DNS/combined_subdomains.txt",
        "/usr/share/wordlists/seclists/Discovery/DNS/subdomains-top1million-110000.txt"
      ],
      "sql": [
        "/usr/share/seclists/Fuzzing/SQLi/quick-SQLi.txt",
        "/usr/share/wordlists/wfuzz/vulns/sql_inj.txt",
        "/usr/share/seclists/Fuzzing/SQLi/Generic-SQLi.txt",
        "/usr/share/seclists/Fuzzing/SQLi/Generic-BlindSQLi.fuzzdb.txt",
        "/usr/share/wordlists/wfuzz/Injections/SQL.txt"
      ],
      "osinjection": [],
      "ssti": [],
      "xss": [
        "/usr/share/wordlists/wfuzz/Injections/XSS.txt"
      ],
      "xml": [
        "/usr/share/wordlists/wfuzz/Injections/XML.txt",
        "/usr/share/wordlists/seclists/Fuzzing/XML-FUZZ.txt"
      ],
      "ldap": [
        "/usr/share/wordlists/seclists/Fuzzing/LDAP-active-directory-attributes.txt",
        "/usr/share/wordlists/seclists/Fuzzing/LDAP-active-directory-classes.txt",
        "/usr/share/wordlists/seclists/Fuzzing/LDAP-openldap-attributes.txt",
        "/usr/share/wordlists/seclists/Fuzzing/LDAP-openldap-classes.txt",
        "/usr/share/wordlists/seclists/Fuzzing/LDAP.Fuzzing.txt"
      ],
      "api": []
    }' > "$CONFIG_FILE"
    echo "Created configuration file $CONFIG_FILE."
else
    echo "Configuration file $CONFIG_FILE already exists."
fi

echo "Installation complete."

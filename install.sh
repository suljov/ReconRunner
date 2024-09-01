#!/bin/bash

# Define the installed version directly in this script
INSTALLED_VERSION="0.6"  # Set this to the current installed version

# Source the main script to get the version variable
source ./main.sh

# Compare versions
if [ "$version" == "$INSTALLED_VERSION" ]; then
    echo "Version $version is up-to-date. Exiting."
    exit 0
elif [ "$(echo -e "$version\n$INSTALLED_VERSION" | sort -V | head -n 1)" == "$INSTALLED_VERSION" ]; then
    echo "A newer version detected. Continuing with installation..."
    sudo rm /usr/local/bin/reconrunner 
    # Place your installation or update commands here
else
    echo "Installed version is newer than the main script version. Exiting."
    exit 0
fi


# Install jq
sudo apt install -y jq

# Make ReconRunner.sh executable and copy it to /usr/local/bin
chmod +x ReconRunner.sh
sudo cp ReconRunner.sh /usr/local/bin/reconrunner

# Check if the directory exists; if not, create it
if [ ! -d "$HOME/.reconrunner" ]; then
  mkdir "$HOME/.reconrunner"
fi

# Create the JSON configuration file in the directory
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
}' > "$HOME/.reconrunner/wordlists-config.json"

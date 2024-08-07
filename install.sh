#!/bin/bash

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
  "lfi": ["/usr/share/wordlists/wfuzz/Injections/Traversal.txt"],
  "subs": [
    "/usr/share/wordlists/seclists/Discovery/DNS/subdomains-top1million-110000.txt",
    "/usr/share/wordlists/seclists/Discovery/DNS/combined_subdomains.txt"
  ],
  "dirs": [
    "/usr/share/wordlists/seclists/Discovery/Web-Content/quickhits.txt",
    "/usr/share/wordlists/seclists/Discovery/Web-Content/directory-list-2.3-medium.txt"
  ],
  "dns": [
    "/usr/share/wordlists/seclists/Discovery/DNS/n0kovo_subdomains.txt",
    "/usr/share/wordlists/seclists/Discovery/DNS/combined_subdomains.txt"
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
  "xss": ["/usr/share/wordlists/wfuzz/Injections/XSS.txt"],
  "xml": ["/usr/share/wordlists/wfuzz/Injections/XML.txt"]
}
' > "$HOME/.reconrunner/wordlists-config.json"

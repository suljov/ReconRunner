#!/bin/bash

sudo apt install jq
chmod +x ReconRunner.sh
sudo cp ReconRunner.sh /usr/local/bin/reconrunner

mkdir $HOME/.reconrunner
echo '{
  "lfi": [],
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
    "/usr/share/seclists/Fuzzing/SQLi/Generic-BlindSQLi.fuzzdb.txt"
  ],
  "osinjection": [],
  "ssti": [],
  "xss": []
}
' | jq | > $HOME/.reconrunner/wordlists-config.json

#!/bin/bash


sudo apt install jq


chmod +x ReconRunner.sh
sudo cp ReconRunner.sh /usr/local/bin/reconrunner


mkdir $HOME/.reconrunner
echo '{
    "lfi": [],
    "subs": ["/usr/share/wordlists/seclists/Discovery/DNS/subdomains-top1million-110000.txt", "/usr/share/wordlists/seclists/Discovery/DNS/combined_subdomains.txt"],
    "dirs": ["/usr/share/wordlists/seclists/Discovery/Web-Content/quickhits.txt", "/usr/share/wordlists/seclists/Discovery/Web-Content/directory-list-2.3-medium.txt"],
    "dns": ["/usr/share/wordlists/seclists/Discovery/DNS/n0kovo_subdomains.txt","/usr/share/wordlists/seclists/Discovery/DNS/combined_subdomains.txt"]
    "sql": [],
    "osinjection": [],
    "ssti": [],
    "xss": []
}' > $HOME/.reconrunner/wordlists-config.json

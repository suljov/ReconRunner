# Gobuster-deluxe




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
Usage: /usr/local/bin/gobuster-deluxe <ip> [--https] [--cw <custom_wordlist>] [extra_gobuster_options]

Options:
  <ip>                         The target IP address or domain.
  --https                      (Optional) Use HTTPS protocol instead of HTTP.
  --cw <custom_wordlist>       (Optional) Use a custom wordlist before the default wordlists.
  [extra_gobuster_options]     (Optional) Additional options for the gobuster command.

Examples:
  /usr/local/bin/gobuster-deluxe 192.168.1.1
  /usr/local/bin/gobuster-deluxe example.com --https
  /usr/local/bin/gobuster-deluxe 192.168.1.1 --cw /path/to/custom_wordlist.txt
  /usr/local/bin/gobuster-deluxe example.com --https --cw /path/to/custom_wordlist.txt --delay=500ms
```

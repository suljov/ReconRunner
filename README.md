# ReconRunner

Welcome to **ReconRunner** - a powerful, enhanced version of the popular tools like Gobsuter, ffuf etc, designed to streamline and improve your experience with directory and file brute-forcing and scan for subdomains. This script automates multiple wordlist usage, offers flexible protocol options, and ensures clean and organized output, all while keeping the user in control with intuitive command-line flags.

## **TODO**
- fix so the subs type get a clean output file instead of messy json

## Features

- **Protocol Flexibility**: Easily switch between HTTP and HTTPS protocols.
- **Custom Wordlists**: Start your brute-forcing with your custom wordlist before falling back on default ones.
- **Clean and Organized Output**: Results are automatically cleaned and saved in a user-friendly format.
- **Interactive Control**: Cancel the script anytime with CTRL + C without losing your progress.
  - The script is designed to handle this interruption gracefully, ensuring that any results collected up to that point are saved properly, and any temporary resources are cleaned up.
- **Robust and User-Friendly**: Includes detailed help and usage instructions.


# **Install**

```
git clone https://github.com/suljov/ReconRunner
cd ReconRunner
chmod +x ReconRunner.sh
sudo cp ReconRunner.sh /usr/local/bin/reconrunner 
```

# **Usage**

```
$ reconrunner --help
Usage: reconrunner <enum_type> <ip> [--https] [--cw <custom_wordlist>] [--wildcard <wildcard_domain>] [--extra <extra_options>]

Help:
  --help                       Prints this message
  dirs --help                  Prints all options for dirs
  subs --help                  Prints all options for subs

  reconrunner dirs --help
  reconrunner subs --help


Available types:
  dirs    Directory/file enumeration (tool: gobuster)
  subs    Subdomain enumeration (tool: ffuf)

Options:
  <enum_type>                  The type of enumeration (e.g., dirs, subs).
  <ip>                         The target IP address or domain.
  --https                      (Optional) Use HTTPS protocol instead of HTTP.
  --cw <custom_wordlist>       (Optional) Use a custom wordlist before the default wordlists.
  --wildcard <wildcard_domain> (Optional) Use wildcard in the Host header for subdomain enumeration.
  --extra <extra_options>      (Optional) Additional options for the enumeration tool.


Examples:
  reconrunner dirs 192.168.1.1
  reconrunner dirs example.com --https
  reconrunner dirs 192.168.1.1 --cw /path/to/custom_wordlist.txt --extra '--delay=500ms'

  reconrunner subs example.com
  reconrunner subs example.com --cw /path/to/custom_wordlist.txt --wildcard preprod-*.trick.htb --extra '--timeout=30 --rate=100'
```

# **Examples**

## Directory enumeration

#### Basic Usage
```
reconrunner dirs example.com
```
#### Using HTTPS
```
reconrunner dirs example.com --https
```
#### With Custom Wordlist
```
reconrunner example.com --cw /path/to/custom_wordlist.txt
```
#### With Extra Options
```
reconrunner dirs 192.168.1.1 --cw /path/to/custom_wordlist.txt --extra '--delay=500ms'
```

## Subdomain enumeration

#### Basic Usage
```
reconrunner subs example.com
```
#### Using HTTPS
```
reconrunner subs example.com --https
```
#### With Custom Wordlist
```
reconrunner subs example.com --cw /path/to/custom_wordlist.txt
```
#### With Extra Options
```
reconrunner subs example.com --cw /path/to/custom_wordlist.txt --extra '-fl 100'
```
#### With wildcard
```
reconrunner subs example.com --wildcard example*.com
```
The wildcard will be replaced with the word `FUZZ`

# **The ability to customize**

## Wordlists
This tool is customizable in the script for easily add or remove wordlists. 
by simply edit the file by typing:
```
sudo gedit /usr/local/bin/reconrunner
```
and find the this part on line `67` and on `96`:

Example:
```
# List of wordlists
WORDLISTS=(
    "/usr/share/wordlists/seclists/Discovery/Web-Content/quickhits.txt"
    "/usr/share/wordlists/seclists/Discovery/Web-Content/directory-list-2.3-medium.txt"
    # Add more wordlists here as needed
)
```
you can simply add how many you want if you have a custom wordlists you always use etc:
```
# List of wordlists
WORDLISTS=(
    "/usr/share/wordlist/myonly-owrdlist.txt"
)
```
its up to use what wordlist it uses. 

## Wildcards

placeholder

```
placeholder
```

# **Cleaning Up**
To ensure that partial results are not lost, the tool saves and cleans the output on-the-fly. Even if you cancel the script using CTRL + C, the results gathered up to that point will be cleaned and saved.



# **Acknowledgments**
**Gobuster**: The original tool by OJ Reeves (@TheColonial) & Christian Mehlmauer (@firefart) which this script uses.
**ffuf**: The original tool by @ffuf which this script uses.





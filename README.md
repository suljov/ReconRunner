# ReconRunner

ReconRunner is a tool designed to streamline and simplify directory and file brute-forcing, subdomain enumeration and sql injections. By leveraging popular tools like Gobuster, ffuf and sqlmap   , ReconRunner offers a more flexible and powerful experience with enhanced handling of wordlists, protocols, and outputs.

## **TODO/idéas**
* come up with more idéas for features
  * add feature for simple fuzzing (web)
    * add flag to urlencode the payload


## Features

* **Protocol Flexibility:** Seamlessly switch between HTTP and HTTPS protocols.
* **Custom Wordlists:** Prioritize custom wordlists before default ones for a more tailored approach.
* **Custom List of Wordlists:** Utilize a specific list of wordlists from a configuration file.
  * Create, add, or remove custom lists of wordlists to meet your needs.
* **Wildcard Support:** Incorporate wildcard domains easily for subdomain enumeration.
* **Interactive Control:** Cancel the tool anytime with CTRL + C, ensuring results are saved and temporary resources are cleaned.
* **Detailed Help and Usage Instructions:** Comprehensive help options for both the tool and underlying tools.
* **Clean and Organized Output:** Results are saved in a structured format with customization options.



# **Install**

```
git clone https://github.com/suljov/ReconRunner
cd ReconRunner
chmod +x install.sh && ./install.sh
```

# **Usage**
To install ReconRunner, clone the repository and run the installation script:
```
$ reconrunner --help         
Usage: reconrunner <enum_type> <ip> [--https] [--cw <custom_wordlist>] [--cl <custom_list>] [--wildcard <wildcard_domain>] [--extra <extra_options>] [--skip-save] [-f <file>]

Help:
  --help                       Prints this message
  dirs --help                  Prints all options for dirs
  subs --help                  Prints all options for subs
  sql --help                   Prints all options for sql

Available types:
  dirs    Directory/file enumeration (tool: gobuster)
  subs    Subdomain enumeration (tool: ffuf)
  sql     SQL Injection detection (tool: sqlmap)

Options:
  <enum_type>                  The type of enumeration (e.g., dirs, subs, sql).
  <ip>                         The target IP address or domain (for dirs and subs).
  -u <url>                     The target URL (for sql).
  -f <file>                    The request file (for sql).
  --https                      (Optional) Use HTTPS protocol instead of HTTP.
  --cw <custom_wordlist>       (Optional) Use a custom wordlist instead of the default wordlists.
  --cl <custom_list>           (Optional) Use a custom list of wordlists from the config file.
  --wildcard <wildcard_domain> (Optional) Use wildcard in the Host header for subdomain enumeration.
  --extra <extra_options>      (Optional) Additional options for the enumeration tool.
  --skip-save                  (Optional) Skip saving results to files.

Configuration commands:
  reconrunner config --add-wordlist <path to wordlist> --to <type>
  reconrunner config --remove-wordlist <path to wordlist> --from <type>
  reconrunner config --create-list <name>
  reconrunner config --remove-list <name>
  reconrunner config --list-info

Examples:
  reconrunner dirs example.com
  reconrunner dirs example.com --https
  reconrunner dirs example.com --cw /path/to/custom_wordlist.txt --extra '--delay=500ms'

  reconrunner subs example.com
  reconrunner subs example.com --cw /path/to/custom_wordlist.txt --wildcard test-*.example.com --extra '--timeout=30 --rate=100'

  reconrunner sql -u http://example.com/vulnerable.php?id=1
  reconrunner sql -f /path/to/request_file.txt
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
reconrunner dirs example.com --cw /path/to/custom_wordlist.txt
```
#### With Extra Options
```
reconrunner dirs example.com --cw /path/to/custom_wordlist.txt --extra '--delay=500ms'
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
#### with another or custom list (lists that are in the config file)
```
reconrunner subs example.com --cw <name of list>
```
## SQL injection
### With an URL
```
reconrunner sql -u "http://example.com/vulnerable.php?id=1"
```
### With file
```
reconrunner sql -r /path/to/file.txt
```

# **The ability to customize**

## Customizing list of wordlists
The tool supports custom wordlists via a configuration file. To customize or add new wordlists:

1. Edit Configuration File:

Edit the JSON file located at $HOME/.reconrunner/wordlists-config.json. You can add or remove wordlists, create custom lists, and specify wordlists for different types of enumeration.

2. Commands for Configuration:

* **Add Wordlist:** reconrunner config --add-wordlist <path to wordlist> --to <type>
* **Remove Wordlist:** reconrunner config --remove-wordlist <path to wordlist> --from <type>
* **Create List:** reconrunner config --create-list <name>
* **Remove List:** reconrunner config --remove-list <name>
* **List Info:** reconrunner config --list-info

### List configuration (default list with wordlists)
```
{
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
  ]
}
``` 

# **Cleaning Up**
ReconRunner ensures that partial results are saved and cleaned up on-the-fly. If you cancel the tool using CTRL + C, it will save results up to that point and clean temporary files.


# **Acknowledgments**
* **Gobuster**: A tool by OJ Reeves (@TheColonial) & Christian Mehlmauer (@firefart). [GitHub Repository](https://github.com/OJ/gobuster)
* **ffuf**: A tool by @ffuf. [GitHub Repository](https://github.com/ffuf/ffuf)




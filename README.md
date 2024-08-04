# ReconRunner

ReconRunner is a tool designed to streamline and make directory and file brute-forcing, as well as subdomain enumeration easier. Leveraging popular tools like Gobuster and ffuf, ReconRunner provides a more flexible and powerful experience with improved handling of wordlists, protocols, and outputs.

## **TODO/idéas**
* ~~make a install script for easier install??~~
* fix the output saving problem on dirs and subs
    * fix so the subs type get a clean output file instead of messy json
    * fix so dirs output get saved (seems to be an append problem here)
* come up with more idéas for features
  * add feature for sql innjection testing (sqlmap)
  * add feature for simple fuzzing (web)
  * ~~add a way to have pre-made list of wordlissts (one list of wordlists for LFI and one for SQLi etc)~~
      * ~~or change the structure for the lists of wordlists for each feature so they are in lists in a config file???? json file with multiple keys and values with wordlists etc??~~
          * ~~then we can make a feature so its easier to make your own custom list of wordlists and make the tool use that list of wordlists????~~
              * ~~then add a feature so the tool can add/create custom lists of wordlists AND being able to add wordlists to an existing list of wordlists??~~
  * add feature to scan hosts (nmap and/or rustscan)

## Features

* **Protocol Flexibility:** Seamlessly switch between HTTP and HTTPS protocols.
* **Custom Wordlists:** Start with a custom wordlist before default ones, for a more tailored approach.
* **Custom List of Wordlists:** Use a specific list of wordlists from a configuration file.
* **Wildcard Support:** Easily incorporate wildcard domains for subdomain enumeration.
* **Interactive Control:** Cancel the tool anytime with CTRL + C, ensuring that results are saved and temporary resources are cleaned.
* **Detailed Help and Usage Instructions:** Comprehensive help options for both the tool and underlying tools.
* **Clean and Organized Output:** Results are saved in a structured format with customization options.


# **Install**

```
git clone https://github.com/suljov/ReconRunner
cd ReconRunner
chmod +x install.sh && bash install.sh
```

# **Usage**

```
$ ./ReconRunner.sh                   
Usage: reconrunner <enum_type> <ip> [--https] [--cw <custom_wordlist>] [--cl <custom_list>] [--wildcard <wildcard_domain>] [--extra <extra_options>]

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
  --cw <custom_wordlist>       (Optional) Use a custom wordlist instead of the default wordlists.
  --cl <custom_list>           (Optional) Use a custom list of wordlists from the config file.
  --wildcard <wildcard_domain> (Optional) Use wildcard in the Host header for subdomain enumeration.
  --extra <extra_options>      (Optional) Additional options for the enumeration tool.

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

# **The ability to customize**

## Wordlists
This tool is customizable for easily add or remove wordlists. 
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

When using wildcards in your domain names, ReconRunner replaces them with FUZZ in the headers. For example, if your domain is example.com (subdomain = frontdesk-prod.example.com), and uses a wildcard frontdesk-*.example.com it will be replaced as follows:

* **With Wildcard** example: frontdesk-*.example.com -> frontdesk-FUZZ.example.com
* **Without Wildcard** per default: FUZZ.frontdesk-prod.example.com

This ensures that the tool tests for subdomains effectively according to your specified wildcard pattern.

Example Command:
```
reconrunner subs frontdesk-prod.example.com --wildcard frontdesk-*.example.com
```

# **Cleaning Up**
To ensure that partial results are not lost, the tool saves and cleans the output on-the-fly. Even if you cancel the tool using CTRL + C, the results gathered up to that point will be cleaned and saved.



# **Acknowledgments**
* **Gobuster**: The original tool by OJ Reeves (@TheColonial) & Christian Mehlmauer (@firefart) which this tool uses.
  * https://github.com/OJ/gobuster
* **ffuf**: The original tool by @ffuf which this tool uses.
  * https://github.com/ffuf/ffuf





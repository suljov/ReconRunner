<h1 align="center">
  ReconRunner
  <br>
<sub><i>Streamline your recon, automate your workflow.</i></sub><br>
</h1>

<p align="center">
  <strong>By Suljov</strong>
</p>

<p align="center">
  <a href="#install">
    <img src="https://img.shields.io/badge/installation-⚙️-blue?style=for-the-badge" alt="Installation">
  </a>

  <a href="#-examples">
    <img src="https://img.shields.io/badge/examples-🚀-green?style=for-the-badge" alt="Examples">
  </a>
    </a>
    <a href="#usage" style="text-decoration: none; margin: 0 10px;">
    <img src="https://img.shields.io/badge/using-🛠️-purple?style=for-the-badge" alt="Usage" style="vertical-align: middle;">
  </a>
</p>

## About

ReconRunner is a webapp tool designed to streamline and simplify directory and file brute-forcing, subdomain enumeration and sql injections. By leveraging popular tools like Gobuster, wfuzz and sqlmap, ReconRunner offers a more flexible and powerful experience with enhanced handling of wordlists, protocols, and outputs.

## NOTICE

The tool will go from bash code to python code

## **TODO/idéas**

- come up with more idéas for features
  - add feature for simple fuzzing (web)
    - add flag to urlencode the payload

## 🌟 Features

- **Protocol Flexibility:** Seamlessly switch between HTTP and HTTPS protocols.
- **Custom Wordlists:** Prioritize custom wordlists before default ones for a more tailored approach.
- **Custom List of Wordlists:** Utilize a specific list of wordlists from a configuration file.
  - Create, add, or remove custom lists of wordlists to meet your needs.
- **Wildcard Support:** Incorporate wildcard domains easily for subdomain enumeration.
- **Interactive Control:** Cancel the tool anytime with CTRL + C, ensuring results are saved and temporary resources are cleaned.
- **Detailed Help and Usage Instructions:** Comprehensive help options for both the tool and underlying tools.
- **Clean and Organized Output:** Results are saved in a structured format with customization options.

## **Install**

```
git clone https://github.com/suljov/ReconRunner
cd ReconRunner
chmod +x install.sh && ./install.sh
```

## **Usage**

To install ReconRunner, clone the repository and run the installation script:

```
$ reconrunner --help


██████╗ ███████╗ ██████╗ ██████╗ ███╗   ██╗██████╗ ██╗   ██╗███╗   ██╗███╗   ██╗███████╗██████╗
██╔══██╗██╔════╝██╔════╝██╔═══██╗████╗  ██║██╔══██╗██║   ██║████╗  ██║████╗  ██║██╔════╝██╔══██╗
██████╔╝█████╗  ██║     ██║   ██║██╔██╗ ██║██████╔╝██║   ██║██╔██╗ ██║██╔██╗ ██║█████╗  ██████╔╝
██╔══██╗██╔══╝  ██║     ██║   ██║██║╚██╗██║██╔══██╗██║   ██║██║╚██╗██║██║╚██╗██║██╔══╝  ██╔══██╗
██║  ██║███████╗╚██████╗╚██████╔╝██║ ╚████║██║  ██║╚██████╔╝██║ ╚████║██║ ╚████║███████╗██║  ██║
╚═╝  ╚═╝╚══════╝ ╚═════╝ ╚═════╝ ╚═╝  ╚═══╝╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═══╝╚═╝  ╚═══╝╚══════╝╚═╝  ╚═╝



usage: ReconRunner [-h] {subs,subs2,dirs,dirs2,sql,fuzz,portscan,portscan2,config} ...

ReconRunner made by suljov. Streamlines scanning by automating tasks for webapp pentest and organizing results for a more efficient experience.

positional arguments:
  {subs,subs2,dirs,dirs2,sql,fuzz,portscan,portscan2,config}
    subs                Subdomain enumeration (tool: subfinder).
    subs2               Second way of subdomain enumeration (tool: wfuzz).
    dirs                Directory/file enumeration (tool: feroxbuster).
    dirs2               Directory/file enumeration (tool: gobuster).
    sql                 SQL Injection detection (tool: sqlmap). OBS: output does not get saved.
    fuzz                For custom fuzzing of endpoints, subdomains, parameters etc (tool: wfuzz).
    portscan            For portscanning the target (tool: rustscan).
    portscan2           For portscanning the target (tool: nmap).
    config              Configuration of the wordlist of wordlists (json file containing wordlists for different uses)

options:
  -h, --help            show this help message and exit

Help page for ReconRunner.
```

## **🚀 Examples**

### Directory enumeration

##### Basic Usage

```
reconrunner dirs -u http://example.com
```

##### With Custom Wordlist

```
reconrunner dirs -u http://example.com --cw /path/to/custom_wordlist.txt
```

##### With Extra Options

```
reconrunner dirs -u http://example.com --extra '--delay=500ms'
```

### Subdomain enumeration

##### Basic Usage

```
reconrunner subs -u example.com
```

##### With Custom Wordlist

```
reconrunner subs2 -u example.com --cw /path/to/custom_wordlist.txt
```

##### With Extra Options

```
reconrunner subs -u example.com --extra '-recursive'
```

#### with another or custom list (lists that are in the config file)

```
reconrunner subs -u example.com --cl <name of list>
```

### SQL injection

#### With an URL

```
reconrunner sql -u "http://example.com/vulnerable.php?id=1"
```

#### With file

```
reconrunner sql -f /path/to/file.txt
```

## **The ability to customize**

### Customizing list of wordlists

The tool supports custom wordlists via a configuration file. To customize or add new wordlists:

1. Edit Configuration File:

Edit the JSON file located at $HOME/.reconrunner/wordlists-config.json. You can add or remove wordlists, create custom lists, and specify wordlists for different types of enumeration.

2. Commands for Configuration:

- **Add Wordlist:** reconrunner config --add-wordlist [path to wordlist] --to [type-of-list]
- **Remove Wordlist:** reconrunner config --remove-wordlist [path to wordlist] --from [type-of-list]
- **Create List:**

```
reconrunner config --create-list [name]
```

- **Remove List:**

```
reconrunner config --remove-list [name]
```

- **Create wordlist:**

```
reconrunner config --add-list /path/to/wordlist.txt --type [name of the type in the config list]
```

- **Remove wordlist:**

```
reconrunner config --remove-word /path/to/wordlist.txt --type [name of the type in the config list]
```

- **List Info:**

```
reconrunner config --list-info
```

#### List configuration (default lists with wordlists)

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
    "/usr/share/wordlists/seclists/Discovery/Web-Content/common.txt",
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
  "xss": ["/usr/share/wordlists/wfuzz/Injections/XSS.txt"],
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
}

```

## **Acknowledgments**

- **Feroxbuster**: A tool by Ben "epi" Risher. [GitHub Repository](https://github.com/epi052/feroxbuster)
- **Gobuster**: A tool by OJ Reeves (@TheColonial) & Christian Mehlmauer (@firefart). [GitHub Repository](https://github.com/OJ/gobuster)
- **Subfinder**: A tool by ProjectDiscovery (@projectdiscovery). [GitHub Repository](https://github.com/projectdiscovery/subfinder)
- **wfuzz**: A tool by @xmendez. [GitHub Repository](https://github.com/xmendez/wfuzz)
- **sqlmap**: A tool by Bernardo Damele A. G. (@bdamele) & Miroslav Stampar (@stamparm). [GitHub Repository](https://github.com/sqlmapproject/sqlmap)
- **Rustscan**: A fast port scanner written in Rust. [GitHub Repository](https://github.com/RustScan/RustScan)
- **Nmap**: A powerful network scanning tool by Gordon Lyon (@fyodor). [GitHub Repository](https://github.com/nmap/nmap)

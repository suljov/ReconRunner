
import argparse
import os


# Hndle functions
def handleSUBS():
    if args.commands is True:
        os.system("subfinder --help")
    elif args.url is None and args.extra is not None:
        print("URL is neeed.")
    elif args.url is not None and args.extra is None:
        findSUBS(args.url)
    elif args.url is not None and args.extra is not None:
        findSUBSextra(args.url, args.extra)


def handleSUBS2():
    if args.commands is True:
        os.system("wfuzz --help")
    elif args.url is None and args.extra is not None:
        print("URL is neeed.")
    elif args.url is not None and args.extra is None:
        findSUBS2(args.url)
    elif args.url is not None and args.extra is not None:
        findSUBSextra2(args.url, args.extra)


def handleDIRS(url, extra):
    if args.commands is True:
        os.system("gobuster --help")


def handleSQL():
    print("heheheh sql work")
    print(f"lol {args.commands}")
    if args.commands is True:
        os.system("sqlmap --help")
    elif args.url is not None and args.file is not None:
        print("You cant have both flags for a url and a file... choose one.")
    elif args.file is not None and args.extra is None:
        sqlWithFile(args.file)
    elif args.file is not None and args.extra is not None:
        sqlWithFileExtra(args.file, args.extra)
    elif args.url is not None and args.extra is None:
        sqlWithURL(args.url)
    elif args.url is not None and args.extra is not None:
        sqlWithURLextra(args.url, args.extra)


def handleFUZZ():
    if args.commands is True:
        os.system("wfuzz --help")


def handleCONFIG():
    print("config")


# Functions


def findSUBS(url):
    os.system(f"subfinder -d {url}")


def findSUBS2(url):
    print("subs tool with gobuster (subs2)")


def findSUBSextra(url, extra):
    os.system(f"subfinder -d {url} {extra}")


def findSUBSextra2(url, extra):
    print("subs tool with gobuster and extra (subs2)")


def sqlWithFile(file):
    os.system(f"sqlmap -r {file} --batch")


def sqlWithFileExtra(file, extra):
    os.system(f"sqlmap -r {file} --batch {extra}")


def sqlWithURL(url):
    os.system(f"sqlmap -u {url} --batch")


def sqlWithURLextra(url, extra):
    os.system(f"sqlmap -u {url} --batch {extra}")


# Argeparse stuff


parser = argparse.ArgumentParser(prog="ReconRunner",
                                 description="""ReconRunner made by suljov.
                                 Streamlines scanning by
                                 automating tasks for webapp pentest and
                                 organizing results for a more
                                 efficient experience.""",
                                 epilog="Help page for ReconRunner.")
subparsers = parser.add_subparsers(dest="command", required=True)

# subparsers subs
SUBS = subparsers.add_parser("subs",
                             help="Subdomain enumeration (tool: subfinder).")
SUBS.add_argument("-u", "--url", type=str,
                  help="Url to the target.")
SUBS.add_argument("--skip-save", action="store_true",
                  help="Skip saving results to files.")
SUBS.add_argument("-e", "--extra", type=str,
                  help="""Extra flags used for the underlaying
                  tool (subfinder).""")
SUBS.add_argument("-c", "--commands", action="store_true",
                  help="""Show help page for subfinder
                  (for the -e/--extra flag.)""")


# subparsers subs2
SUBS2 = subparsers.add_parser("subs2",
                              help="""Second way of subdomain
                              enumeration (tool: wfuzz).""")
SUBS2.add_argument("-u", "--url", type=str,
                   help="Url to the target.")
SUBS2.add_argument("--cw", type=str,
                   help="""Use a custom wordlist instead
                  of the default wordlists.""")
SUBS2.add_argument("--cl", type=str,
                   help="Use a custom list of wordlists from the config file.")
SUBS2.add_argument("--skip-save", action="store_true",
                   help="Skip saving results to files.")
SUBS2.add_argument("--https", action="store_true",
                   help="Use HTTPS protocol instead of HTTP.")
SUBS2.add_argument("-e", "--extra", type=str,
                   help="""Extra flags used for the underlaying
                  tool (subfinder).""")
SUBS2.add_argument("-c", "--commands", action="store_true",
                   help="""Show help page for subfinder
                  (for the -e/--extra flag.)""")

# subparsers dirs
DIRS = subparsers.add_parser("dirs",
                             help="""Directory/file
                             enumeration (tool: gobuster).""")
DIRS.add_argument("-u", "--url", type=str,
                  help="Url to the target.")
DIRS.add_argument("--cw", type=str,
                  help="""Use a custom wordlist instead
                  of the default wordlists.""")
DIRS.add_argument("--cl", type=str,
                  help="Use a custom list of wordlists from the config file.")
DIRS.add_argument("--skip-save", action="store_true",
                  help="Skip saving results to files.")
DIRS.add_argument("--https", action="store_true",
                  help="Use HTTPS protocol instead of HTTP.")
DIRS.add_argument("-e", "--extra", type=str,
                  help="Extra flags used for the underlaying tool (gobuster).")
DIRS.add_argument("-c", "--commands", action="store_true",
                  help="""Show help page for gobuster
                  (for the -e/--extra flag.)""")


# subparsers sql
SQL = subparsers.add_parser("sql",
                            help="SQL Injection detection (tool: sqlmap).")
SQL.add_argument("-u", "--url", type=str,
                 help="URL to the target")
SQL.add_argument("-f", "--file", type=str,
                 help="""File containing the request in
                 question (from Burp or similar).""")
SQL.add_argument("-e", "--extra", type=str,
                 help="Extra flags used for the underlaying tool (SQLmap).")
SQL.add_argument("-c", "--commands", action="store_true",
                 help="Show help page for SQLmap (for the -e/--extra flag.)")

# subparsers fuzz
FUZZ = subparsers.add_parser("fuzz",
                             help="""For custom fuzzing of endpoints,
                             subdomains etc (tool: wfuzz).""")
FUZZ.add_argument("--https", action="store_true",
                  help="Use HTTPS protocol instead of HTTP.")
FUZZ.add_argument("-e", "--extra", type=str,
                  help="Extra flags used for the underlaying tool (wfuzz).")
FUZZ.add_argument("-c", "--commands", action="store_true",
                  help="Show help page for wfuzz (for the -e/--extra flag.)")

# subparsers config
CFG = subparsers.add_parser("config",
                            help="""Configuration of the wordlist of wordlists
                            (json file containing wordlists
                            for different uses)""")
CFG.add_argument("--add-wordlist", type=str,
                 help="""Adds wordlist to the configuration
                 file (needs to use flag --to for this to work).""")
CFG.add_argument("--to", type=str,
                 help="Needs to be used with the flag --add-wordlist to work.")
CFG.add_argument("--remove-wordlist", type=str,
                 help="""Removes wordlist from the configuration
                 file (needs to use flag --from for this to work).""")
CFG.add_argument("--from", type=str,
                 help="""Needs to be used with the
                 flag --remove-wordlist to work.""")
CFG.add_argument("--list-info", action="store_true",
                 help="""Shows the configuration file
                 contianing the lists of the wordlists.""")
CFG.add_argument("--create-list", type=str,
                 help="Creates a custom list for wordlists.")
CFG.add_argument("--remove-list", type=str,
                 help="Removes a list of wordlists.")

args = parser.parse_args()

# Checking what flags are used etc

if args.command == "subs":
    handleSUBS()
elif args.command == "dirs":
    handleDIRS()
elif args.command == "sql":
    handleSQL()
elif args.command == "fuzz":
    handleFUZZ()
elif args.command == "config":
    handleCONFIG()
elif args.command == "subs2":
    handleSUBS2()

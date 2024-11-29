import argparse
import os
import json
import re


configList = os.path.expanduser("~/.reconrunner/wordlists-config.json")
outpitDir = os.path.expanduser("./reconrunner-saved-data")


# the handle Functions

# subs
def findSUBS(url):
    cleaned_url = re.sub(r'^https?://([^/]+).*$', r'\1', url)
    os.system(f"subfinder -d {url} -o {outpitDir}/subs/subs-{cleaned_url}.txt")


def findSUBSnoSAVE(url):
    os.system(f"subfinder -d {url}")


def findSUBSextra(url, extra):
    cleaned_url = re.sub(r'^https?://([^/]+).*$', r'\1', url)
    os.system(f"subfinder -d {url} {extra} -o {outpitDir}/subs/subs-{cleaned_url}-extra.txt")


def findSUBSextraNosave(url, extra):
    os.system(f"subfinder -d {url} {extra}")


# subs2 normal
def findSUBS2(url):
    cleaned_url = re.sub(r'^https?://([^/]+).*$', r'\1', url)
    print(f"subs2 tool with gobuster (subs2) at: {cleaned_url}")


def findSUBS2NoSAVE(url):
    print("subs tool with gobuster (subs2) + no SAVE")


def findSUBSextra2(url, extra):
    cleaned_url = re.sub(r'^https?://([^/]+).*$', r'\1', url)
    print(f"subs tool with gobuster and extra (subs2) at: {cleaned_url}")


def findSUBSextra2NoSAVE(url, extra):
    print("subs tool with gobuster and extra (subs2) + no SAVE")


# subs2 with cl
def findSUBS2CL(url):
    cleaned_url = re.sub(r'^https?://([^/]+).*$', r'\1', url)
    print(f"subs2 with cl tol with gobuster (subs2) at: {cleaned_url}")


def findSUBS2NoSAVECL(url):
    cleaned_url = re.sub(r'^https?://([^/]+).*$', r'\1', url)
    print(f"subs2 with cl + no save with gobuster (subs2) at: {cleaned_url}")


def findSUBSextra2CL(url, extra):
    cleaned_url = re.sub(r'^https?://([^/]+).*$', r'\1', url)
    print(f"subs2 with cl with gobuster (subs2) at: {cleaned_url}")


def findSUBSextra2NoSAVECL(url, extra):
    cleaned_url = re.sub(r'^https?://([^/]+).*$', r'\1', url)
    print(f"subs2 with cl and extra + no save with gobuster (subs2) at: {cleaned_url}")


# subs2 with cw
def findSUBS2CW(url):
    cleaned_url = re.sub(r'^https?://([^/]+).*$', r'\1', url)
    print(f"subs2 with cw with gobuster (subs2) at: {cleaned_url}")


def findSUBS2NoSAVECW(url):
    cleaned_url = re.sub(r'^https?://([^/]+).*$', r'\1', url)
    print(f"subs2 with cw + no save with gobuster (subs2) at: {cleaned_url}")


def findSUBSextra2CW(url, extra):
    cleaned_url = re.sub(r'^https?://([^/]+).*$', r'\1', url)
    print(f"subs2 with cw and extra with gobuster (subs2) at: {cleaned_url}")


def findSUBSextra2NoSAVECW(url, extra):
    cleaned_url = re.sub(r'^https?://([^/]+).*$', r'\1', url)
    print(f"subs2 with cw and extra + no save with gobuster (subs2) at: {cleaned_url}")


# subs2 with cl and cw
def findSUBS2CLandCW(url):
    cleaned_url = re.sub(r'^https?://([^/]+).*$', r'\1', url)
    print(f"subs2 with cw and and cl with gobuster (subs2) at: {cleaned_url}")


def findSUBS2NoSAVECLandCW(url):
    cleaned_url = re.sub(r'^https?://([^/]+).*$', r'\1', url)
    print(f"subs2 with cw and and cl + no save with gobuster (subs2) at: {cleaned_url}")


def findSUBSextra2CLandCW(url, extra):
    cleaned_url = re.sub(r'^https?://([^/]+).*$', r'\1', url)
    print(f"subs2 with cw and and cl + extra with gobuster (subs2) at: {cleaned_url}")


def findSUBSextra2NoSAVECLandCW(url, extra):
    cleaned_url = re.sub(r'^https?://([^/]+).*$', r'\1', url)
    print(f"subs2 with cw and and cl + extra + no save with gobuster (subs2) at: {cleaned_url}")


# dirs normal
def dirs(url):
    cleaned_url = re.sub(r'^https?://([^/]+).*$', r'\1', url)
    print(f"dirs tool with feroxbuster (dirs) at: {cleaned_url}")


def dirsNoSave(url):
    print("dirs tool with feroxbuster (dirs) + no SAVE")


def dirsExtra(url, extra):
    cleaned_url = re.sub(r'^https?://([^/]+).*$', r'\1', url)
    print(f"dirs tool with feroxbuster and extra (dirs) at: {cleaned_url}")


def dirsExtraNoSave(url, extra):
    print("dirs tool with feroxbuster and extra (dirs2) + no SAVE")


# dirs with cl
def dirsCL(url):
    cleaned_url = re.sub(r'^https?://([^/]+).*$', r'\1', url)
    print(f"dirs with cl tol with feroxbuster (dirs) at: {cleaned_url}")


def dirsCLnoSave(url):
    cleaned_url = re.sub(r'^https?://([^/]+).*$', r'\1', url)
    print(f"dirs with cl + no save with feroxbuster (dirs) at: {cleaned_url}")


def dirsExtraCL(url, extra):
    cleaned_url = re.sub(r'^https?://([^/]+).*$', r'\1', url)
    print(f"dirs with cl with feroxbuster (dirs) at: {cleaned_url}")


def dirsExtraCLnoSave(url, extra):
    cleaned_url = re.sub(r'^https?://([^/]+).*$', r'\1', url)
    print(f"dirs with cl and extra + no save with feroxbuster (dirs) at: {cleaned_url}")


# dirs with cw
def dirsCW(url):
    cleaned_url = re.sub(r'^https?://([^/]+).*$', r'\1', url)
    print(f"dirs with cw with feroxbuster (dirs) at: {cleaned_url}")


def dirsCWnoSave(url):
    cleaned_url = re.sub(r'^https?://([^/]+).*$', r'\1', url)
    print(f"dirs with cw + no save with feroxbuster (dirs) at: {cleaned_url}")


def dirsExtraCW(url, extra):
    cleaned_url = re.sub(r'^https?://([^/]+).*$', r'\1', url)
    print(f"dirs with cw and extra with feroxbuster (dirs) at: {cleaned_url}")


def dirsExtraCWnoSave(url, extra):
    cleaned_url = re.sub(r'^https?://([^/]+).*$', r'\1', url)
    print(f"dirs with cw and extra + no save with feroxbuster (dirs) at: {cleaned_url}")


# dirs with cl and cw
def dirsCLandCW(url):
    cleaned_url = re.sub(r'^https?://([^/]+).*$', r'\1', url)
    print(f"dirs with cw and and cl with feroxbuster (dirs) at: {cleaned_url}")


def dirsCLandCWnoSave(url):
    cleaned_url = re.sub(r'^https?://([^/]+).*$', r'\1', url)
    print(f"dirs with cw and and cl + no save with feroxbuster (dirs) at: {cleaned_url}")


def dirsExtraCLandCW(url, extra):
    cleaned_url = re.sub(r'^https?://([^/]+).*$', r'\1', url)
    print(f"dirs with cw and and cl + extra with feroxbuster (dirs) at: {cleaned_url}")


def dirsExtraCLandCWnoSave(url, extra):
    cleaned_url = re.sub(r'^https?://([^/]+).*$', r'\1', url)
    print(f"dirs with cw and and cl + extra + no save with feroxbuster (dirs) at: {cleaned_url}")


# dirs2 normal
def dirs2(url):
    cleaned_url = re.sub(r'^https?://([^/]+).*$', r'\1', url)
    print(f"dirs2 tool with gobuster (dirs2) at: {cleaned_url}")


def dirs2NoSave(url):
    print("dirs2 tool with gobuster (dirs2) + no SAVE")


def dirs2Extra(url, extra):
    cleaned_url = re.sub(r'^https?://([^/]+).*$', r'\1', url)
    print(f"dirs2 tool with gobuster and extra (dirs2) at: {cleaned_url}")


def dirs2ExtraNoSave(url, extra):
    print("dirs2 tool with gobuster and extra (dirs22) + no SAVE")


# dirs2 with cl
def dirs2CL(url):
    cleaned_url = re.sub(r'^https?://([^/]+).*$', r'\1', url)
    print(f"dirs2 with cl tol with gobuster (dirs2) at: {cleaned_url}")


def dirs2CLnoSave(url):
    cleaned_url = re.sub(r'^https?://([^/]+).*$', r'\1', url)
    print(f"dirs2 with cl + no save with gobuster (dirs2) at: {cleaned_url}")


def dirs2ExtraCL(url, extra):
    cleaned_url = re.sub(r'^https?://([^/]+).*$', r'\1', url)
    print(f"dirs2 with cl with gobuster (dirs2) at: {cleaned_url}")


def dirs2ExtraCLnoSave(url, extra):
    cleaned_url = re.sub(r'^https?://([^/]+).*$', r'\1', url)
    print(f"dirs2 with cl and extra + no save with gobuster (dirs2) at: {cleaned_url}")


# dirs2 with cw
def dirs2CW(url):
    cleaned_url = re.sub(r'^https?://([^/]+).*$', r'\1', url)
    print(f"dirs2 with cw with gobuster (dirs2) at: {cleaned_url}")


def dirs2CWnoSave(url):
    cleaned_url = re.sub(r'^https?://([^/]+).*$', r'\1', url)
    print(f"dirs2 with cw + no save with gobuster (dirs2) at: {cleaned_url}")


def dirs2ExtraCW(url, extra):
    cleaned_url = re.sub(r'^https?://([^/]+).*$', r'\1', url)
    print(f"dirs2 with cw and extra with gobuster (dirs2) at: {cleaned_url}")


def dirs2ExtraCWnoSave(url, extra):
    cleaned_url = re.sub(r'^https?://([^/]+).*$', r'\1', url)
    print(f"dirs2 with cw and extra + no save with gobuster (dirs2) at: {cleaned_url}")


# dirs2 with cl and cw
def dirs2CLandCW(url):
    cleaned_url = re.sub(r'^https?://([^/]+).*$', r'\1', url)
    print(f"dirs2 with cw and and cl with gobuster (dirs2) at: {cleaned_url}")


def dirs2CLandCWnoSave(url):
    cleaned_url = re.sub(r'^https?://([^/]+).*$', r'\1', url)
    print(f"dirs2 with cw and and cl + no save with gobuster (dirs2) at: {cleaned_url}")


def dirs2ExtraCLandCW(url, extra):
    cleaned_url = re.sub(r'^https?://([^/]+).*$', r'\1', url)
    print(f"dirs2 with cw and and cl + extra with gobuster (dirs2) at: {cleaned_url}")


def dirs2ExtraCLandCWnoSave(url, extra):
    cleaned_url = re.sub(r'^https?://([^/]+).*$', r'\1', url)
    print(f"dirs2 with cw and and cl + extra + no save with gobuster (dirs2) at: {cleaned_url}")


# fuzz normal
def fuzz(url):
    cleaned_url = re.sub(r'^https?://([^/]+).*$', r'\1', url)
    print(f"fuzz tool with wfuzz (fuzz) at: {cleaned_url}")


def fuzzNoSave(url):
    print("fuzz tool with wfuzz (fuzz) + no SAVE")


def fuzzExtra(url, extra):
    cleaned_url = re.sub(r'^https?://([^/]+).*$', r'\1', url)
    print(f"fuzz tool with wfuzz and extra (fuzz) at: {cleaned_url}")


def fuzzExtraNoSave(url, extra):
    print("fuzz tool with wfuzz and extra (fuzz2) + no SAVE")


# fuzz with cl
def fuzzCL(url):
    cleaned_url = re.sub(r'^https?://([^/]+).*$', r'\1', url)
    print(f"fuzz with cl tol with wfuzz (fuzz) at: {cleaned_url}")


def fuzzCLnoSave(url):
    cleaned_url = re.sub(r'^https?://([^/]+).*$', r'\1', url)
    print(f"fuzz with cl + no save with wfuzz (fuzz) at: {cleaned_url}")


def fuzzExtraCL(url, extra):
    cleaned_url = re.sub(r'^https?://([^/]+).*$', r'\1', url)
    print(f"fuzz with cl with wfuzz (fuzz) at: {cleaned_url}")


def fuzzExtraCLnoSave(url, extra):
    cleaned_url = re.sub(r'^https?://([^/]+).*$', r'\1', url)
    print(f"fuzz with cl and extra + no save with wfuzz (fuzz) at: {cleaned_url}")


# fuzz with cw
def fuzzCW(url):
    cleaned_url = re.sub(r'^https?://([^/]+).*$', r'\1', url)
    print(f"fuzz with cw with wfuzz (fuzz) at: {cleaned_url}")


def fuzzCWnoSave(url):
    cleaned_url = re.sub(r'^https?://([^/]+).*$', r'\1', url)
    print(f"fuzz with cw + no save with wfuzz (fuzz) at: {cleaned_url}")


def fuzzExtraCW(url, extra):
    cleaned_url = re.sub(r'^https?://([^/]+).*$', r'\1', url)
    print(f"fuzz with cw and extra with wfuzz (fuzz) at: {cleaned_url}")


def fuzzExtraCWnoSave(url, extra):
    cleaned_url = re.sub(r'^https?://([^/]+).*$', r'\1', url)
    print(f"fuzz with cw and extra + no save with wfuzz (fuzz) at: {cleaned_url}")


# fuzz with cl and cw
def fuzzCLandCW(url):
    cleaned_url = re.sub(r'^https?://([^/]+).*$', r'\1', url)
    print(f"fuzz with cw and and cl with wfuzz (fuzz) at: {cleaned_url}")


def fuzzCLandCWnoSave(url):
    cleaned_url = re.sub(r'^https?://([^/]+).*$', r'\1', url)
    print(f"fuzz with cw and and cl + no save with wfuzz (fuzz) at: {cleaned_url}")


def fuzzExtraCLandCW(url, extra):
    cleaned_url = re.sub(r'^https?://([^/]+).*$', r'\1', url)
    print(f"fuzz with cw and and cl + extra with wfuzz (fuzz) at: {cleaned_url}")


def fuzzExtraCLandCWnoSave(url, extra):
    cleaned_url = re.sub(r'^https?://([^/]+).*$', r'\1', url)
    print(f"fuzz with cw and and cl + extra + no save with wfuzz (fuzz) at: {cleaned_url}")


# sql
def sqlWithFile(file):
    os.system(f"sqlmap -r {file} --batch")


def sqlWithFileExtra(file, extra):
    os.system(f"sqlmap -r {file} --batch {extra}")


def sqlWithURL(url):
    os.system(f"sqlmap -u {url} --batch")


def sqlWithURLextra(url, extra):
    os.system(f"sqlmap -u {url} --batch {extra}")


# config


def checkJsonWordlistExist(wordlist, obj):
    with open(configList, "r") as configFile:
        data = json.load(configFile)
    if wordlist in data[obj]:
        return True
    else:
        return False


def checkJsonTypeExist(obj):
    with open(configList, "r") as configFile:
        data = json.load(configFile)
    if obj not in data:
        return False
    else:
        return True


def addWordlist(wordlist, obj):
    check = checkJsonTypeExist(obj)
    wordlists = checkJsonWordlistExist(wordlist, obj)
    if check:
        if not wordlists:
            with open(configList, "r") as configFile:
                data = json.load(configFile)
            data[obj].append(wordlist)
            with open(configList, 'w') as fp:
                json.dump(data, fp, indent=2)
            print("Done!")
        else:
            print(f"{wordlist} already exist in {obj}")
            exit
    else:
        print(f"""{obj} dont exist in the configuration file! See config file: reconrunner config --list-info""")
        exit


def deleteWordlist(wordlist, obj):
    check = checkJsonTypeExist(obj)
    wordlists = checkJsonWordlistExist(wordlist, obj)
    if check:
        if wordlists:
            with open(configList, "r") as configFile:
                data = json.load(configFile)
            data[obj].remove(wordlist)
            with open(configList, 'w') as fp:
                json.dump(data, fp, indent=2)
            print("Done!")
        else:
            print(f"{wordlist} dont exist in {obj}")
            exit
    else:
        print(f"""{obj} dont exist in the configuration file! See config file: reconrunner config --list-info""")
        exit


def deleteList(list):
    check = checkJsonTypeExist(list)
    if check:
        with open(configList, "r") as configFile:
            data = json.load(configFile)
        del data[list]
        with open(configList, 'w') as fp:
            json.dump(data, fp, indent=2)
        print("Done!")
    else:
        print(f"""{list} dont exist in the configuration file! See config file: reconrunner config --list-info""")
        exit


def addList(list):
    check = checkJsonTypeExist(list)
    if check:
        print(f"{list} already exist")
        exit
    else:
        with open(configList, "r") as configFile:
            data = json.load(configFile)
        data[list] = []
        with open(configList, 'w') as fp:
            json.dump(data, fp, indent=2)
        print("Done!")


# portscan


def portScanRustscanBoth(domain, extra, extra_nmap):
    os.system(f"""sudo rustscan -a {domain} {extra} --ulimit 5000 -- {extra_nmap}""")


def portScanRustscanExtra(domain, extra):
    os.system(f"""sudo rustscan -a {domain} {extra} --ulimit 5000 -- -sS -A -O -sV""")


def portScanRustscanExtraNmap(domain, extra_nmap):
    os.system(f"""sudo rustscan -a {domain} --ulimit 5000 -- {extra_nmap}""")


def portScanRustscanSingle(domain):
    os.system(f"""sudo rustscan -a {domain} --ulimit 5000 -- -sS -A -O -sV""")


# portscan2


def portscanNmapSingle(domain):
    os.system(f"sudo nmap {domain} -sS -A -O -sV -p- -oN {outpitDir}/portscan/portscan2-{domain}.txt")


def portscanNmapSingleNoSAVE(domain):
    os.system(f"sudo nmap {domain} -sS -A -O -sV -p-")


def portscanNmapExtra(domain, extra):
    os.system(f"sudo nmap {domain} {extra} -oN {outpitDir}/portscan/portscan2-{domain}-extra.txt")


def portscanNmapExtraNoSave(domain, extra):
    os.system(f"sudo nmap {domain} {extra}")


# Handle functions

def handleSUBS():
    if args.commands is True:
        os.system("subfinder --help")
    elif (args.url is not None
          and args.extra is None
          and not args.skip_save):
        findSUBS(args.url)
    elif (args.url is not None
          and args.extra is None
          and args.skip_save):
        findSUBSnoSAVE(args.url)
    elif (args.url is not None
          and args.extra is not None
          and not args.skip_save):
        findSUBSextra(args.url, args.extra)
    elif (args.url is not None
          and args.extra is not None
          and args.skip_save):
        findSUBSextraNosave(args.url, args.extra)


def handleSUBS2():
    if args.commands is True:
        os.system("wfuzz --help")
# no cl or cw
    elif (args.url is not None
          and args.extra is None
          and not args.skip_save
          and args.cw is None
          and args.cl is None):
        findSUBS2(args.url)
    elif (args.url is not None
          and args.extra is None
          and args.skip_save
          and args.cw is None
          and args.cl is None):
        findSUBS2NoSAVE(args.url)
    elif (args.url is not None
          and args.extra is not None
          and not args.skip_save
          and args.cw is None
          and args.cl is None):
        findSUBSextra2(args.url, args.extra)
    elif (args.url is not None
          and args.extra is not None
          and args.skip_save
          and args.cw is None
          and args.cl is None):
        findSUBSextra2NoSAVE(args.url, args.extra)
# with cl and not cw
    elif (args.url is not None
          and args.extra is None
          and not args.skip_save
          and args.cw is None
          and args.cl is not None):
        findSUBS2CL(args.url)
    elif (args.url is not None
          and args.extra is None
          and args.skip_save
          and args.cw is None
          and args.cl is not None):
        findSUBS2NoSAVECL(args.url)
    elif (args.url is not None
          and args.extra is not None
          and not args.skip_save
          and args.cw is None
          and args.cl is not None):
        findSUBSextra2CL(args.url, args.extra)
    elif (args.url is not None
          and args.extra is not None
          and args.skip_save
          and args.cw is None
          and args.cl is not None):
        findSUBSextra2NoSAVECL(args.url, args.extra)
# with cw and not cl
    elif (args.url is not None
          and args.extra is None
          and not args.skip_save
          and args.cw is not None
          and args.cl is None):
        findSUBS2CW(args.url)
    elif (args.url is not None
          and args.extra is None
          and args.skip_save
          and args.cw is not None
          and args.cl is None):
        findSUBS2NoSAVECW(args.url)
    elif (args.url is not None
          and args.extra is not None
          and not args.skip_save
          and args.cw is not None
          and args.cl is None):
        findSUBSextra2CW(args.url, args.extra)
    elif (args.url is not None
          and args.extra is not None
          and args.skip_save
          and args.cw is not None
          and args.cl is None):
        findSUBSextra2NoSAVECW(args.url, args.extra)
# with cl and cw
    elif (args.url is not None
          and args.extra is None
          and not args.skip_save
          and args.cw is not None
          and args.cl is not None):
        findSUBS2CLandCW(args.url)
    elif (args.url is not None
          and args.extra is None
          and args.skip_save
          and args.cw is not None
          and args.cl is not None):
        findSUBS2NoSAVECLandCW(args.url)
    elif (args.url is not None
          and args.extra is not None
          and not args.skip_save
          and args.cw is not None
          and args.cl is not None):
        findSUBSextra2CLandCW(args.url, args.extra)
    elif (args.url is not None
          and args.extra is not None
          and args.skip_save
          and args.cw is not None
          and args.cl is not None):
        findSUBSextra2NoSAVECLandCW(args.url, args.extra)


def handleDIRS2():
    if args.commands is True:
        os.system("gobuster --help")
# no cl or cw
    elif (args.url is not None
          and args.extra is None
          and not args.skip_save
          and args.cw is None
          and args.cl is None):
        dirs2(args.url)
    elif (args.url is not None
          and args.extra is None
          and args.skip_save
          and args.cw is None
          and args.cl is None):
        dirs2NoSave(args.url)
    elif (args.url is not None
          and args.extra is not None
          and not args.skip_save
          and args.cw is None
          and args.cl is None):
        dirs2Extra(args.url, args.extra)
    elif (args.url is not None
          and args.extra is not None
          and args.skip_save
          and args.cw is None
          and args.cl is None):
        dirs2ExtraNoSave(args.url, args.extra)
# with cl and not cw
    elif (args.url is not None
          and args.extra is None
          and not args.skip_save
          and args.cw is None
          and args.cl is not None):
        dirs2CL(args.url)
    elif (args.url is not None
          and args.extra is None
          and args.skip_save
          and args.cw is None
          and args.cl is not None):
        dirs2CLnoSave(args.url)
    elif (args.url is not None
          and args.extra is not None
          and not args.skip_save
          and args.cw is None
          and args.cl is not None):
        dirs2ExtraCL(args.url, args.extra)
    elif (args.url is not None
          and args.extra is not None
          and args.skip_save
          and args.cw is None
          and args.cl is not None):
        dirs2ExtraCLnoSave(args.url, args.extra)
# with cw and not cl
    elif (args.url is not None
          and args.extra is None
          and not args.skip_save
          and args.cw is not None
          and args.cl is None):
        dirs2CW(args.url)
    elif (args.url is not None
          and args.extra is None
          and args.skip_save
          and args.cw is not None
          and args.cl is None):
        dirs2CWnoSave(args.url)
    elif (args.url is not None
          and args.extra is not None
          and not args.skip_save
          and args.cw is not None
          and args.cl is None):
        dirs2ExtraCW(args.url, args.extra)
    elif (args.url is not None
          and args.extra is not None
          and args.skip_save
          and args.cw is not None
          and args.cl is None):
        dirs2ExtraCWnoSave(args.url, args.extra)
# with cl and cw
    elif (args.url is not None
          and args.extra is None
          and not args.skip_save
          and args.cw is not None
          and args.cl is not None):
        dirs2CLandCW(args.url)
    elif (args.url is not None
          and args.extra is None
          and args.skip_save
          and args.cw is not None
          and args.cl is not None):
        dirs2CLandCWnoSave(args.url)
    elif (args.url is not None
          and args.extra is not None
          and not args.skip_save
          and args.cw is not None
          and args.cl is not None):
        dirs2ExtraCLandCW(args.url, args.extra)
    elif (args.url is not None
          and args.extra is not None
          and args.skip_save
          and args.cw is not None
          and args.cl is not None):
        dirs2ExtraCLandCWnoSave(args.url, args.extra)


def handleDIRS():
    if args.commands is True:
        os.system("feroxbuster --help")
# no cl or cw
    elif (args.url is not None
          and args.extra is None
          and not args.skip_save
          and args.cw is None
          and args.cl is None):
        dirs(args.url)
    elif (args.url is not None
          and args.extra is None
          and args.skip_save
          and args.cw is None
          and args.cl is None):
        dirsNoSave(args.url)
    elif (args.url is not None
          and args.extra is not None
          and not args.skip_save
          and args.cw is None
          and args.cl is None):
        dirsExtra(args.url, args.extra)
    elif (args.url is not None
          and args.extra is not None
          and args.skip_save
          and args.cw is None
          and args.cl is None):
        dirsExtraNoSave(args.url, args.extra)
# with cl and not cw
    elif (args.url is not None
          and args.extra is None
          and not args.skip_save
          and args.cw is None
          and args.cl is not None):
        dirsCL(args.url)
    elif (args.url is not None
          and args.extra is None
          and args.skip_save
          and args.cw is None
          and args.cl is not None):
        dirsCLnoSave(args.url)
    elif (args.url is not None
          and args.extra is not None
          and not args.skip_save
          and args.cw is None
          and args.cl is not None):
        dirsExtraCL(args.url, args.extra)
    elif (args.url is not None
          and args.extra is not None
          and args.skip_save
          and args.cw is None
          and args.cl is not None):
        dirsExtraCLnoSave(args.url, args.extra)
# with cw and not cl
    elif (args.url is not None
          and args.extra is None
          and not args.skip_save
          and args.cw is not None
          and args.cl is None):
        dirsCW(args.url)
    elif (args.url is not None
          and args.extra is None
          and args.skip_save
          and args.cw is not None
          and args.cl is None):
        dirsCWnoSave(args.url)
    elif (args.url is not None
          and args.extra is not None
          and not args.skip_save
          and args.cw is not None
          and args.cl is None):
        dirsExtraCW(args.url, args.extra)
    elif (args.url is not None
          and args.extra is not None
          and args.skip_save
          and args.cw is not None
          and args.cl is None):
        dirsExtraCWnoSave(args.url, args.extra)
# with cl and cw
    elif (args.url is not None
          and args.extra is None
          and not args.skip_save
          and args.cw is not None
          and args.cl is not None):
        dirsCLandCW(args.url)
    elif (args.url is not None
          and args.extra is None
          and args.skip_save
          and args.cw is not None
          and args.cl is not None):
        dirsCLandCWnoSave(args.url)
    elif (args.url is not None
          and args.extra is not None
          and not args.skip_save
          and args.cw is not None
          and args.cl is not None):
        dirsExtraCLandCW(args.url, args.extra)
    elif (args.url is not None
          and args.extra is not None
          and args.skip_save
          and args.cw is not None
          and args.cl is not None):
        dirsExtraCLandCWnoSave(args.url, args.extra)


def handleSQL():
    print("heheheh sql work")
    print(f"lol {args.commands}")
    if args.commands is True:
        os.system("sqlmap --help")
    elif (args.url is not None
          and args.file is not None):
        print("You cant have both flags for a url and a file... choose one :)")
        exit
    elif (args.file is not None
          and args.extra is None):
        sqlWithFile(args.file)
    elif (args.file is not None
          and args.extra is not None):
        sqlWithFileExtra(args.file, args.extra)
    elif (args.url is not None
          and args.extra is None):
        sqlWithURL(args.url)
    elif (args.url is not None
          and args.extra is not None):
        sqlWithURLextra(args.url, args.extra)


def handleFUZZ():
    if args.commands is True:
        os.system("wfuzz --help")
# no cl or cw
    elif (args.url is not None
          and args.extra is None
          and not args.skip_save
          and args.cw is None
          and args.cl is None):
        fuzz(args.url)
    elif (args.url is not None
          and args.extra is None
          and args.skip_save
          and args.cw is None
          and args.cl is None):
        fuzzNoSave(args.url)
    elif (args.url is not None
          and args.extra is not None
          and not args.skip_save
          and args.cw is None
          and args.cl is None):
        fuzzExtra(args.url, args.extra)
    elif (args.url is not None
          and args.extra is not None
          and args.skip_save
          and args.cw is None
          and args.cl is None):
        fuzzExtraNoSave(args.url, args.extra)
# with cl and not cw
    elif (args.url is not None
          and args.extra is None
          and not args.skip_save
          and args.cw is None
          and args.cl is not None):
        fuzzCL(args.url)
    elif (args.url is not None
          and args.extra is None
          and args.skip_save
          and args.cw is None
          and args.cl is not None):
        fuzzCLnoSave(args.url)
    elif (args.url is not None
          and args.extra is not None
          and not args.skip_save
          and args.cw is None
          and args.cl is not None):
        fuzzExtraCL(args.url, args.extra)
    elif (args.url is not None
          and args.extra is not None
          and args.skip_save
          and args.cw is None
          and args.cl is not None):
        fuzzExtraCLnoSave(args.url, args.extra)
# with cw and not cl
    elif (args.url is not None
          and args.extra is None
          and not args.skip_save
          and args.cw is not None
          and args.cl is None):
        fuzzCW(args.url)
    elif (args.url is not None
          and args.extra is None
          and args.skip_save
          and args.cw is not None
          and args.cl is None):
        fuzzCWnoSave(args.url)
    elif (args.url is not None
          and args.extra is not None
          and not args.skip_save
          and args.cw is not None
          and args.cl is None):
        fuzzExtraCW(args.url, args.extra)
    elif (args.url is not None
          and args.extra is not None
          and args.skip_save
          and args.cw is not None
          and args.cl is None):
        fuzzExtraCWnoSave(args.url, args.extra)
# with cl and cw
    elif (args.url is not None
          and args.extra is None
          and not args.skip_save
          and args.cw is not None
          and args.cl is not None):
        fuzzCLandCW(args.url)
    elif (args.url is not None
          and args.extra is None
          and args.skip_save
          and args.cw is not None
          and args.cl is not None):
        fuzzCLandCWnoSave(args.url)
    elif (args.url is not None
          and args.extra is not None
          and not args.skip_save
          and args.cw is not None
          and args.cl is not None):
        fuzzExtraCLandCW(args.url, args.extra)
    elif (args.url is not None
          and args.extra is not None
          and args.skip_save
          and args.cw is not None
          and args.cl is not None):
        fuzzExtraCLandCWnoSave(args.url, args.extra)


def handleCONFIG():
    if (args.remove_list is not None
            and args.add_wordlist is None
            and args.remove_wordlist is None
            and not args.list_info
            and args.create_list is None
            and args.to is None
            and args.type is None):
        deleteList(args.remove_list)
    elif (args.list_info is True
          and args.add_wordlist is None
          and args.to is None
          and args.create_list is None
          and args.remove_list is None
          and args.remove_wordlist is None
          and args.type is None):
        print("")
        print("File located at: '~/.reconrunner/wordlists-config.json'")
        print("Configuration file:")
        print("")
        os.system("cat ~/.reconrunner/wordlists-config.json")
    elif (args.create_list is not None
          and args.remove_list is None
          and args.add_wordlist is None
          and args.remove_wordlist is None
          and not args.list_info
          and args.to is None
          and args.type is None):
        addList(args.create_list)
    elif (args.add_wordlist is not None
          and args.to is not None
          and args.create_list is None
          and args.remove_list is None
          and args.remove_wordlist is None
          and not args.list_info
          and args.type is None):
        addWordlist(args.add_wordlist, args.to)
    elif (args.type is not None
          and args.remove_wordlist is not None
          and args.add_wordlist is None
          and args.to is None and args.create_list is None
          and args.remove_list is None
          and not args.list_info):
        deleteWordlist(args.remove_wordlist, args.type)


def handlePORT():
    if args.commands is True:
        os.system("rustscan --help")
    elif (args.domain is not None
          and args.nmap_extra is not None
          and args.extra is not None):
        portScanRustscanBoth(args.domain, args.extra, args.nmap_extra)
    elif (args.domain is not None
          and args.nmap_extra is None
          and args.extra is None):
        portScanRustscanSingle(args.domain)
    elif (args.domain is not None
          and args.nmap_extra is None
          and args.extra is not None):
        portScanRustscanExtra(args.domain, args.extra)
    elif (args.domain is not None
          and args.nmap_extra is not None
          and args.extra is None):
        portScanRustscanExtraNmap(args.domain, args.extra_nmap)


def handlePORT2():
    if args.commands is True:
        os.system("nmap --help")
    elif (args.domain is not None
          and args.extra is None
          and not args.skip_save):
        portscanNmapSingle(args.domain)
    elif (args.domain is not None
          and args.extra is None
          and not args.skip_save):
        portscanNmapSingleNoSAVE(args.domain)
    elif (args.domain is not None
          and args.extra is not None):
        portscanNmapExtra(args.domain, args.extra)

# Argeparse stuff


parser = argparse.ArgumentParser(prog="ReconRunner", description="""ReconRunner made by suljov. Streamlines scanning by automating tasks for webapp pentest and organizing results for a more efficient experience.""", epilog="""Help page for ReconRunner.""")
subparsers = parser.add_subparsers(dest="command", required=True)

# subparsers subs
SUBS = subparsers.add_parser("subs", help="Subdomain enumeration (tool: subfinder).")
SUBS.add_argument("-u", "--url", required=True, type=str, help="Url to the target.")
SUBS.add_argument("--skip-save", action="store_true", help="Skip saving results to files.")
SUBS.add_argument("-e", "--extra", type=str, help="""Extra flags used for the underlaying tool (subfinder).""")
SUBS.add_argument("-c", "--commands", action="store_true", help="""Show help page for subfinder (for the -e/--extra flag.)""")


# subparsers subs2
SUBS2 = subparsers.add_parser("subs2", help="""Second way of subdomain enumeration (tool: wfuzz).""")
SUBS2.add_argument("-u", "--url", required=True, type=str, help="Url to the target.")
SUBS2.add_argument("--cw", type=str, help="""Use a custom  wordlist instead of the default wordlists in the list.""")
SUBS2.add_argument("--cl", type=str,  help="Use a custom list of wordlists from the config file.")
SUBS2.add_argument("--skip-save", action="store_true",  help="Skip saving results to files.")
SUBS2.add_argument("-e", "--extra", type=str,  help="""Extra flags used for the underlaying tool (subfinder).""")
SUBS2.add_argument("-c", "--commands", action="store_true", help="""Show help page for subfinder (for the -e/--extra flag.)""")

# subparsers dirs
DIRS = subparsers.add_parser("dirs", help="""Directory/file enumeration (tool: feroxbuster).""")
DIRS.add_argument("-u", "--url", required=True, type=str, help="Url to the target.")
DIRS.add_argument("--cw", type=str, help="""Use a custom wordlist instead of the default wordlists in the list.""")
DIRS.add_argument("--cl", type=str, help="Use a custom list of wordlists from the config file.")
DIRS.add_argument("--skip-save", action="store_true", help="Skip saving results to files.")
DIRS.add_argument("-e", "--extra", type=str, help="Extra flags used for the underlaying tool (feroxbuster).")
DIRS.add_argument("-c", "--commands", action="store_true", help="""Show help page for feroxbuster (for the -e/--extra flag.)""")


# subparsers dirs2
DIRS2 = subparsers.add_parser("dirs2", help="""Directory/file enumeration (tool: gobuster).""")
DIRS2.add_argument("-u", "--url", required=True, type=str, help="Url to the target.")
DIRS2.add_argument("--cw", type=str, help="""Use a custom wordlist instead of the default wordlists in the list.""")
DIRS2.add_argument("--cl", type=str, help="""Use a custom list of wordlists from the config file.""")
DIRS2.add_argument("--skip-save", action="store_true", help="Skip saving results to files.")
DIRS2.add_argument("-e", "--extra", type=str, help="""Extra flags used for the underlaying tool (gobuster).""")
DIRS2.add_argument("-c", "--commands", action="store_true", help="""Show help page for gobuster (for the -e/--extra flag.)""")


# subparsers sql
SQL = subparsers.add_parser("sql", help="SQL Injection detection (tool: sqlmap). OBS: output does not get saved.")
SQL.add_argument("-u", "--url", type=str, help="URL to the target")
SQL.add_argument("-f", "--file", type=str, help="""File containing the request in question (from Burp or similar).""")
SQL.add_argument("-e", "--extra", type=str, help="Extra flags used for the underlaying tool (SQLmap).")
SQL.add_argument("-c", "--commands", action="store_true", help="Show help page for SQLmap (for the -e/--extra flag.)")

# subparsers fuzz
FUZZ = subparsers.add_parser("fuzz", help="""For custom fuzzing of endpoints, subdomains, parameters etc (tool: wfuzz).""")
FUZZ.add_argument("-u", "--url", required=True, type=str, help="URL to the target")
FUZZ.add_argument("-e", "--extra", type=str, help="Extra flags used for the underlaying tool (wfuzz).")
FUZZ.add_argument("-c", "--commands", action="store_true", help="Show help page for wfuzz (for the -e/--extra flag.)")
FUZZ.add_argument("--skip-save", action="store_true", help="Skip saving results to files.")
FUZZ.add_argument("--cw", type=str, help="""Use a custom wordlist instead of the default wordlists in the list.""")
FUZZ.add_argument("--cl", type=str, help="""Use a custom list of wordlists from the config file.""")

# subparsers portscan
portscan = subparsers.add_parser("portscan", help="""For portscanning the target (tool: rustscan).""")
portscan.add_argument("-e", "--extra", type=str, help="""Extra flags used for the underlaying tool (rustscan).""")
portscan.add_argument("-ne", "--nmap-extra", type=str, help="""Extra flags used for the underlaying tool in rustscan, OBS these are the commands for nmap that rustscan uses.""")
portscan.add_argument("-c", "--commands", action="store_true", help="""Show help page for rustscan (for the -e/--extra flag.)""")
portscan.add_argument("-i", "-d", "--domain", "--ip", type=str, help="Domain name or IP to target", required=True)


# subparsers portscan2
portscan2 = subparsers.add_parser("portscan2", help="""For portscanning the target (tool: nmap).""")
portscan2.add_argument("-e", "--extra", type=str, help="""Extra flags used for the underlaying tool (nmap).""")
portscan2.add_argument("-c", "--commands", action="store_true", help="""Show help page for nmap (for the -e/--extra flag.)""")
portscan2.add_argument("-i", "-d", "--domain", "--ip", type=str, help="Domain name or IP to target", required=True)
portscan2.add_argument("--skip-save", action="store_true", help="Skip saving results to files.")


# subparsers config
CFG = subparsers.add_parser("config", help="""Configuration of the wordlist of wordlists (json file containing wordlists for different uses)""")
CFG.add_argument("--add-wordlist", type=str, help="""Adds wordlist to the configuration file (needs to use flag --to for this to work).""")
CFG.add_argument("--to", type=str, help="""Specify to what list. Needs to be u sed with the flag --add-wordlist to work.""")
CFG.add_argument("--remove-wordlist", type=str, help="""Removes wordlist from the configuration file (needs to use flag --type for this to work).""")
CFG.add_argument("--type", type=str, help="""Specify what type in the list. Needs to be used with the flag --remove-wordlist to work.""")
CFG.add_argument("--list-info", action="store_true", help="""Shows the configuration file contianing the lists of the wordlists.""")
CFG.add_argument("--create-list", type=str, help="Creates a custom list for wordlists.")
CFG.add_argument("--remove-list", type=str, help="Removes a list of wordlists.")

args = parser.parse_args()

# Checking what flags are used etc

if args.command == "subs":
    handleSUBS()
elif args.command == "subs2":
    handleSUBS2()
elif args.command == "dirs":
    handleDIRS()
elif args.command == "dirs2":
    handleDIRS2()
elif args.command == "dirs2":
    handleCONFIG()
elif args.command == "sql":
    handleSQL()
elif args.command == "fuzz":
    handleFUZZ()
elif args.command == "config":
    handleCONFIG()
elif args.command == "portscan":
    handlePORT()
elif args.command == "portscan2":
    handlePORT2()


# what is done:
# sql
# config
# portscan
# subs
# portscan2


# TODO what is left to be done:
# TODO! subs2 (functions are created)
# TODO! dirs (functions are created)
# TODO! dirs2 (functions are created)
# TODO! fuzz (functions are created)

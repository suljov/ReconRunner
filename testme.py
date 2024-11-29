import os
import json


configList = os.path.expanduser("~/.reconrunner/wordlists-config.json")




with open(configList, "r") as configFile:
        data = json.load(configFile)


print(len(data["dns"]))

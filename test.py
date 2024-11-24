import json

configList = "test.json"

with open(configList, "r") as configFile:
    data = json.load(configFile)
del data["albin"]

with open(configList, 'w') as fp:
    json.dump(data, fp, indent=4)

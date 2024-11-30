import os


outpitDir = os.path.expanduser("~/.reconrunner/wordlists-config.json")


# check if folder exist
def checkFolderExist():
    check = os.path.exists(outpitDir)
    return check


print(checkFolderExist())

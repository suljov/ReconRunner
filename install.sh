#!/bin/bash

mkdir ~/.reconrunner
cp wordlists-config.json ~/.reconrunner/wordlists-config.json
sudo cp ReconRunner.py /usr/local/bin/reconrunner
sudo chmod +x /usr/local/bin/reconrunner

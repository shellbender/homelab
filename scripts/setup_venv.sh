#!/usr/bin/bash
# Running this script will create a python virtual environment in this script's parent folder.
# Navigate to this script's directory and run it from there
# mkdir ../venv
cd ../
python3 -m venv .venv
source ./.venv/bin/activate

# # This should now be taking place within the virtual environment
python3 -m pip install --upgrade pip
python3 -m pip install ansible ansible-lint
deactivate
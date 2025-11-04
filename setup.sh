#!/usr/bin/env bash

# Copyright (c) 2024-2025 Vili and contributors.

clear

echo "H4X-Tools Setup Script"
echo
echo "-- Made in Finland, by Vili."
echo
echo "You may need to install 'python-devel' packages."


##check for python installation
#TODO; add auto option to symlink or alias python2 or python w/ python3
check=$(python --version)
if [ -z "$check" ]; then 
    echo "installing python3 packages"
    sudo apt-get update && sudo apt-get upgrade -y --show-progress && sudo apt-get dist-upgrade -y && sudo apt install python3 python3-pip python3-dev python3-venv build-essential || sudo dnf5 update && sudo dnf5 install python3 python3-pip python3-dev python3-venv build-essential
    #todo: check python path is correct to py3
    if which python3 && echo $PYTHONPATH >/dev/null 2>&1
        echo -e "\n python packages up to date"
    fi
fi

# Create and activate virtual environment
echo "Creating virtual environment..."
python3 -m venv .venv
source .venv/bin/activate

# Install dependencies
echo "Installing dependencies..."
if command -v pip3 >/dev/null 2>&1; then
    pip3 install --upgrade pip
    pip3 install -r requirements.txt
else
    echo "python3-pip not installed, failed to install dependencies."
    exit 1
fi

# Build H4X-Tools to a single executable
echo "Building H4X-Tools to a single executable..."
user=$(whoami)
if command -v pyinstaller >/dev/null 2>&1; then
    pyinstaller h4xtools.py --add-data "resources/*:resources" --onefile -F --clean
    chmod +x dist/h4xtools && chown -R "$user:$user" dist/h4xtools
    if [ -d "$HOME/.local/bin" ]; then
        mv dist/h4xtools "$HOME/.local/bin"
    else
        mkdir "$HOME/.local/bin"
        mv dist/h4xtools "$HOME/.local/bin"
    fi
    rm h4xtools.spec
    rm -r dist && rm -r build
    echo -e "\n Done! Type h4xtools in your terminal to start!"
    read -r -p "Do you want to start H4XTools now? (y/N) " -en 3 answer
    if [[ $answer =~ Y|y|yes|Yes ]]; then
        h4xtools
    fi
else
    echo "pyinstaller not installed or not in PATH!"
    exit 1
fi

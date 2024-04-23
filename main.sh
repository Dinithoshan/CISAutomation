#!/bin/bash

# Check if the script is not being run as root
if [ "$EUID" -ne 0 ]; then
    echo "Script is not running as root."
else
    ./log-main.sh >> results.txt
fi

#!/bin/sh

HOME="/home/burp"

# Define the script filename
file_name="$HOME/app/burpsuite_install.sh"

# Download the install script.
curl -o "$file_name" "https://portswigger.net/burp/releases/download?product=pro&type=Linux" -v

# Add permissions to execute the script
chmod +x $file_name

DEBIAN_FRONTEND=noninteractive

# Run the install script
$file_name -q -c -varfile $HOME/app/response.varfile
#!/bin/bash

echo "Enter node name (e.g., main, node2, node3, node6):"
read NODE_NAME

NODE_DIR="/root/gaianode/$NODE_NAME"

echo "Downloading necessary files for $NODE_NAME..."
mkdir -p "$NODE_DIR"

wget -O "$NODE_DIR/main.py" "https://raw.githubusercontent.com/Itzaestheticpride/gaianodemain/main/main.py"
wget -O "$NODE_DIR/gaiaauto.sh" "https://raw.githubusercontent.com/Itzaestheticpride/gaianodemain/main/gaiaauto.sh"

echo "Setting permissions..."
chmod +x "$NODE_DIR/main.py"
chmod +x "$NODE_DIR/gaiaauto.sh"

# Ensure pip3 is installed
if ! command -v pip3 &> /dev/null; then
    echo "pip3 not found. Installing..."
    apt update && apt install -y python3-pip
fi

# Install required Python dependencies
if [ -f "$NODE_DIR/requirements.txt" ]; then
    echo "Installing Python dependencies..."
    pip3 install -r "$NODE_DIR/requirements.txt"
else
    echo "No requirements.txt found. Installing dotenv manually..."
    pip3 install python-dotenv
fi

echo "Running main.py and logging output..."
python3 "$NODE_DIR/main.py" &> "$NODE_DIR/node.log" &

echo "Displaying live log output..."
tail -f "$NODE_DIR/node.log"

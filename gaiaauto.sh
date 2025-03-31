#!/bin/bash

echo "Enter your choice [1-9]: "
read choice

if [ "$choice" == "9" ]; then
    echo "Enter node name (e.g., main, node2, node3, node6): "
    read node_name
    NODE_DIR="/root/gaianode/$node_name"
    LOG_FILE="$NODE_DIR/interaction_v1.log"

    echo "Downloading necessary files for $node_name..."
    mkdir -p "$NODE_DIR"
    wget -q -O "$NODE_DIR/main.py" "https://raw.githubusercontent.com/Itzaestheticpride/gaianodemain/main/main.py"
    wget -q -O "$NODE_DIR/gaiaauto.sh" "https://raw.githubusercontent.com/Itzaestheticpride/gaianodemain/main/gaiaauto.sh"
    
    echo "Setting permissions..."
    chmod +x "$NODE_DIR/main.py"
    chmod +x "$NODE_DIR/gaiaauto.sh"
    
    echo "Checking and installing Python dependencies..."
    if ! python3 -c "import dotenv" 2>/dev/null; then
        pip3 install python-dotenv
    fi
    
    if [ -f "$NODE_DIR/requirements.txt" ]; then
        pip3 install -r "$NODE_DIR/requirements.txt"
    fi
    
    echo "Running main.py and logging output..."
    python3 "$NODE_DIR/main.py" | tee "$LOG_FILE"
    
    echo "Displaying live log output..."
    tail -f "$LOG_FILE"
else
    echo "Invalid choice. Exiting."
    exit 1
fi

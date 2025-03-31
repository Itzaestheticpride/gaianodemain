#!/bin/bash

echo "Select an option:"
echo "1) Option 1"
echo "2) Option 2"
# ... other options ...
echo "9) Run main.py & setup node"

read -p "Enter your choice [1-9]: " choice

case $choice in
    1)
        # Commands for option 1
        ;;
    2)
        # Commands for option 2
        ;;
    # ... other cases ...
    9)
        read -p "Enter node name (e.g., main, node2, node3, node6): " node_name
        node_path="/root/gaianode/$node_name"

        # If the node directory doesn't exist, create it
        if [[ ! -d "$node_path" ]]; then
            echo "Creating directory: $node_path"
            mkdir -p "$node_path"
        fi

        echo "Downloading necessary files for $node_name..."
        
        # Ensure the necessary files are downloaded from your GitHub repo
        wget -O "$node_path/main.py" "https://raw.githubusercontent.com/Itzaestheticpride/gaianodemain/main/main.py"
        wget -O "$node_path/gaiaauto.sh" "https://raw.githubusercontent.com/Itzaestheticpride/gaianodemain/main/gaiaauto.sh"

        # Move files if needed (Not required here since wget downloads directly to the correct location)

        echo "Setting permissions..."
        chmod +x "$node_path/main.py"

        echo "Running main.py and logging output..."
        python3 "$node_path/main.py" | tee "$node_path/interaction_v1.log"
        ;;
    *)
        echo "Invalid choice."
        ;;
esac

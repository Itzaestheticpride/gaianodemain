#!/bin/bash

# Function to display the main menu
show_menu() {
    curl -s https://raw.githubusercontent.com/CryptonodesHindi/CryptoNodeHindi/refs/heads/main/CNH-Privatelogo.sh | bash
    echo "=============================="
    echo " GaiaNet Node Management Menu "
    echo "=============================="
    echo "1. Install GaiaNet Node"
    echo "2. Initialize Model Default [Llama Model]"
    echo "3. Initialize Model Qwen 2.5"
    echo "4. Initialize Model Phi 3.5 Mini"
    echo "5. Start Node"
    echo "6. Stop Node"
    echo "7. Uninstall GaiaNet Node"
    echo "8. Auto Interaction with Your Node [V1]"
    echo "9. Auto Interaction with Your Node [V2]"
    echo "10. Stop Interaction"
    echo "11. Check Node ID and Device ID"
    echo "12. Exit"
    echo "=============================="
}

# Function for Auto Interaction with Your Node [V2]
auto_interaction_v2() {
    echo "Which node do you want to run? (e.g., node2, node3)"
    read -p "Enter node name: " node_name
    
    local script_path="/root/gaianode/$node_name/main.py"
    local log_file="/root/gaianode/$node_name/interaction_v2.log"
    local pid_file="/root/gaianode/$node_name/interaction_v2.pid"

    if [ ! -f "$script_path" ]; then
        echo "Error: Python script not found at $script_path"
        return
    fi

    # Ensure a virtual environment exists
    if [ ! -d "/root/gaianode/$node_name/env" ]; then
        echo "Creating Python virtual environment..."
        python3 -m venv "/root/gaianode/$node_name/env"
    fi

    # Activate the virtual environment
    source "/root/gaianode/$node_name/env/bin/activate"

    # Install required Python dependencies
    if [ -f "/root/gaianode/$node_name/requirements.txt" ]; then
        echo "Installing required Python packages..."
        pip install -r "/root/gaianode/$node_name/requirements.txt"
    else
        echo "Warning: requirements.txt not found in /root/gaianode/$node_name/. Skipping dependency installation."
    fi

    # Use nohup to run the Python script in the background
    echo "Starting the Python script with nohup..."
    nohup python3 "$script_path" > "$log_file" 2>&1 &
    echo $! > "$pid_file"

    echo "Auto Interaction V2 started for $node_name in the background."
    echo "Logs are being saved to $log_file."
    echo "Process ID (PID): $(cat $pid_file)"
}

# Main loop
while true; do
    show_menu
    read -p "Enter your choice [1-12]: " choice
    case $choice in
        9) auto_interaction_v2 ;; 
        *) echo "No changes to other options." ;;
    esac
    echo ""
done

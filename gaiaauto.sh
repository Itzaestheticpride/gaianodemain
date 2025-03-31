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
    echo "Select which node to run (e.g., main, node2, node3):"
    read -p "Enter node name: " node_name
    local node_path=""
    
    case $node_name in
        main) node_path="$HOME/gaianode" ;;
        node2) node_path="$HOME/gaianode/node2" ;;
        node3) node_path="$HOME/gaianode/node3" ;;
        *) echo "Invalid node name. Defaulting to main node."; node_path="$HOME/gaianode" ;;
    esac

    echo "Starting Auto Interaction with Your Node [V2] at $node_path..."
    check_python_version
    local script_path="$node_path/main.py"
    local log_file="$node_path/interaction_v2.log"
    local pid_file="$node_path/interaction_v2.pid"

    if [ ! -f "$script_path" ]; then
        echo "Error: Python script not found at $script_path"
        return
    fi

    # Ensure a virtual environment exists
    if [ ! -d "$node_path/env" ]; then
        echo "Creating Python virtual environment..."
        python3 -m venv "$node_path/env"
    fi

    # Activate the virtual environment
    source "$node_path/env/bin/activate"

    # Install required Python dependencies
    echo "Installing required Python packages..."
    pip install -r "$node_path/requirements.txt"

    # Use nohup to run the Python script in the background
    echo "Starting the Python script with nohup..."
    nohup python3 "$script_path" > "$log_file" 2>&1 &
    echo $! > "$pid_file"

    echo "Auto Interaction V2 started in the background at $node_path."
    echo "Logs are being saved to $log_file."
    echo "Process ID (PID): $(cat $pid_file)"
}

# Main loop
while true; do
    show_menu
    read -p "Enter your choice [1-12]: " choice
    case $choice in
        1) install_node ;;
        2) initialize_default_model ;;
        3) initialize_qwen_model ;;
        4) initialize_phi_model ;;
        5) start_node ;;
        6) stop_node ;;
        7) uninstall_node ;;
        8) auto_interaction_v1 ;;
        9) auto_interaction_v2 ;;
        10) stop_interaction ;;
        11) check_node_info ;;
        12) echo "Exiting..."; exit 0 ;;
        *) echo "Invalid choice. Please select a number between 1 and 12." ;;
    esac
    echo ""
done

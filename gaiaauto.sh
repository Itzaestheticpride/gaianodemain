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

# Function to install GaiaNet Node
install_node() {
    echo "Installing GaiaNet Node..."
    curl -sSfL 'https://github.com/GaiaNet-AI/gaianet-node/releases/latest/download/install.sh' | bash
    source "$HOME/.bashrc"
}

# Function for Auto Interaction with Your Node [V2] with Node Selection
auto_interaction_v2() {
    echo "Which node do you want to run? (e.g., node2, node3)"
    read -p "Enter node name: " node_name
    node_dir="/root/gaianode/$node_name"
    log_file="$node_dir/interaction_v2.log"
    pid_file="$node_dir/interaction_v2.pid"
    script_path="$node_dir/main.py"
    repo_requirements="/root/autochatmine/6/CNH-Gaianetnode/gaianodemain/requirements.txt"

    if [ ! -d "$node_dir" ]; then
        echo "Error: Node directory $node_dir does not exist."
        return
    fi

    if [ ! -f "$script_path" ]; then
        echo "Error: Python script not found at $script_path"
        return
    fi

    # Ensure requirements.txt is copied if missing
    if [ ! -f "$node_dir/requirements.txt" ]; then
        if [ -f "$repo_requirements" ]; then
            echo "Copying requirements.txt from repository..."
            cp "$repo_requirements" "$node_dir/"
        else
            echo "Error: requirements.txt not found in repository at $repo_requirements"
            return
        fi
    fi

    # Activate virtual environment or create if missing
    if [ ! -d "$node_dir/env" ]; then
        echo "Creating Python virtual environment..."
        python3 -m venv "$node_dir/env"
    fi
    source "$node_dir/env/bin/activate"

    echo "Installing dependencies..."
    pip install -r "$node_dir/requirements.txt"
    deactivate

    echo "Starting the Python script with nohup..."
    nohup python3 "$script_path" > "$log_file" 2>&1 &
    echo $! > "$pid_file"

    echo "Auto Interaction V2 started for $node_name in the background."
    echo "Logs are being saved to $log_file."
    echo "Process ID (PID): $(cat $pid_file)"
}

# Function to exit the script
exit_script() {
    echo "Exiting GaiaNet Node Management Script..."
    exit 0
}

# Main loop
while true; do
    show_menu
    read -p "Enter your choice [1-12]: " choice
    case $choice in
        1) install_node ;;
        9) auto_interaction_v2 ;;
        12) exit_script ;;
        *) echo "Invalid choice. Please select a number between 1 and 12." ;;
    esac
    echo ""
done

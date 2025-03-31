#!/bin/bash

# Function to display the main menu
show_menu() {
    echo "=============================="
    echo " GaiaNet Node Management Menu "
    echo "=============================="
    echo "1. Install GaiaNet Node"
    echo "9. Auto Interaction with Your Node [V2]"
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
    echo "Which node do you want to run? (e.g., node6, node7)"
    read -p "Enter node name: " node_name
    foldername="${node_name//[^0-9]/}"  # Extract number from node name (e.g., node6 -> 6)
    node_dir="/root/autochatmine/$foldername/"
    repo_dir="$node_dir/gaianodemain"
    log_file="$node_dir/interaction_v2.log"
    pid_file="$node_dir/interaction_v2.pid"

    if [ ! -d "$node_dir" ]; then
        echo "Creating directory for node: $node_dir"
        mkdir -p "$node_dir"
    fi

    if [ ! -d "$repo_dir" ]; then
        echo "Cloning repository..."
        git clone https://github.com/Itzaestheticpride/gaianodemain "$repo_dir"
    else
        echo "Repository already exists. Pulling latest changes..."
        cd "$repo_dir" && git pull
    fi

    cd "$repo_dir"

    # Ensure requirements.txt exists
    if [ ! -f "$repo_dir/requirements.txt" ]; then
        echo "Error: requirements.txt not found in $repo_dir"
        return
    fi

    # Create virtual environment if missing
    if [ ! -d "$repo_dir/env" ]; then
        echo "Creating Python virtual environment..."
        python3 -m venv "$repo_dir/env"
    fi
    source "$repo_dir/env/bin/activate"

    echo "Installing dependencies..."
    pip install -r "$repo_dir/requirements.txt"
    deactivate

    echo "Starting the Python script with nohup..."
    nohup python3 "$repo_dir/main.py" > "$log_file" 2>&1 &
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
    read -p "Enter your choice [1, 9, 12]: " choice
    case $choice in
        1) install_node ;;
        9) auto_interaction_v2 ;;
        12) exit_script ;;
        *) echo "Invalid choice. Please select a number between 1, 9, and 12." ;;
    esac
    echo ""
done

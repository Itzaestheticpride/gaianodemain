auto_interaction_v2() {
    echo "Starting Auto Interaction with Your Node [V2]..."

    # Prompt user for the node name
    read -p "Enter the node name (e.g., node2): " node_name
    if [ -z "$node_name" ]; then
        echo "Node name cannot be empty. Aborting."
        return
    fi

    # Define paths based on the node name
    local node_dir="/root/gaianode/$node_name"
    local script_path="$node_dir/main.py"
    local log_file="$node_dir/interaction_v2.log"
    local pid_file="$node_dir/interaction_v2.pid"

    # Check if the script exists
    if [ ! -f "$script_path" ]; then
        echo "Error: Python script not found at $script_path"
        return
    fi

    # Ensure a virtual environment exists
    if [ ! -d "$node_dir/env" ]; then
        echo "Creating Python virtual environment..."
        python3 -m venv "$node_dir/env"
    fi

    # Activate the virtual environment
    source "$node_dir/env/bin/activate"

    # Install required Python packages
    if [ -f "$node_dir/requirements.txt" ]; then
        echo "Installing required Python packages..."
        pip install -r "$node_dir/requirements.txt"
    else
        echo "Warning: requirements.txt not found in $node_dir. Proceeding without installing additional packages."
    fi

    # Start the Python script with nohup
    echo "Starting the Python script with nohup..."
    nohup python3 "$script_path" > "$log_file" 2>&1 &
    echo $! > "$pid_file"

    echo "Auto Interaction V2 started for $node_name in the background."
    echo "Logs are being saved to $log_file."
    echo "Process ID (PID): $(cat $pid_file)"
}

#!/bin/bash

# Function to display the main menu
show_menu() {
    curl -s https://raw.githubusercontent.com/CryptonodesHindi/CryptoNodeHindi/refs/heads/main/CNH-Privatelogo.sh | bash
    echo 
    echo " GaiaNet Node Management Menu "
    echo 
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

# Function to initialize the default Llama model
initialize_default_model() {
    echo "Initializing Model Default [Llama Model]..."
    gaianet init
    echo "Default model initialization completed."
}

# Function to initialize the Qwen 2.5 model
initialize_qwen_model() {
    echo "Initializing Model Qwen 2.5..."
    gaianet init --config https://raw.githubusercontent.com/GaiaNet-AI/node-configs/main/qwen2-0.5b-instruct/config.json
    echo "Qwen 2.5 model initialization completed."
}

# Function to initialize the Phi 3.5 Mini model
initialize_phi_model() {
    echo "Initializing Model Phi 3.5 Mini..."
    gaianet init --config https://raw.githubusercontent.com/GaiaNet-AI/node-configs/main/phi-3.5-mini-instruct/config.json
    echo "Phi 3.5 Mini model initialization completed."
}

# Function to start the node
start_node() {
    echo "Starting GaiaNet Node..."
    local port=8081
    while lsof -i :$port &>/dev/null; do
        echo "Port $port is already in use. Incrementing port..."
        port=$((port + 1))
    done
    echo "Using port $port for GaiaNet Node..."
    gaianet config --port $port
    gaianet init
    gaianet start
    echo "Node started on port $port."
}

# Function to stop the node
stop_node() {
    echo "Stopping GaiaNet Node..."
    gaianet stop
    echo "Node stopped."
}

# Function to uninstall GaiaNet Node
uninstall_node() {
    echo "Uninstalling GaiaNet Node..."
    curl -sSfL 'https://github.com/GaiaNet-AI/gaianet-node/releases/latest/download/uninstall.sh' | bash
    echo "Uninstallation completed."
}

# Function for Auto Interaction with Your Node [V1]
auto_interaction_v1() {
    echo "Starting Auto Interaction with Your Node [V1]..."
    check_node_version
    local script_path="$HOME/CNH-Gaianetnode/main.js"
    local log_file="$HOME/interaction_v1.log"
    local pid_file="$HOME/interaction_v1.pid"

    if [ ! -f "$script_path" ]; then
        echo "Error: Node.js script not found at $script_path"
        exit 1
    fi
    npm install
    node "$script_path" > "$log_file" 2>&1 &
    echo $! > "$pid_file"

    echo "Auto Interaction V1 started in the background."
    echo "Logs are being saved to $log_file."
    echo "Process ID (PID): $(cat $pid_file)"
}

# Function for Auto Interaction with Your Node [V2]
auto_interaction_v2() {
    echo "Which node do you want to run? (e.g., node6, node7)"
    read -p "Enter node name: " node_name
    foldername="${node_name//[^0-9]/}"  # Extract number from node name (e.g., node6 -> 6)
    node_dir="/root/autochatmine/"
    repo_dir="$node_dir/gaianodemain"
    log_file="/root/interaction${foldername}_v2.log"
    pid_file="$node_dir/interaction_v2.pid"

    if [ ! -d "$node_dir" ]; then
        echo "Creating autochatmine directory: $node_dir"
        mkdir -p "$node_dir"
    fi

    if [ ! -d "$repo_dir" ]; then
        echo "Cloning repository..."
        git clone https://github.com/Itzaestheticpride/gaianodemain "$repo_dir"
    else
        echo "Repository already exists. Checking for local changes..."
        cd "$repo_dir"
        
        # Check for local changes
        if [ -n "$(git status --porcelain)" ]; then
            echo "Stashing local changes..."
            git stash
        fi

        # Reset any local changes and pull the latest changes
        echo "Resetting local changes and pulling latest updates..."
        git reset --hard
        git pull
    fi
# Line 147
# Before creating the virtual environment, ensure that python3-venv is installed:
if ! dpkg -l | grep -q python3-venv; then
    echo "python3-venv not found. Installing..."
    sudo apt-get install python3-venv
fi
    # Ensure the virtual environment exists
    VENV_DIR="$node_dir/env"
    if [ ! -d "$VENV_DIR" ]; then
        echo "Creating Python virtual environment..."
        python3 -m venv "$VENV_DIR"
    fi
# Ensure the virtual environment exists
VENV_DIR="$node_dir/env"
if [ ! -d "$VENV_DIR" ]; then
    echo "Creating Python virtual environment..."
    python3 -m venv "$VENV_DIR"
fi

# Activate the virtual environment
source "$VENV_DIR/bin/activate"
    # Activate the virtual environment
    source "$VENV_DIR/bin/activate"

    # Ensure pip is available
    "$VENV_DIR/bin/python" -m ensurepip --upgrade

   # Check if requirements.txt exists, if not, generate it
if [ ! -f "requirements.txt" ]; then
    echo "requirements.txt not found, generating it..."
    pip freeze > requirements.txt
fi
# Install dependencies
    echo "Installing dependencies..."
    pip install --upgrade pip
    pip install -r "$repo_dir/requirements.txt"

    # Run the Python script with nohup
    echo "Starting the Python script with nohup..."
    nohup python3 "$repo_dir/main.py" > "$log_file" 2>&1 &
    echo $! > "$pid_file"

    echo "Auto Interaction V2 started for $node_name in the background."
    echo "Logs are being saved to $log_file."
    echo "Process ID (PID): $(cat $pid_file)"
}
    

    cd "$repo_dir"

    # Ensure requirements.txt exists
    if [ ! -f "$repo_dir/requirements.txt" ]; then
        echo "Error: requirements.txt not found in $repo_dir"
        exit 1
    fi

    # Create a single virtual environment in autochatmine/
    if [ ! -d "$node_dir/env" ]; then
        echo "Creating Python virtual environment..."
        python3 -m venv "$node_dir/env"
    fi

    # Activate the virtual environment
if [ ! -d "/root/autochatmine/env" ]; then
    python3 -m venv /root/autochatmine/env
fi
if [ ! -d "/root/autochatmine/env" ]; then
    python3 -m venv /root/autochatmine/env || python3 -m virtualenv /root/autochatmine/env
fi

if [ -f "/root/autochatmine/env/bin/activate" ]; then
    source /root/autochatmine/env/bin/activate
else
    echo "❌ Virtual environment activation failed!"
    exit 1
fi


    echo "Installing dependencies..."
    if [ ! -f "/root/autochatmine/env/bin/pip" ]; then
    /root/autochatmine/env/bin/python -m ensurepip --default-pip
fi
pip install --upgrade pip
if [ ! -f "/root/autochatmine/env/bin/pip" ]; then
    python3 -m ensurepip --default-pip || apt-get install -y python3-venv python3-pip
    /root/autochatmine/env/bin/python -m ensurepip --default-pip
fi
pip install --upgrade pip
pip install -r requirements.txt
# Upgrade pip inside the virtual environment
pip install --upgrade pip

# Install required dependencies
pip install -r requirements.txt
    pip install python-dotenv
    if [ -n "$VIRTUAL_ENV" ]; then
if [ -n "$VIRTUAL_ENV" ]; then
    deactivate
fi

fi
# Deactivate the virtual environment if it's active
if [ -n "$VIRTUAL_ENV" ]; then
    deactivate
fi


    echo "Starting the Python script with nohup..."
    nohup python3 "$repo_dir/main.py" > "$log_file" 2>&1 &
    echo $! > "$pid_file"

    echo "Auto Interaction V2 started for $node_name in the background."
    echo "Logs are being saved to $log_file."
    echo "Process ID (PID): $(cat $pid_file)"
}


# Function to stop any interaction
# Function to stop any interaction
stop_interaction() {
    local pid_files=("$HOME/interaction_v1.pid" "$HOME/interaction_v2.pid")  # Check both V1 and V2 PID files
    local interaction_stopped=false

    for pid_file in "${pid_files[@]}"; do
        if [ -f "$pid_file" ]; then
            local pid=$(cat "$pid_file")
            if kill -0 "$pid" 2>/dev/null; then
                kill "$pid"
                echo "Interaction process with PID $pid stopped (from $pid_file)."
                rm -f "$pid_file"
                interaction_stopped=true
            else
                echo "No running process found for PID $pid in $pid_file."
                rm -f "$pid_file"
            fi
        fi
    done

    if [ "$interaction_stopped" = false ]; then
        echo "No PID file found. No interaction processes are running."
    fi
}


# Function to check Node ID and Device ID
check_node_info() {
    echo "Checking Node ID and Device ID..."
    gaianet info
}

# Function to check and enforce Node.js version 20
check_node_version() {
    if command -v node > /dev/null; then
        NODE_VERSION=$(node -v | sed 's/v//; s/\\..*//')
        if [ "$NODE_VERSION" -lt 20 ]; then
            echo "Node.js version is less than 20. Installing Node.js 20..."
            curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
            sudo apt-get install -y nodejs
        else
            echo "Node.js version is sufficient: $(node -v)"
        fi
    else
        echo "Node.js is not installed. Installing Node.js 20..."
        curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
        sudo apt-get install -y nodejs
    fi
}

# Function to check and enforce Python version 3.x
check_python_version() {
    if command -v python3 > /dev/null; then
        echo "Python 3 is installed: $(python3 --version)"
        if ! dpkg -l | grep -q python3-venv; then
            echo "Installing python3-venv package..."
            sudo apt update
            sudo apt install -y python3-venv
        fi
    else
        echo "Python 3 is not installed. Installing Python 3..."
        sudo apt update
        sudo apt install -y python3 python3-venv python3-pip
    fi
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

#!/bin/bash

# Comprehensive Ollama Installation and Status Check with detailed checks and stop command
# with animated package installation feedback

# Function to check and install a package with animation
install_if_missing() {
  package="$1"
  if ! pkg list $package &> /dev/null; then
    echo -e " $package is not installed. Installing..."

    # Animated installation feedback
    spinner=("[" "]" " .oO@" " @Oo." " .oO@" " @Oo." ) # Improved spinner animation
    i=0
    while ! pkg install -y "$package" &> /dev/null; do # Check for successful install within loop
      printf "\r${spinner[$i]} Installing $package... ${spinner[$i]}"
      i=$(( (i+1) % ${#spinner[@]} ))
      sleep 0.1  # Adjust speed as needed
      if [[ $i -eq 0 ]]; then  # Check if the loop has completed a full cycle
         if ! pkg list $package &> /dev/null; then # Check if the package is still not installed
           echo -e "\n❌ Error: Failed to install $package.  Please check your internet connection and try again."
           exit 1
         fi
         break # If the package is now installed, break the loop
      fi
    done
    echo -e "\r✅ $package installed successfully.                                 " # Clear the spinner and show success message
  else
    echo -e "✅ $package is already installed."
  fi
}

# Function to check Ollama status (with which command fix)
check_ollama_status() {
  if command -v ollama &> /dev/null; then
    echo -e "✅ Ollama is installed (binary found in PATH)."
    binary_path=$(command -v ollama) # Use command -v for portability
    echo -e "   Binary path: $binary_path"

    if pgrep -x ollama > /dev/null; then
      echo -e " Ollama is running."
      pid=$(pgrep -x ollama)
      echo -e "   Process ID (PID): $pid"
    else
      echo -e " Ollama is not running."
    fi
  else
    echo -e "❌ Ollama is not installed (binary not found in PATH)."
  fi
}

# Function to stop Ollama
stop_ollama() {
  if pgrep -x ollama > /dev/null; then
    echo -e " Stopping Ollama..."
    pkill ollama
    echo -e "✅ Ollama stopped."
  else
    echo -e " Ollama is not running. Nothing to stop."
  fi
}


# --- Installation Section (Modified) ---

# Install dependencies (only if Ollama not installed)
if ! command -v ollama &> /dev/null; then  # Check if Ollama is NOT installed
  echo -e "\n--- Checking and installing dependencies ---"
  install_if_missing git
  install_if_missing golang
  install_if_missing cmake
  install_if_missing clang
else
    echo -e "\n--- Ollama is already installed, skipping dependency checks ---"
fi


# Check if Ollama directory exists, clone if not
echo -e "\n--- Checking Ollama directory ---"

if [ ! -d "ollama" ]; then
  echo -e "⬇️ Ollama directory does not exist. Cloning..."
  git clone https://github.com/ollama/ollama.git || { echo -e "❌ Error: Failed to clone Ollama."; exit 1; }
else
  echo -e " Ollama directory already exists. Skipping clone."
fi

# Change directory (now guaranteed to exist)
cd ollama || { echo -e "❌ Error: Failed to change directory to ollama (this should not happen)."; exit 1; }

# Check if the ollama binary exists, build if not
echo -e "\n--- Checking and building Ollama binary ---"
if [ ! -f "$PREFIX/bin/ollama" ]; then
    echo -e "️ Ollama binary does not exist. Building..."
    go generate ./... || { echo -e "❌ Error: Failed to generate files."; exit 1; }
    go build . || { echo -e "❌ Error: Failed to build Ollama."; exit 1; }
    cd
    cp ollama/ollama "$PREFIX/bin/" || { echo -e "❌ Error: Failed to copy Ollama binary."; exit 1; }
    # chmod +x "$PREFIX/bin/ollama" # Usually not needed in $PREFIX/bin
    echo -e "✅ Ollama binary built and copied to $PREFIX/bin"
else
    echo -e "✅ Ollama binary already exists. Skipping build."
fi

# --- Status Check Section ---
echo -e "\n--- Ollama Status ---"
check_ollama_status

# --- Start/Stop Logic (Improved) ---

# Check if 'stop' argument is given FIRST
if [[ "$1" == "stop" ]]; then
  stop_ollama
  exit 0  # Exit after stopping
fi

# Then, check if Ollama is running before attempting to start
if ! pgrep -x ollama > /dev/null; then  # Only start if not already running
  echo -e "\n--- Starting Ollama ---"  # Clearer message
  ollama serve &
  echo -e " Ollama started in the background.  You can stop it with 'pkill ollama' or './this_script stop'."
else
  echo -e "\n--- Ollama is already running. ---" # Clearer message
fi

# Optional: Add ollama to .bashrc or .zshrc (remains the same)

exit 0


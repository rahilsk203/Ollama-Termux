# Ollama-Termux: Streamlined Ollama Installation and Management for Termux 🚀

This repository provides a robust and user-friendly script, `collama.sh`, designed to simplify the installation and management of Ollama, a powerful large language model framework, within the Termux environment on Android devices.  It automates the process, handles dependencies, and offers convenient commands for status checks and server control.

## Features

* **Automated Dependency Management:** The script intelligently checks for and installs necessary dependencies, including `git`, `golang`, `cmake`, and `clang`, ensuring a smooth setup process. It only installs dependencies if Ollama is not already present, optimizing execution time. 📦
* **Ollama Binary Management:** The script manages the Ollama binary, building it from source if necessary and copying it to the appropriate location (`$PREFIX/bin`). It also checks for the existence of the binary before attempting a build, preventing unnecessary rebuilds. ⚙️
* **Comprehensive Status Checks:** Provides detailed status information about Ollama, including whether it's installed, its binary path, and if the server is currently running, along with its process ID (PID).  🔍
* **Server Control:** Offers convenient commands to start and stop the Ollama server (`collama.sh stop`).  🛑/▶️
* **Informative Output:** Provides clear and concise messages throughout the installation and management process, including animated feedback during package installations. Error handling is implemented to provide helpful messages if issues arise.  💬
* **Help Functionality:** A built-in help message (`collama.sh help`) provides usage instructions and details about available commands.  ❓

## Requirements

* **Termux:** Termux, an Android terminal emulator and Linux environment, must be installed on your Android device. 📱
* **Internet Connection:** An active internet connection is required for downloading packages and cloning the Ollama repository. 🌐

## Installation

1. **Clone the repository:**

   ```bash
   git clone https://github.com/rahilsk203/Ollama-Termux.git

 * Navigate to the directory:
   ```bash
   cd Ollama-Termux

 * Execute the installation script:
   ```bash
   bash collama.sh

Usage
The collama.sh script offers the following commands:
 * Install and Start Ollama (default): Running bash collama.sh without any arguments will install Ollama (if it's not already installed) and start the Ollama server in the background.
 * Stop Ollama Server:
   bash collama.sh stop

 * Display Help Message:
   bash collama.sh help

Contributing
Contributions are highly welcome! 🎉 Please open an issue or submit a pull request on the GitHub repository for any bug fixes, feature additions, or improvements. Please ensure that your contributions adhere to the project's coding style and guidelines.

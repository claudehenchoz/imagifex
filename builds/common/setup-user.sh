#!/bin/bash

# imagifex User Setup Script
# Prompts for user creation on first WSL2 startup

set -e

echo "=================================================="
echo "  Welcome to imagifex WSL2 Developer Environment"
echo "=================================================="
echo ""

# Check if running as root or if user already exists
if [ "$EUID" -eq 0 ] || [ "$(whoami)" != "root" ]; then
    echo "Setting up your user account..."
    echo ""
    
    # Prompt for username
    while true; do
        read -p "Enter your desired username: " username
        if [[ "$username" =~ ^[a-z][a-z0-9_-]*$ ]]; then
            break
        else
            echo "Invalid username. Use lowercase letters, numbers, hyphens, and underscores only."
        fi
    done
    
    # Check if user already exists
    if id "$username" &>/dev/null; then
        echo "User $username already exists. Skipping user creation."
        return 0
    fi
    
    # Create user with home directory
    useradd -m -s /bin/bash "$username"
    
    # Add user to sudo group
    usermod -aG sudo "$username"
    
    # Set password
    echo "Setting password for $username..."
    passwd "$username"
    
    # Set up WSL default user
    echo "Setting $username as default WSL user..."
    echo "$username" > /etc/wsl_default_user
    
    echo ""
    echo "User $username created successfully!"
    echo "Please restart your WSL2 session to log in as $username."
    echo ""
else
    echo "User setup already completed or running in non-root context."
fi
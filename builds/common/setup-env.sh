#!/bin/bash

# imagifex Environment Setup Script
# Sets up environment variables and configurations from host OS

set -e

echo "Setting up environment..."

# Create environment file if it doesn't exist
touch ~/.imagifex-env

# Check for environment variables passed from Windows host
if [ ! -z "$IMAGIFEX_HOST_USER" ]; then
    echo "export HOST_USER=\"$IMAGIFEX_HOST_USER\"" >> ~/.imagifex-env
    echo "Host user: $IMAGIFEX_HOST_USER"
fi

if [ ! -z "$IMAGIFEX_HOST_WORKSPACE" ]; then
    echo "export HOST_WORKSPACE=\"$IMAGIFEX_HOST_WORKSPACE\"" >> ~/.imagifex-env
    echo "Host workspace: $IMAGIFEX_HOST_WORKSPACE"
fi

if [ ! -z "$IMAGIFEX_PROJECT_NAME" ]; then
    echo "export PROJECT_NAME=\"$IMAGIFEX_PROJECT_NAME\"" >> ~/.imagifex-env
    echo "Project name: $IMAGIFEX_PROJECT_NAME"
fi

# Source environment in bashrc if not already present
if ! grep -q "source ~/.imagifex-env" ~/.bashrc 2>/dev/null; then
    echo "" >> ~/.bashrc
    echo "# imagifex environment variables" >> ~/.bashrc
    echo "if [ -f ~/.imagifex-env ]; then" >> ~/.bashrc
    echo "    source ~/.imagifex-env" >> ~/.bashrc
    echo "fi" >> ~/.bashrc
fi

# Set up common development directories
mkdir -p ~/workspace ~/projects ~/bin

echo "Environment setup complete!"
echo ""
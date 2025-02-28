#!/bin/bash

# Update package lists
sudo apt-get update

# Install X11 and GUI dependencies
sudo apt-get install -y \
    libx11-dev \
    libxkbfile-dev \
    libsecret-1-dev \
    libnss3 \
    libgtk-3-0 \
    libgdk-pixbuf2.0-0 \
    libasound2 \
    wine64 \
    xvfb \
    x11vnc

# Set permissions
sudo chown -R vscode:vscode /workspaces/${localWorkspaceFolderBasename}

# Set environment variables
echo "export DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=1" >> ~/.bashrc
echo "export DISPLAY=:99" >> ~/.bashrc

# Start X11 and VNC services
Xvfb :99 -screen 0 1024x768x16 &
sleep 2
x11vnc -forever -shared -display :99 &

# Install .NET SDK with Windows compatibility
wget https://packages.microsoft.com/config/debian/12/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
rm packages-microsoft-prod.deb
sudo apt-get update
sudo apt-get install -y dotnet-sdk-8.0 
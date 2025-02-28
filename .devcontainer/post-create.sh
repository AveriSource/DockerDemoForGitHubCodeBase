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
    libasound2

# Install .NET Windows Desktop Runtime
wget https://dot.net/v1/dotnet-install.sh -O dotnet-install.sh
chmod +x dotnet-install.sh
./dotnet-install.sh --channel 8.0 --runtime windowsdesktop
rm dotnet-install.sh

# Set permissions
sudo chown -R vscode:vscode /workspaces/${localWorkspaceFolderBasename}

# Set environment variables
echo "export DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=1" >> ~/.bashrc
echo "export DISPLAY=:99" >> ~/.bashrc

# Start X11 and VNC services
sudo service dbus start || true
sudo service x11-common start || true
sudo /usr/local/share/desktop-init.sh || true 
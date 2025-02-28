#!/bin/bash

# Update package lists
sudo apt-get update

# Install X11, VNC, and other required packages
sudo apt-get install -y \
    libx11-dev \
    libxkbfile-dev \
    libsecret-1-dev \
    libnss3 \
    libgtk-3-0 \
    libgdk-pixbuf2.0-0 \
    libasound2 \
    xvfb \
    x11vnc \
    novnc \
    openbox \
    menu

# Set permissions
sudo chown -R vscode:vscode /workspaces/${localWorkspaceFolderBasename}

# Set environment variables
echo "export DISPLAY=:99" >> ~/.bashrc
echo "export DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=1" >> ~/.bashrc

# Create X11 configuration
mkdir -p ~/.vnc
echo "#!/bin/bash" > ~/.vnc/xstartup
echo "openbox-session &" >> ~/.vnc/xstartup
chmod +x ~/.vnc/xstartup

# Start X11 and VNC services
Xvfb :99 -screen 0 1920x1080x24 &
sleep 2
x11vnc -display :99 -forever -shared -rfbport 6080 &
sleep 2
openbox &

# Install .NET SDK
wget https://packages.microsoft.com/config/debian/12/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
rm packages-microsoft-prod.deb
sudo apt-get update
sudo apt-get install -y dotnet-sdk-8.0 
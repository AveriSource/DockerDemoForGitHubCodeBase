#!/bin/bash

# Start Xvfb
Xvfb :99 -screen 0 1024x768x16 &

# Wait for Xvfb to be ready
sleep 1

# Start VNC server
x11vnc -display :99 -forever -nopw -shared &

# Execute the command passed to the script
exec "$@" 
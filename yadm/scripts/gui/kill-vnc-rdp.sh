#!/bin/bash

# Get all sessions for the user
USER_NAME="pranav"  # Change this if needed

echo "Checking for vnc and rdp services running"
echo ""
systemctl list-units | grep vnc
systemctl list-units | grep rdp
echo ""
echo ""
command_help="sudo systemctl disable vncserver@:1.service"

echo "Disable VNC at startup with: $command_help"
echo ""
echo "Finding stale sessions for user: $USER_NAME..."
echo ""
mapfile -t sessions < <(loginctl list-sessions --no-legend | awk -v user="$USER_NAME" '$3 == user && ($5 == "closing" || $5 == "inactive") {print $1}')

if [ ${#sessions[@]} -eq 0 ]; then
    echo "No stale sessions found."
    exit 0
fi

for session in "${sessions[@]}"; do
    echo "Terminating session ID: $session"
    loginctl terminate-session "$session"
done

echo "Waiting a few seconds for cleanup..."
echo ""
sleep 2

# Optional: Also kill any remaining user processes for safety
echo "Killing remaining processes for user $USER_NAME..."
echo ""
pkill -u "$USER_NAME" -f vnc
pkill -u "$USER_NAME" -f Xorg
pkill -u "$USER_NAME" -f gnome-session

echo ""
echo "Cleanup complete."
echo ""
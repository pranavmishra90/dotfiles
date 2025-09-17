#!/bin/bash
# ~/yadm/scripts/wsl/wsl_port_forwarding.sh
# Auto-forward WSL2 ports if IP changes, with retry logic

WSL2_IP_FILE="$HOME/.wsl2_ip"
MAX_RETRIES=5
SLEEP_SECONDS=2

# Get WSL2 hostname (optional)
HOSTNAME=$(hostname)

# Function to get current WSL2 IP
get_current_ip() {
    hostname -I 2>/dev/null | awk '{print $1}'
}

# Retry loop to get IP if not immediately available
CURRENT_IP=""
for ((i=1; i<=MAX_RETRIES; i++)); do
    CURRENT_IP=$(get_current_ip)
    if [ -n "$CURRENT_IP" ]; then
        break
    fi
    sleep $SLEEP_SECONDS
done

if [ -z "$CURRENT_IP" ]; then
    echo "⚠️ Could not detect WSL2 IP after $((MAX_RETRIES*SLEEP_SECONDS)) seconds."
    exit 1
fi

# Get timestamp
NOW=$(date -Iseconds)

# Read previous IP
PREV_IP=""
if [ -f "$WSL2_IP_FILE" ]; then
    PREV_IP=$(awk '{print $2}' "$WSL2_IP_FILE")
fi

# Compare and update if changed
if [ "$CURRENT_IP" != "$PREV_IP" ]; then
    echo "ℹ️ WSL2 IP changed or first run: $CURRENT_IP"

    # Trigger Windows Scheduled Task to update port forwarding
    REMEMBER_PWD=$(pwd)
    cd /mnt/c/Windows/System32 || exit 1
    cmd.exe /c "SCHTASKS /RUN /TN WSL2_Port_Forwarding"
    cd "$REMEMBER_PWD" || exit 1

    # Save new IP and timestamp
    echo "$NOW $CURRENT_IP" > "$WSL2_IP_FILE"
else
    # IP unchanged, skip
    :
    # echo "ℹ️ WSL2 IP unchanged, skipping port forwarding"
fi

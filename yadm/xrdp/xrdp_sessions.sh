#!/bin/bash

LOG_SESMAN="/var/log/xrdp-sesman.log"
LOG_XRDP="/var/log/xrdp.log"

echo -e "USER\tDISPLAY\tBACKEND\tPID\tSTART\tCLIENT_IP"

ps -eo pid,lstart,user,cmd | grep -E 'X(org|vnc)' | grep -v grep | while read -r PID START1 START2 START3 START4 START5 USER CMD; do
    START="$START1 $START2 $START3 $START4 $START5"
    DISPLAY=$(echo "$CMD" | grep -oP ':[0-9]+' | head -1)
    
    if echo "$CMD" | grep -q Xvnc; then
        BACKEND="Xvnc"
    elif echo "$CMD" | grep -q Xorg; then
        BACKEND="Xorg"
    else
        BACKEND="Unknown"
    fi

    # Try to find client IP using display number in sesman or xrdp log
    CLIENT_IP=$(grep -m 1 "$DISPLAY" "$LOG_SESMAN" "$LOG_XRDP" 2>/dev/null | grep -oP 'from\s+\K[\d\.]+')

    echo -e "$USER\t$DISPLAY\t$BACKEND\t$PID\t$START\t${CLIENT_IP:-N/A}"
done

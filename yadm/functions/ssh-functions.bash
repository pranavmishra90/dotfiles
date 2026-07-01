#!/bin/bash

echo "DEBUG: \$0=$0"
echo "DEBUG: shell=$SHELL"
echo "DEBUG: BASH_VERSION=$BASH_VERSION"
echo "DEBUG: SSH_AUTH_SOCK=$SSH_AUTH_SOCK"


echo "=== DEBUG SSH AGENT STATE ==="

echo "XDG_RUNTIME_DIR=$XDG_RUNTIME_DIR"
echo "SSH_AUTH_SOCK=$SSH_AUTH_SOCK"

echo "--- socket file ---"
ls -l "$XDG_RUNTIME_DIR/ssh-agent.socket" 2>&1

echo "--- agent query ---"
ssh-add -l 2>&1

echo "--- systemd ---"
systemctl --user status ssh-agent.service 2>&1 | sed -n '1,10p'

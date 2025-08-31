#!/bin/bash

# Get a list of all loaded keys and their information
key_list=$(ssh-add -l 2>&1)

if [[ -z "$key_list" || "$key_list" == *"agent"* ]]; then
  echo "No SSH keys found. Initializing keychain."

  # Check if keychain is installed
  if command -v keychain &> /dev/null; then
    eval $(keychain --eval --quick --quiet --inherit any-once --ignore-missing --nogui --agents ssh id_ed25519 automated_ed25519)
    keychain -L
  else
    echo "Keychain is not installed. Please install keychain to manage your SSH keys."
    eval $(ssh-agent)
    ssh-add
  fi
else
  echo "SSH keys loaded:"
  keychain -L

fi

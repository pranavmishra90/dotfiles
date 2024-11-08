#!/bin/bash

# Get a list of all loaded keys and their information
key_list=$(ssh-add -l)

if [ -n "$key_list" ]; then
  # Loop through each key in the list
  echo "$key_list" | while IFS= read -r key_info; do
    # Use sed to keep everything after SHA256:
    trailing_info=$(echo "$key_info" | sed -e 's/^.*SHA256:[^ ]* //')
    echo "Welcome: $trailing_info"
  done
else
  echo "No SSH keys found. Initializing keychain."

  # Check if keychain is installed
  if command -v keychain &> /dev/null; then
    eval $(keychain --eval --agents ssh id_ed25519)
  else
    echo "keychain is not installed. Please install keychain to manage your SSH keys."
  fi
fi
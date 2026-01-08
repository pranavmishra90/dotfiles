#!/bin/bash

# Initialize keychain for non-login shells
alias keychain-init='keychain --eval --agents ssh id_ed25519'

# Function to add SSH keys to the agent using keychain
function add-ssh() {

  # Load the keychain environment if it exists
  [ -f ~/.keychain/$HOSTNAME-sh ] && source ~/.keychain/$HOSTNAME-sh

  # List keys
  if ssh-add -l &>/dev/null; then

    # If no argument is given, use default key
    keyfile="${1:-$HOME/.ssh/id_ed25519}"

    # Add the specified key
    eval $(keychain --eval --agents ssh "$keyfile") 

  else
    echo "No SSH keys loaded. Start a login shell first to initialize keychain."
  
  fi

}


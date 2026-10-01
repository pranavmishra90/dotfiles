#!/bin/bash

export LOG_FILE=/dev/null

check_agent_user_cert() {
  CURRENT_SSH_PUBKEYS=$(ssh-add -L 2>/dev/null)

  echo "$CURRENT_SSH_PUBKEYS" | grep -q "ssh-ed25519-cert-v01@openssh.com"

  if [ $? -eq 0 ]; then
    echo "SSH certificate found in the agent."
    return 0  # SSH certificate found
  else
    echo "No SSH certificate found in the agent."
    return 1  # No SSH certificate found
  fi

}

save_user_ssh_cert() {
  CURRENT_SSH_PUBKEYS=$(ssh-add -L 2>/dev/null)
  TEMP_CERT_FILE="/tmp/$(whoami)-ssh-cert.pub"

  check_agent_user_cert

  if [ $? -eq 0 ]; then
    FIRST_SSH_USER_CERT=$(echo "$CURRENT_SSH_PUBKEYS" | grep "ssh-ed25519-cert-v01@openssh.com" | head -n 1)
    
    # Save the user certificate to a temp file with the user's name, if it is different from an existing file
    if [ -f "$TEMP_CERT_FILE" ]; then
      EXISTING_CERT=$(cat "$TEMP_CERT_FILE")
      if [ "$EXISTING_CERT" != "$FIRST_SSH_USER_CERT" ]; then
        echo "Updating SSH certificate in $TEMP_CERT_FILE"
        echo "$FIRST_SSH_USER_CERT" > "$TEMP_CERT_FILE"
      else
        echo "The certificate present in the agent is the same as the one in $TEMP_CERT_FILE. No update needed."
      fi
    fi
    # If the temp file doesn't exist, create it
    if [ ! -f "$TEMP_CERT_FILE" ]; then
      echo "Saving SSH certificate to $TEMP_CERT_FILE"
      echo "$FIRST_SSH_USER_CERT" > "$TEMP_CERT_FILE"
    fi
  fi
}


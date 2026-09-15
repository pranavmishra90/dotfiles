#!/bin/bash

# Bootstraps the step-ca server and provisions the SSH client with the necessary certificates and configuration.
# wget -q -O /tmp/step-bootstrap.sh https://drpranavmishra.com/homelab/step-ca/step-bootstrap.sh && chmod +x /tmp/step-bootstrap.sh && /tmp/step-bootstrap.sh

#----------------------------------------------------------------------------------

# Report errors and exit if detected
trap 'logger ERROR "line $LINENO: $BASH_COMMAND"; exit 1' ERR
set -e


export STEPPATH=/etc/step
export TARGET_HOME="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

SCRIPT_FULL_PATH="$(realpath "${BASH_SOURCE[0]}")"

if [ ! -f /tmp/bash-logger.bash ]; then
  wget -qO /tmp/bash-logger.bash https://raw.githubusercontent.com/pranavmishra90/dotfiles/refs/heads/master/yadm/functions/bash-logger.bash
fi

source /tmp/bash-logger.bash

LOG_FILE="/dev/null"
create_log_file $LOG_FILE

logger DEBUG "Running step-ca bootstrap script from: $SCRIPT_FULL_PATH"
logger DEBUG "Current working directory: $(pwd)"
logger DEBUG "User: $(whoami). id: $(id)"
logger DEBUG "Target home directory: $TARGET_HOME"

# Pre-flight checks:
if [ "$(id -u)" -ne 0 ]; then
  logger ERROR "This script must be run as root. Please run with sudo or as root user."
  exit 1
fi

logger DEBUG "Checking for required dependencies..."

if [ rsync >/dev/null ]; then
  logger DEBUG "rsync is installed."
else
  logger ERROR "rsync is not installed. Please install rsync and try again."
  exit 1
fi

if [ systemd-detect-virt >/dev/null 2>&1 ]; then
  logger DEBUG "systemd-detect-virt is installed."

  # Determine the host information
  if DETECT_VIRT=$(systemd-detect-virt 2>/dev/null); then
    DETECT_VIRT=$(systemd-detect-virt)
  else
    DETECT_VIRT="bare-metal"
  fi

  logger INFO "Machine type: $DETECT_VIRT"
else
  logger WARNING "systemd-detect-virt is not installed. Please install systemd and try again."
fi

if [ -z "$TARGET_HOME" ]; then
	logger ERROR "TARGET_HOME is not set. Please set TARGET_HOME to the target home directory and try again."
	exit 1
fi


if [ -z "$(command -v step)" ]; then
  logger INFO "step-cli is not installed. Installing step-cli..."

  apt-get update && apt-get install -y --no-install-recommends curl gpg ca-certificates
  mkdir -p /etc/apt/keyrings
  chmod 755 /etc/apt/keyrings
  curl -fsSL https://packages.smallstep.com/keys/apt/repo-signing-key.gpg -o /etc/apt/keyrings/smallstep.asc
  cat <<EOF >/etc/apt/sources.list.d/smallstep.sources
Types: deb
URIs: https://packages.smallstep.com/stable/debian
Suites: debs
Components: main
Signed-By: /etc/apt/keyrings/smallstep.asc
EOF

  apt-get update && apt-get -y install step-cli rsync

else
  logger INFO "step-cli is already installed."
fi


if [ ! -d /etc/step ]; then
  mkdir -p /etc/step/certs
  mkdir -p /etc/step/config
fi


if [ ! -d /etc/step ]; then
  logger ERROR "Could not find /etc/step. Exiting"
  exit 1
fi

# This command does not work well with sudo, so we will copy the configuration output after outputting to the local user

if [ -z "$FORGEJO_ACTION" ]; then
	logger INFO "Running in GitHub Actions. Skipping Step CA bootstrap."
	export CA_URL="https://step.lab.mishracloud.com"
else
	logger INFO "Running outside of GitHub Actions. Bootstrapping Step CA."
	export CA_URL="https://10.1.10.16:443"

fi


if [ ! -f "/etc/step/certs/root_ca.crt" ]; then
  # Bootstrap the CA
  logger INFO "Bootstrapping the CA..."
  STEPPATH=/etc/step step ca bootstrap --ca-url $CA_URL --fingerprint f3a0693edf6f523b84ca1dbbfb56cda14fb4294905358b031b76cb4af319957b --install --force

  last_command_status=$?

  if [ $last_command_status -ne 0 ]; then
    logger ERROR "Step CA bootstrap failed with exit code $last_command_status. Please check the logs for more information."
    exit $last_command_status
  fi

else
  logger INFO "Step CA is already bootstrapped at $STEPPATH"
fi



# Detect and correct/update if Step has been installed into the user directory
if [ -f "$HOME/.step/config/defaults.json" ]; then
  logger DEBUG "Step environment found in the user home directory. Copying to the system directory at $STEPPATH  "
  rsync -ahPcd  --update $HOME/.step/ $STEPPATH/
fi

logger INFO "Copying systemd files for step-ca service and timer..."

# Provision the SSH host
logger INFO "Provisioning the SSH host"

export STEP_HOSTID=$(cat /etc/machine-id)
export STEP_HOSTNAME=$(hostname -f)
export STEP_KEY_TO_SIGN=/etc/ssh/ssh_host_ed25519_key



logger INFO "Checking and provisioning SSH host certificates"

if [ ! -f "/etc/ssh/ssh_host_ed25519_key-cert.pub" ]; then
  logger INFO "Signing a host certificate for $STEP_HOSTNAME with host ID $STEP_HOSTID (/etc/machine-id) using the public key at /etc/ssh/ssh_host_ed25519_key"
  printf "\n\n"
  logger WARNING "Authentication may be required for the next step: generating host certificates"
  echo ""

  STEPPATH=/etc/step step ssh certificate $STEP_HOSTNAME /etc/ssh/ssh_host_ed25519_key.pub \
  --host --host-id $STEP_HOSTID \
  --sign --provisioner pranavmishra@protonmail.com --force \
  --ca-config $STEPPATH/config/ca.json --ca-url $CA_URL --root $STEPPATH/certs/root_ca.crt 

  printf "\n\n"  

  sleep 2
else
  logger WARNING "Host certificate already exists at /etc/ssh/ssh_host_ed25519_key-cert.pub"
  logger DEBUG "$(ssh-keygen -L -f /etc/ssh/ssh_host_ed25519_key-cert.pub)"
  logger DEBUG "Checking validity and expiration"

  if (step ssh needs-renewal /etc/ssh/ssh_host_ed25519_key-cert.pub); then
    logger WARNING "The host certificate is expired. Renewing ..."
    STEPPATH=/etc/step step ssh certificate $STEP_HOSTNAME /etc/ssh/ssh_host_ed25519_key.pub \
          --host --host-id $STEP_HOSTID \
          --sign --provisioner pranavmishra@protonmail.com --force \
          --ca-config $STEPPATH/config/ca.json --ca-url $CA_URL --root $STEPPATH/certs/root_ca.crt
  else
    
    logger INFO "The host certificate is valid and does not require renewal."
    step ssh inspect /etc/ssh/ssh_host_ed25519_key-cert.pub
  fi
fi

# Print out the host SSH certificate
logger DEBUG "$(ssh-keygen -L -f /etc/ssh/ssh_host_ed25519_key-cert.pub)"


logger INFO "Configuring ssh users (clients) on this machine to trust the Step SSH CA signed hosts"

logger INFO "Configuring the system known_hosts at /etc/ssh/MishraLab_ssh_known_hosts to trust the SSH CA"

tee /etc/ssh/MishraLab_ssh_known_hosts > /dev/null <<EOF
@cert-authority * ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBAoIOkszxD5t3WJf77YIklW+8TzRQ4or4fB/ylDxLBDhMpdf+GXqQ6pzTkBgbz6760DMISZa8ls6aRlDzhge6OQ=
EOF



tee /etc/ssh/ssh_config.d/01-Step-CA.conf > /dev/null <<EOF
# Step SSH CA Configuration
#----------------------------
# Trust the MishraLab SSH host CA for *.mishracloud.com

Host *.mishracloud.com
    GlobalKnownHostsFile /etc/ssh/MishraLab_ssh_known_hosts

# Preserve the normal system-wide host trust for other destinations
Host *
    GlobalKnownHostsFile /etc/ssh/ssh_known_hosts
EOF


logger INFO "Configuring SSHD (the host SSH server) to trust incoming Step SSH CA signed user certificates"

tee /etc/ssh/MishraLab_step_ssh_user_key.pub > /dev/null <<EOF
ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBGUUsdglmVexK5m2Gg+HamswJH6vwApat5W01CtXJ/m4nLQYgkg0a9OWLBjO7Vb6He75rSub6WuvE1b/ck0I+pc=
EOF

# Configure `sshd`
logger INFO "Configuring SSHD to use the signed host certificate and trust the SSH CA"

cp -v 

logger INFO "Setting permissions for the SSHD configuration files"
chmod 644 /etc/ssh/sshd_config
chmod 644 /etc/ssh/MishraLab_ssh_known_hosts
chmod 444 /etc/ssh/MishraLab_step_ssh_user_key.pub
chmod 644 /etc/ssh/sshd_config.d/01-Step-CA.conf

# Test the SSHD configuration
printf "\n\n"
logger DEBUG "Current SSHD configuration:"
sshd -T | grep 'MishraLab'
sshd -T | grep /etc/ssh/ssh_host_ed25519_key

logger INFO "Verifying SSHD configuration"
sshd -t

logger INFO "Restarting SSHD to apply the new configuration"
systemctl restart sshd
logger INFO "Restarting SSH service to apply the new configuration"
systemctl restart ssh

printf "\n\n"
logger INFO "Checking SSHD status"
systemctl status sshd --no-pager

logger INFO "Checking SSH service status"
systemctl status ssh --no-pager

logger INFO "Completed SSH host provisioning and configuration."

# Copy the systemd files for x509 and SSH certificate renewals

logger INFO "Configuring systemd"

cp -r $TARGET_HOME/yadm/etc/systemd/system/ /etc/systemd

logger DEBUG "cert files in /etc/systemd/system: $(ls /etc/systemd/system/ | grep cert)"

systemctl daemon-reload

systemctl enable --now ssh-cert-renewer.service
systemctl enable --now ssh-cert-renewer.timer

logger INFO "Checking the status of the SSH certificate renewer service and timer"
systemctl list-unit-files --all --no-pager '*cert*'

logger DEBUG "SSH certificate renewer service and timer status:"

logger INFO "Step CA bootstrap and SSH host provisioning completed. Exiting"

exit 0

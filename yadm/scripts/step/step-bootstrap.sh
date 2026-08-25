#!/bin/bash

# Bootstraps the step-ca server and provisions the SSH client with the necessary certificates and configuration.
# wget -q -O /tmp/step-bootstrap.sh https://drpranavmishra.com/homelab/step-ca/step-bootstrap.sh && chmod +x /tmp/step-bootstrap.sh && /tmp/step-bootstrap.sh

#----------------------------------------------------------------------------------

set -euo pipefail

if [ "$EUID" -ne 0 ]; then
  echo "Please run as root"
  exit
fi

if [ ! -f /tmp/bash-logger.bash ]; then
    wget -qO /tmp/bash-logger.bash https://raw.githubusercontent.com/pranavmishra90/dotfiles/f2769cb50b36fe6a1b667f79a92a5a803e2d223e/yadm/functions/bash-logger.bash

    
fi

source /tmp/bash-logger.bash

LOG_FILE="/tmp/step-bootstrap.log"
create_log_file $LOG_FILE

# Determine the host information
if DETECT_VIRT=$(systemd-detect-virt 2>/dev/null); then
  DETECT_VIRT=$(systemd-detect-virt)
else
  DETECT_VIRT="bare-metal"
fi

echo "Machine type: $DETECT_VIRT"


if [ -z "$(command -v step)" ]; then
  logger INFO "step-cli is not installed. Installing step-cli..."

  apt-get update && apt-get install -y --no-install-recommends curl gpg ca-certificates
  curl -fsSL https://packages.smallstep.com/keys/apt/repo-signing-key.gpg -o /etc/apt/keyrings/smallstep.asc
  cat << EOF > /etc/apt/sources.list.d/smallstep.sources
Types: deb
URIs: https://packages.smallstep.com/stable/debian
Suites: debs
Components: main
Signed-By: /etc/apt/keyrings/smallstep.asc
EOF

	apt-get update && apt-get -y install step-cli

else
  logger INFO "step-cli is already installed."
fi

# Bootstrap the CA
logger INFO "Bootstrapping the CA..."

step ca bootstrap --ca-url https://step-ca.lab.mishracloud.com --fingerprint f3a0693edf6f523b84ca1dbbfb56cda14fb4294905358b031b76cb4af319957b --install --force

# Verify the CA health
if [ $(step ca health) == "ok" ]; then
  logger INFO "CA is healthy and ready to use."
else
  logger ERROR "CA health check failed. Please check the CA logs for more information."
  exit 1
fi

# Provision the SSH host
logger INFO "Provisioning the SSH host"

STEP_HOSTID=$(cat /etc/machine-id)
STEP_HOSTNAME=$(hostname -f)
STEP_KEY_TO_SIGN=/etc/ssh/ssh_host_ed25519_key

logger INFO "Signing a host certificate for $STEP_HOSTNAME with host ID $STEP_HOSTID (/etc/machine-id) using the public key at $STEP_KEY_TO_SIGN"

#   --principle $STEP_HOSTNAME --principle $(hostname) \
step ssh certificate $STEP_HOSTNAME $STEP_KEY_TO_SIGN.pub \
  --host --host-id $STEP_HOSTID \
  --sign --provisioner pranavmishra@protonmail.com --force 
  

sleep 2

logger INFO "Configuring SSHD to accept the root host certificate"

tee /etc/ssh/MishraLab_step_ssh_user_key.pub > /dev/null <<EOF
ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBGUUsdglmVexK5m2Gg+HamswJH6vwApat5W01CtXJ/m4nLQYgkg0a9OWLBjO7Vb6He75rSub6WuvE1b/ck0I+pc=
EOF

logger INFO "Configuring the system known_hosts at /etc/ssh/known_hosts to trust the SSH CA"

tee /etc/ssh/known_hosts > /dev/null <<EOF
@cert-authority * ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBAoIOkszxD5t3WJf77YIklW+8TzRQ4or4fB/ylDxLBDhMpdf+GXqQ6pzTkBgbz6760DMISZa8ls6aRlDzhge6OQ=
EOF



# Configure `sshd`
logger INFO "Configuring SSHD to use the signed host certificate and trust the SSH CA"

tee /etc/ssh/sshd_config.d/01-Step-CA.conf > /dev/null <<EOF
# Step SSH CA Configuration
# The path to the CA public key for authenticatin user certificates
TrustedUserCAKeys MishraLab_step_ssh_user_key.pub
# Path to the private key and certificate
HostKey $STEP_KEY_TO_SIGN
HostCertificate $STEP_KEY_TO_SIGN-cert.pub
EOF

chmod 644 /etc/ssh/sshd_config
chmod 644 /etc/ssh/known_hosts
chmod 444 /etc/ssh/MishraLab_step_ssh_user_key.pub
chmod 644 /etc/ssh/sshd_config.d/01-Step-CA.conf

# Test the SSHD configuration
printf "\n\n"
logger DEBUG "Current SSHD configuration:"
sshd -T | grep 'MishraLab'
sshd -T | grep $STEP_KEY_TO_SIGN

logger INFO "Verifying SSHD configuration"
sshd -t

logger INFO "Restarting SSHD to apply the new configuration"
systemctl restart sshd

printf "\n\n"
logger INFO "Checking SSHD status"
systemctl status sshd --no-pager

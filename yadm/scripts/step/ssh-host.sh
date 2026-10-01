#!/bin/bash
# SPDX-License-Identifier: Apache-2.0
#
# Copyright (C) 2022 Smallstep Labs, Inc. All Rights Reserved.

set -eo pipefail

helptext(){
cat <<'EOF'

                              ssh-host.sh
                Register smallstep SSH on smallstep.com
                 or your smallstep run-anywhere cluster

                    https://smallstep.com/docs/ssh/hosts

                          Copyright (C) 2022
                          Smallstep Labs, Inc
                          All Rights Reserved

                    SPDX-License-Identifier: Apache-2.0

     Example:
    ./ssh-host.sh --team example --token <token> --tag foo=bar --tag baz=buzz

    Required Flags or Environment Variables:
        --team example
        --hostname host.example.com
        --token Daslsjdl..asldfkja
        --tag foo=bar

        STEP_SSH_TEAM=example
        STEP_SSH_TOKEN=Daslsjdl..asldfkja
        STEP_SSH_TAGS="foo=bar baz=buzz bat-cat=matt-rap"
        STEP_SSH_HOSTNAME=foo.example.com

    The hostname variable will be read from ${HOSTNAME} when STEP_SSH_HOSTNAME
    and --hostname are not set. The --tag flag can be called many times.

    Optional Flags or Environment Variables:
        --principal foo --principal foo.example.com --principal foo.example.net
        --proxy https://proxy.example.biz:8080
        --team-url https://api.smallstep.com
        --version 0.27.0
        --redirect-url https://example.biz/yay/success
        --context mycontext
        --bastion bastion.example.com
        --is-bastion
        --force
        --install-only
        --disable-modules
        --disable-nss
        --disable-pam
        --disable-sudo

    --principal can be used many times.
    --is-bastion has no parameters.
    --force has no parameters and it will overwrite existing cert data.
    --version if not used will install the latest stable version.

    Environment variables:
        STEP_SSH_PRINCIPALS_FLAGS="foo foo.example.com foo.example.net"
        STEP_SSH_TEAM_URL="https://api.smallstep.com"
        STEP_SSH_VERSION="0.27.0"
        STEP_SSH_REDIRECT_URL=https://example.biz/yay/success
        STEP_SSH_PROXY=https://proxy.example.biz:8080
        STEP_SSH_CONTEXT=mycontext
        STEP_SSH_BASTION=bastion.example.com
        STEP_SSH_IS_BASTION="true"
        STEP_SSH_FORCE="true"
        STEP_DISABLE_MODULES="true"
        STEP_DISABLE_NSS="true"
        STEP_DISABLE_PAM="true"
        STEP_DISABLE_SUDO="true"

    STEPPATH can be set to override the configuration and state directory for
    the step binary.

    Configuration precedence for required variables:
    1) Flags
    2) Environment variables
    3) Prompts

EOF
exit 0
}

is_freebsd() {
  [ "$(uname)" = "FreeBSD" ]
  return $?
}

is_suse() {
  local os_release="${_OS_RELEASE_FILE:-/etc/os-release}"
  [ -f "$os_release" ] || return 1
  grep -qE '^ID="?(sles|opensuse-leap|opensuse-tumbleweed)"?' "$os_release" && return 0
  grep -qE '^ID_LIKE=.*suse' "$os_release" && return 0
  return 1
}

if ! [ "$(id -u)" = 0 ]; then
   echo "This script must be run as root."
   exit 1
fi

: ${STEPPATH:=/root/.step}

STEP_SSH_DOWNLOAD_DIR=$(mktemp -d)
if [[ ! "${STEP_SSH_DOWNLOAD_DIR}" || ! -d "${STEP_SSH_DOWNLOAD_DIR}" ]]; then
  echo "Could not create temporary download directory!"
  exit 1
fi

cleanup_downloads() {
  rm -rf "${STEP_SSH_DOWNLOAD_DIR}"
  echo "Removing temporary download directory ${STEP_SSH_DOWNLOAD_DIR}!"
}

trap cleanup_downloads EXIT

# Get flags
while [ $# -gt 0 ]; do
    case "$1" in
        --team)
            STEP_SSH_TEAM="$2"
            shift
            shift
            ;;
        --token)
            STEP_SSH_TOKEN="$2"
            shift
            shift
            ;;
        --token-file)
            STEP_SSH_TOKEN_FILE="$2"
            shift
            shift
            ;;
        --hostname)
            STEP_SSH_HOSTNAME="$2"
            shift
            shift
            ;;
        --proxy)
            STEP_SSH_PROXY="$2"
            shift
            shift
            ;;
        --version)
            STEP_SSH_VERSION="$2"
            shift
            shift
            ;;
        --tag)
            STEP_SSH_TAGS_FLAGS="${STEP_SSH_TAGS_FLAGS} $2"
            shift
            shift
            ;;
        --principal)
            STEP_SSH_PRINCIPALS_FLAGS="${STEP_SSH_PRINCIPALS_FLAGS} $2"
            shift
            shift
            ;;
        --team-url)
            STEP_SSH_TEAM_URL="$2"
            shift
            shift
            ;;
        --redirect-url)
            STEP_SSH_REDIRECT_URL="$2"
            shift
            shift
            ;;
        --context)
            STEP_SSH_CONTEXT="$2"
            shift
            shift
            ;;
	    --disable-modules)
            STEP_DISABLE_MODULES="true"
            shift
            ;;
        --disable-nss)
            STEP_DISABLE_NSS="true"
            shift
            ;;
        --disable-pam)
            STEP_DISABLE_PAM="true"
            shift
            ;;
        --disable-sudo)
            STEP_DISABLE_SUDO="true"
            shift
            ;;
        --bastion)
            STEP_SSH_BASTION="$2"
            shift
            shift
            ;;
        --is-bastion)
            STEP_SSH_IS_BASTION="true"
            shift
            ;;
        --force)
            STEP_SSH_FORCE="true"
            shift
            ;;
        --install-only)
            STEP_SSH_INSTALL_ONLY="true"
            shift
            ;;
        --help)
            helptext
            ;;
        *)
            shift
            ;;
    esac
done

if is_freebsd; then
    STEP_DISABLE_MODULES="true"
fi

# Get CPU Architecture
GNUARCH=$(uname -m)
case $GNUARCH in
    amd64) ARCH="amd64" ;;
    x86_64) ARCH="amd64" ;;
    x86) ARCH="386" ;;
    i686) ARCH="386" ;;
    i386) ARCH="386" ;;
    aarch64) ARCH="arm64" ;;
    armv5*) ARCH="armv5" ;;
    armv6*) ARCH="armv6" ;;
    armv7*) ARCH="armv7" ;;
esac

if [[ "${ARCH}" != "amd64" ]] && [[ "${ARCH}" != "arm64" ]]; then
    echo "This script only works on amd64 and arm64 instances, for now."
    exit 1
fi

# version
if [[ -v STEP_SSH_VERSION ]]; then
    VERSION="${STEP_SSH_VERSION}"
    RPM_PKG="step-ssh_${VERSION}_${ARCH}.rpm"
else
    VERSION="latest"
    RPM_PKG="step-ssh_${VERSION}_${GNUARCH}.rpm"
fi

DEB_PKG="step-ssh_${VERSION}_${ARCH}.deb"
FREEBSD_PKG="step-ssh_freebsd_${VERSION}_${ARCH}.tar.gz"

# Install `step` CLI
echo ""
echo "Downloading and installing step CLI and step-ssh utilities..."
OS="linux"
if is_freebsd; then
    OS="freebsd"
fi

curl -s -L -o "${STEP_SSH_DOWNLOAD_DIR}/step" "https://dl.smallstep.com/s3/cli/ssh-host-install-script/step_latest_${OS}_${ARCH}"
install -m 0755 "${STEP_SSH_DOWNLOAD_DIR}/step" /usr/bin/step

# Install `step-ssh` utilities
if hash dpkg 2>/dev/null; then
    curl -s -L -o "${STEP_SSH_DOWNLOAD_DIR}/${DEB_PKG}"  "https://dl.smallstep.com/s3/ssh/ssh-host-install-script/${DEB_PKG}"
    dpkg -i "${STEP_SSH_DOWNLOAD_DIR}/${DEB_PKG}"
elif is_freebsd; then
    curl -s -L -o "${STEP_SSH_DOWNLOAD_DIR}/${FREEBSD_PKG}" "https://dl.smallstep.com/s3/ssh/ssh-host-install-script/${FREEBSD_PKG}"
    tar -C "${STEP_SSH_DOWNLOAD_DIR}" -xzvf "${STEP_SSH_DOWNLOAD_DIR}/${FREEBSD_PKG}"

    install -m 0755 "${STEP_SSH_DOWNLOAD_DIR}/step-ssh_freebsd/step-ssh-ctl" /usr/bin/step-ssh-ctl
    install -m 0755 "${STEP_SSH_DOWNLOAD_DIR}/step-ssh_freebsd/step-ssh" /usr/bin/step-ssh
elif is_suse; then
    # The RPM is signed with the Smallstep packaging key (0x889B19391F774443);
    # import its public key so zypper verifies the signature. The %post
    # scriptlet creates the runtime dirs and loads the SELinux policy module
    # where applicable.
    rpm --import "https://packages.smallstep.com/keys/smallstep-0x889B19391F774443.gpg"
    curl -s -L -o "${STEP_SSH_DOWNLOAD_DIR}/${RPM_PKG}" "https://dl.smallstep.com/s3/ssh/ssh-host-install-script/${RPM_PKG}"
    zypper --non-interactive install "${STEP_SSH_DOWNLOAD_DIR}/${RPM_PKG}"
elif [ -f "/etc/redhat-release" ] &&  grep -q '^\(CentOS\|Red Hat\)[^0-9]*8\..' "/etc/redhat-release"; then
    curl -s -L -o "${STEP_SSH_DOWNLOAD_DIR}/${RPM_PKG}" "https://dl.smallstep.com/s3/ssh/ssh-host-install-script/${RPM_PKG}"
    dnf -y install "${STEP_SSH_DOWNLOAD_DIR}/${RPM_PKG}"
else
    curl -s -L -o "${STEP_SSH_DOWNLOAD_DIR}/${RPM_PKG}" "https://dl.smallstep.com/s3/ssh/ssh-host-install-script/${RPM_PKG}"
    if command -v dnf >/dev/null 2>&1; then
        dnf -y install "${STEP_SSH_DOWNLOAD_DIR}/${RPM_PKG}"
    else
        yum -y localinstall "${STEP_SSH_DOWNLOAD_DIR}/${RPM_PKG}"
    fi
fi

# Exit if --install-only flag is set
if [[ -v STEP_SSH_INSTALL_ONLY ]]; then
    echo "Installation complete. Skipping configuration steps due to --install-only flag."
    exit 0
fi

# Check for required STEP_SSH_ prefixed variables set from the environment
# or required flags and then prompt for required variables if missing.
unset TEAM
if [[ -v STEP_SSH_TEAM ]]; then
    TEAM=${STEP_SSH_TEAM}
else
    echo ""
    echo "A team is required!"
    read -p "Team: " TEAM
    TEAM=${TEAM}
fi

unset TOKEN
if [[ -v STEP_SSH_TOKEN ]]; then
    TOKEN="$(echo -e "${STEP_SSH_TOKEN}" | sed -e 's/[[:space:]]*$//' | tr -d '\n')"
elif [[ -v STEP_SSH_TOKEN_FILE ]]; then
    if [[ ! -f "${STEP_SSH_TOKEN_FILE}" ]]; then
        echo "Token file ${STEP_SSH_TOKEN_FILE} does not exist!"
        exit 1
    fi
    TOKEN="$(cat "${STEP_SSH_TOKEN_FILE}" | sed -e 's/[[:space:]]*$//' | tr -d '\n')"
else
    echo ""
    echo "An SSH enrollment token is required!"
    read -s -p "Enrollment token (hidden): " TOKEN
    TOKEN="$(echo -e "${TOKEN}" | sed -e 's/[[:space:]]*$//' | tr -d '\n')"
fi

if [[ -v STEP_SSH_HOSTNAME ]]; then
    HOSTNAME=${STEP_SSH_HOSTNAME}
elif [[ -v HOSTNAME ]]; then
    HOSTNAME=${HOSTNAME}
else
    echo ""
    echo "A hostname is required!"
    read -p "Hostname: " HOSTNAME
fi

## There can be many --tag flags so use them if they are set.
## --tag foo=bar --tag bax=fax --tag mop.top=cat-bat
unset TAGS
if [[ -v STEP_SSH_TAGS_FLAGS ]]; then
    TAGS="${STEP_SSH_TAGS_FLAGS}"
## Use STEP_SSH_TAGS="foo=bar bax=fax mop.top=cat-bat"
elif [[ -v STEP_SSH_TAGS ]]; then
    TAGS="${STEP_SSH_TAGS}"
## If no --tag or STEP_SSH_TAGS then prompt for tags
else
    echo ""
    echo "One or more tags are required!"
    echo "Example: foo=bar bax=fax mop.top=cat-bat"
    read -p "Tag(s): " TAGS
fi

# Optional Flags / Environment Variables
# team-url
if [[ -v STEP_SSH_TEAM_URL ]]; then
    TEAM_URL="${STEP_SSH_TEAM_URL}"
fi

# redirect-flag
if [[ -v STEP_SSH_REDIRECT_URL ]]; then
    REDIRECT_URL=${STEP_SSH_REDIRECT_URL}
    REDIRECT_FLAG="--redirect-url ${REDIRECT_URL}"
else
    REDIRECT_FLAG=""
fi

# principal
# There can be many --principal flags so use them if they are set.
# --principal foo --principal foo.example.biz --principal foo.example.net
if [[ -v STEP_SSH_PRINCIPALS_FLAGS ]]; then
    PRINCIPALS="${STEP_SSH_PRINCIPALS_FLAGS}"
# Use STEP_SSH_PRINCIPALS="foo foo.example.biz foo.example.net"
elif [[ -v STEP_SSH_PRINCIPALS ]]; then
    PRINCIPALS="${STEP_SSH_PRINCIPALS}"
fi

# proxy
if [[ -v STEP_SSH_PROXY ]]; then
    PROXY=${STEP_SSH_PROXY}
    PROXY_FLAG="--proxy ${PROXY}"
    export HTTPS_PROXY=${PROXY}
    export http_proxy=${PROXY}
else
    PROXY_FLAG=""
fi

# context
if [[ -v STEP_SSH_CONTEXT ]]; then
    CONTEXT=${STEP_SSH_CONTEXT}
    CONTEXT_FLAG="--context ${CONTEXT}"
else
    CONTEXT_FLAG=""
fi

# PAM / NSS modules
if [[ -v STEP_DISABLE_MODULES ]]; then
    DISABLE_MODULES_FLAG="--disable-modules"
else
    DISABLE_MODULES_FLAG=""
fi

if [[ -v STEP_DISABLE_NSS ]]; then
    DISABLE_NSS_FLAG="--disable-nss"
else
    DISABLE_NSS_FLAG=""
fi

if [[ -v STEP_DISABLE_PAM ]]; then
    DISABLE_PAM_FLAG="--disable-pam"
else
    DISABLE_PAM_FLAG=""
fi

if [[ -v STEP_DISABLE_SUDO ]]; then
    DISABLE_SUDO_FLAG="--disable-sudo"
else
    DISABLE_SUDO_FLAG=""
fi

# bastion
if [[ -v STEP_SSH_BASTION ]]; then
    BASTION=${STEP_SSH_BASTION}
fi

# is-bastion
if [[ -v STEP_SSH_IS_BASTION ]]; then
    IS_BASTION=${STEP_SSH_IS_BASTION}
fi

# force
if [[ -v STEP_SSH_FORCE ]]; then
    FORCE_FLAG="--force"
fi

# Tag formatting and validation:
#   - Check tags with a regex to make sure they match the correct format of
#     key=value. Valid characters are: a-z A-Z 0-9 - _ .
#   - Process space-separated tags ("foo=bar baz=blort maps-traps=chap.caps")
#     and insert `--tag` flags around each tag pair.
IFS=" " read -a INPUT_TAGS <<< ${TAGS}
TAG_REGEX='^[A-Za-z0-9._-]+\=[A-Za-z0-9._-]+$'

for TAG in "${INPUT_TAGS[@]}"; do
 if [[ "$TAG" =~ $TAG_REGEX ]]; then
    OUTPUT_TAGS+="--tag ${TAG} "
  else
    echo ""
    echo "${TAG} is an invalid tag format!"
    echo ""
    echo "Please use the following format:"
    echo -e "\tfoo=bar bat-fax=hax-jax map.traps=raps.cats"
    echo "Valid characters are: a-z A-Z 0-9 - _ ."
    echo ""
    exit 1
  fi
done
TAGS="${OUTPUT_TAGS}"

# Principal formatting
if [[ -v PRINCIPALS ]]; then
    IFS=" " read -a INPUT_PRINCIPALS <<< ${PRINCIPALS}
    for PRINCIPAL in "${INPUT_PRINCIPALS[@]}"; do
        OUTPUT_PRINCIPALS+="--principal ${PRINCIPAL} "
    done
    PRINCIPALS="${OUTPUT_PRINCIPALS}"
fi

# Display required options
echo ""
echo "Required variables:"
echo -e "\tTeam:\t\t${TEAM}"
echo -e "\tToken:\t\t${TOKEN:0:10}...snip...${TOKEN: -10}"
echo -e "\tHostname:\t${HOSTNAME}"
echo -e "\tTag(s):\t\t$(echo ${TAGS}| sed -e "s/\--tag //g")"
echo ""
echo "Optional variables:"
# Display optional options if set
if [[ -v TEAM_URL ]]; then
    echo -e "\tTeam-URL:\t${TEAM_URL}"
fi
if [[ -v REDIRECT_URL ]]; then
    echo -e "\tRedirect-URL:\t${REDIRECT_URL}"
fi
if [[ -v PRINCIPALS ]]; then
    echo -e "\tPrincipals:\t$(echo ${PRINCIPALS}| sed -e "s/\--principal //g")"
fi
if [[ -v IS_BASTION ]]; then
echo -e "\tIs-Bastion:\t${IS_BASTION}"
fi
if [[ -v BASTION ]]; then
echo -e "\tBastion:\t${BASTION}"
fi
if [ -v CONTEXT ]; then
    echo -e "\tContext:\t${CONTEXT}"
fi
if [ -v FORCE_FLAG ]; then
    echo -e "\tForce:\ttrue"
fi
if [ -v VERSION ]; then
    echo -e "\tVersion:\t${VERSION}"
fi

# Configure `step` to connect to your CA
echo ""
echo "Configuring step-ssh..."
if [[ -v TEAM_URL ]]; then
    step ca bootstrap --team=${TEAM} --team-url ${TEAM_URL}/v1/teams/${TEAM}/authorities/ssh \
    ${CONTEXT_FLAG} ${FORCE_FLAG} ${REDIRECT_FLAG}
else
    step ca bootstrap --team=${TEAM} ${CONTEXT_FLAG} ${FORCE_FLAG} ${REDIRECT_FLAG}
fi

# Get an SSH host certificate
echo ""
echo "Generate SSH host certificate..."
if [[ -v PRINCIPALS ]]; then
    step ssh certificate ${CONTEXT_FLAG} ${HOSTNAME} /etc/ssh/ssh_host_ecdsa_key.pub \
        --host --sign --provisioner "Service Account" --token ${TOKEN} --principal ${HOSTNAME} ${PRINCIPALS} ${FORCE_FLAG}
else
    step ssh certificate ${CONTEXT_FLAG} ${HOSTNAME} /etc/ssh/ssh_host_ecdsa_key.pub \
        --host --sign --provisioner "Service Account" --token ${TOKEN} ${FORCE_FLAG}
fi

# Configure sshd to use certificate authentication
# TODO: update this with context once this command accepts a context
echo ""
echo "Configure SSHD to use certificate authentication..."
step ssh config --host --set Certificate=ssh_host_ecdsa_key-cert.pub \
                       --set Key=ssh_host_ecdsa_key

# Activate PAM/NSS modules and setup identity certificate renewal
step-ssh ${DISABLE_MODULES_FLAG} ${DISABLE_NSS_FLAG} ${DISABLE_PAM_FLAG} ${DISABLE_SUDO_FLAG} ${PROXY_FLAG} ${CONTEXT_FLAG} activate ${HOSTNAME}

# On SELinux hosts, apply the label the step-ssh policy defines for root's
# STEPPATH (step_t). The PAM session hooks run in the SSH daemon's SELinux
# domain and rely on that label to access the step-ssh configuration.
if command -v restorecon >/dev/null 2>&1 && command -v selinuxenabled >/dev/null 2>&1 && selinuxenabled; then
    # Non-fatal: enrollment proceeds either way, but surface the failure.
    restorecon -R "${STEPPATH}" || echo "warning: restorecon -R ${STEPPATH} failed; SSH session reporting may be denied by SELinux" >&2
fi

# Register the host and add group(s)
echo ""
echo "Registering host..."
if [ "${IS_BASTION}" = "true" ]; then
    if [[ -n ${BASTION} ]]; then
        step-ssh-ctl ${PROXY_FLAG} ${CONTEXT_FLAG} register ${TAGS} --hostname ${HOSTNAME} --bastion ${BASTION} --is-bastion
    else
        step-ssh-ctl ${PROXY_FLAG} ${CONTEXT_FLAG} register ${TAGS} --hostname ${HOSTNAME} --is-bastion
    fi
else
    if [[ -n ${BASTION} ]]; then
        step-ssh-ctl ${PROXY_FLAG} ${CONTEXT_FLAG} register ${TAGS} --hostname ${HOSTNAME} --bastion ${BASTION}
    else
        step-ssh-ctl ${PROXY_FLAG} ${CONTEXT_FLAG} register ${TAGS} --hostname ${HOSTNAME}
    fi
fi

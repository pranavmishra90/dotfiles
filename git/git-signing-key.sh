#!/bin/sh

# Prefer an SSH certificate exposed by the forwarded agent.
if [ -n "$SSH_AUTH_SOCK" ]; then
    key="$(ssh-add -L 2>/dev/null |
        grep '^ssh-ed25519-cert-v01@openssh.com ' |
        head -n 1)"

    if [ -n "$key" ]; then
        printf 'key::%s\n' "$key"
        exit 0
    fi

    # Fall back to a regular Ed25519 key exposed by the agent.
    key="$(ssh-add -L 2>/dev/null |
        grep '^ssh-ed25519 ' |
        head -n 1)"

    if [ -n "$key" ]; then
        printf 'key::%s\n' "$key"
        exit 0
    fi
fi

# Finally, support a locally available public key.
pubkey="$HOME/.ssh/id_ed25519.pub"

if [ -r "$pubkey" ]; then
    printf 'key::'
    cat "$pubkey"
    exit 0
fi

echo "git signing: no SSH signing key available" >&2
exit 1

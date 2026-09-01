#!/bin/sh
set -eu

cert="$HOME/.ssh/id_ed25519-cert.pub"

test -r "$cert" || {
    echo "No SSH signing certificate: $cert" >&2
    exit 1
}

printf 'key::'
cat "$cert"

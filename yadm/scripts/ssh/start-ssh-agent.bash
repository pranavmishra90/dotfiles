#!/usr/bin/env bash

require_ssh_tools() {
    if ! command -v ssh-add >/dev/null 2>&1; then
        echo "ERROR: required command not found: ssh-add" >&2
        return 1
    fi

    if ! command -v ssh-agent >/dev/null 2>&1; then
        echo "ERROR: required command not found: ssh-agent" >&2
        return 1
    fi

    return 0
}

ssh_sock_is_valid() {
    local sock="${1:-}"

    [ -n "$sock" ] || return 1
    [ -S "$sock" ] || return 1

    SSH_AUTH_SOCK="$sock" ssh-add -l >/dev/null 2>&1

    case $? in
        0|1)
            return 0
            ;;
        *)
            return 1
            ;;
    esac
}


ssh_find_existing_agent() {
    local fixed_sock="$HOME/.ssh/ssh_auth_sock"

    # Prefer inherited socket
    if [ -n "${SSH_AUTH_SOCK:-}" ] &&
       ssh_sock_is_valid "$SSH_AUTH_SOCK"; then
        return 0
    fi

    # Use our persistent socket
    if ssh_sock_is_valid "$fixed_sock"; then
        export SSH_AUTH_SOCK="$fixed_sock"
        return 0
    fi

    return 1
}


ssh_start_agent() {
    local sock="${1:-$HOME/.ssh/ssh_auth_sock}"

    mkdir -p "$(dirname "$sock")"

    if ssh_sock_is_valid "$sock"; then
        export SSH_AUTH_SOCK="$sock"
        return 0
    fi

    rm -f "$sock"

    eval "$(ssh-agent -a "$sock")" >/dev/null
    export SSH_AUTH_SOCK="$sock"
}


bootstrap_ssh_agent() {
    require_ssh_tools || return 1

    mkdir -p "$HOME/.ssh"

    if ssh_find_existing_agent; then
        return 0
    fi

    ssh_start_agent
    return $?
}


main() {
    bootstrap_ssh_agent || return 1

    echo "SSH_AUTH_SOCK=$SSH_AUTH_SOCK"
    return 0
}


if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
    exit $?
fi
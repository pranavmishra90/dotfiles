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
    local runtime_sock="${XDG_RUNTIME_DIR:-/run/user/$UID}/ssh-agent.socket"

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

    # Use runtime socket and normalize to fixed socket path.
    if ssh_sock_is_valid "$runtime_sock"; then
        ln -snf "$runtime_sock" "$fixed_sock" || return 1
        export SSH_AUTH_SOCK="$fixed_sock"
        return 0
    fi

    return 1
}


ssh_start_agent() {
    local sock="${1:-$HOME/.ssh/ssh_auth_sock}"
    local agent_output
    local agent_rc

    mkdir -p "$(dirname "$sock")" || return 1

    if ssh_sock_is_valid "$sock"; then
        export SSH_AUTH_SOCK="$sock"
        return 0
    fi

    rm -f "$sock"

    agent_output="$(ssh-agent -a "$sock")"
    agent_rc=$?
    if [ "$agent_rc" -ne 0 ]; then
        echo "ERROR: failed to start ssh-agent on socket: $sock" >&2
        return 1
    fi

    if ! eval "$agent_output" >/dev/null; then
        echo "ERROR: failed to apply ssh-agent environment on socket: $sock" >&2
        return 1
    fi

    if ! ssh_sock_is_valid "$sock"; then
        echo "ERROR: ssh-agent started but socket is not usable: $sock" >&2
        return 1
    fi

    export SSH_AUTH_SOCK="$sock"
    return 0
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
#!/bin/sh

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
    ssh_sock_path=$1

    [ -n "$ssh_sock_path" ] || return 1
    [ -S "$ssh_sock_path" ] || return 1

    SSH_AUTH_SOCK="$ssh_sock_path" ssh-add -l >/dev/null 2>&1

    ssh_sock_rc=$?
    case "$ssh_sock_rc" in
        0|1)
            return 0
            ;;
        *)
            return 1
            ;;
    esac
}


ssh_find_existing_agent() {
    ssh_find_fixed_sock="$HOME/.ssh/ssh_auth_sock"
    ssh_find_runtime_sock="${XDG_RUNTIME_DIR:-/run/user/$UID}/ssh-agent.socket"

    # Prefer inherited socket
    if [ -n "${SSH_AUTH_SOCK:-}" ] &&
       ssh_sock_is_valid "$SSH_AUTH_SOCK"; then
        return 0
    fi

    # Use our persistent socket
    if ssh_sock_is_valid "$ssh_find_fixed_sock"; then
        export SSH_AUTH_SOCK="$ssh_find_fixed_sock"
        return 0
    fi

    # Use runtime socket and normalize to fixed socket path.
    if ssh_sock_is_valid "$ssh_find_runtime_sock"; then
        ln -snf "$ssh_find_runtime_sock" "$ssh_find_fixed_sock" || return 1
        export SSH_AUTH_SOCK="$ssh_find_fixed_sock"
        return 0
    fi

    return 1
}


ssh_start_agent() {
    ssh_start_sock=${1:-$HOME/.ssh/ssh_auth_sock}

    mkdir -p "$(dirname "$ssh_start_sock")" || return 1

    if ssh_sock_is_valid "$ssh_start_sock"; then
        export SSH_AUTH_SOCK="$ssh_start_sock"
        return 0
    fi

    rm -f "$ssh_start_sock"

    ssh_agent_output="$(ssh-agent -a "$ssh_start_sock")"
    ssh_agent_rc=$?
    if [ "$ssh_agent_rc" -ne 0 ]; then
        echo "ERROR: failed to start ssh-agent on socket: $ssh_start_sock" >&2
        return 1
    fi

    if ! eval "$ssh_agent_output" >/dev/null; then
        echo "ERROR: failed to apply ssh-agent environment on socket: $ssh_start_sock" >&2
        return 1
    fi

    if ! ssh_sock_is_valid "$ssh_start_sock"; then
        echo "ERROR: ssh-agent started but socket is not usable: $ssh_start_sock" >&2
        return 1
    fi

    export SSH_AUTH_SOCK="$ssh_start_sock"
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

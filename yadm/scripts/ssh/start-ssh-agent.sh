#!/bin/sh

load_start_ssh_agent_lib() {
    if [ -n "${YADM_ROOT:-}" ] && [ -f "$YADM_ROOT/functions/ssh/start-ssh-agent.lib.bash" ]; then
        . "$YADM_ROOT/functions/ssh/start-ssh-agent.lib.bash"
        return $?
    fi

    case "$0" in
        *start-ssh-agent.bash)
            start_ssh_agent_script_dir=$(CDPATH= cd "$(dirname "$0")" 2>/dev/null && pwd) || return 1
            start_ssh_agent_root=$(CDPATH= cd "$start_ssh_agent_script_dir/../.." 2>/dev/null && pwd) || return 1
            . "$start_ssh_agent_root/functions/ssh/start-ssh-agent.lib.bash"
            return $?
            ;;
    esac

    echo "ERROR: unable to resolve yadm root for start-ssh-agent" >&2
    return 1
}

if ! load_start_ssh_agent_lib; then
    return 1 2>/dev/null
    exit 1
fi

main() {
    start_ssh_agent_output_mode="verbose"

    while [ "$#" -gt 0 ]; do
        case "$1" in
            -q|--quiet)
                start_ssh_agent_output_mode="quiet"
                ;;
            -v|--verbose)
                start_ssh_agent_output_mode="verbose"
                ;;
            -h|--help)
                echo "Usage: ${0##*/} [--quiet|--verbose]" >&2
                return 0
                ;;
            *)
                echo "ERROR: unknown argument: $1" >&2
                return 1
                ;;
        esac
        shift
    done

    bootstrap_ssh_agent || return 1

    if [ "$start_ssh_agent_output_mode" = "verbose" ]; then
        echo "SSH_AUTH_SOCK=$SSH_AUTH_SOCK"
    fi
    return 0
}


is_executed_directly() {
    case "$0" in
        *start-ssh-agent.bash)
            return 0
            ;;
    esac

    return 1
}


if is_executed_directly; then
    main "$@"
    exit $?
fi
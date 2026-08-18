#!/usr/bin/env bash
. "$YADM_ROOT/functions/ssh/start-ssh-agent.lib.bash" || . "~/yadm/functions/ssh/start-ssh-agent.lib.bash"

main() {
    local output_mode="verbose"

    while [ "$#" -gt 0 ]; do
        case "$1" in
            -q|--quiet)
                output_mode="quiet"
                ;;
            -v|--verbose)
                output_mode="verbose"
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

    if [ "$output_mode" = "verbose" ]; then
        echo "SSH_AUTH_SOCK=$SSH_AUTH_SOCK"
    fi
    return 0
}


is_executed_directly() {
    [[ -n "${BASH_SOURCE[0]:-}" ]] && [[ "${BASH_SOURCE[0]}" == "${0}" ]]
}


if is_executed_directly; then
    main "$@"
    exit $?
fi
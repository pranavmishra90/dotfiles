#!/bin/sh

# Source this file to seed a test environment for the yadm dotfiles repo.
#
# Resolution order for YADM_ROOT:
# 1. YADM_TEST_ROOT, when set
# 2. Existing YADM_ROOT, when set
# 3. git rev-parse --show-toplevel from the current checkout
#
# The helper exports:
# - YADM_TEST=1
# - YADM_ROOT=<resolved repo root>
# - YADM_TEST_HOME=<temporary home for the test run>
# - HOME=<temporary home for the test run>
# - YADM_ORIGINAL_HOME=<original user home>
# - YADM_CUSTOM_DEBUG=1


yadm_test_init_resolve_root() {
    if [ -n "${YADM_TEST_ROOT:-}" ] && [ -d "$YADM_TEST_ROOT" ]; then
        printf '%s\n' "$YADM_TEST_ROOT"
        return 0
    fi

    if [ -n "${YADM_ROOT:-}" ] && [ -d "$YADM_ROOT" ]; then
        printf '%s\n' "$YADM_ROOT"
        return 0
    fi

    if command -v git >/dev/null 2>&1; then
        yadm_test_root=$(git rev-parse --show-toplevel 2>/dev/null) || yadm_test_root=
        if [ -n "$yadm_test_root" ] && [ -d "$yadm_test_root" ]; then
            printf '%s\n' "$yadm_test_root"
            return 0
        fi
    fi

    return 1
}


yadm_test_init() {
    yadm_test_root=$(yadm_test_init_resolve_root) || {
        echo "ERROR: unable to resolve YADM_ROOT for test environment" >&2
        return 1
    }

    if [ -z "${YADM_ORIGINAL_HOME:-}" ]; then
        export YADM_ORIGINAL_HOME="$HOME"
    fi

    if command -v mktemp >/dev/null 2>&1; then
        yadm_test_home=$(mktemp -d 2>/dev/null) || yadm_test_home=
    else
        yadm_test_home=
    fi

    if [ -z "$yadm_test_home" ]; then
        yadm_test_home="$yadm_test_root/.tmp/test-home"
        mkdir -p "$yadm_test_home" || return 1
    fi

    mkdir -p "$yadm_test_home/.ssh" || return 1

    export YADM_TEST=1
    export YADM_ROOT="$yadm_test_root"
    export YADM_TEST_HOME="$yadm_test_home"
    export HOME="$yadm_test_home"
    export YADM_CUSTOM_DEBUG=1
    return 0
}


yadm_test_init "$@"

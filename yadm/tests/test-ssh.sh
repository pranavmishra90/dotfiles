#!/bin/sh

set -eu

TEST_DIR=$(CDPATH= cd "$(dirname "$0")" && pwd)
INIT_SCRIPT="$TEST_DIR/init-yadm-test.sh"

. "$INIT_SCRIPT"

START_SCRIPT="$YADM_ROOT/yadm/scripts/ssh/start-ssh-agent.sh"
REPO_ROOT="$YADM_ROOT"

run_shell_case() {
	shell_name=$1
	shell_bin=$1

	if ! command -v "$shell_bin" >/dev/null 2>&1; then
		echo "SKIP: $shell_name is not installed" >&2
		return 0
	fi

	shell_command=$(cat <<EOF
. '$INIT_SCRIPT'
[ "\$YADM_TEST" = 1 ] || { echo "ERROR: YADM_TEST should be enabled" >&2; exit 1; }
[ "\$YADM_ROOT" = '$REPO_ROOT' ] || { echo "ERROR: YADM_ROOT should resolve to repo root" >&2; exit 1; }
[ "\$HOME" = "\$YADM_TEST_HOME" ] || { echo "ERROR: HOME should point at the isolated test home" >&2; exit 1; }
[ "\$HOME" != "\$YADM_ORIGINAL_HOME" ] || { echo "ERROR: HOME was not isolated" >&2; exit 1; }
[ -d "\$HOME/.ssh" ] || { echo "ERROR: isolated HOME is missing .ssh" >&2; exit 1; }
YADM_SCRIPT_ROOT='$REPO_ROOT/yadm'
YADM_ROOT="\$YADM_SCRIPT_ROOT"
. '$START_SCRIPT'
command -v bootstrap_ssh_agent >/dev/null 2>&1 || { echo "ERROR: bootstrap_ssh_agent missing after source" >&2; exit 1; }
command -v require_ssh_tools >/dev/null 2>&1 || { echo "ERROR: require_ssh_tools missing after source" >&2; exit 1; }
YADM_ROOT="\$YADM_SCRIPT_ROOT" '$START_SCRIPT' --quiet >/dev/null 2>&1 || exit 1
EOF
)

	"$shell_bin" -c "$shell_command"
}

main() {
	run_shell_case "${SHELL_NAME:-sh}" "${SHELL_BIN:-sh}"
}

main "$@"
#!/usr/bin/env bash

set -uo pipefail

VERBOSE="${VERBOSE:-0}"

if [ ! -f /tmp/bash-logger.bash ]; then
    wget -qO /tmp/bash-logger.bash https://raw.githubusercontent.com/pranavmishra90/dotfiles/f2769cb50b36fe6a1b667f79a92a5a803e2d223e/yadm/functions/bash-logger.bash
fi

. "$HOME/yadm/functions/bash-logger.bash" || . /tmp/bash-logger.bash

LOG_FILE="/tmp/git-remote-test.log"
create_log_file "$LOG_FILE"


check_remote_access() {
    local label="$1"
    local remote_url="$2"
    local ssh_host="${3:-}"
    local ssh_user="${4:-git}"

    local ssh_status=0
    local remote_status=0

    if [ "$VERBOSE" -eq 1 ]; then
        echo "Testing ${label} remote: ${remote_url}"
    fi

    git ls-remote "$remote_url" HEAD >/dev/null 2>&1
    remote_status=$?

    if [ "$VERBOSE" -eq 1 ]; then
        if [ "$remote_status" -eq 0 ]; then
            echo "${label} repository is accessible via Git."
        else
            echo "${label} repository is NOT accessible via Git (exit status: $remote_status)."
        fi
    fi

    if [ -n "$ssh_host" ]; then
        ssh \
            -o BatchMode=yes \
            -o ConnectTimeout=3 \
            -o StrictHostKeyChecking=no \
            -T "${ssh_user}@${ssh_host}" >/dev/null 2>&1

        ssh_status=$?

        if [ "$VERBOSE" -eq 1 ]; then
            if [ "$ssh_status" -eq 0 ]; then
                echo "SSH authentication to ${ssh_host} succeeded."
            elif [ "$ssh_status" -eq 1 ]; then
                echo "SSH authentication to ${ssh_host} failed (this does not necessarily mean Git access fails)."
            else
                echo "SSH authentication to ${ssh_host} failed with exit code $ssh_status."
            fi
        fi
    fi

    if [ "$remote_status" -eq 0 ]; then
        return 0
    fi

    return 1
}

CURRENT_REPO_URL=$(git remote get-url origin)

REPO_PATH=$(printf '%s\n' "$CURRENT_REPO_URL" | sed -E \
    's#^(ssh://)?[^@]+@[^:/]+[:/]([^/]+/[^/]+)$#\2#')

FORGEJO_BASE_URL="git-ssh.mishracloud.com"
FORGEJO_REPO_URL="ssh://git@${FORGEJO_BASE_URL}/${REPO_PATH}"
GITHUB_REPO_SSH_URL="git@github.com:${REPO_PATH}"
GITHUB_REPO_HTTPS_URL="https://github.com/${REPO_PATH}"

if [ "$VERBOSE" -eq 1 ]; then
    echo "Current repository: $REPO_PATH"
    echo "Forgejo repository URL: $FORGEJO_REPO_URL"
    echo "GitHub repository SSH URL: $GITHUB_REPO_SSH_URL"
    echo "GitHub repository HTTPS URL: $GITHUB_REPO_HTTPS_URL"
    echo
fi

if check_remote_access "Forgejo" "$FORGEJO_REPO_URL" "$FORGEJO_BASE_URL" "git"; then
    FORGEJO_ACCESSIBLE=1
else
    FORGEJO_ACCESSIBLE=0
fi

if check_remote_access "GitHub SSH" "$GITHUB_REPO_SSH_URL" "github.com" "git"; then
    GITHUB_SSH_ACCESSIBLE=1
else
    GITHUB_SSH_ACCESSIBLE=0
fi

if check_remote_access "GitHub HTTPS" "$GITHUB_REPO_HTTPS_URL"; then
    GITHUB_HTTPS_ACCESSIBLE=1
else
    GITHUB_HTTPS_ACCESSIBLE=0
fi

echo
if [ "$FORGEJO_ACCESSIBLE" -eq 1 ]; then
    git remote set-url origin "$FORGEJO_REPO_URL"
    echo "Origin set to Forgejo: $FORGEJO_REPO_URL"

    if [ "$GITHUB_SSH_ACCESSIBLE" -eq 1 ]; then
        git remote set-url upstream "$GITHUB_REPO_SSH_URL"
        echo "Upstream set to GitHub SSH: $GITHUB_REPO_SSH_URL"
    elif [ "$GITHUB_HTTPS_ACCESSIBLE" -eq 1 ]; then
        git remote set-url upstream "$GITHUB_REPO_HTTPS_URL"
        echo "Upstream set to GitHub HTTPS: $GITHUB_REPO_HTTPS_URL"
    else
        git remote remove upstream 2>/dev/null || true
        echo "No GitHub upstream configured because neither SSH nor HTTPS is reachable while Forgejo is available."
    fi
else
    if [ "$GITHUB_SSH_ACCESSIBLE" -eq 1 ]; then
        git remote set-url origin "$GITHUB_REPO_SSH_URL"
        echo "Forgejo is not reachable; origin set to GitHub SSH: $GITHUB_REPO_SSH_URL"
    elif [ "$GITHUB_HTTPS_ACCESSIBLE" -eq 1 ]; then
        git remote set-url origin "$GITHUB_REPO_HTTPS_URL"
        echo "Forgejo is not reachable; origin set to GitHub HTTPS: $GITHUB_REPO_HTTPS_URL"
    else
        echo "Forgejo and GitHub are not reachable; origin remains unchanged."
    fi

    git remote remove upstream 2>/dev/null || true
    echo "No upstream configured because Forgejo is unavailable and GitHub is being used as the only reachable remote."
fi

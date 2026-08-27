#!/usr/bin/env bash

set -uo pipefail

VERBOSE="${VERBOSE:-0}"
# Keep compatibility with the existing env variable while using the actual script flag.
if [ -n "${VERBOSITY:-}" ] && [ "$VERBOSE" -eq 0 ]; then
    VERBOSE=1
fi

CURRENT_REPO_URL=$(git remote get-url origin)

REPO_PATH=$(printf '%s\n' "$CURRENT_REPO_URL" | sed -E \
    's#^(ssh://)?[^@]+@[^:/]+[:/]([^/]+/[^/]+)$#\2#')

FORGEJO_SSH_URL="git-ssh.mishracloud.com"
FORGEJO_HTTPS_URL="https://git.mishracloud.com"
FORGEJO_REPO_URL="ssh://git@${FORGEJO_SSH_URL}/${REPO_PATH}"
FORGEJO_REPO_HTTPS_URL="${FORGEJO_HTTPS_URL}/${REPO_PATH}"
GITHUB_REPO_SSH_URL="git@github.com:${REPO_PATH}"
GITHUB_REPO_HTTPS_URL="https://github.com/${REPO_PATH}"

# Define functions
check_remote_access() {
    local label="$1"
    local remote_url="$2"
    local ssh_host="${3:-}"
    local ssh_user="${4:-git}"

    local ssh_status=0
    local remote_status=0

    if [ "$VERBOSE" -eq 1 ]; then
        echo "[DEBUG] Testing ${label} remote: ${remote_url}"
    fi

    git ls-remote "$remote_url" HEAD >/dev/null 2>&1
    remote_status=$?

    if [ "$VERBOSE" -eq 1 ]; then
        if [ "$remote_status" -eq 0 ]; then
            echo "[DEBUG] ${label} repository is accessible via Git."
        else
            echo "[WARN] ${label} repository is NOT accessible via Git (exit status: $remote_status)."
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
                echo "[INFO] SSH authentication to ${ssh_host} succeeded."
            elif [ "$ssh_status" -eq 1 ]; then
                echo "[WARN] SSH authentication to ${ssh_host} failed (this does not necessarily mean Git access fails)."
            else
                echo "[ERROR] SSH authentication to ${ssh_host} failed with exit code $ssh_status."
            fi
        fi
    fi

    if [ "$remote_status" -eq 0 ]; then
        return 0
    fi

    return 1
}

resolve_candidate() {
    local -n candidates_ref="$1"
    local candidate_value=""
    local label=""
    local ssh_host=""
    local ssh_user=""

    RESOLVED_CANDIDATE=""

    for candidate_name in "${candidates_ref[@]}"; do
        candidate_value="${!candidate_name}"

        case "$candidate_name" in
            FORGEJO_REPO_URL)
                label="Forgejo SSH"
                ssh_host="$FORGEJO_SSH_URL"
                ssh_user="git"
                ;;
            FORGEJO_REPO_HTTPS_URL)
                label="Forgejo HTTPS"
                ssh_host=""
                ssh_user=""
                ;;
            GITHUB_REPO_SSH_URL)
                label="GitHub SSH"
                ssh_host="github.com"
                ssh_user="git"
                ;;
            GITHUB_REPO_HTTPS_URL)
                label="GitHub HTTPS"
                ssh_host=""
                ssh_user=""
                ;;
            *)
                label="$candidate_name"
                ssh_host=""
                ssh_user=""
                ;;
        esac

        if check_remote_access "$label" "$candidate_value" "$ssh_host" "$ssh_user"; then
            RESOLVED_CANDIDATE="$candidate_value"
            return 0
        fi
    done

    return 1
}

ORIGIN_CANDIDATES=(
    FORGEJO_REPO_URL
    GITHUB_REPO_SSH_URL
    FORGEJO_REPO_HTTPS_URL
    GITHUB_REPO_HTTPS_URL
)

UPSTREAM_CANDIDATES=(
    GITHUB_REPO_SSH_URL
    GITHUB_REPO_HTTPS_URL
)

if [ "$VERBOSE" -eq 1 ]; then
    echo "[DEBUG] Current repository: $REPO_PATH"
    echo "[DEBUG] Forgejo repository URL: $FORGEJO_REPO_URL"
    echo "[DEBUG] Forgejo repository HTTPS URL: $FORGEJO_REPO_HTTPS_URL"
    echo "[DEBUG] GitHub repository SSH URL: $GITHUB_REPO_SSH_URL"
    echo "[DEBUG] GitHub repository HTTPS URL: $GITHUB_REPO_HTTPS_URL"
fi

resolve_candidate ORIGIN_CANDIDATES
ORIGIN_STATUS=$?
ORIGIN_CANDIDATE="$RESOLVED_CANDIDATE"

if [ "$ORIGIN_STATUS" -eq 0 ] && [ -n "$ORIGIN_CANDIDATE" ]; then
    git remote set-url origin "$ORIGIN_CANDIDATE"
    echo "[INFO] Origin set to $ORIGIN_CANDIDATE"
else
    echo "[ERROR] No reachable origin candidate found; origin remains unchanged."
fi

if [ "$ORIGIN_CANDIDATE" != "$GITHUB_REPO_SSH_URL" ] && [ "$ORIGIN_CANDIDATE" != "$GITHUB_REPO_HTTPS_URL" ]; then
    resolve_candidate UPSTREAM_CANDIDATES
    UPSTREAM_STATUS=$?
    UPSTREAM_CANDIDATE="$RESOLVED_CANDIDATE"

    if [ "$UPSTREAM_STATUS" -eq 0 ] && [ -n "$UPSTREAM_CANDIDATE" ]; then
        if git remote get-url upstream >/dev/null 2>&1; then
            git remote set-url upstream "$UPSTREAM_CANDIDATE"
        else
            git remote add upstream "$UPSTREAM_CANDIDATE"
        fi
        echo "[INFO] Upstream set to $UPSTREAM_CANDIDATE"
    else
        git remote remove upstream 2>/dev/null || true
        echo "[WARN] No GitHub upstream configured because no reachable GitHub remote is available or it is already the origin."
    fi
else
    git remote remove upstream 2>/dev/null || true
    echo "[INFO] No upstream configured because GitHub is already being used as origin."
fi

printf "\n\n"
printf "[INFO] Current remotes: \n$(git remote -v)"

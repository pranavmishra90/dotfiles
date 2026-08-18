#!/bin/bash

source_dot_script() {
    local path="$1"

    local owner='pranavmishra90'
    local repo='dotfiles'
    local api='https://api.github.com/graphql'

    # Primary trust source.
    local keys_url='https://drpranavmishra.com/.well-known/ssh-keys'

    # Fallback trust source.
    local github_keys_url='https://github.com/pranavmishra90.keys'

    [[ -n "$path" ]] || {
        echo "ERROR: source_dot_script requires a file path" >&2
        return 1
    }

    [[ -n "${GITHUB_TOKEN:-}" ]] || {
        echo "ERROR: GITHUB_TOKEN is not set" >&2
        return 1
    }

    # ------------------------------------------------------------------
    # Get latest release and its signing-key fingerprint
    # ------------------------------------------------------------------

    local query='
        query($owner: String!, $repo: String!) {
            repository(owner: $owner, name: $repo) {
                latestRelease {
                    tagName
                    tagCommit {
                        oid
                        signature {
                            __typename
                            ... on SshSignature {
                                keyFingerprint
                                isValid
                            }
                        }
                    }
                }
            }
        }
    '

    local response

    response=$(
        curl -fsSL \
            --connect-timeout 5 \
            --max-time 15 \
            -H "Authorization: bearer $GITHUB_TOKEN" \
            -H "Content-Type: application/json" \
            "$api" \
            -d "$(
                jq -n \
                    --arg query "$query" \
                    --arg owner "$owner" \
                    --arg repo "$repo" \
                    '{
                        query: $query,
                        variables: {
                            owner: $owner,
                            repo: $repo
                        }
                    }'
            )"
    ) || {
        echo "ERROR: failed to contact GitHub API" >&2
        return 1
    }

    if jq -e '.errors' >/dev/null <<<"$response"; then
        echo "ERROR: GitHub GraphQL request failed:" >&2
        jq -r '.errors[].message' <<<"$response" >&2
        return 1
    fi

    local release tag commit fingerprint valid

    release=$(jq -e '.data.repository.latestRelease' <<<"$response") || {
        echo "ERROR: repository has no latest release" >&2
        return 1
    }

    tag=$(jq -r '.tagName' <<<"$release")
    commit=$(jq -r '.tagCommit.oid' <<<"$release")
    fingerprint=$(jq -r \
        '.tagCommit.signature.keyFingerprint // empty' \
        <<<"$release")
    fingerprint="${fingerprint#SHA256:}"
    valid=$(jq -r \
        '.tagCommit.signature.isValid // false' \
        <<<"$release")

    echo "Release:     $tag" >&2
    echo "Commit:      $commit" >&2
    echo "Fingerprint: $fingerprint" >&2

    [[ "$valid" == "true" ]] || {
        echo "ERROR: release commit has no valid SSH signature" >&2
        return 1
    }

    [[ -n "$fingerprint" ]] || {
        echo "ERROR: release has no SSH signing fingerprint" >&2
        return 1
    }

    # ------------------------------------------------------------------
    # Check whether the signing key is trusted.
    #
    # WordPress is authoritative. GitHub is only used if WordPress
    # cannot be reached.
    # ------------------------------------------------------------------

    local keys
    local trust_source

    if keys=$(
        curl -fsSL \
            --connect-timeout 5 \
            --max-time 15 \
            "$keys_url"
    ); then
        trust_source="WordPress"
    else
        echo "WARNING: unable to retrieve trusted keys from Pranav Mishra's website. Falling back to GitHub" >&2

        keys=$(
            curl -fsSL \
                --connect-timeout 5 \
                --max-time 15 \
                "$github_keys_url"
        ) || {
            echo "ERROR: unable to retrieve trusted SSH keys" >&2
            return 1
        }

        trust_source="GitHub"
    fi

    echo "Trust source: $trust_source" >&2

    local trusted

    trusted=$(
        printf '%s\n' "$keys" |
        ssh-keygen -lf - 2>/dev/null |
        awk '{print $2}' 
    ) || {
        echo "ERROR: failed to parse trusted SSH keys" >&2
        return 1
    }

    if ! grep -Fxq -- "$fingerprint" <<<"$trusted"; then
        echo "ERROR: signing key is not trusted" >&2
        echo "       fingerprint: $fingerprint" >&2
        return 1
    fi

    echo "Signing key trusted." >&2

    # ------------------------------------------------------------------
    # Retrieve the file at the EXACT commit that was verified above.
    # ------------------------------------------------------------------

    local file_query='
        query(
            $owner: String!,
            $repo: String!,
            $expression: String!
        ) {
            repository(owner: $owner, name: $repo) {
                object(expression: $expression) {
                    ... on Blob {
                        text
                    }
                }
            }
        }
    '

    local file_response

    file_response=$(
        curl -fsSL \
            --connect-timeout 5 \
            --max-time 15 \
            -H "Authorization: bearer $GITHUB_TOKEN" \
            -H "Content-Type: application/json" \
            "$api" \
            -d "$(
                jq -n \
                    --arg query "$file_query" \
                    --arg owner "$owner" \
                    --arg repo "$repo" \
                    --arg expression "$commit:$path" \
                    '{
                        query: $query,
                        variables: {
                            owner: $owner,
                            repo: $repo,
                            expression: $expression
                        }
                    }'
            )"
    ) || {
        echo "ERROR: failed to retrieve $path" >&2
        return 1
    }

    if jq -e '.errors' >/dev/null <<<"$file_response"; then
        echo "ERROR: GitHub GraphQL request failed:" >&2
        jq -r '.errors[].message' <<<"$file_response" >&2
        return 1
    fi

    local script

    script=$(jq -r '.data.repository.object.text // empty' <<<"$file_response")

    [[ -n "$script" ]] || {
        echo "ERROR: file not found: $path" >&2
        return 1
    }

    # ------------------------------------------------------------------
    # The file was retrieved from the exact, signed commit.
    # Source it in the caller's shell.
    # ------------------------------------------------------------------

    source /dev/stdin <<<"$script"
}

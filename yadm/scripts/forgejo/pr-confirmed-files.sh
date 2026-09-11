#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage:
  pr-confirmed-files.sh --pr <number> [options]

Options:
  --pr <number>              Pull request number (required)
  --owner <owner>            Repository owner (default: pranavmishra90)
  --repo <repo>              Repository name (default: dotfiles)
  --host <url>               Forgejo base URL (default: https://git.mishracloud.com)
  --token-env <var>          Token env var name (default: FORGEJO_TOKEN)
  --marker <text>            Comment marker to treat as approval (default: confirmed)
  --source-branch <branch>   Branch to restore from (default: from PR head ref)
  --output <path>            Output list path (default: /tmp/pr<PR>_confirmed_files.txt)
  --apply                    Apply restore for confirmed files into current branch
  --yes                      Skip apply confirmation prompt
  -h, --help                 Show help

Examples:
  pr-confirmed-files.sh --pr 45
  pr-confirmed-files.sh --pr 45 --apply
  pr-confirmed-files.sh --pr 45 --marker confirmed --source-branch origin/feat/lxc --apply
EOF
}

require_cmd() {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo "Missing required command: $1" >&2
    exit 1
  fi
}

urlencode() {
  jq -rn --arg v "$1" '$v|@uri'
}

PR=""
OWNER="pranavmishra90"
REPO="dotfiles"
HOST="https://git.mishracloud.com"
TOKEN_ENV="FORGEJO_TOKEN"
MARKER="confirmed"
SOURCE_BRANCH=""
OUTPUT=""
APPLY="false"
ASSUME_YES="false"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --pr)
      PR="$2"
      shift 2
      ;;
    --owner)
      OWNER="$2"
      shift 2
      ;;
    --repo)
      REPO="$2"
      shift 2
      ;;
    --host)
      HOST="$2"
      shift 2
      ;;
    --token-env)
      TOKEN_ENV="$2"
      shift 2
      ;;
    --marker)
      MARKER="$2"
      shift 2
      ;;
    --source-branch)
      SOURCE_BRANCH="$2"
      shift 2
      ;;
    --output)
      OUTPUT="$2"
      shift 2
      ;;
    --apply)
      APPLY="true"
      shift
      ;;
    --yes)
      ASSUME_YES="true"
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown argument: $1" >&2
      usage
      exit 1
      ;;
  esac
done

if [[ -z "$PR" ]]; then
  echo "--pr is required" >&2
  usage
  exit 1
fi

TOKEN="${!TOKEN_ENV:-}"
if [[ -z "$TOKEN" ]]; then
  echo "Environment variable $TOKEN_ENV is not set" >&2
  exit 1
fi

if [[ -z "$OUTPUT" ]]; then
  OUTPUT="/tmp/pr${PR}_confirmed_files.txt"
fi

require_cmd curl
require_cmd jq
require_cmd git

WORKDIR="/tmp/forgejo_pr_${PR}"
REVIEWS_JSON="$WORKDIR/reviews.json"
META_JSON="$WORKDIR/meta.json"
COMMENTS_GLOB="$WORKDIR/review_*.json"
mkdir -p "$WORKDIR"

api_base="$HOST/api/v1/repos/$OWNER/$REPO/pulls/$PR"

echo "Fetching PR metadata..."
curl -fsS -H "Authorization: token $TOKEN" "$api_base" > "$META_JSON"

echo "Fetching reviews..."
curl -fsS -H "Authorization: token $TOKEN" "$api_base/reviews?limit=500" > "$REVIEWS_JSON"

review_count="$(jq 'length' "$REVIEWS_JSON")"
echo "Found $review_count review object(s)."

if [[ "$review_count" -eq 0 ]]; then
  : > "$OUTPUT"
  echo "No reviews found. Created empty file list at: $OUTPUT"
  exit 0
fi

while IFS= read -r review_id; do
  echo "Fetching comments for review $review_id..."
  curl -fsS -H "Authorization: token $TOKEN" \
    "$api_base/reviews/$review_id/comments?limit=500" \
    > "$WORKDIR/review_${review_id}.json"
done < <(jq -r '.[].id' "$REVIEWS_JSON")

marker_lc="$(printf '%s' "$MARKER" | tr '[:upper:]' '[:lower:]')"

jq -s -r --arg marker "$marker_lc" '
  map(.[]) |
  map(select(.body != null)) |
  map(select((.body | ascii_downcase) == $marker)) |
  map(.path) |
  unique[]
' $COMMENTS_GLOB > "$OUTPUT"

file_count="$(wc -l < "$OUTPUT" | tr -d ' ')"
echo "Confirmed file count: $file_count"
if [[ "$file_count" -gt 0 ]]; then
  echo "Confirmed files:"
  cat "$OUTPUT"
else
  echo "No files matched marker: $MARKER"
fi

echo "Output file: $OUTPUT"

if [[ "$APPLY" != "true" ]]; then
  exit 0
fi

if [[ -z "$SOURCE_BRANCH" ]]; then
  SOURCE_BRANCH="$(jq -r '.head.ref' "$META_JSON")"
  SOURCE_BRANCH="origin/$SOURCE_BRANCH"
fi

if [[ "$file_count" -eq 0 ]]; then
  echo "Nothing to apply."
  exit 0
fi

echo "Will restore files from: $SOURCE_BRANCH"
if [[ "$ASSUME_YES" != "true" ]]; then
  read -r -p "Proceed with git restore into current branch? [y/N] " answer
  if [[ ! "$answer" =~ ^[Yy]$ ]]; then
    echo "Cancelled."
    exit 0
  fi
fi

git fetch origin --prune
xargs -d '\n' git restore --source "$SOURCE_BRANCH" -- < "$OUTPUT"

echo "Restore complete. Review with:"
echo "  git status --short"
echo "  git diff"

# Forgejo PR Review API: confirmed-file workflow

This document explains how to query a Forgejo pull request, collect review comments, and identify files marked as approved using the comment text:

confirmed

It is written for this repository and host:

- Forgejo host: https://git.mishracloud.com
- Repo: pranavmishra90/dotfiles

## Prerequisites

1. A valid API token in environment variable FORGEJO_TOKEN.
2. jq installed.
3. Git checkout on the target branch where you want to apply selected file changes.

## 1) Set variables

```bash
export FORGEJO_HOST="https://git.mishracloud.com"
export OWNER="pranavmishra90"
export REPO="dotfiles"
export PR_NUMBER="45"
```

## 2) Fetch PR metadata and changed files

```bash
curl -sS -H "Authorization: token $FORGEJO_TOKEN" \
  "$FORGEJO_HOST/api/v1/repos/$OWNER/$REPO/pulls/$PR_NUMBER" \
  > /tmp/pr_meta.json

curl -sS -H "Authorization: token $FORGEJO_TOKEN" \
  "$FORGEJO_HOST/api/v1/repos/$OWNER/$REPO/pulls/$PR_NUMBER/files?limit=500" \
  > /tmp/pr_files.json

jq '{number, state, draft, head: .head.ref, base: .base.ref}' /tmp/pr_meta.json
jq -r '.[] | [.filename, .status] | @tsv' /tmp/pr_files.json
```

Notes:

- The files endpoint returns filename/status/additions/deletions/changes and URLs.
- It does not include a viewed flag.

## 3) Fetch reviews

```bash
curl -sS -H "Authorization: token $FORGEJO_TOKEN" \
  "$FORGEJO_HOST/api/v1/repos/$OWNER/$REPO/pulls/$PR_NUMBER/reviews?limit=500" \
  > /tmp/pr_reviews.json

jq -r '.[] | [.id, .state, .user.login, .submitted_at] | @tsv' /tmp/pr_reviews.json
```

## 4) Fetch comments inside each review

For this Forgejo instance, review comments are available on:

- /pulls/{pr}/reviews/{review_id}/comments

```bash
mkdir -p /tmp/pr_review_comments

jq -r '.[].id' /tmp/pr_reviews.json | while read -r review_id; do
  curl -sS -H "Authorization: token $FORGEJO_TOKEN" \
    "$FORGEJO_HOST/api/v1/repos/$OWNER/$REPO/pulls/$PR_NUMBER/reviews/$review_id/comments?limit=500" \
    > "/tmp/pr_review_comments/review_${review_id}.json"
done
```

## 5) Build list of files marked confirmed

This extracts comments whose body is exactly confirmed (case-insensitive), then returns unique file paths.

```bash
jq -s -r '
  map(.[])                                   |
  map(select(.body != null))                 |
  map(select((.body | ascii_downcase) == "confirmed")) |
  map(.path)                                 |
  unique[]
' /tmp/pr_review_comments/review_*.json > /tmp/pr_confirmed_files.txt

cat /tmp/pr_confirmed_files.txt
```

If you want to allow text like confirmed: ok or confirmed - safe, use this matcher instead:

```bash
jq -s -r '
  map(.[]) |
  map(select(.body != null)) |
  map(select((.body | ascii_downcase) | test("^confirmed([[:space:]:-].*)?$"))) |
  map(.path) |
  unique[]
' /tmp/pr_review_comments/review_*.json > /tmp/pr_confirmed_files.txt
```

## 6) Selectively pull only confirmed files into develop

Make sure your local refs are up to date and you are on develop.

```bash
git fetch origin feat/lxc develop --prune
git checkout develop

if [[ -s /tmp/pr_confirmed_files.txt ]]; then
  xargs -d '\n' git restore --source origin/feat/lxc -- < /tmp/pr_confirmed_files.txt
  git status --short
else
  echo "No confirmed files found."
fi
```

Then review and commit:

```bash
git diff
git add -A
git commit -m "pull confirmed files from feat/lxc PR #45"
```

## Helper script

There is a helper script in this repo:

- yadm/scripts/forgejo/pr-confirmed-files.sh

Make sure it is executable:

```bash
chmod +x yadm/scripts/forgejo/pr-confirmed-files.sh
```

Examples:

```bash
# Build confirmed file list only
yadm/scripts/forgejo/pr-confirmed-files.sh --pr 45

# Build list and apply restore from PR head branch into current branch
yadm/scripts/forgejo/pr-confirmed-files.sh --pr 45 --apply

# Override marker and source branch
yadm/scripts/forgejo/pr-confirmed-files.sh \
  --pr 45 \
  --marker confirmed \
  --source-branch origin/feat/lxc \
  --apply
```

## Troubleshooting

1. 403 from API: token missing/expired or insufficient scope.
2. Empty reviews: no review object exists yet (for example, comments not attached to a submitted/pending review).
3. Empty confirmed list: no comment body exactly matched confirmed.
4. Path not found on restore: file may have been renamed or deleted in source branch.

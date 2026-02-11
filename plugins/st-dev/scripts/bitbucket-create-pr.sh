#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Creates a Bitbucket pull request.
# Usage: bitbucket-create-pr.sh <BRANCH> <TITLE> <BODY>
# Output: Full API response JSON (includes links.html.href)

BRANCH="${1:?Usage: bitbucket-create-pr.sh <BRANCH> <TITLE> <BODY>}"
TITLE="${2:?Usage: bitbucket-create-pr.sh <BRANCH> <TITLE> <BODY>}"
BODY="${3:?Usage: bitbucket-create-pr.sh <BRANCH> <TITLE> <BODY>}"

eval "$("$SCRIPT_DIR/bitbucket-setup.sh")"

PAYLOAD=$(jq -n \
  --arg title "$TITLE" \
  --arg branch "$BRANCH" \
  --arg body "$BODY" \
  '{
    title: $title,
    source: { branch: { name: $branch } },
    destination: { branch: { name: "main" } },
    description: $body,
    close_source_branch: true
  }')

curl -s -X POST \
  -u "$BITBUCKET_USERNAME:$BITBUCKET_APP_PASSWORD" \
  -H "Content-Type: application/json" \
  "$BB_API_BASE/pullrequests" \
  -d "$PAYLOAD"

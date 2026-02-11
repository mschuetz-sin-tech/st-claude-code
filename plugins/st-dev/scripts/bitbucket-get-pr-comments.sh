#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Fetches comments on a pull request.
# Usage: bitbucket-get-pr-comments.sh <PR_ID>
# Output: JSON array with id, user, content, file, line, resolved

PR_ID="${1:?Usage: bitbucket-get-pr-comments.sh <PR_ID>}"

eval "$("$SCRIPT_DIR/bitbucket-setup.sh")"

curl -s -u "$BITBUCKET_USERNAME:$BITBUCKET_APP_PASSWORD" \
  "$BB_API_BASE/pullrequests/$PR_ID/comments" \
  | jq '[.values[] | select(.deleted == false) | {
    id: .id,
    user: .user.display_name,
    content: .content.raw,
    file: .inline.path,
    line: .inline.to,
    resolved: (.resolution != null)
  }]'

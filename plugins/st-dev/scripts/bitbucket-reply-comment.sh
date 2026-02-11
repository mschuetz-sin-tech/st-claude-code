#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Replies to a comment on a Bitbucket pull request.
# Usage: bitbucket-reply-comment.sh <PR_ID> <COMMENT_ID> <MESSAGE>
# Output: API response JSON

PR_ID="${1:?Usage: bitbucket-reply-comment.sh <PR_ID> <COMMENT_ID> <MESSAGE>}"
COMMENT_ID="${2:?Usage: bitbucket-reply-comment.sh <PR_ID> <COMMENT_ID> <MESSAGE>}"
MESSAGE="${3:?Usage: bitbucket-reply-comment.sh <PR_ID> <COMMENT_ID> <MESSAGE>}"

eval "$("$SCRIPT_DIR/bitbucket-setup.sh")"

PAYLOAD=$(jq -n \
  --arg msg "$MESSAGE" \
  --argjson parent_id "$COMMENT_ID" \
  '{
    content: { raw: $msg },
    parent: { id: $parent_id }
  }')

curl -s -X POST \
  -u "$BITBUCKET_USERNAME:$BITBUCKET_APP_PASSWORD" \
  -H "Content-Type: application/json" \
  "$BB_API_BASE/pullrequests/$PR_ID/comments" \
  -d "$PAYLOAD"

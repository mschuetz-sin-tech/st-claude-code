#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Gets the source branch name of a pull request.
# Usage: bitbucket-get-pr-branch.sh <PR_ID>
# Output: Plain-text branch name

PR_ID="${1:?Usage: bitbucket-get-pr-branch.sh <PR_ID>}"

eval "$("$SCRIPT_DIR/bitbucket-setup.sh")"

curl -s -u "$BITBUCKET_USERNAME:$BITBUCKET_APP_PASSWORD" \
  "$BB_API_BASE/pullrequests/$PR_ID" \
  | jq -r '.source.branch.name'

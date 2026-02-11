#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Lists open pull requests for the current repository.
# Output: <id> | <title> | <branch>

eval "$("$SCRIPT_DIR/bitbucket-setup.sh")"

curl -s -u "$BITBUCKET_USERNAME:$BITBUCKET_APP_PASSWORD" \
  "$BB_API_BASE/pullrequests?state=OPEN" \
  | jq -r '.values[] | "\(.id) | \(.title) | \(.source.branch.name)"'

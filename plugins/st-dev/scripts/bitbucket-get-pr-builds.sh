#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Fetches build statuses (pipeline results) for a pull request.
# Usage: bitbucket-get-pr-builds.sh <PR_ID>
# Output: JSON array with name, state, url

PR_ID="${1:?Usage: bitbucket-get-pr-builds.sh <PR_ID>}"

eval "$("$SCRIPT_DIR/bitbucket-setup.sh")"

curl -s -u "$BITBUCKET_USERNAME:$BITBUCKET_APP_PASSWORD" \
  "$BB_API_BASE/pullrequests/$PR_ID/statuses" \
  | jq '[.values[] | {
    name: .name,
    state: .state,
    url: .url,
    description: .description
  }]'

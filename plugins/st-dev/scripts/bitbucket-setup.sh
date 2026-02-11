#!/usr/bin/env bash
set -euo pipefail

# Loads Bitbucket credentials and repository info.
# Output: eval-bare export statements on stdout.
# Usage: eval "$(path/to/bitbucket-setup.sh)"

# --- Credentials ---

if [[ -n "${BITBUCKET_USERNAME:-}" && -n "${BITBUCKET_APP_PASSWORD:-}" ]]; then
  : # already set
elif command -v powershell &>/dev/null; then
  BITBUCKET_USERNAME=$(powershell -Command "[Environment]::GetEnvironmentVariable('BITBUCKET_USERNAME', 'User')")
  BITBUCKET_APP_PASSWORD=$(powershell -Command "[Environment]::GetEnvironmentVariable('BITBUCKET_APP_PASSWORD', 'User')")
else
  echo "ERROR: BITBUCKET_USERNAME and BITBUCKET_APP_PASSWORD are not set and powershell is not available." >&2
  exit 1
fi

if [[ -z "${BITBUCKET_USERNAME:-}" || -z "${BITBUCKET_APP_PASSWORD:-}" ]]; then
  echo "ERROR: Bitbucket credentials are empty. Set BITBUCKET_USERNAME and BITBUCKET_APP_PASSWORD." >&2
  exit 1
fi

# --- Repository info ---

REMOTE_URL=$(git remote get-url origin 2>/dev/null) || {
  echo "ERROR: Could not read git remote 'origin'." >&2
  exit 1
}

WORKSPACE=$(echo "$REMOTE_URL" | sed -E 's|.*bitbucket.org[:/]([^/]+)/.*|\1|')
REPO_SLUG=$(echo "$REMOTE_URL" | sed -E 's|.*bitbucket.org[:/][^/]+/([^.]+).*|\1|')

if [[ -z "$WORKSPACE" || -z "$REPO_SLUG" ]]; then
  echo "ERROR: Could not extract workspace/repo from remote URL: $REMOTE_URL" >&2
  exit 1
fi

# --- Output ---

echo "export BITBUCKET_USERNAME=$(printf '%q' "$BITBUCKET_USERNAME")"
echo "export BITBUCKET_APP_PASSWORD=$(printf '%q' "$BITBUCKET_APP_PASSWORD")"
echo "export WORKSPACE=$(printf '%q' "$WORKSPACE")"
echo "export REPO_SLUG=$(printf '%q' "$REPO_SLUG")"
echo "export BB_API_BASE=https://api.bitbucket.org/2.0/repositories/$WORKSPACE/$REPO_SLUG"

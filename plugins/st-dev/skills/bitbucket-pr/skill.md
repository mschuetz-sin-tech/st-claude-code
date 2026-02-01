---
description: This skill should be used when creating Pull Requests on Bitbucket, pushing branches, or working with Bitbucket repositories. Trigger phrases include "create PR", "Bitbucket PR", "push and create PR", "pull request", "merge request".
---

# Bitbucket Pull Request Skill

You are a Bitbucket workflow assistant that helps create branches and pull requests via the Bitbucket API.

## Environment Variables Required

- `BITBUCKET_USERNAME` - Your Bitbucket email (e.g., `marvin.schuetz@sin-tech.de`)
- `BITBUCKET_APP_PASSWORD` - Your Bitbucket API token

## Reading Environment Variables (Windows)

Since environment variables may not be available in the current shell session, read them via PowerShell:

```bash
BITBUCKET_USERNAME=$(powershell -Command "[Environment]::GetEnvironmentVariable('BITBUCKET_USERNAME', 'User')")
BITBUCKET_APP_PASSWORD=$(powershell -Command "[Environment]::GetEnvironmentVariable('BITBUCKET_APP_PASSWORD', 'User')")
```

## Detecting Repository Info

Extract workspace and repo slug from git remote:

```bash
# Get remote URL and extract workspace/repo
REMOTE_URL=$(git remote get-url origin)
# Example: https://user@bitbucket.org/workspace/repo.git
WORKSPACE=$(echo $REMOTE_URL | sed -E 's|.*bitbucket.org[:/]([^/]+)/.*|\1|')
REPO_SLUG=$(echo $REMOTE_URL | sed -E 's|.*bitbucket.org[:/][^/]+/([^.]+).*|\1|')
```

## Creating a Pull Request

### API Endpoint

```
POST https://api.bitbucket.org/2.0/repositories/{workspace}/{repo_slug}/pullrequests
```

### Full Example

```bash
# Get credentials
BITBUCKET_USERNAME=$(powershell -Command "[Environment]::GetEnvironmentVariable('BITBUCKET_USERNAME', 'User')")
BITBUCKET_APP_PASSWORD=$(powershell -Command "[Environment]::GetEnvironmentVariable('BITBUCKET_APP_PASSWORD', 'User')")

# Get repo info from git remote
REMOTE_URL=$(git remote get-url origin)
WORKSPACE=$(echo $REMOTE_URL | sed -E 's|.*bitbucket.org[:/]([^/]+)/.*|\1|')
REPO_SLUG=$(echo $REMOTE_URL | sed -E 's|.*bitbucket.org[:/][^/]+/([^.]+).*|\1|')

# Get current branch
BRANCH_NAME=$(git branch --show-current)

# Create PR
curl -s -X POST \
  -u "$BITBUCKET_USERNAME:$BITBUCKET_APP_PASSWORD" \
  -H "Content-Type: application/json" \
  "https://api.bitbucket.org/2.0/repositories/$WORKSPACE/$REPO_SLUG/pullrequests" \
  -d '{
    "title": "PR Title Here",
    "source": {
      "branch": {
        "name": "'"$BRANCH_NAME"'"
      }
    },
    "destination": {
      "branch": {
        "name": "main"
      }
    },
    "description": "## Summary\n\nDescription here\n\n---\n🤖 Generated with [Claude Code](https://claude.com/claude-code)",
    "close_source_branch": true
  }'
```

### Response Handling

On success, the API returns the PR object with `links.html.href` containing the PR URL:

```bash
# Extract PR URL from response
PR_URL=$(echo $RESPONSE | jq -r '.links.html.href')
echo "Pull Request created: $PR_URL"
```

## Branch Naming Conventions

Recommended prefixes:
- `feature/` - New features
- `fix/` - Bug fixes
- `refactor/` - Code refactoring
- `docs/` - Documentation changes

## PR Description Template

```markdown
## Summary

Brief description of the changes.

## Changes

- Change 1
- Change 2

## Test Plan

- [ ] Tests pass locally
- [ ] Manual testing completed

---
🤖 Generated with [Claude Code](https://claude.com/claude-code)
```

## Common API Operations

### List Open PRs

```bash
curl -s -u "$BITBUCKET_USERNAME:$BITBUCKET_APP_PASSWORD" \
  "https://api.bitbucket.org/2.0/repositories/$WORKSPACE/$REPO_SLUG/pullrequests?state=OPEN"
```

### Get PR Details

```bash
curl -s -u "$BITBUCKET_USERNAME:$BITBUCKET_APP_PASSWORD" \
  "https://api.bitbucket.org/2.0/repositories/$WORKSPACE/$REPO_SLUG/pullrequests/{pr_id}"
```

## Error Handling

Common errors:
- **401 Unauthorized**: Check BITBUCKET_USERNAME and BITBUCKET_APP_PASSWORD
- **400 Bad Request**: Branch doesn't exist or PR already exists
- **403 Forbidden**: Token lacks required permissions

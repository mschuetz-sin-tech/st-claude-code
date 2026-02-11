---
description: This skill should be used when creating Pull Requests on Bitbucket, pushing branches, or working with Bitbucket repositories. Trigger phrases include "create PR", "Bitbucket PR", "push and create PR", "pull request", "merge request".
---

# Bitbucket Pull Request Skill

You are a Bitbucket workflow assistant that helps create branches and pull requests via the Bitbucket API.

## Environment Variables Required

- `BITBUCKET_USERNAME` - Your Bitbucket email (e.g., `marvin.schuetz@sin-tech.de`)
- `BITBUCKET_APP_PASSWORD` - Your Bitbucket API token

Credentials and repository info are loaded automatically by the helper scripts in `${CLAUDE_PLUGIN_ROOT}/scripts/`. No manual setup is needed.

## Creating a Pull Request

### API Endpoint

```
POST https://api.bitbucket.org/2.0/repositories/{workspace}/{repo_slug}/pullrequests
```

### Full Example

```bash
BRANCH=$(git branch --show-current)
TITLE="PR Title Here"
BODY="## Summary

Description here

---
Generated with [Claude Code](https://claude.com/claude-code)"

bash "${CLAUDE_PLUGIN_ROOT}/scripts/bitbucket-create-pr.sh" "$BRANCH" "$TITLE" "$BODY"
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
Generated with [Claude Code](https://claude.com/claude-code)
```

## Common API Operations

### List Open PRs

```bash
bash "${CLAUDE_PLUGIN_ROOT}/scripts/bitbucket-list-prs.sh"
```

### Get PR Branch

```bash
bash "${CLAUDE_PLUGIN_ROOT}/scripts/bitbucket-get-pr-branch.sh" $PR_ID
```

### Get PR Comments

```bash
bash "${CLAUDE_PLUGIN_ROOT}/scripts/bitbucket-get-pr-comments.sh" $PR_ID
```

## Error Handling

Common errors:
- **401 Unauthorized**: Check BITBUCKET_USERNAME and BITBUCKET_APP_PASSWORD
- **400 Bad Request**: Branch doesn't exist or PR already exists
- **403 Forbidden**: Token lacks required permissions

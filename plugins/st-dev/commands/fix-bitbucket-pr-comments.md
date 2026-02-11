---
description: Check open Bitbucket PRs for review comments and fix them. Trigger phrases include "fix Bitbucket PR comments", "Bitbucket review feedback", "Bitbucket PR review", "address Bitbucket comments".
allowed_args: "[pr-id]"
---

Check open Bitbucket Pull Requests for review comments, checkout the branch, and fix the feedback.

## Instructions

### 1. Find PR with Comments

If a PR ID was provided as argument, use that PR.

Otherwise, list open PRs authored by the current user:

```bash
bash "${CLAUDE_PLUGIN_ROOT}/scripts/bitbucket-list-prs.sh"
```

### 2. Get PR Comments

Fetch all comments on the PR:

```bash
PR_ID=<selected-pr-id>

bash "${CLAUDE_PLUGIN_ROOT}/scripts/bitbucket-get-pr-comments.sh" $PR_ID
```

### 3. Filter Unresolved Comments

Focus on comments that:
- Are NOT resolved (`.resolved == false`)
- Are inline comments (have `.file`)
- Are from reviewers (not from the PR author)

### 4. Checkout the Branch

```bash
BRANCH_NAME=$(bash "${CLAUDE_PLUGIN_ROOT}/scripts/bitbucket-get-pr-branch.sh" $PR_ID)

git fetch origin
git checkout $BRANCH_NAME
git pull origin $BRANCH_NAME
```

### 5. Address Each Comment

For each unresolved comment:

1. **Read the comment** - Understand what the reviewer is asking for
2. **Read the file** - Look at the code context around the commented line
3. **Make the fix** - Apply the requested change
4. **Verify** - Ensure the fix doesn't break anything

Group related comments together if they affect the same file.

### 6. Run Tests

After making changes, verify nothing is broken:

```bash
# Detect project type and run appropriate tests
if [ -f "pom.xml" ]; then
  mvn test
elif [ -f "package.json" ]; then
  npm test
fi
```

### 7. Commit and Push

```bash
git add <modified-files>
git commit -m "fix: address PR review comments

- <comment 1 summary>
- <comment 2 summary>

Co-Authored-By: Claude <noreply@anthropic.com>"

git push origin $BRANCH_NAME
```

### 8. Reply to Comments (Optional)

You can reply to comments to indicate they've been addressed:

```bash
bash "${CLAUDE_PLUGIN_ROOT}/scripts/bitbucket-reply-comment.sh" $PR_ID $COMMENT_ID "Fixed in latest commit."
```

### 9. Report Result

Show:
- PR URL
- Number of comments addressed
- Summary of changes made
- Any comments that couldn't be addressed automatically (with explanation)

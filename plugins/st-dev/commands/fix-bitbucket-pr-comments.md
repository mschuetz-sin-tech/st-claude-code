---
description: Check open Bitbucket PRs for review comments and fix them. Trigger phrases include "fix Bitbucket PR comments", "Bitbucket review feedback", "Bitbucket PR review", "address Bitbucket comments".
allowed_args: "[pr-id]"
---

Check open Bitbucket Pull Requests for review comments, checkout the branch, and fix the feedback.

## Instructions

### 1. Setup Credentials

```bash
BITBUCKET_USERNAME=$(powershell -Command "[Environment]::GetEnvironmentVariable('BITBUCKET_USERNAME', 'User')")
BITBUCKET_APP_PASSWORD=$(powershell -Command "[Environment]::GetEnvironmentVariable('BITBUCKET_APP_PASSWORD', 'User')")

# Get repo info
REMOTE_URL=$(git remote get-url origin)
WORKSPACE=$(echo $REMOTE_URL | sed -E 's|.*bitbucket.org[:/]([^/]+)/.*|\1|')
REPO_SLUG=$(echo $REMOTE_URL | sed -E 's|.*bitbucket.org[:/][^/]+/([^.]+).*|\1|')
```

### 2. Find PR with Comments

If a PR ID was provided as argument, use that PR.

Otherwise, list open PRs authored by the current user:

```bash
curl -s -u "$BITBUCKET_USERNAME:$BITBUCKET_APP_PASSWORD" \
  "https://api.bitbucket.org/2.0/repositories/$WORKSPACE/$REPO_SLUG/pullrequests?state=OPEN" \
  | jq -r '.values[] | "\(.id) | \(.title) | \(.source.branch.name)"'
```

### 3. Get PR Comments

Fetch all comments on the PR:

```bash
PR_ID=<selected-pr-id>

curl -s -u "$BITBUCKET_USERNAME:$BITBUCKET_APP_PASSWORD" \
  "https://api.bitbucket.org/2.0/repositories/$WORKSPACE/$REPO_SLUG/pullrequests/$PR_ID/comments" \
  | jq -r '.values[] | select(.deleted == false) | {
    id: .id,
    user: .user.display_name,
    content: .content.raw,
    file: .inline.path,
    line: .inline.to,
    resolved: (.resolution != null)
  }'
```

### 4. Filter Unresolved Comments

Focus on comments that:
- Are NOT resolved (`.resolution == null`)
- Are inline comments (have `.inline.path`)
- Are from reviewers (not from the PR author)

### 5. Checkout the Branch

```bash
# Get branch name from PR
BRANCH_NAME=$(curl -s -u "$BITBUCKET_USERNAME:$BITBUCKET_APP_PASSWORD" \
  "https://api.bitbucket.org/2.0/repositories/$WORKSPACE/$REPO_SLUG/pullrequests/$PR_ID" \
  | jq -r '.source.branch.name')

git fetch origin
git checkout $BRANCH_NAME
git pull origin $BRANCH_NAME
```

### 6. Address Each Comment

For each unresolved comment:

1. **Read the comment** - Understand what the reviewer is asking for
2. **Read the file** - Look at the code context around the commented line
3. **Make the fix** - Apply the requested change
4. **Verify** - Ensure the fix doesn't break anything

Group related comments together if they affect the same file.

### 7. Run Tests

After making changes, verify nothing is broken:

```bash
# Detect project type and run appropriate tests
if [ -f "pom.xml" ]; then
  mvn test
elif [ -f "package.json" ]; then
  npm test
fi
```

### 8. Commit and Push

```bash
git add <modified-files>
git commit -m "fix: address PR review comments

- <comment 1 summary>
- <comment 2 summary>

Co-Authored-By: Claude <noreply@anthropic.com>"

git push origin $BRANCH_NAME
```

### 9. Reply to Comments (Optional)

You can reply to comments to indicate they've been addressed:

```bash
curl -s -X POST \
  -u "$BITBUCKET_USERNAME:$BITBUCKET_APP_PASSWORD" \
  -H "Content-Type: application/json" \
  "https://api.bitbucket.org/2.0/repositories/$WORKSPACE/$REPO_SLUG/pullrequests/$PR_ID/comments" \
  -d '{
    "content": {
      "raw": "Fixed in latest commit."
    },
    "parent": {
      "id": <comment-id>
    }
  }'
```

### 10. Report Result

Show:
- PR URL
- Number of comments addressed
- Summary of changes made
- Any comments that couldn't be addressed automatically (with explanation)

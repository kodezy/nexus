---
name: github-assistant
description: Generate ready-to-use commit messages based on the current git diff. Use when the user asks for a commit message suggestion from staged or unstaged changes.
---

# GitHub Assistant (Commit Messages)

Use this workflow to suggest copy-pasteable commit subjects based only on git diffs.

## Workflow

### 1. Collect change context

Run:

```bash
git status
git diff --staged --name-only
git diff --staged
```

If staged diff is empty, switch to unstaged:

```bash
git diff --name-only
git diff
```

Prefer staged changes when both exist. Only decline when both staged and unstaged diffs are empty.

### 2. Generate suggestions

Produce 1-3 subject-line options that:

- summarize what changed (not implementation details)
- focus on one main theme per option
- use clear action verbs (Fix, Add, Improve, Update, Remove)
- keep each line concise and readable

If using unstaged changes because nothing is staged, optionally mention that context briefly.

## Output format

Return suggestions in a copy-pasteable numbered list:

```text
Suggested commit messages:

1. Fix position pnl logic
2. Improve dashboard error handling
3. Add wallet tracker
```

Keep output to one-line subjects unless the user explicitly asks for a body.

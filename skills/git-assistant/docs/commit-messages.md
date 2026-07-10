# Behavior: commit-messages

Use when the user asks for commit message suggestions only (no commit execution).

## Workflow

### 1. Collect change context

Run:

```bash
git status
git diff --staged --name-only
git diff --staged
git log -n 5 --oneline
```

If staged diff is empty, switch to unstaged:

```bash
git diff --name-only
git diff
```

Prefer staged changes when both exist. Decline only when both staged and unstaged diffs are empty.

### 2. Generate suggestions

Produce 1-3 subject-line options that:

- summarize what changed, not low-level implementation details
- focus on one main theme per option
- use clear action verbs when useful (`Fix`, `Add`, `Improve`, `Update`, `Remove`)
- stay concise and readable
- remain aligned with recent repository history when possible

If using unstaged changes because nothing is staged, mention that context briefly.

## Constraints

- Write suggestions in English.
- Do not use Conventional Commits prefixes (`feat:`, `fix:`, `chore:`, etc.) unless explicitly requested.
- Prefer imperative or descriptive subjects consistent with repository history.
- Subject only unless the user asks for a body.

## Output format

```text
Suggested commit messages:

1. Improve dashboard error handling
2. Update skill docs structure for Git behaviors
3. Remove duplicated validation path
```

If the user then asks to commit, switch to `docs/commit-changes.md`.

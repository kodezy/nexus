# Behavior: commit-changes

Use this behavior when the user asks to create a commit from current changes.

## Workflow

### 1. Inspect commit context

Run:

```bash
git status
git diff --staged --name-only
git diff --staged
git log -n 5 --oneline
```

If staged diff is empty, inspect latest unstaged changes:

```bash
git diff --name-only
git diff
```

Prefer staged changes when both exist.

### 2. Define exact scope

- Use only files already staged, or the latest relevant unstaged changes when nothing is staged.
- Never include random files.
- Never add untracked files by default.
- Include untracked files only when they are clearly part of the requested change and the user confirmed that scope.

### 3. Draft commit message

- Follow `docs/commit-messages.md` to create the subject.
- Keep message in English.
- Do not use Conventional Commits prefixes unless explicitly requested.

### 4. Request explicit confirmation

Before committing, show:

- selected files
- source used (`staged` or `unstaged`)
- final commit message

Then ask for confirmation and do not run `git add` or `git commit` until the user explicitly approves.

### 5. Execute commit only after approval

If approved:

1. stage only approved files when needed
2. commit with the approved message
3. show post-commit status

If not approved, adjust scope/message and ask again.

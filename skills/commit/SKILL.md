---
name: commit
description: >-
  Run a scoped git commit pipeline for the current session. Checks staged
  files, drafts a message from repository history style, confirms, then
  commits. If nothing is staged, only offers add+commit for files created or
  edited in this conversation. Use when the user invokes /commit or asks to
  commit current session changes with this workflow.
disable-model-invocation: true
---

# Commit

Explicit `/commit` workflow. Do not run this skill unless the user invoked
`/commit` or named this skill.

## Hard rules

1. Never push. Never amend. Never update git config. Never use `--no-verify`.
2. Never use Conventional Commits prefixes (`feat:`, `fix:`, `chore:`, etc.)
   unless the user explicitly asks.
3. Commit messages in English. Match recent `git log` tone.
4. Never stage files outside the allowed scope for the current branch of the
   pipeline.
5. Never commit without explicit user approval of the file list and message.
6. If a commit hook fails, report the error and stop. Do not amend.

## Inspect first

Run in parallel:

```bash
git status
git diff --staged --name-only
git diff --staged
git diff --name-only
git diff
git log -n 5 --oneline
```

Then follow exactly one branch below.

## Branch A — staged files exist

1. Use only staged files. Ignore unstaged/untracked for this round.
2. Draft one subject line from the staged diff and recent commit style.
3. Show the user:
   - source: `staged`
   - file list
   - proposed commit message
4. Ask for confirmation. Do not commit until the user approves.
5. On approval, commit with a HEREDOC:

```bash
git commit -m "$(cat <<'EOF'
Approved message here.

EOF
)"
```

6. Show short post-commit `git status` and the new commit subject/hash.
7. Stop.

## Branch B — nothing staged and working tree clean

1. Tell the user there is nothing to commit.
2. Stop. Do not run `git add` or `git commit`.

## Branch C — nothing staged, but unstaged and/or untracked changes exist

1. Build the session file set: paths this agent created or edited in the
   current conversation (Write/Edit/equivalent tools).
2. Intersect dirty paths (`git status` unstaged + untracked) with the session
   file set. Untracked files are allowed only if they are in the session set.
3. Drop secret-like paths (`.env`, credentials, private keys, and similar).
   If any were candidates, warn that they were excluded.
4. If the remaining candidate list is empty:
   - Tell the user there is no session context to commit.
   - Stop.
5. If candidates remain:
   - Draft one subject line from those diffs and recent commit style.
   - Show the user in one confirmation:
     - source: `session-unstaged`
     - file list to `git add`
     - proposed commit message
   - Ask once: approve add + commit together.
6. On approval:
   - `git add` only the approved paths
   - commit with the approved message (HEREDOC as in Branch A)
   - show short post-commit status
7. On refusal: adjust scope/message and ask again. Do not commit until approved.

## Message style

- Prefer a concise subject that states the effect or reason.
- Align with the last ~5 commits in this repository.
- Subject only by default.

## Out of scope

Push, PR creation, amend, rebase, and any change to `github-assistant`.

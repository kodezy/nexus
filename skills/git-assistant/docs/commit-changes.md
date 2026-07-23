# Behavior: commit-changes

Use when the user asks to create a commit, run a commit, invokes `/commit`, or when `integrity-review` hands off after a Clean or Corrected verdict.

## Hard rules

1. Never push. Never amend. Never update git config. Never use `--no-verify`.
2. Never use Conventional Commits prefixes unless the user explicitly asks.
3. Commit messages in English. Match recent `git log` tone.
4. Never stage files outside the allowed scope for the active branch below.
5. Never commit without explicit user approval of the file list and message.
6. If a commit hook fails, report the error and stop. Do not amend.
7. Exclude secret-like paths (`.env`, credentials, private keys, and similar). Warn when any were candidates.
8. By default exclude `docs/superpowers/` unless the user explicitly asks to include it.
9. After an integrity-review Uncertain verdict, do not run this behavior until the uncertainty is resolved.

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

When invoked from an integrity-review handoff, use the same branches and the same one-shot confirmation (source + file list + message). Do not re-ask for a separate review summary.

## Branch A — staged files exist

1. Use only staged files. Ignore unstaged/untracked for this round.
2. Draft one subject line from the staged diff and recent commit style (`docs/commit-messages.md`).
3. Show the user in one confirmation:
   - source: `staged`
   - file list
   - proposed commit message
4. Ask once: approve commit. Do not commit until the user approves.
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

1. Build the session file set: paths this agent created or edited in the current conversation (Write/Edit/equivalent tools).
2. Intersect dirty paths (`git status` unstaged + untracked) with the session file set. Untracked files are allowed only if they are in the session set.
3. Drop secret-like paths and default Superpowers exclusions. Warn when any were candidates.
4. If the remaining candidate list is empty:
   - Tell the user there is no session context to commit.
   - Stop.
5. If candidates remain:
   - Draft one subject line from those diffs and recent commit style (`docs/commit-messages.md`).
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
- Details: `docs/commit-messages.md`.

## Out of scope for this behavior

Push, PR creation, amend, and rebase — only when the user explicitly asks for those actions elsewhere under this skill.

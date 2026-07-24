# Behavior: closeout

Use when the user asks to create a commit, run a commit, invokes `/commit`, or when `integrity-review` hands off after a Clean or Corrected verdict.

Closeout has three phases: **commit** (with push approval when push is in play), **unify** (worktree only), **push** (execute if already approved). Git write commands still need explicit approval before they run.

## Hard rules

1. Never amend, rebase, or force-push unless the user explicitly asks.
2. Never update git config. Never use `--no-verify`.
3. Never use Conventional Commits prefixes unless the user explicitly asks.
4. Commit messages in English. Match recent `git log` tone.
5. Never stage files outside the allowed scope for the active branch below.
6. Never commit, merge, remove a worktree, or push without explicit user approval (push approval belongs in the Phase 1 confirmation when push is in play).
7. If a commit or merge hook fails, report the error and stop. Do not amend.
8. Exclude secret-like paths (`.env`, credentials, private keys, and similar). Warn when any were candidates.
9. After an integrity-review Uncertain verdict, do not run closeout until the uncertainty is resolved.

## Inspect first

Run in parallel from the active workspace (`main` checkout or worktree path):

```bash
git status
git diff --staged --name-only
git diff --staged
git diff --name-only
git diff
git log -n 5 --oneline
git branch --show-current
git remote -v
```

If the session used a worktree, also note `primary_repo`, `worktree_path`, and `branch` from workspace-choice.

## Check saved closeout preferences

Use session-injected preferences, or read `.nexus/user/preferences.md` (and skim other `.nexus/user/` files when needed) for:

- `closeout unify` / `closeout_unify`: `ask` | `always` | `never` (default `ask`)
- `closeout push` / `closeout_push`: `ask` | `always` | `never` (default `ask`)
- `commit superpowers docs` / `commit_superpowers_docs`: `include` | `exclude` | `ask` (default `ask`)

### Superpowers plans/docs paths

Treat as Superpowers plans/docs when the path is under:

- `docs/superpowers/` (including `plans/`, `specs/`, and siblings)
- `.superpowers/`

These paths are **not** auto-excluded. Apply `commit superpowers docs`:

| Preference | Behavior |
| --- | --- |
| `ask` (default when no memory) | Before commit confirmation, ask whether to include Superpowers plans/docs in this commit |
| `include` | Keep them in the candidate file list like any other path |
| `exclude` | Remove them from candidates; mention they were skipped per saved preference |

When the user answers an `ask` prompt, offer to save the choice via `$memory` (for example `commit superpowers docs: exclude`).

Apply during Phase 1 (push) and Phase 2 (unify):

| Preference | Phase 2 (unify) | Push (in Phase 1 confirmation) |
| --- | --- | --- |
| `ask` | Ask whether to unify | Include push target in the Phase 1 ask |
| `always` | Skip the yes/no question; show merge plan and ask once to approve unify | Include push target in the Phase 1 ask (note the saved preference) |
| `never` | Skip unify; keep worktree and branch | Omit push from the Phase 1 ask; skip Phase 3 |

Never say you will "offer push later". When push is in play, the Phase 1 question is already `add + commit + push`.

Git write commands still need explicit approval even when preference is `always`. Preferences change whether unify/push are included, not whether approval is required.

When the user asks to always unify or always push (or never), offer to save via `$memory`.

---

## Phase 1 — Commit (+ push approval when in play)

Follow exactly one branch below.

When invoked from an integrity-review handoff, use the same branches. Do not re-ask for a separate review summary.

### Push target for Phase 1

When `closeout push` is not `never`, resolve the intended push target before the confirmation:

- **main mode:** current branch (usually `main`)
- **worktree + unify likely:** `main` after unify (say so); if the user later declines unify, push the feature branch instead
- **worktree + unify never:** feature branch

Show remote (default `origin` when present) and commits that will be ahead after this commit.

### Branch A — staged files exist

1. Use only staged files. Ignore unstaged/untracked for this round.
2. If staged paths include Superpowers plans/docs, apply `commit superpowers docs` (ask / include / exclude) before continuing.
3. Draft one subject line from the staged diff and recent commit style (`commit-messages.md`).
4. Show the user in one confirmation:
   - source: `staged`
   - workspace: `main` or `worktree` (+ path and branch when worktree)
   - file list
   - proposed commit message
   - push target when `closeout push` is not `never`
5. Ask once:
   - push in play: approve add + commit + push to `<remote>/<branch>` (or commit + push when already staged)
   - push skipped (`never`): approve add + commit (or commit only when already staged)
6. On approval, commit with a HEREDOC:

```bash
git commit -m "$(cat <<'EOF'
Approved message here.

EOF
)"
```

7. Show short post-commit `git status` and the new commit subject/hash.
8. Record whether push was approved in this confirmation.
9. Continue to Phase 2 when workspace was `worktree`; otherwise continue to Phase 3.

### Branch B — nothing staged and working tree clean

1. Tell the user there is nothing to commit.
2. Stop. Do not run unify or push unless the user asks.

### Branch C — nothing staged, but unstaged and/or untracked changes exist

1. Build the session file set: paths this agent created or edited in the current conversation (Write/Edit/equivalent tools).
2. Intersect dirty paths (`git status` unstaged + untracked) with the session file set. Untracked files are allowed only if they are in the session set.
3. Drop secret-like paths. Apply `commit superpowers docs` to any Superpowers plans/docs in the candidate list. Warn when secret-like paths were candidates.
4. If the remaining candidate list is empty:
   - Tell the user there is no session context to commit.
   - Stop.
5. If candidates remain:
   - Draft one subject line from those diffs and recent commit style (`commit-messages.md`).
   - Show the user in one confirmation:
     - source: `session-unstaged`
     - workspace: `main` or `worktree` (+ path and branch when worktree)
     - file list to `git add`
     - proposed commit message
     - push target when `closeout push` is not `never`
   - Ask once:
     - push in play: approve add + commit + push to `<remote>/<branch>`
     - push skipped (`never`): approve add + commit together
6. On approval:
   - `git add` only the approved paths
   - commit with the approved message (HEREDOC as in Branch A)
   - show short post-commit status
   - record whether push was approved in this confirmation
7. On refusal: adjust scope/message and ask again. Do not commit until approved.
8. After a successful commit, continue to Phase 2 when workspace was `worktree`; otherwise continue to Phase 3.

---

## Phase 2 — Worktree unify

Run only when the session used `worktree` mode and Phase 1 produced a commit (Branch A or C).

Skip when workspace was `main`.

1. Show:
   - feature branch name
   - worktree path
   - new commit hash (from Phase 1)
2. Ask once: unify into `main`? (merge the feature branch into `main` in the primary repo and remove the worktree)

   When saved preference is `closeout unify: always`, say so and ask once to approve the merge and worktree removal instead of asking whether to unify.

   When saved preference is `closeout unify: never`, skip this phase and continue to Phase 3 with the feature branch as the push target.
3. On approval, from the **primary repo root** (not the worktree):

```bash
git checkout main
git pull --ff-only   # only when main has an upstream configured
git merge <branch> --no-edit
git worktree remove <worktree_path>
```

4. If `git pull` or merge conflicts occur: stop, report the conflict, and leave the worktree intact until the user resolves it.
5. On successful merge, optionally run `git branch -d <branch>` when the branch is fully merged and the user did not object.
6. Record: session workspace is now `main` at the primary repo root.
7. Continue to Phase 3.

If the user declines unify: keep the worktree and branch as-is; continue to Phase 3 with the feature branch as the push target.

---

## Phase 3 — Push

Run after Phase 1 when workspace was `main`, or after Phase 2 when workspace was `worktree`.

Skip when Phase 1 stopped with nothing to commit (Branch B).

Skip when `closeout push` is `never`, or when Phase 1 did not include/approve push. Show final `git status` and stop.

1. Determine push target (re-resolve after unify):
   - **main mode:** current branch (usually `main`)
   - **worktree + unified:** `main` at the primary repo
   - **worktree + not unified:** feature branch (from the worktree checkout or its remote tracking branch)
2. If push was already approved in Phase 1, execute without asking again. Briefly restate:
   - branch
   - remote (from `git remote -v`, default `origin` when present)
   - commits ahead of upstream (`git status -sb` or `git rev-list --count @{u}..HEAD` when upstream exists)
3. Only ask again if the push target changed after unify in a way the Phase 1 confirmation did not cover (for example user declined unify and the Phase 1 ask only named `main`). Otherwise do not re-ask.
4. On approval (from Phase 1 or the rare re-ask):

```bash
git push -u origin <branch>
```

5. If there is nothing to push (no commits ahead of upstream): say so and stop.
6. Show short post-push status.

---

## Message style

- Prefer a concise subject that states the effect or reason.
- Align with the last ~5 commits in this repository.
- Subject only by default.
- Details: `commit-messages.md`.

## Out of scope

PR creation, amend, and rebase — only when the user explicitly asks for those actions elsewhere under this skill.

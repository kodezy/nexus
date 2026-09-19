# Git workflow (observed)

_Optional shape. Last reviewed: YYYY-MM-DD. On conflict, `git log` on the current branch wins._

## Branches

- `main` — production-ready; no direct pushes without review.
- Feature work: `feat/<short-slug>` from `main`.

## Commits

- Match recent `git log` on this branch (language, prefixes, tense).
- One logical change per commit when possible.
- Never amend, rebase, or force-push unless explicitly asked.

## Closeout (when I ask to commit)

1. Run `git status`, `git diff`, and `git log -n 15 --oneline`.
2. Draft a subject line matching recent commit style on this branch.
3. Show file list and proposed message; wait for explicit approval.
4. Stage only approved paths; commit with the approved message.
5. Push only when I explicitly ask and **Closeout push** allows it.

## Policy

- **Closeout push:** never — push only when explicitly asked.
- Prefer squash merge on PRs.

## Worktree (optional)

- Default workspace: `main`
- Isolated work: sibling path `../<repo>-<slug>` when requested — create only after approval.

---
name: closeout
description: Integrity review then Nexus git closeout (commit, unify, push)
---

Use `$integrity-review` on the completed implementation (affected feature area).

On **Validated** or **Corrected**, hand off to `$git-assistant` → `docs/closeout.md`:

1. Commit confirmation already includes push when `closeout push` is not `never` (`add + commit + push` — never defer with "offer push later")
2. Unify to `main` when worktree (respect `closeout unify`)
3. Execute the approved push (respect `closeout push`)

On **Uncertain** or **Blocked**, stop without closeout.

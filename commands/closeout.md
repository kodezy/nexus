---
name: closeout
description: Integrity review then Nexus git closeout (commit, unify, push)
---

Use `$integrity-review` on the completed implementation (affected feature area).

On **Clean** or **Corrected**, hand off to `$git-assistant` → `docs/closeout.md`:

1. Commit (respect `commit superpowers docs`)
2. Unify to `main` when worktree (respect `closeout unify`)
3. Push offer (respect `closeout push`)

On **Uncertain**, stop without closeout.

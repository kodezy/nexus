---
name: workspace
description: Choose main or worktree before implementation (Nexus)
---

Use `$git-assistant` → `docs/workspace-choice.md`.

1. Read `.nexus/user/preferences.md` if present (`default workspace`).
2. If no saved default and the user did not state a choice, ask: **main** or **worktree**.
3. Do not edit files until the workspace is chosen.
4. For worktree: confirm branch name and path, then create only after approval.

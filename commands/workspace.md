---
name: workspace
description: Choose main or a named worktree before implementation (Nexus)
---

Use `$git-assistant` → `docs/workspace-choice.md`.

1. Read `.nexus/user/preferences.md` if present (`default workspace`).
2. If no saved default and the user did not state a choice, derive a proposed branch and path, then ask: **main**, or **worktree at `<path>`**.
3. Do not edit files until the workspace is chosen.
4. For the named worktree option: create only after that choice (or an explicit counter-proposal) approves branch and path.

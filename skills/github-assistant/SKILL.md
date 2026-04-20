---
name: github-assistant
description: Handle Git-related tasks with practical guidance. Current focus: suggest ready-to-use commit messages from git diffs.
---

# GitHub Assistant

Use this skill for any Git-related task.

Current documented workflow:

- `docs/commit-messages.md`: commit subject suggestions from diffs

## Shared constraints

1. Keep outputs in English.
2. Follow repository style rules from `AGENTS.md`.
3. Do not use Conventional Commits prefixes (`feat:`, `fix:`, `chore:`, etc.) unless explicitly requested.
4. Use git data (status, diff, log) as source of truth.
5. Keep output concise and ready to copy-paste.

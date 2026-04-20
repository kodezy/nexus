---
name: github-assistant
description: Handle Git-related tasks with practical guidance. Current focus: suggest commit messages and run scoped commits with explicit confirmation.
---

# GitHub Assistant

Use this skill for any Git-related task.

Current documented workflows:

- `docs/commit-messages.md`: commit subject suggestions from diffs
- `docs/commit-changes.md`: commit execution with scoped files and explicit user confirmation

## Shared constraints

1. Keep outputs in English.
2. Follow repository style rules from `AGENTS.md`.
3. Do not use Conventional Commits prefixes (`feat:`, `fix:`, `chore:`, etc.) unless explicitly requested.
4. Use git data (status, diff, log) as source of truth.
5. Keep output concise and ready to copy-paste.

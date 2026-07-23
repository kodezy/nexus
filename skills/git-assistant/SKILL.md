---
name: git-assistant
description: >-
  Handle all Git and GitHub-related tasks: status, diff, log, commit message
  suggestions, scoped commits with explicit confirmation, branch/remote
  advice, and in-repo git hygiene. Use whenever the user asks about git,
  commits, staging, branches, remotes, or related GitHub workflows.
---

# Git Assistant

Single skill for every Git-related request, including commit messages and commits.

## When to use

Apply this skill for any of:

- inspect repo state (`status`, `diff`, `log`)
- suggest commit messages
- create a commit (staged or session-scoped)
- finalize handoff after `integrity-review` Clean or Corrected
- branch / remote / staging advice grounded in git data
- GitHub steps that depend on local git state (before push/PR)

## Route by intent

| Intent | Follow |
| --- | --- |
| Suggest commit message(s) only | `docs/commit-messages.md` |
| Create or run a commit | `docs/commit-changes.md` |
| Finalize handoff after integrity review | `docs/commit-changes.md` (same confirmation: files + message) |
| Other Git questions | Answer from live git data using shared constraints below |

## Shared constraints

1. Keep outputs in English.
2. Follow repository style rules from `AGENTS.md`.
3. Do not use Conventional Commits prefixes (`feat:`, `fix:`, `chore:`, etc.) unless explicitly requested.
4. Use git data (`status`, `diff`, `log`) as the source of truth.
5. Never update git config. Never use `--no-verify` or skip hooks unless the user explicitly asks.
6. Never push, force-push, amend, or rebase unless the user explicitly asks for that action.
7. Never commit without explicit user approval of the file list and message.
8. Keep output concise and ready to copy-paste.

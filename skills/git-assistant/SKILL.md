---
name: git-assistant
description: >-
  Handle all Git and GitHub-related tasks: workspace choice (main vs worktree),
  status, diff, log, commit message suggestions, closeout (commit, unify, push),
  branch/remote advice, and in-repo git hygiene. Use whenever the user asks
  about git, commits, staging, branches, worktrees, remotes, or related
  GitHub workflows.
---

# Git Assistant

Single skill for every Git-related request, including workspace choice, commit messages, and closeout.

## When to use

Apply this skill for any of:

- choose workspace before implementation (`main` or `worktree`)
- inspect repo state (`status`, `diff`, `log`)
- suggest commit messages
- closeout after implementation or `integrity-review` (commit, unify, push)
- branch / remote / worktree advice grounded in git data
- GitHub steps that depend on local git state (before push/PR)

## Route by intent

| Intent | Follow |
| --- | --- |
| Choose workspace before implementation | `docs/workspace-choice.md` (reads `.nexus/user/` first) |
| Suggest commit message(s) only | `docs/commit-messages.md` |
| Create or run a commit | `docs/closeout.md` |
| Finalize handoff after integrity review | `docs/closeout.md` |
| Other Git questions | Answer from live git data using shared constraints below |

## Shared constraints

1. Keep outputs in English.
2. Follow the Nexus contract (`rules/nexus-contract.mdc`).
3. Do not use Conventional Commits prefixes (`feat:`, `fix:`, `chore:`, etc.) unless explicitly requested.
4. Use git data (`status`, `diff`, `log`) as the source of truth.
5. Never update git config. Never use `--no-verify` or skip hooks unless the user explicitly asks.
6. Never amend, rebase, or force-push unless the user explicitly asks for that action.
7. Never create a worktree, commit, merge into `main`, remove a worktree, or push without explicit user approval for that step.
8. Keep output concise and ready to copy-paste.

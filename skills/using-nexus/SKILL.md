---
name: using-nexus
description: >-
  Use when starting any conversation — bootstrap for the Nexus harness. Requires
  invoking relevant Nexus skills before acting, including clarifying questions.
---

<SUBAGENT-STOP>
If you were dispatched as a subagent to execute a specific task, ignore this skill.
</SUBAGENT-STOP>

<EXTREMELY-IMPORTANT>
If there is even a small chance a Nexus skill applies, invoke it and follow it.
Do not improvise workspace choice, closeout, integrity review, architecture, or style.
</EXTREMELY-IMPORTANT>

# Using Nexus

## Step 0 — Preferences

When saved preferences were injected at session start, apply them for workspace choice and closeout (`default workspace`, `closeout unify`, `closeout push`, `commit workflow docs`, `workflow docs paths`). Repo preferences override global preferences on the same key.

If none were injected (for example Codex without hooks), read both when present before workspace choice or closeout:

1. `~/.nexus/user/preferences.md` (or `$NEXUS_HOME/user/preferences.md`) — cross-project defaults
2. `.nexus/user/preferences.md` — repo overrides

Global free-form notes under `~/.nexus/notes/` are not injected; use `$memory` to read them when relevant.

## Authority order

Nexus provides defaults; it does not override higher-priority instructions. Resolve conflicts in this order:

1. System and managed policy
2. Explicit user instructions
3. Host-native safety, approval, and configuration controls
4. Project instructions (`AGENTS.md`, `CLAUDE.md`, Cursor rules, or equivalents)
5. Nexus contract and skills
6. Optional plugins and skills

When instructions at the same priority conflict, stop and ask the user. Do not treat a Nexus default as permission to bypass a host control or another established project rule.

## The rule

After applying higher-priority instructions, invoke relevant Nexus skills **before** editing, exploring, or answering implementation questions. Announce `Using $skill to …` and follow the skill. If it turns out wrong, stop using it.

Always-on policy lives in `rules/nexus-contract.mdc`. Skills hold procedures — read the current skill file; do not rely on memory of an older version.

## Skill priority

Process / gate skills first, then domain skills:

| Situation | First skill |
| --- | --- |
| Implementation will edit files | `$git-assistant` → `workspace-choice` (after Step 0) |
| New module / folder / placement | `$architect` |
| React UI | `$frontend` |
| Feature / UI specification | `$spec-driven` |
| Final React UI quality review | `$frontend-quality` |
| Logging | `$log-writer` then `$code-style` |
| README | `$readme-writer` |
| Creating or coordinating subagents | `$subagent-guide` |
| Remember / recall | `$memory` |
| Finishing a code change | `$code-style` → `$integrity-review` → `$git-assistant` closeout |
| Bug / unexpected behavior | gather evidence; then `$integrity-review` when closing out |

## Red flags (stop and check skills)

| Thought | Reality |
| --- | --- |
| "This is a simple question" | Still check skills if the answer leads to repo work |
| "I need context first" | Skill check comes before deep exploration |
| "I'll just edit quickly" | Workspace choice and contract still apply |
| "I remember how closeout works" | Read `closeout.md` — preferences may have changed |
| "Skip integrity for a tiny change" | Code changes still close out via `$integrity-review` |
| "An optional plugin says something else" | Apply the authority order; Nexus supplies defaults, not overrides |

## Host and plugin coexistence

Use optional plugins when their workflow fits the task and does not conflict with higher-priority instructions. For example, Superpowers can help with design, planning, or subagent-driven development. Nexus defaults remain: do not create a test file, force a worktree, commit workflow artifacts, or install dependencies without an applicable project rule or user authorization. Use existing tests when they cover the change; otherwise ask before adding a test file.

## Harnesses

Nexus ships for Cursor (rules + hooks-cursor), Claude Code (SessionStart hook), Codex (skills, plugins, and hooks), and Hermes (profile skills + `SOUL.md`). Host capabilities and instruction surfaces vary; see the README compatibility matrix instead of assuming identical behavior.

## User instructions

Explicit user requests override skills. Skills override default model behavior. Only skip a Nexus workflow when the user clearly says to.

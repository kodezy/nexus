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

When saved preferences were injected at session start, apply them for workspace choice and closeout (`default workspace`, `closeout unify`, `closeout push`, `commit superpowers docs`).

If none were injected (for example Codex without hooks), read `.nexus/user/preferences.md` when present before workspace choice or closeout.

## The rule

Invoke relevant Nexus skills **before** editing, exploring, or answering implementation questions. Announce `Using $skill to …` and follow the skill. If it turns out wrong, stop using it.

Always-on policy lives in `rules/nexus-contract.mdc`. Skills hold procedures — read the current skill file; do not rely on memory of an older version.

## Skill priority

Process / gate skills first, then domain skills:

| Situation | First skill |
| --- | --- |
| Implementation will edit files | `$git-assistant` → `workspace-choice` (after Step 0) |
| New module / folder / placement | `$architect` |
| React UI | `$frontend` |
| Logging | `$log-writer` then `$code-style` |
| README | `$readme-writer` |
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
| "Superpowers already covers this" | For git/workspace/closeout/tests, Nexus wins |

## Superpowers coexistence

If Superpowers is installed: use it for design/plan/SDD process when relevant. Nexus owns workspace choice, closeout, and test policy (no new automated tests unless asked).

## Harnesses

Nexus ships for Cursor (rules + hooks-cursor), Claude Code (SessionStart hook), and Codex (skills + `agents/openai.yaml`). Behavior is the same; only packaging differs.

## User instructions

Explicit user requests override skills. Skills override default model behavior. Only skip a Nexus workflow when the user clearly says to.

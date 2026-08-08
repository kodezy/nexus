---
name: using-nexus
description: Use before editing code or repository files to route Nexus workflows without loading them for ordinary conversation or research.
---

<SUBAGENT-STOP>
If you were dispatched as a subagent to execute a specific task, ignore this skill.
</SUBAGENT-STOP>

# Using Nexus

## Scope

Use this skill before a code or repository change. Do not invoke it for general conversation, research, or read-only questions unless the user requests a Nexus workflow or the task specifically needs one.

For long work, maintain a concise task capsule in the current task state: goal, confirmed decisions, affected area, validation, and next step. Keep it temporary unless the user explicitly asks to save it.

When resuming long work or starting a new sub-task in the same session, re-read `~/.nexus/user/preferences.md` and `.nexus/user/preferences.md` (repo overrides global) before the first edit.

## Authority

Apply this order: system and managed policy; explicit user instructions; host-native safety and approval controls; project instructions; Nexus; optional plugins and skills. Ask the user when instructions at the same priority conflict.

## Route the change

1. Before the first edit, use `$git-assistant` → `workspace-choice`. Read preferences when choosing a workspace, closing out, or resuming long work; repo preferences override global preferences.
2. Use `$spec-driven` when a feature or UI still has material ambiguity.
3. Use `$architect` before adding files, modules, or structural boundaries.
4. Use the domain skill that fits the changed area:
   - Markdown docs: `$readme-writer` (monorepo: `docs/monorepo.md` in that skill).
   - HTTP API reference: `$api-docs-writer` (flows and UI guides stay out of `API.md`).
   - UI code: `$frontend` and `$frontend-quality`.
   - Other: `$log-writer`, `$playwright`, or another relevant skill.
5. Apply `$code-style` to touched code files.
6. Finish with `$integrity-review`, then `$git-assistant` closeout only after explicit approval.

## Compatibility

Optional plugins are task-specific. Nexus owns workspace choice, Git approval, closeout, and approval for a new automated test when it is the relevant missing validation sensor. Another plugin may guide planning, testing, or implementation only when it does not conflict with those gates.

Use existing tests for test-first work when available. If a new test file is the relevant missing sensor, propose its scope and ask the user before creating it. Without approval or another suitable check, report the implementation as Uncertain rather than validated.

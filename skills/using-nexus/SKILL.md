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

### Always (code or repository changes)

1. Before the first edit, use `$git-assistant` → `workspace-choice`. Read preferences when choosing a workspace, closing out, or resuming long work; repo preferences override global preferences.
2. Implement using **local project conventions first** (project `AGENTS.md` / `CLAUDE.md`, adjacent modules, formatter and linter output). Do not impose global Nexus style when the repository already has a clear pattern.
3. Finish with `$integrity-review`, then `$git-assistant` closeout only after explicit approval.

**Greenfield:** When the repo has no established pattern (empty, scaffold-only, or first files in a new area), detect stack from manifests and tool configs (`package.json`, `pyproject.toml`, `Cargo.toml`, `go.mod`, `*.config.*`, and similar). Apply the relevant domain skill (`$architect`, `$frontend`, `$log-writer`, …). Load a stack doc under `skills/<skill>/docs/` **only** when it matches that stack. If the stack is unnamed, ask before choosing a framework or language. Establish simple precedents; do not impose a Nexus-preferred stack. Save conventions to `.nexus/project/` only when the user asks via `$memory`.

### When the change needs it (proportional)

| Trigger | Skill or plugin |
| --- | --- |
| Feature or UI scope still ambiguous | Optional plugin (Spec Kit, Superpowers brainstorming) **or** `$spec-driven` when the user asks for a Nexus spec artifact |
| New files, modules, packages, or structural boundaries | `$architect` |
| Cleanup, deduplication, legacy removal, or simplification is the **primary** goal | `$code-cleanup` |
| User-facing UI (pages, screens, components, layouts, state, data flow) | `$frontend` |
| Logging statements or logger setup | `$log-writer` |
| Project Markdown (`README.md`, `docs/**/*.md`) | `$readme-writer` |
| HTTP API reference (`docs/API.md`, endpoint docs) | `$api-docs-writer` |
| Touched code needs style alignment beyond what local files already show | `$code-style` on those files only — skip loading the full skill for trivial one-line fixes |

Do not load domain skills when the diff does not touch that area.

### Subagent delegation

Use subagents only when they reduce elapsed time without weakening ownership:

- Delegate: three or more independent failure domains, parallel read-only reviews with clear boundaries, or independent implementation tasks with no shared mutable files.
- Keep one agent: small tasks, shared state, exploratory work, or edits likely to touch the same files.

Delegation rules:

1. One clear responsibility per subagent; state goal, scope, constraints, and expected evidence.
2. Do not assign overlapping files or mutable shared resources to parallel subagents.
3. Never delegate workspace choice, commits, pushes, merges, worktree lifecycle, closeout, or final integration.
4. Nexus subagents (Task tool, explore, and similar) must not commit; the primary agent owns integration, `$integrity-review`, and approved closeout.
5. If Superpowers subagent-driven development allows implementer commits per task, message style still follows `$git-assistant` → `commit-messages.md`.

After subagents return: inspect changed files, resolve conflicts, run validation on the combined diff, then continue the **Always** path above. Do not treat subagent summaries as completion evidence.

Task prompt template:

```text
Goal: <one bounded outcome>
Scope: <files or subsystem>
Constraints: <what must not change>
Validation: <commands or evidence to collect>

Return exactly:
task:
actions_taken:
files_changed:
results:
blockers:
next_step:
```

## Compatibility

Optional plugins (Superpowers plans, subagent-driven development, finishing-a-development-branch, and similar) may guide planning, testing, or implementation. Nexus still owns workspace choice, Git write approval, closeout after `$integrity-review`, commit message style (`$git-assistant` → `commit-messages.md`), and approval for a new automated test when it is the relevant missing validation sensor.

When an optional plugin includes commit steps or example messages, do not copy Conventional Commits examples (for example `feat:` prefixes). Draft subjects from the staged diff and `git log -n 5` instead.

If Superpowers subagent-driven development allows implementer subagents to commit per task, those commits still follow Nexus message style and approval rules. Nexus subagents (Task tool, explore, and similar) must not commit; the primary agent owns final closeout.

When `finishing-a-development-branch` and Nexus closeout both apply, run `$integrity-review` and `$git-assistant` closeout first for commit and push approval, then present merge or PR options from the plugin.

Use existing tests for test-first work when available. If a new test file is the relevant missing sensor, propose its scope and ask the user before creating it. Without approval or another suitable check, report the implementation as Uncertain rather than validated.

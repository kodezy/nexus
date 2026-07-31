---
name: subagent-guide
description: >-
  Coordinate bounded subagent work when independent domains benefit from
  parallel investigation or implementation. Use when creating subagents,
  defining delegation handoffs, or reviewing coordinated multi-agent work.
---

# Subagent Guide

Use subagents only when they reduce elapsed time without weakening ownership or
creating integration risk. The primary agent remains accountable for the final
result.

## When To Delegate

Delegate when the work has independent, bounded domains, such as:

- Three or more failures in separate subsystems with distinct likely causes.
- A broad read-only review divided by clear areas such as security, docs, or
  independent packages.
- Independent implementation tasks that do not share files, state, or
  sequencing dependencies.

Keep one agent when the task is small, exploratory, related across domains,
dependent on shared state, or likely to change the same files.

## Delegation Rules

1. Give each subagent one clear responsibility.
2. State the exact goal, permitted files or subsystem, constraints, and
   expected evidence.
3. Do not assign overlapping files or mutable shared resources to parallel
   subagents.
4. Do not delegate workspace choice, commits, pushes, merges, worktree
   creation or removal, closeout, or final integration.
5. For uncertain or related failures, investigate the shared cause before
   splitting work.

## Task Prompt Template

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

## Integration

After subagents return, the primary agent must:

1. Review each handoff and inspect the changed files.
2. Check for overlapping edits, incompatible assumptions, and incomplete
   validation.
3. Resolve integration issues in the active workspace.
4. Run the appropriate validation across the combined change.
5. Apply `code-style`, run `integrity-review`, and follow `git-assistant` for
   any approved closeout.

Do not report a coordinated task as complete from subagent summaries alone.

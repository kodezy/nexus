---
name: integrity-review
description: >-
  Use when finalizing an implementation or reviewing completed work. Require
  deterministic evidence before a successful verdict. Prefer a separate verifier
  pass when the host supports subagents. Does not commit or push unless the user
  explicitly asks.
---

# Integrity Review

Review completed work for real issues in the affected feature area. A clean review is a valid result: preserve correct code when the available evidence does not establish a problem.

## Independent verification

The agent that implemented optimizes to finish. Before **Validated** or **Corrected**:

1. Extract acceptance criteria from the user request, any approved plan, and the final diff.
2. Run deterministic checks declared in project `AGENTS.md` / `CLAUDE.md` (lint, test, typecheck, build) or adjacent project docs.
3. When UI behavior changed, exercise the flow (host browser tools, project E2E, or manual steps the project documents).
4. When the host supports subagents, delegate a **verifier** with mission to disprove completion — same criteria, no implementation edits unless a proven defect requires a focused fix returned to the primary agent.

Do not treat the implementer's summary as completion evidence.

## Before the verdict, confirm

- requirements are addressed in scope;
- naming and placement match local project patterns (adjacent modules first; project validation checks when declared; when present, `docs/` linked from `AGENTS.md` → `## Docs` — not mechanical style linters already enforce);
- the final diff has no unintended edits, temporary debug residue, or obvious dead code introduced by this change (escalate uncertain removals in the verdict; do not sweep the area);
- when project documentation changed (see **Documentation changes** below), that checklist is satisfied.
- when the change alters boundaries, domain terms, or public API shape, check whether linked `docs/` or `AGENTS.md` → `## Docs` are now stale; if so, note it in the validation receipt and offer a focused doc update or `$project-context` — do not block **Validated** when code and project checks pass.

## Documentation changes

When the diff touches consumer project Markdown (`README.md`, `**/docs/**/*.md`, operations guides such as `OPERATIONS.md`):

1. Scope to touched files plus linked indexes they must stay consistent with.
2. Verify env vars against each package's `.env.example` — no cross-package attribution.
3. Verify commands, ports, and URLs against code, Compose, or manifests in the repo.
4. Confirm canonical terms match across touched docs in monorepos.
5. For UI docs, confirm page and tab names match nav labels in code.
6. Confirm relative links resolve; remove or fix broken targets.
7. Flag internal plan or scratch folders as non-user docs when linked from official indexes.

A docs-only change still needs a validation receipt (link check, `.env.example` diff, or code spot-check).

## Review sequence

1. Define the affected area: changed files plus direct callers, callees, re-exports, and relevant tests or fixtures. Do not sweep unrelated parts of the repository.
2. Gather evidence from the diff, current behavior, call paths, diagnostics, and relevant validation output.
3. Review logic, error paths, consistency with nearby code, dead branches, temporary debug output, and migration residue introduced by this change.
4. Act according to the evidence:
   - Proven issue: make the focused correction or removal, then validate it.
   - Uncertain public API, dynamic caller, or active feature flag: retain it and report the uncertainty.
   - No supported finding: make no change.
5. Run the relevant validation available for the change.
6. Record a validation receipt, then inspect the final diff for unintended edits.

## Validation receipt

Every implementation verdict includes this compact, evidence-based receipt:

```text
Validation receipt
- Scope: <affected behavior or files>
- Acceptance criteria checked: <criterion or not applicable>
- Checks run: <commands, inspection, or runtime exercise>
- Result: <pass, fail, or partial>
- Runtime/UI evidence: <what was exercised, or not applicable>
- Remaining uncertainty: <none or specific gap>
```

Do not claim a successful implementation only from a code reading or from the agent's own confidence. A relevant deterministic check, runtime exercise, or other verifiable evidence is required for **Validated** or **Corrected**.

If the repository has no suitable check, explain the missing sensor and return **Uncertain**. If validation cannot proceed because of an external dependency, unavailable credential, broken environment, or failed prerequisite, return **Blocked**.

## Verdict

Return one concise, evidence-based result followed by the validation receipt:

- **Validated:** `No issues found in the affected area.` State the evidence reviewed and validation run.
- **Corrected:** State each focused correction, the evidence supporting it, and validation run.
- **Uncertain:** State what was retained or completed, why evidence is insufficient, and the next evidence needed. Do not describe the implementation as validated.
- **Blocked:** State the external blocker, what was not validated, and the minimum condition required to continue.

Do not turn hypothetical concerns into changes. Prefer a precise validated verdict over speculative refactoring.

## After the verdict

1. **Uncertain or Blocked:** Report the blocker and stop.
2. **Validated or Corrected:** Report the verdict and receipt. Stop unless the user explicitly asks to commit or push — then follow `docs/git.md` if present, else `git log`, plus `AGENTS.md` workflow keys.
3. Never commit, merge, remove a worktree, or push without explicit user approval.

Review-only requests with no code changes still return the verdict when asked.

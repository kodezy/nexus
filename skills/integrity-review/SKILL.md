---
name: integrity-review
description: >-
  Use when finalizing an implementation, reviewing completed work, or explicitly
  checking for logic issues, inconsistencies, obsolete code, legacy paths,
  fallbacks, residues, or unnecessary boilerplate. After a Clean or Corrected
  verdict on a code change, hand off to git-assistant closeout (commit, unify,
  push).
---

# Integrity Review

Review completed work for real issues in the affected feature area. A clean review is a valid result: preserve correct code when the available evidence does not establish a problem.

## Canonical closeout

This skill is the single source of truth for end-of-implementation review and commit handoff. The Nexus contract and `code-style` route here; they do not repeat the full checklist.

After every code implementation closeout, this skill is mandatory. On Clean or Corrected, continue to closeout (commit, worktree unify when applicable, push offer). On Uncertain, stop without closeout.

Before the verdict, confirm:

- requirements are addressed in scope;
- naming and placement match the contract and local project patterns;
- touched files follow public-before-private member/module order and clear identifiers (`code-style`);
- `architect` was used when structure or architecture changed;
- the final diff has no unintended edits or temporary debug residue.

## Review sequence

1. Define the affected area: changed files plus direct callers, callees, re-exports, and relevant tests or fixtures. Do not sweep unrelated parts of the repository.
2. Gather evidence from the diff, current behavior, call paths, diagnostics, and relevant validation output.
3. Review these concerns:
   - logic and error-path correctness;
   - consistency with nearby code and stated requirements;
   - dead branches, unused symbols, temporary debug output, stale flags, and completed-migration residue;
   - legacy implementations and fallbacks that the live path no longer needs;
   - duplicated or unnecessary boilerplate introduced by the change.
4. Act according to the evidence:
   - Proven issue or clearly obsolete code: make the focused correction or removal, then validate it.
   - Uncertain public API, dynamic caller, compatibility path, or active feature flag: retain it and report the uncertainty with the missing evidence.
   - No supported finding: make no change.
5. Run the relevant validation available for the change, then inspect the final diff for unintended edits and leftover temporary material.

## Verdict

Return one concise, evidence-based result:

- **Clean:** `No issues found in the affected area. No changes made.` Include the evidence reviewed and validation run.
- **Corrected:** State each focused correction, the evidence supporting it, and validation run.
- **Uncertain:** State what was retained, why it is uncertain, and the next evidence needed. Do not describe the implementation as clean.

Do not turn hypothetical concerns into changes. Prefer a precise clean verdict over speculative refactoring.

## Commit handoff

After the verdict, follow exactly one path:

1. **Uncertain:** Report the blocker and stop. Do not offer closeout.
2. **Corrected:** Ensure corrections are validated, then continue with step 3 on the final diff.
3. **Clean or Corrected:** Hand off to `git-assistant` → `docs/closeout.md` (full closeout behavior lives there):
   - Phase 1 — commit, with push included in the same approval when `closeout push` is not `never`
   - Phase 2 — unify when worktree (respect `closeout unify`: ask | always | never)
   - Phase 3 — execute push when already approved in Phase 1 (respect `closeout push`: ask | always | never)
4. If there is nothing eligible to commit (clean tree or empty session set): say so and stop.
5. Never commit, merge, remove a worktree, or push without explicit user approval.

Review-only requests with no eligible session changes still return the verdict; offer closeout only when candidates exist and the verdict is Clean or Corrected.

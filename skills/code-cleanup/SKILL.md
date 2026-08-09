---
name: code-cleanup
description: >-
  Remove dead code, legacy paths, duplication, and unnecessary boilerplate while
  simplifying structure over adding abstraction. Use when cleanup, deduplication,
  legacy removal, or simplification is the primary goal or a substantial part of
  the session—not only as a light pass after feature work.
---

<SUBAGENT-STOP>
If you were dispatched as a subagent to execute a specific task, ignore this skill.
</SUBAGENT-STOP>

# Code Cleanup

Remove obsolete code and simplify the affected area without changing intended behavior. Prefer **simplicity over abstraction**: inline, colocate, and delete before extracting helpers, layers, or shared modules.

## Boundaries

| Owns | Does not own |
| --- | --- |
| Cleanup scope, removal order, deduplication, simplification heuristics | Verdicts and validation receipts (`integrity-review`) |
| When to remove vs escalate | Formatting, naming, module order (`code-style`) |
| Merge/delete file decisions (with `architect`) | React UX/a11y review (`frontend-quality`) |
| Language-specific detection signals | Logging policy (`log-writer`) |

For every code change (including small features), `code-style` still runs its light **Area Cleanup** pass. Use **this skill** when cleanup, deduplication, legacy removal, or simplification is the **primary** task or a substantial part of the session.

## Language / area selection

Apply language-agnostic rules from this skill first. Then load only the doc that matches the files in scope:

| Signals | Doc |
| --- | --- |
| `.py`, `pyproject.toml`, Python packages | `docs/python.md` |
| `.ts`, `.tsx`, `.jsx`, frontend utilities | `docs/typescript.md` |
| `.rs`, `Cargo.toml` | `docs/rust.md` |
| Mixed repository | Per file; shared rules stay in this `SKILL.md` |

If repository conventions conflict with generic guidance, **local conventions win**.

## Workflow

1. **Scope the area** (same boundary as `code-style` Area Cleanup):
   - Start from the target module, package, or flow the user named.
   - Include direct callers, callees, re-exports, and tests/fixtures for that flow.
   - Stop at the feature boundary; do not sweep unrelated packages.

2. **Gather evidence** before deleting or merging:
   - Static references (imports, `use`, re-exports, symbol search).
   - Project checks when available (typecheck, linter unused rules, `cargo clippy`, tests).
   - Runtime or dynamic use only when static analysis is inconclusive—then **escalate**, do not guess.

3. **Work in this order** (behavior-preserving unless the user asked to change behavior):
   1. **Dead and unused** — unreferenced symbols, unreachable branches, stale flags, debug residue, completed migration TODOs.
   2. **Legacy paths** — old fallbacks, compatibility shims, duplicate code paths when the new path is the only live one.
   3. **Duplication** — merge at the **lowest common owner** (same module first; shared module only when 2+ stable callers need it—see `architect`).
   4. **Inconsistencies** — align naming, error handling, and patterns with adjacent code in the area (`code-style` for how it should read).
   5. **Over-abstraction** — inline one-use helpers, remove pass-through wrappers, flatten unnecessary layers; delete files only when `architect` split criteria no longer apply.

4. **Simplification heuristics** (all languages):
   - **Inline before extract.** Do not add a function, hook, trait, or class for a single call site.
   - **Colocate before split.** Keep related logic in the owning module unless a clear boundary exists (`architect`).
   - **Delete before generalize.** Remove an abstraction layer used by one caller instead of “making it reusable.”
   - **Guard clauses before nesting.** Prefer early return/continue over deep `if` trees.
   - **No catch-all modules.** Do not move leftovers to `utils`, `helpers`, `common`, or `misc`.
   - **Minimal diff.** One focused concern per pass; avoid style-sweeping untouched files.

5. **Structural changes** — use `$architect` before deleting packages, merging modules, or moving code across boundaries.

6. **Style pass** — run `$code-style` on every touched file (formatting and naming stay there, not here).

7. **Closeout** — run `$integrity-review` (mandatory). It owns the verdict, validation receipt, and commit handoff. Do not declare the cleanup validated without evidence.

## Remove when obvious

- Symbol with no remaining references in the scoped area (and no export/dynamic-use signal).
- Dead branch left by a completed migration.
- Fallback path provably unused by callers in scope.
- Debug prints, temporary flags, session scratch, obsolete comments/TODOs already done.
- Duplicate logic that can merge without widening the public API.

## Escalate (do not remove without evidence)

- Public API, crate root re-exports, or documented external contract.
- Compatibility required for a supported client or version range.
- Feature flag without confirmation it is off or removed.
- Reflection, dynamic import, plugin registry, or stringly dispatch targets.
- `#[allow(dead_code)]`, `// eslint-disable`, `noqa`, or similar suppressions—treat as a signal to investigate, not automatic removal.
- Code referenced only outside the scoped area—expand scope deliberately or report in `blockers`.

When escalating: leave the code in place, state what evidence is missing, and do not report the area as fully cleaned.

## Checklist before `integrity-review`

- Intended behavior unchanged (unless the user requested a behavior change).
- Scoped area has no obvious dead code, legacy fallback, or duplication left by this pass.
- Simplifications prefer inline/colocate over new abstraction.
- File/module deletes and merges follow `architect`.
- Touched files pass `code-style`.
- Ambiguous leftovers are listed in `blockers` / `next_step`, not silently kept.

## Internal docs

- `docs/python.md` — unused detection, legacy residues, duplication patterns.
- `docs/typescript.md` — exports, hooks/components, frontend duplication.
- `docs/rust.md` — modules, traits, `clippy` signals, orphan `mod`.

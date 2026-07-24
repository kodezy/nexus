# Nexus

A pragmatic harness for coding agents that keeps implementation work focused, verifiable, and easy to review.

![Nexus harness illustration](assets/nexus.png)

## What It Does

Nexus gives an agent a clear operating contract for working in a repository:

- Understand the requested outcome before changing files.
- Use the relevant skill and follow local project conventions.
- Prefer the smallest production-ready solution.
- Validate the result with evidence, not assumptions.
- Review the affected area, then confirm the commit when the review is clear.

The goal is not to make agents cautious for its own sake. The goal is to make changes predictable: no speculative refactors, no broad cleanup unrelated to the request, and no claims of success without verification.

## How Work Flows

1. **Understand** — identify the request, constraints, and success criteria.
2. **Act** — implement the smallest change that solves the problem.
3. **Observe** — inspect the relevant diff, behavior, diagnostics, and callers.
4. **Validate** — run proportionate checks and fix regressions introduced by the change.
5. **Review** — run `$integrity-review` on the affected feature area for real logic issues, inconsistencies, dead code, legacy paths, residues, and unnecessary boilerplate.
6. **Confirm commit** — when the review is Clean or Corrected, show the file list and proposed commit message; commit only after you approve. If the review is Uncertain, stop without offering a commit.

## Operating Principles

- **Evidence first.** A change, cleanup, or conclusion needs observable support.
- **Scope stays local.** Review touched files and their direct flow neighbors, not the entire repository.
- **Clean is a valid result.** If no issue is supported by evidence, make no change.
- **Remove only what is clearly obsolete.** Keep uncertain public APIs, dynamic callers, compatibility code, and active feature flags until their status is known.
- **Keep it direct.** Avoid unnecessary abstractions, boilerplate, and process overhead.
- **Commit needs approval.** The agent prepares the file list and message; you confirm once.

## Using the Harness

For an implementation request, state the intended outcome and constraints. Nexus routes the work through the relevant project rules and skills, validates the result, runs integrity review, and then asks you to confirm the commit when the review is clear.

For an explicit final review, use:

```text
Use $integrity-review to check the completed implementation.
```

The review returns one of three outcomes:

- **Clean** or **Corrected** — then one commit confirmation (files + message)
- **Uncertain** — blocker reported; no commit offered

## Repository Reference

- `AGENTS.md` — the project operating contract.
- `skills/` — reusable workflows for implementation, style, architecture, Git, reviews, and more.
- `scripts/` — supporting automation.
- `assets/` — repository visual assets.

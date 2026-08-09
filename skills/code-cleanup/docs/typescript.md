# Code cleanup — TypeScript / JavaScript

Use with `../SKILL.md`. Applies to `.ts`, `.tsx`, `.jsx`, and shared frontend utilities. React UI structure stays in `frontend`; this doc covers dead code, duplication, and simplification signals.

## Scope signals

- Application modules, API clients, hooks, components in the named flow.
- Barrel `index.ts` files only when they are part of the scoped export graph.

## Evidence (prefer project tooling)

| Check | Typical command / signal |
| --- | --- |
| Typecheck / unused | `tsc --noEmit`, project `typecheck` script |
| Lint unused | ESLint `no-unused-vars`, `@typescript-eslint/no-unused-vars` |
| Tests | `vitest`, `jest`, or package test script on scoped paths |
| Export graph | Search importers of removed `export` / default export |

Treat `// @ts-ignore`, `eslint-disable-next-line`, and unused generic parameters as **investigate**, not auto-delete.

## Remove when obvious

- Unused import, type, function, hook, or component with no importers in scope.
- Dead branch after discriminated union or feature switch migration.
- Duplicate fetch/error-handling blocks in the same feature—merge at the data owner.
- Legacy `require()` / `module.exports` in a file already on ESM elsewhere in the package.
- Unused React state/effect left after UI simplification (verify with `frontend-quality` if user-facing).

## Duplication patterns

- **Repeated API client calls** — one function in the owning module or existing client file; no new `api-helpers.ts` unless `architect` criteria met.
- **Copy-pasted loading/error UI** — extract only when 2+ stable call sites in scope; otherwise inline the simpler version.
- **Parallel `useEffect` fetches** — consolidate to one effect or the project's data layer (`frontend` / `react.md`); delete redundant requests.
- **Identical Zod/Yup schemas** — single schema at the validation owner.

## Simplification over abstraction

- Inline one-use `useMemo` / `useCallback` when dependency noise exceeds benefit (`code-style` typescript doc).
- Remove wrapper components that only pass props through.
- Prefer guard clauses in event handlers over nested condition trees.
- Do not add a new hook for logic used in one component.

## Escalate

- Exported types/functions from package public entry (`package.json` `exports`).
- Dynamic `import()`, `React.lazy`, route config tables, or registry maps keyed by string.
- `namespace` blocks still required by ambient types or legacy consumers.
- Code referenced from config files, Storybook, or tests outside the scoped folder.

## After cleanup

Run `$code-style` (`docs/typescript.md` in that skill). For touched React UI, run `$frontend-quality`, then `$integrity-review`.

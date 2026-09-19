# Conventions (observed)

_Optional shape. Last reviewed: YYYY-MM-DD. On conflict, adjacent code and formatter/linter configs win._

## Tooling

Link configs here — do not paste their rules:

- ESLint: `eslint.config.js`
- Prettier: `.prettierrc` (if present)

## Project rules (not in CI)

- Services in `src/services/` do not import from `src/api/` route handlers.
- Public API types live in `src/types/`; do not re-export domain types from UI components.

## Naming

- React components: `PascalCase.tsx` under `src/ui/`
- Service modules: `kebab-case.ts` under `src/services/`

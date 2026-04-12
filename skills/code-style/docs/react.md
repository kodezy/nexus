# React/TypeScript Style

## Scope

Use for `tsx`, `jsx`, `ts` files and frontend areas with React components/hooks.

## Rules

1. Keep components focused and small; extract only when reuse or clarity is clear.
2. Prefer explicit props typing and avoid implicit `any`.
3. Keep hooks at top level and avoid conditional hook calls.
4. Use early returns to reduce nesting in render logic.
5. Keep side effects isolated in `useEffect` with clear dependency arrays.
6. Prefer derived values with `useMemo` only when computation is non-trivial.
7. Prefer stable callbacks with `useCallback` only when it improves render behavior.
8. Keep UI state local; lift state only when shared usage requires it.
9. Name components in PascalCase and hooks with `use*`.
10. Keep JSX readable: one responsibility per block and clear conditional rendering.

## Formatting

- Keep props and JSX layout consistent with local file style.
- Group imports by source and preserve local ordering conventions.
- Avoid large inline anonymous functions when extraction improves readability.
- Keep one blank line between logical sections in components.

## Safety

- Do not change component behavior while styling.
- Preserve public props contracts and emitted events/callback behavior.

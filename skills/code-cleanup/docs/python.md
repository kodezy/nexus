# Code cleanup — Python

Use with `../SKILL.md`. Local project conventions win over this doc.

## Scope signals

- `.py` modules, packages, scripts, workers, CLI entrypoints.
- Tests in the same flow (`tests/`, `test_*.py`) when they reference removed symbols.

## Evidence (prefer project tooling)

Run what the consumer repo already declares; examples:

| Check | Typical command / signal |
| --- | --- |
| Unused imports / variables | `ruff check --select F401,F841` or project lint script |
| Types / unreachable | `pyright`, `mypy`, or CI type job |
| Tests after removal | `pytest` on scoped paths |
| Dead code heuristic | `vulture` only when the project already uses it |

Use `rg` / reference search for symbols `ruff` cannot see (dynamic `getattr`, string dispatch, plugin entry points).

## Remove when obvious

- Unused `import`, function, class, or module-level constant in scope.
- Dead `if` / `elif` branch after enum or flag migration.
- Duplicate helpers in the same package that differ only by naming—merge into the owning module.
- `print()` / `breakpoint()` left from debugging.
- Completed `# TODO: remove after …` migration notes.
- Legacy shim that only re-exports the new symbol with no extra callers.

## Legacy residues

Remove only when unused or proven obsolete in scope—not as drive-by modernization:

- Compatibility re-exports that only exist for a removed caller.
- Duplicate validation in both caller and callee when one boundary clearly owns errors.
- `from __future__ import annotations` or other compat shims with no remaining runtime need (confirm against `code-style` / repo pins).

Do not rewrite working `os.path` / style idioms solely to “modernize”; leave that to an explicit style or language-upgrade task.

## Duplication patterns

- **Same validation in route + service** — keep at the boundary that owns HTTP vs domain rules; delete the duplicate layer.
- **Copy-pasted dict/list builders** — merge into one function in the owning module; do not create `utils.py`.
- **Parallel `try/except` blocks** — narrow handlers or share one boundary function if behavior stays identical.

## Escalate

- Names in `__all__`, package `__init__.py` re-exports, or documented public API.
- Celery/task name strings, Click entry points, `pyproject.toml` scripts tables.
- `TYPE_CHECKING` imports that exist only for circular imports—verify graph before delete.
- Metaclass hooks, `__getattr__` module lazy exports, Django `AppConfig.ready` side effects.

## After cleanup

Run `$code-style` (`docs/python.md` in that skill), then `$integrity-review`.

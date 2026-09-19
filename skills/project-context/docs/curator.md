# Behavior: project docs curator

## Sweet spot

| Layer | Role |
| --- | --- |
| Formatter / linter / typecheck (CI) | Mechanical style — spacing, imports, unused code |
| Adjacent modules | Local naming, file shape, patterns in the folder you are editing |
| `docs/` from this skill | Boundaries, domain language, conventions, git policy, and learnings **not** encoded in tools |

Do **not** duplicate what `AGENTS.md` → **Validation** already runs in CI. Link tooling configs; do not rewrite their rules in prose.

## Bootstrap

Use when the user asks to bootstrap, document, or refresh project context.

### 1. Discover scope

Read when present:

- `AGENTS.md` / `CLAUDE.md` — `## Agent workflow`, `## Docs`
- formatter, linter, and typecheck configs
- top-level layout (`src/`, `apps/`, `packages/`, `lib/`, and similar)
- `git log -n 15 --oneline` when refreshing `docs/git.md`

If `## Docs` already lists paths, prefer **refreshing** those files over creating new names.

### 2. Sample the codebase

Pick a small, representative set per area (typically 3–5 files each): API/routes, services/domain, data, UI, tests. Stop at the feature boundary.

### 3. Choose outputs

| File | Use when |
| --- | --- |
| `docs/architecture.md` | module boundaries, data flow, or where new code belongs |
| `docs/domain.md` | domain terms, synonyms to avoid, or glossary gaps |
| `docs/conventions.md` | project rules linters do not enforce (optional — skip when CI already covers it) |
| `docs/git.md` | branch naming, commit style, closeout push policy, worktree defaults |

Skip any file with nothing new to add.

### 4. Do not document

- spacing, indentation, quote style — formatter domain
- import sort, unused imports, max line length — linter domain when configured
- generic language style guides copied from outside the repo

### 5. Write observed content

Each file:

```markdown
# <Title> (observed)

_Last reviewed: YYYY-MM-DD. On conflict, adjacent code and formatter/linter configs win._
```

For `docs/git.md`, add: _On conflict, `git log` on the current branch wins._

Bullet facts tied to real paths. Link configs under **Tooling** — do not paste their rules.

### 6. Update AGENTS.md

Add or refresh `## Docs` linking files you created or updated. Template: `examples/AGENTS.md`.

## Capture

Use when the user asks to save, remember, or capture a learning (for example: "save this", "remember for next time").

1. Confirm the learning is not already obvious from adjacent code or CI.
2. Choose a short topic slug (`auth-callbacks`, `deploy-order`, and similar).
3. Create or append `docs/notes/<slug>.md`:

```markdown
# <Topic> (captured)

_Captured: YYYY-MM-DD. Promote to architecture/domain/conventions/git when durable._

- <fact tied to paths or behavior>
```

4. Do not auto-promote to durable docs unless the user asks.
5. Ensure `docs/notes/` is linked from `## Docs` when you add the first note.

## Promote

Use when the user asks to promote a note or a note clearly belongs in durable docs.

1. Merge relevant bullets into `docs/architecture.md`, `docs/domain.md`, `docs/conventions.md`, or `docs/git.md`.
2. Remove or shorten the source note.
3. Update `## Docs` links if paths changed.

## Prune

Only when the user asks. Remove notes superseded by code, CI, or promoted content.

## Hand off

Report files created, updated, promoted, or skipped (including "covered by linter/formatter"). Ask whether to commit. Run `$integrity-review` if the user wants validation before claiming done.

# Behavior: project docs curator

## Sweet spot

| Layer | Role |
| --- | --- |
| Formatter / linter / typecheck (CI) | Mechanical style |
| Adjacent modules | Local naming and file shape |
| `docs/` | Learnings **not** encoded in tools |

Do **not** duplicate CI rules. Link configs; do not paste them.

`## Docs` is a **living index**. Create `docs/<topic>.md` when there is content (kebab-case filename). Add a row per file. Names like `git.md` or `architecture.md` are suggestions — any topic slug is fine. A `docs/notes/` subfolder is optional, not required.

## Bootstrap

Use when the user asks to bootstrap, document, or refresh project context.

### 1. Discover

Read when present: `AGENTS.md` / `CLAUDE.md` (`## Agent workflow`, `## Docs`), tooling configs, top-level layout.

If `## Docs` already lists paths, refresh those files. Do not invent a full doc tree.

### 2. Sample

A small set of files per area (typically 3–5). Stop at the feature boundary.

### 3. Choose outputs

Default: `docs/<topic>.md` (kebab-case filename).

| File | When |
| --- | --- |
| `docs/<topic>.md` | first capture or focused topic |
| `docs/git.md` | commit/branch/push policy that repeats |
| `docs/architecture.md` | module boundaries, data flow |
| `docs/domain.md` | glossary that keeps coming up |
| `docs/conventions.md` | rules linters do **not** enforce |

Skip any file with nothing new.

### 4. Do not document

- spacing, quotes, import sort, line length — formatter/linter domain
- generic language guides copied from outside the repo

### 5. Write observed content

```markdown
# <Title> (observed)

_Last reviewed: YYYY-MM-DD. On conflict, adjacent code and tooling configs win._
```

For git docs, add: _On conflict, `git log` on the current branch wins._

Link related docs and configs. Do not paste their rules.

### 6. Update AGENTS.md

Add or refresh `## Docs` with a **row per file that exists**. Remove rows for files you delete. Template: `examples/AGENTS.md`.

## Capture

When the user asks to save or remember something:

1. Skip if it is already obvious from code or CI.
2. Create or append `docs/<topic>.md` (or append to an existing linked doc).
3. Add a `## Docs` row for new files.
4. Link related docs when they exist.
5. Do not auto-merge unless the user asks.

```markdown
# <Topic> (captured)

_Captured: YYYY-MM-DD._

- <fact tied to paths or behavior>
```

## Merge

When the user asks, or a small doc clearly belongs in a larger one:

1. Merge into the target file (create it if needed).
2. Remove or shorten the source file.
3. Update `## Docs` and cross-links.

## Prune

Only when the user asks. Remove docs superseded by code or CI. Drop stale `## Docs` rows.

## Hand off

Report created, updated, merged, skipped. Ask whether to commit. `$integrity-review` if the user wants validation before claiming done.

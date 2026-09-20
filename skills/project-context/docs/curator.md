# Behavior: project docs curator

## Sweet spot

| Layer | Role |
| --- | --- |
| Formatter / linter / typecheck (CI) | Mechanical style |
| Adjacent modules | Local naming and file shape |
| `docs/` | Learnings **not** encoded in tools |

Do **not** duplicate CI rules. Link configs; do not paste them.

`## Docs` is a **living index**. Create `docs/<topic>.md` when there is content (kebab-case slug from the topic). Add a row per file. No fixed schema — name files for what they describe. A `docs/notes/` subfolder is optional, not required.

## Reconcile

At the start of **bootstrap**, **capture**, or **refresh**:

1. Read paths listed in `AGENTS.md` / `CLAUDE.md` → `## Docs`.
2. List `docs/**/*.md` when `docs/` exists.
3. Add a `## Docs` row for each file on disk that is missing from the index.
4. Flag rows whose target file no longer exists; remove only when pruning or after user confirmation.
5. Before creating a new file, check indexed docs for a matching topic — prefer append or cross-link.

Report reconciled rows, missing files, and broken links in the hand off.

## Bootstrap

Use when the user asks to bootstrap, document, or refresh project context.

### 1. Discover

Run **Reconcile**, then read when present: `AGENTS.md` / `CLAUDE.md` (`## Agent workflow`, `## Docs`), tooling configs, top-level layout.

Refresh files already listed in `## Docs`. Do not invent a full doc tree.

### 2. Sample

A small set of files per area (typically 3–5). Stop at the feature boundary.

### 3. Choose outputs

Default: one `docs/<topic>.md` per distinct topic (kebab-case slug). Split when topics diverge; merge when a doc grows together. Skip any file with nothing new.

### 4. Do not document

- spacing, quotes, import sort, line length — formatter/linter domain
- generic language guides copied from outside the repo

### 5. Write observed content

```markdown
# <Title> (observed)

_Last reviewed: YYYY-MM-DD. On conflict, adjacent code and tooling configs win._
```

Link related docs and configs. Do not paste their rules.

### 6. Update AGENTS.md

Add or refresh `## Docs` with a **row per file that exists**. Remove rows for files you delete. Template: `template/AGENTS.md`.

## Capture

When the user asks to save or remember something:

1. Run **Reconcile**.
2. Skip if it is already obvious from code or CI.
3. Create or append `docs/<topic>.md` (or append to an existing indexed doc).
4. Add a `## Docs` row for new files.
5. Link related docs when they exist.
6. Do not auto-merge unless the user asks.

```markdown
# <Topic> (captured)

_Captured: YYYY-MM-DD._

- <fact tied to paths or behavior>
```

## Merge

Only when the user asks (or confirms a merge you proposed):

1. Merge into the target file (create it if needed).
2. Remove or shorten the source file.
3. Update `## Docs` and cross-links.

## Prune

Only when the user asks. Remove docs superseded by code or CI. Drop stale `## Docs` rows.

## Hand off

Report created, updated, merged, skipped, and reconcile findings. Ask whether to commit. Offer `$integrity-review` when docs changed and the user wants validation before claiming done.

---
name: memory
description: >-
  Store and retrieve local memories in ~/.nexus/ (global) and .nexus/ (repo).
  Use when the user asks to remember, save, note, or recall preferences or learnings.
---

# Memory

Store and retrieve local memories as markdown files. Global memories live under `~/.nexus/` (machine-wide). Repo memories live under `.nexus/` in the current app repository. Both are local to the machine and gitignored by default in app repos.

## When to Use

Apply this skill for any of:

- **Write** — explicit user request to remember, save, note, or record something (`remember`, `save`, `note`, `learned`, `gravar`, etc.)
- **Read** — user asks what was saved, or a task clearly benefits from prior local notes
- **Delete** — explicit user request to remove a saved memory

Do not write memories without an explicit user request. Do not delete without an explicit user request.

## Scope Routing

| Scope | Path | Use for |
| --- | --- | --- |
| Global | `~/.nexus/user/` and `~/.nexus/notes/` | Cross-project preferences and personal notes for all repos |
| User | `.nexus/user/` | Personal preferences and habits for this repo (overrides global on the same key) |
| Project | `.nexus/project/` | Codebase learnings, architecture decisions, gotchas, and domain facts |

When unsure:

- Prefer `project/` for facts about the code
- Prefer `user/` for how the user wants work done **in this repo**
- Prefer `global` when the user says always / everywhere / all projects / global, or the content is clearly personal across repos

`NEXUS_HOME` overrides the global root (default `~/.nexus`).

## Layout

```text
~/.nexus/                          # global (machine-wide)
  user/
    preferences.md
  notes/
    communication.md

.nexus/                            # current app repo
  user/
    preferences.md
  project/
    auth.md
```

- One file per topic; prefer short English names (`preferences`, `auth`, `deploy`).
- Follow `architect` naming: single word when possible; at most two words with one separator.
- Global free-form notes go under `~/.nexus/notes/` (not `user/`, except `preferences.md`).
- File format details: `docs/format.md`.

## Preference Precedence

For workflow keys (`default workspace`, `closeout unify`, `closeout push`, `commit superpowers docs`, and related):

1. Session-injected preferences when hooks ran
2. Repo `.nexus/user/preferences.md` overrides `~/.nexus/user/preferences.md` on the same key
3. Keys only in global still apply

Git workflow preferences are injected at session start when hooks run (global and repo). Otherwise `git-assistant` (`workspace-choice.md`, `closeout.md`) and `$using-nexus` read both paths.

## Initialization

**Repo** — before the first write when `.nexus/` does not exist:

1. Create `.nexus/user/` and `.nexus/project/`.
2. If `.nexus/` is not listed in `.gitignore`, ask the user once before adding `.nexus/` to `.gitignore`.

**Global** — before the first write when `~/.nexus/` (or `$NEXUS_HOME`) does not exist:

1. Create `user/` and `notes/` under the global root.
2. Do not put global memory inside the Nexus plugin checkout.

Do not commit `.nexus/` or `~/.nexus/` contents.

## Write Workflow

1. Initialize the target root if needed (global or repo).
2. Classify scope (`global`, `user`, or `project`).
3. Search existing files in that scope for the same topic; update in place when a match exists.
4. Write concise English content; keep one topic per file.
5. Reply with what was saved, the file path, and whether an existing file was updated or a new one was created.

## Read Workflow

1. Check global (`~/.nexus/` or `$NEXUS_HOME`) and repo (`.nexus/`) roots; if neither exists, report that nothing is saved yet.
2. Read relevant files from the scopes that apply:
   - Preferences: global `user/` then repo `user/` (repo wins on conflict)
   - Free-form global notes: `~/.nexus/notes/` on demand (not session-injected)
   - Project learnings: `.nexus/project/` on demand
3. Treat memories as local context — do not override official repo docs or current code without checking.
4. If a memory conflicts with current code or docs, report the conflict instead of assuming the memory is correct.

## Delete Workflow

1. Confirm the target file or section with the user when the request is ambiguous (and which scope: global vs repo).
2. Remove the requested content or file.
3. Reply with what was removed and what remains.

## Guardrails

1. **English:** All memory content in English (per Nexus contract).
2. **No secrets:** Never store passwords, tokens, private keys, or personal data.
3. **No invention:** Do not save facts the user did not provide or confirm.
4. **Local only:** Repo `.nexus/` is gitignored; global `~/.nexus/` stays on the machine. Tell the user if they want team-shared notes (use repo docs instead).
5. **Focused files:** Prefer updating an existing topic file over creating duplicates.
6. **No plugin pollution:** Never write global memories into the Nexus source/plugin checkout.

## Internal Docs

- `docs/format.md` — frontmatter, templates, and examples for memory files.

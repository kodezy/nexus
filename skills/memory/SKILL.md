---
name: memory
description: Store and retrieve local user/project memories in .nexus/. Use when the user asks to remember, save, note, or recall project learnings or personal preferences.
---

# Memory

Store and retrieve local memories in `.nexus/` inside the current app repository. Memories are markdown files, local to the machine, and gitignored by default.

## When to Use

Apply this skill for any of:

- **Write** — explicit user request to remember, save, note, or record something (`remember`, `save`, `note`, `learned`, `gravar`, etc.)
- **Read** — user asks what was saved, or a task clearly benefits from prior local notes
- **Delete** — explicit user request to remove a saved memory

Do not write memories without an explicit user request. Do not delete without an explicit user request.

## Scope Routing

| Scope | Path | Use for |
| --- | --- | --- |
| User | `.nexus/user/` | Personal preferences, workflow defaults, and local habits for this repo |
| Project | `.nexus/project/` | Codebase learnings, architecture decisions, gotchas, and domain facts |

When unsure, prefer `project/` for facts about the code and `user/` for how the user wants work done.

## Layout

```text
.nexus/
  user/
    preferences.md
  project/
    auth.md
```

- One file per topic; prefer short English names (`preferences`, `auth`, `deploy`).
- Follow `architect` naming: single word when possible; at most two words with one separator.
- File format details: `docs/format.md`.

## Initialization

Run before the first write when `.nexus/` does not exist:

1. Create `.nexus/user/` and `.nexus/project/`.
2. If `.nexus/` is not listed in `.gitignore`, ask the user once before adding `.nexus/` to `.gitignore`.

Do not commit `.nexus/` contents.

## Write Workflow

1. Initialize `.nexus/` if needed.
2. Classify scope (`user` or `project`).
3. Search existing files in that scope for the same topic; update in place when a match exists.
4. Write concise English content; keep one topic per file.
5. Reply with what was saved, the file path, and whether an existing file was updated or a new one was created.

## Read Workflow

1. Check whether `.nexus/` exists; if not, report that nothing is saved yet.
2. Read relevant files from `.nexus/user/` and `.nexus/project/`.
3. Treat memories as local context — do not override official repo docs or current code without checking.
4. If a memory conflicts with current code or docs, report the conflict instead of assuming the memory is correct.

Git workflow preferences in `.nexus/user/preferences.md` are injected at session start when hooks run, and otherwise read by `git-assistant` (`workspace-choice.md`, `closeout.md`). Save keys such as `default workspace`, `closeout unify`, and `closeout push` there when the user asks to remember workflow defaults.

## Delete Workflow

1. Confirm the target file or section with the user when the request is ambiguous.
2. Remove the requested content or file.
3. Reply with what was removed and what remains.

## Guardrails

1. **English:** All memory content in English (per Nexus contract).
2. **No secrets:** Never store passwords, tokens, private keys, or personal data.
3. **No invention:** Do not save facts the user did not provide or confirm.
4. **Local only:** `.nexus/` is gitignored; tell the user if they want team-shared notes (use repo docs instead).
5. **Focused files:** Prefer updating an existing topic file over creating duplicates.

## Internal Docs

- `docs/format.md` — frontmatter, templates, and examples for memory files.

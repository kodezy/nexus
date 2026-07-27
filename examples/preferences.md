# Preferences

## Global (all projects)

Copy to `~/.nexus/user/preferences.md` (create the folders if needed). Cross-project defaults for every app repo.

```markdown
---
created: 2026-07-27
updated: 2026-07-27
tags: [tooling]
---

# Preferences

## Git workflow

- **default workspace:** `worktree` — isolate implementation unless the request says otherwise
- **worktree branch prefix:** `feat/`
- **closeout unify:** `ask` — `ask` | `always` | `never` after a worktree commit
- **closeout push:** `ask` — `ask` | `always` | `never`
- **commit superpowers docs:** `exclude` — `include` | `exclude` | `ask`
```

Free-form cross-project notes go in `~/.nexus/notes/` (one topic per file). They are read on demand via `$memory`, not injected at session start.

## Repo override

Copy into an app repo as `.nexus/user/preferences.md` (create the folder if needed). Contents stay local and gitignored. Same keys here override the global file.

```markdown
---
created: 2026-07-24
updated: 2026-07-24
tags: [tooling]
---

# Preferences

## Git workflow

- **default workspace:** `main` — implement on the current checkout unless the request says otherwise
- **worktree branch prefix:** `feat/`
- **closeout unify:** `ask` — `ask` | `always` | `never` after a worktree commit
- **closeout push:** `ask` — `ask` | `always` | `never`; when not `never`, include push in the `add + commit + push` confirmation
- **commit superpowers docs:** `ask` — `include` | `exclude` | `ask` for `docs/superpowers/` and `.superpowers/` at commit time
```

Or ask the agent in any session:

```text
Use $memory to save default workspace: main
Use $memory to save closeout push: ask
Use $memory to save globally: default workspace worktree
```

See `skills/memory/docs/format.md` for the full format, global notes, and project-memory examples.

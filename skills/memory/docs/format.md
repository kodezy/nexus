# Memory File Format

Memory files are plain markdown. Optional YAML frontmatter helps track metadata.

## Frontmatter (optional)

```yaml
---
created: 2026-07-24
updated: 2026-07-24
tags: [auth, api]
---
```

- `created` — date the file was first written (`YYYY-MM-DD`)
- `updated` — date of the latest edit
- `tags` — short topic labels for scanning

## Body

- Start with a single `#` title that names the topic.
- Use short paragraphs and bullet lists.
- State facts directly; avoid narrative filler.
- One topic per file.

## Examples

### User preference

Path: `.nexus/user/preferences.md`

```markdown
---
created: 2026-07-24
updated: 2026-07-24
tags: [tooling]
---

# Preferences

- Use uv for Python dependency and run commands in this repo.
- Prefer concise commit messages without Conventional Commit prefixes.
```

### Project learning

Path: `.nexus/project/auth.md`

```markdown
---
created: 2026-07-24
updated: 2026-07-24
tags: [auth, middleware]
---

# Auth

- Auth middleware runs before route handlers.
- Session tokens are validated in `src/middleware/auth.py`.
- Expired sessions return 401, not 403.
```

## `.nexus/README.md` template

Use this content when initializing:

```markdown
# Local memory

This directory stores local agent memory for this repository.

- `user/` — personal preferences and workflow defaults for this repo
- `project/` — codebase learnings, decisions, and gotchas

Contents are gitignored and stay on this machine. To share notes with the team, use project documentation instead.
```

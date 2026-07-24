# Behavior: workspace-choice

Use before the first file change of any implementation request.

## When to run

- The user asked for a change that will modify the repository (code, docs, config, automation).
- Do **not** run for read-only questions, pure reviews with no edits, or git inspection only.

## Check saved preferences first

Before asking `main` or `worktree`, read local workflow preferences:

1. If `.nexus/user/preferences.md` exists, read it.
2. If missing or incomplete, skim other files under `.nexus/user/` for git-workflow defaults.
3. Look for these keys (bullet labels or `key: value` forms):
   - `default workspace` / `default_workspace`: `main` | `worktree`
   - `worktree branch prefix` (optional, for example `feat/`)
   - `worktree path pattern` (optional, for example `../<repo>-<slug>`)

Preference resolution:

| Situation | Action |
| --- | --- |
| User stated workspace in this message | Honor the request; do not ask |
| User chose workspace earlier in this conversation | Reuse that choice |
| `default workspace` is set in `.nexus/` | Apply it; tell the user briefly (`Using saved preference: main`) |
| No saved preference | Ask once (see below) |

When applying a saved `worktree` preference, still confirm branch name and worktree path unless those defaults are also saved in `.nexus/`.

When the user says to always use `main` or `worktree`, offer to save it:

```text
Use $memory to save default workspace: main
```

Only write to `.nexus/` when the user explicitly asks to remember.

## Skip when

- The user already chose `main` or `worktree` for this task in the same conversation.
- The user explicitly stated the workspace in the request (for example: "on main", "in a worktree").
- A saved `default workspace` preference applies and the user did not override it.
- The task is git-only with no implementation (status, diff, log, message suggestions).

## Ask once

When no applicable preference or override exists, before creating, editing, or deleting files, ask:

1. **main** — work directly in the current checkout (typically `main` or the active branch).
2. **worktree** — isolated git worktree on a dedicated branch.

Wait for an explicit choice. Do not start implementation until the user answers.

## main mode

- Work in the current repository root.
- Record for the session: `workspace: main`, `branch: <current branch>`, `repo_root: <path>`.

## worktree mode

1. Propose a branch name from the task and any saved `worktree branch prefix`. Ask the user to confirm or edit.
2. Propose a worktree path as a sibling of the repo root (for example `../<repo>-<slug>`). Confirm if the path is non-obvious and not covered by a saved pattern.
3. Create only after the user approves branch name and path:

```bash
git worktree add <path> -b <branch>
```

4. Run all subsequent edits and validation for this task from the worktree path.
5. Record for the session: `workspace: worktree`, `worktree_path: <path>`, `branch: <branch>`, `primary_repo: <original root>`.

## Hard rules

- Never create a worktree, switch branches, or start editing without a workspace choice (from preference, request, or explicit answer).
- Never assume `main` when no preference, request, or answer exists.
- Never remove a worktree except during the approved closeout unify step in `closeout.md`.

# Behavior: workspace-choice

Use before the first file change of any implementation request.

## When to run

- The user asked for a change that will modify the repository (code, docs, config, automation).
- Do **not** run for read-only questions, pure reviews with no edits, or git inspection only.

## Check saved preferences first

Before asking `main` or a named worktree, resolve local workflow preferences:

1. Read, when present:
   - `~/.nexus/user/preferences.md` (or `$NEXUS_HOME/user/preferences.md`)
   - `.nexus/user/preferences.md` in the app repo
2. If missing or incomplete, skim other files under those `user/` dirs for git-workflow defaults.
3. Look for these keys (bullet labels or `key: value` forms):
   - `default workspace` / `default_workspace`: `main` | `worktree`
   - `worktree branch prefix` (optional, for example `feat/`)
   - `worktree path pattern` (optional, for example `../<repo>-<slug>`)

Preference resolution:

| Situation | Action |
| --- | --- |
| User stated workspace in this message | Honor the request; do not ask |
| User chose workspace earlier in this conversation | Reuse that choice |
| `default workspace` is set (repo or global; repo wins) | Apply it; tell the user briefly (`Using saved preference: main`) |
| No saved preference | Ask once (see below) |

When applying a saved `worktree` preference, still show the proposed branch name and worktree path and confirm them unless those defaults are also saved in `.nexus/`.

When the user says to always use `main` or `worktree`, offer to save it (global when they mean all projects; repo when they mean this repo only):

```text
Use $memory to save default workspace: main
```

Only write to `~/.nexus/` or `.nexus/` when the user explicitly asks to remember.

## Skip when

- The user already chose `main` or `worktree` for this task in the same conversation.
- The user explicitly stated the workspace in the request (for example: "on main", "in a worktree").
- A saved `default workspace` preference applies and the user did not override it.
- The task is git-only with no implementation (status, diff, log, message suggestions).

## Ask once

When no applicable preference or override exists, before creating, editing, or deleting files:

1. Derive a proposed worktree from the task:
   - branch name (apply saved `worktree branch prefix` when present)
   - path (apply saved `worktree path pattern`, else sibling `../<repo>-<slug>`)
2. Ask with the worktree path visible (branch is derived but not the prompt label):

```text
main, or worktree at <path>?
```

Example: `main, or worktree at ../nexus-closeout-ux?`

Options:

- **main** — work directly in the current checkout (typically `main` or the active branch).
- **worktree at `<path>`** — isolated git worktree on the proposed branch (`<branch>`).

Wait for an explicit choice. Do not start implementation until the user answers. If the user picks the proposed option, that choice approves branch and path. If they counter-propose a name or path, use their values.

## main mode

- Work in the current repository root.
- Record for the session: `workspace: main`, `branch: <current branch>`, `repo_root: <path>`.

## worktree mode

1. Use the branch and path from the Ask once choice (or the saved preference defaults when applying `default workspace: worktree` without an ask).
2. Create only after the user has approved that branch and path (via the Ask once choice, a preference-driven confirmation, or an explicit override):

```bash
git worktree add <path> -b <branch>
```

3. Run all subsequent edits and validation for this task from the worktree path.
4. Record for the session: `workspace: worktree`, `worktree_path: <path>`, `branch: <branch>`, `primary_repo: <original root>`.

## Hard rules

- Never create a worktree, switch branches, or start editing without a workspace choice (from preference, request, or explicit answer).
- Never assume `main` when no preference, request, or answer exists.
- Never remove a worktree except during the approved closeout unify step in `closeout.md`.

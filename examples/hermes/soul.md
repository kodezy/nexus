# Nexus

You are a coding agent under the Nexus production harness in this Hermes profile.

Hermes has no session-start hook here. This file is the bootstrap — follow it every session.

## Bootstrap

Before editing, exploring, or answering implementation questions, load and follow the `using-nexus` skill. Announce `Using $skill to …` and obey the skill. If it turns out wrong, stop using it.

Procedures live in Nexus skills — do not invent workflows for workspace choice, integrity review, git closeout, architecture, or style.

## Loop

1. Preferences — if the app repo has `.nexus/user/preferences.md`, apply it before workspace choice or closeout; otherwise ask when needed.
2. Workspace — `git-assistant` → workspace-choice before the first edit (`main` or a named worktree).
3. Act — smallest production-ready change; `architect` before new files or modules.
4. Style — `code-style` on touched files.
5. Review — `integrity-review` on the affected area.
6. Closeout — on Clean or Corrected: `git-assistant` closeout; on Uncertain: stop.

## Hard gates

- No worktree, commit, merge to `main`, or push without explicit approval for that step.
- No new automated test files unless asked; extend existing tests when needed.
- English for code, commits, and harness docs; UI copy follows the product language only when requested.
- Do not edit Nexus skill files under this profile. Keep `skills.write_approval: true`.

## Memory split

- App-repo Nexus memory: `.nexus/user/` (preferences) and `.nexus/project/` (learnings). Write only when the user explicitly asks to remember. No secrets.
- Hermes `MEMORY.md` / `USER.md`: tone and environment only — not Nexus procedures or closeout policy.

## Slash skills

Prefer Nexus skills for coding work (`/using-nexus`, `/git-assistant`, `/integrity-review`, `/architect`, `/code-style`, and related). Hermes built-in `/memory` is Hermes memory approval — not Nexus `.nexus/` memory.

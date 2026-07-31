---
name: "playwright"
description: "Use when the task requires automating a real browser from the terminal (navigation, form filling, snapshots, screenshots, data extraction, UI-flow debugging) via `playwright-cli`."
---


# Playwright CLI Skill

Drive a real browser from the terminal using `playwright-cli` through `npx`, so the skill works from every supported Codex skill location.
Treat this skill as CLI-first automation. Do not pivot to `@playwright/test` unless the user explicitly asks for test files.

## Prerequisite check (required)

Before proposing commands, check whether `npx` is available (the wrapper depends on it):

```bash
command -v npx >/dev/null 2>&1
```

If it is not available, pause and ask the user to install Node.js/npm (which provides `npx`). Provide these steps verbatim:

```bash
# Verify Node/npm are installed
node --version
npm --version

# If missing, install Node.js/npm, then:
npm install -g @playwright/cli@latest
playwright-cli --help
```

Once `npx` is present, proceed with `pwcli`. A global install of `playwright-cli` is optional.

## Command (set once)

```bash
pwcli() {
  local has_session_flag=false
  local arg
  local command=(npx --yes --package @playwright/cli playwright-cli)

  for arg in "$@"; do
    if [[ "$arg" == "--session" || "$arg" == --session=* ]]; then
      has_session_flag=true
      break
    fi
  done
  if [[ "$has_session_flag" == false && -n "${PLAYWRIGHT_CLI_SESSION:-}" ]]; then
    command+=(--session "$PLAYWRIGHT_CLI_SESSION")
  fi
  command+=("$@")
  "${command[@]}"
}
```

The function does not depend on where Codex installed the skill.

## Quick start

Use the function:

```bash
pwcli open https://playwright.dev --headed
pwcli snapshot
pwcli click e15
pwcli type "Playwright"
pwcli press Enter
pwcli screenshot
```

If the user prefers a global install, this is also valid:

```bash
npm install -g @playwright/cli@latest
playwright-cli --help
```

## Core workflow

1. Open the page.
2. Snapshot to get stable element refs.
3. Interact using refs from the latest snapshot.
4. Re-snapshot after navigation or significant DOM changes.
5. Capture artifacts (screenshot, pdf, traces) when useful.

Minimal loop:

```bash
pwcli open https://example.com
pwcli snapshot
pwcli click e3
pwcli snapshot
```

## When to snapshot again

Snapshot again after:

- navigation
- clicking elements that change the UI substantially
- opening/closing modals or menus
- tab switches

Refs can go stale. When a command fails due to a missing ref, snapshot again.

## Recommended patterns

### Form fill and submit

```bash
pwcli open https://example.com/form
pwcli snapshot
pwcli fill e1 "user@example.com"
pwcli fill e2 "password123"
pwcli click e3
pwcli snapshot
```

### Debug a UI flow with traces

```bash
pwcli open https://example.com --headed
pwcli tracing-start
# ...interactions...
pwcli tracing-stop
```

### Multi-tab work

```bash
pwcli tab-new https://example.com
pwcli tab-list
pwcli tab-select 0
pwcli snapshot
```

## References

Open only what you need:

- CLI command reference: `references/cli.md`
- Practical workflows and troubleshooting: `references/workflows.md`

## Guardrails

- Always snapshot before referencing element ids like `e12`.
- Re-snapshot when refs seem stale.
- Prefer explicit commands over `eval` and `run-code` unless needed.
- When you do not have a fresh snapshot, use placeholder refs like `eX` and say why; do not bypass refs with `run-code`.
- Use `--headed` when a visual check will help.
- When capturing artifacts in this repo, use `output/playwright/` and avoid introducing new top-level artifact folders.
- Default to CLI commands and workflows, not Playwright test specs.

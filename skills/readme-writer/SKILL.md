---
name: readme-writer
description: Write and refactor short, scannable README files. Use when creating or updating README.md or other project Markdown docs (Install, Run, Use, Config, Structure, Packages, Docs, API). Never leave placeholders — ask for real values or omit.
---

# README Writer

## Objective

Write READMEs that are short, direct, and easy to scan. One job per section. Omit empty sections.

## No Placeholders

Never ship a README with fields for the user to fill in later.

Before writing or updating the file, gather concrete values for anything you cannot verify from the repo or existing docs. Ask the user when information is missing — do not guess and do not leave blanks.

Forbidden in output:

- Placeholder URLs or text: `https://github.com/your-org/your-repo`, `[link]`, `TODO`, `TBD`, `coming soon`, `insert … here`
- Angle-bracket or bracket stand-ins: `<Project Name>`, `[your-username]`, `example.com`
- Instructional filler: “Add your GitHub link”, “Replace with …”, “Fill in …”
- Empty link targets, stub sections, or badge blocks waiting for real values

When a value is unknown:

1. Ask for the exact text or URL you need.
2. If the user does not provide it, omit that link, badge, or section — do not add a stub.
3. Write only what is confirmed; finish the README after answers arrive.

## Choose A Variant

Detect the project type, then use that skeleton. Default to **App / CLI** when unclear.

When editing an existing README, keep its working structure unless the user asks to restructure or the file has no clear install → run path.

### App / CLI (default)

Required path:

```md
# Name
One factual sentence.

## Install
## Run
## Docs
```

Add only when needed:

- `## API` — HTTP service; link to `docs/API.md` (use `$api-docs-writer`)
- `## Config` — project has configuration
- `## Structure` — short tree (~5–8 lines) that helps onboarding

Rules:

- Description under the title (no `## About`).
- `## Run` = how to start or execute.
- `## Docs` = links only.

### Lib

```md
# Name
One factual sentence.

## Install
## Use
## API
## Docs
```

- Use when the reader’s goal is import or call a library API.
- HTTP surface: link `## API` to `docs/API.md` (`$api-docs-writer`); keep import/usage notes here for the library API.

### Monorepo

```md
# Name
One factual sentence.

## Install
## Run
## Packages
## Docs
```

- Use when the root README must point at multiple packages.
- `## Packages` = short list or tree; details stay in each package README or `docs/README.md`.
- `## Docs` = link every package-level doc index (API, UI, operations).
- Follow [docs/monorepo.md](docs/monorepo.md) for env attribution, ports, terminology, UI names, and cross-links.

## Style

- One idea per sentence. Prefer bullets over paragraphs.
- Max one short prose sentence per section when text is needed.
- Commands in fenced blocks with a language tag (`bash`, `json`, …); complete commands, not fragments.
- One-word section headers: `Install`, `Run`, `Config`, `Use`, `Structure`, `Packages`, `Docs`, `API`.
- No Features, Contributing, or License in the short README — link them from `## Docs` when needed.
- No marketing language. No secrets in examples.
- English unless the project already uses another language.

## Commands

- Numbered steps; one action per step.
- Document the repo’s real tool (e.g. **uv**, npm, cargo). Do not invent a second package manager.
- Show the minimal happy path first (`Install` → `Run` or `Use`).
- Mark **required** vs **optional** when it matters.

## Links

- Verify every link before adding or keeping it.
- Never leave dead, placeholder, or `TODO` links.
- If a link cannot be verified, ask the user for the real URL — then add it or omit the link. Never write a stand-in.
- Common asks before first draft: repository URL, docs site, demo/deploy URL, issue tracker, license file path, and any external badges the user wants.

## Avoid

- Long narrative blocks
- Sections filled only to match a template
- Duplicating content across sections
- Mixing install methods without clear separation
- Vague words (“soon”, “sometimes”)
- Renaming a healthy README wholesale without being asked
- Placeholder or “fill in later” content of any kind

## Checklist

- Commands and versions match the repo
- Empty sections removed
- Every retained link resolves
- Variant matches the project type
- No placeholders, stubs, or “replace me” text — missing facts were asked or omitted
- Monorepo: [docs/monorepo.md](docs/monorepo.md) checklist satisfied when multiple packages are documented

#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

cd "${repo_root}"

python3 - <<'PYTHON'
import json
import os
import re
import shlex
import subprocess
import sys
import tempfile
from pathlib import Path


ROOT = Path.cwd()
RELEASE = ROOT / "release.json"
MANIFESTS = {
    ".codex-plugin/plugin.json": ("name", "version", "homepage", "repository"),
    ".claude-plugin/plugin.json": ("name", "version"),
    ".cursor-plugin/plugin.json": ("name", "version"),
}
MARKETPLACE = ROOT / ".agents/plugins/marketplace.json"
MARKDOWN_LINK = re.compile(r"!?(?:\[[^]]*]\(([^)]+)\))")
ALLOWED_SKILLS = {"integrity-review", "project-context"}
REMOVED_SKILLS = {
    "using-nexus",
    "memory",
    "architect",
    "frontend",
    "code-style",
    "code-cleanup",
    "log-writer",
    "readme-writer",
    "api-docs-writer",
    "spec-driven",
    "git-assistant",
    "structure",
    "conventions",
}


def fail(message: str) -> None:
    print(f"error: {message}", file=sys.stderr)
    raise SystemExit(1)


def is_external(target: str) -> bool:
    return target.startswith(("#", "http://", "https://", "mailto:"))


def verify_skill_surface() -> None:
    present = {path.name for path in (ROOT / "skills").iterdir() if path.is_dir()}
    if present != ALLOWED_SKILLS:
        fail(f"skills/ must contain exactly {sorted(ALLOWED_SKILLS)}; found {sorted(present)}")
    for removed in REMOVED_SKILLS:
        if (ROOT / "skills" / removed).exists():
            fail(f"removed skill still present: skills/{removed}")


def verify_session_hook() -> None:
    with tempfile.TemporaryDirectory() as temporary_directory:
        temporary_root = Path(temporary_directory)
        project_dir = temporary_root / "project"
        project_dir.mkdir(parents=True)
        (project_dir / "AGENTS.md").write_text("# App\n\n## Agent workflow\n\n- **Workspace:** main\n")

        environment = os.environ | {
            "CURSOR_PLUGIN_ROOT": str(ROOT),
            "CURSOR_PROJECT_DIR": str(project_dir),
        }
        result = subprocess.run(
            ["bash", str(ROOT / "hooks" / "session-start")],
            capture_output=True,
            check=False,
            env=environment,
            text=True,
        )
        if result.returncode != 0:
            fail(f"session-start hook failed: {result.stderr.strip()}")

        try:
            output = json.loads(result.stdout)
        except json.JSONDecodeError as error:
            fail(f"session-start hook returned invalid JSON: {error}")

        context = output.get("additional_context")
        if not isinstance(context, str):
            fail("session-start hook must return Cursor additional_context")
        if "$integrity-review" not in context:
            fail("session-start hook must reference $integrity-review")
        if "$project-context" not in context:
            fail("session-start hook must reference $project-context")
        if "## Docs" not in context and "docs/" not in context:
            fail("session-start hook must reference project docs/")
        for removed in ("$using-nexus", "$git-assistant", "$structure", "$conventions"):
            if removed in context:
                fail(f"session-start hook must not reference removed {removed}")
        if "git gates" in context.lower():
            fail("session-start hook must not promote git gates as always-on policy")
        if len(context.encode()) > 1_200:
            fail("session-start hook context must stay within the 1200-byte budget")


def verify_context_docs() -> None:
    stale_phrases = {
        "README.md": (
            "using-nexus",
            "examples/preferences.md",
            "~/.nexus",
            "NEXUS_HOME",
            "Optional domain skills",
            "git gates",
            "$git-assistant",
            "$structure",
            "$conventions",
            "/closeout",
            "Git has no Nexus skill",
            "docs/git.md",
        ),
        "rules/nexus-contract.mdc": (
            "$using-nexus",
            "$memory",
            "$git-assistant",
            "$structure",
            "$conventions",
            "~/.nexus",
            "NEXUS_HOME",
            "## Hard gates",
            "## Git",
            "docs/git.md",
        ),
        "docs/workflow.md": (
            "$using-nexus",
            "$spec-driven",
            "$architect",
            "$git-assistant",
            "$structure",
            "$conventions",
            "/closeout",
            "/workspace",
            "~/.nexus",
            "NEXUS_HOME",
            "**Git**",
            "docs/git.md",
        ),
        "skills/integrity-review/SKILL.md": (
            "$code-cleanup",
            "$architect",
            "$readme-writer",
            "$git-assistant",
            "$structure",
            "$conventions",
            "docs/git.md",
        ),
        "template/AGENTS.md": (
            "~/.nexus",
            "NEXUS_HOME",
            "$git-assistant",
            "$structure",
            "$conventions",
            "app-agents",
            "examples/docs/",
        ),
        "AGENTS.md": ("$git-assistant", "$structure", "$conventions", "/closeout", "/workspace"),
        "CLAUDE.md": ("$git-assistant", "$structure", "$conventions", "/closeout", "/workspace"),
    }
    for relative_path, phrases in stale_phrases.items():
        content = (ROOT / relative_path).read_text()
        for phrase in phrases:
            if phrase in content:
                fail(f"{relative_path} contains stale policy wording: {phrase}")

    integrity_review = (ROOT / "skills/integrity-review/SKILL.md").read_text()
    for phrase in ("## Validation receipt", "**Validated:**", "**Blocked:**", "Independent verification"):
        if phrase not in integrity_review:
            fail(f"skills/integrity-review/SKILL.md is missing validation policy: {phrase}")
    if "## Docs" not in integrity_review and "docs/" not in integrity_review:
        fail("skills/integrity-review/SKILL.md must reference docs/ linked from AGENTS.md")

    if (ROOT / "examples").exists():
        fail("examples/ was renamed to template/ — remove the legacy directory")

    app_template = (ROOT / "template/AGENTS.md").read_text()
    for phrase in (
        "## Agent ritual",
        "## Docs",
        "$integrity-review",
        "$project-context",
        "Add a row",
        "docs/<topic>",
    ):
        if phrase not in app_template:
            fail(f"template/AGENTS.md is missing template content: {phrase}")
    fixed_doc_paths = (
        "docs/architecture.md",
        "docs/domain.md",
        "docs/conventions.md",
        "docs/git.md",
        "docs/notes/",
    )
    for fixed_path in fixed_doc_paths:
        if fixed_path in app_template:
            fail(f"template/AGENTS.md must not require fixed doc paths: {fixed_path}")

    project_context = (ROOT / "skills/project-context/SKILL.md").read_text()
    curator = (ROOT / "skills/project-context/docs/curator.md").read_text()
    for phrase in ("On demand only", "docs/curator.md", "docs/<topic>"):
        if phrase not in project_context:
            fail(f"skills/project-context/SKILL.md is missing curator policy: {phrase}")
    for phrase in ("## Sweet spot", "## Reconcile", "## Capture", "living index", "docs/<topic>", "## Merge", "No fixed schema"):
        if phrase not in curator:
            fail(f"skills/project-context/docs/curator.md is missing curator workflow: {phrase}")
    for preset in ("docs/architecture.md", "docs/domain.md", "docs/conventions.md", "docs/git.md"):
        if preset in curator:
            fail(f"skills/project-context/docs/curator.md must not prescribe fixed doc paths: {preset}")

    if (ROOT / "commands").exists() and any((ROOT / "commands").iterdir()):
        fail("commands/ must be empty or removed — use app docs/ for workflow topics when needed")


try:
    release = json.loads(RELEASE.read_text())
except FileNotFoundError:
    fail("release.json is missing")
except json.JSONDecodeError as error:
    fail(f"release.json is invalid JSON: {error}")

for field in ("name", "version", "homepage", "repository"):
    if not isinstance(release.get(field), str) or not release[field]:
        fail(f"release.json requires a non-empty {field!r} field")

for manifest_name, fields in MANIFESTS.items():
    manifest_path = ROOT / manifest_name
    try:
        manifest = json.loads(manifest_path.read_text())
    except json.JSONDecodeError as error:
        fail(f"{manifest_name} is invalid JSON: {error}")

    for field in fields:
        if manifest.get(field) != release[field]:
            fail(
                f"{manifest_name} {field!r} must match release.json "
                f"({release[field]!r})"
            )

for skill_path in sorted((ROOT / "skills").iterdir()):
    if not skill_path.is_dir():
        continue
    if not (skill_path / "SKILL.md").is_file():
        fail(f"skill {skill_path.name!r} is missing SKILL.md")
    agents_path = skill_path / "agents"
    if agents_path.exists() and not (agents_path / "openai.yaml").is_file():
        fail(f"skill {skill_path.name!r} has agents/ but no agents/openai.yaml")

cursor_manifest = json.loads((ROOT / ".cursor-plugin/plugin.json").read_text())
for field in ("logo", "skills", "rules", "hooks"):
    target = cursor_manifest.get(field)
    if isinstance(target, str) and not (ROOT / target).exists():
        fail(f".cursor-plugin/plugin.json references missing {field}: {target}")
if "commands" in cursor_manifest:
    fail(".cursor-plugin/plugin.json must not reference commands/")

codex_manifest = json.loads((ROOT / ".codex-plugin/plugin.json").read_text())
for field, target in {
    "skills": codex_manifest.get("skills"),
    "interface.logo": codex_manifest.get("interface", {}).get("logo"),
}.items():
    if isinstance(target, str) and not (ROOT / target).exists():
        fail(f".codex-plugin/plugin.json references missing {field}: {target}")

if codex_manifest.get("hooks") != "./hooks/hooks.json":
    fail(".codex-plugin/plugin.json must reference ./hooks/hooks.json")

hook_config = json.loads((ROOT / "hooks/hooks.json").read_text())
session_hooks = hook_config.get("hooks", {}).get("SessionStart", [])
if not any(
    any(hook.get("type") == "command" for hook in entry.get("hooks", []))
    for entry in session_hooks
):
    fail("hooks/hooks.json requires a command SessionStart hook")
if any("compact" in entry.get("matcher", "").split("|") for entry in session_hooks):
    fail("hooks/hooks.json must not match compact events")

try:
    marketplace = json.loads(MARKETPLACE.read_text())
except FileNotFoundError:
    fail(".agents/plugins/marketplace.json is missing")
except json.JSONDecodeError as error:
    fail(f".agents/plugins/marketplace.json is invalid JSON: {error}")

entries = marketplace.get("plugins", [])
nexus_entry = next((entry for entry in entries if entry.get("name") == release["name"]), None)
if not nexus_entry:
    fail("marketplace is missing the Nexus plugin entry")
source = nexus_entry.get("source", {})
source_path = source.get("path")
if source.get("source") != "local" or not isinstance(source_path, str):
    fail("marketplace Nexus entry must use a local source path")
if not source_path.startswith("./"):
    fail("marketplace Nexus source path must be relative to the marketplace root")
if not (ROOT / source_path / ".codex-plugin/plugin.json").is_file():
    fail("marketplace Nexus source path must contain .codex-plugin/plugin.json")
policy = nexus_entry.get("policy", {})
if policy.get("installation") != "AVAILABLE" or policy.get("authentication") != "ON_INSTALL":
    fail("marketplace Nexus entry has an invalid installation policy")

cursor_hooks = json.loads((ROOT / "hooks/hooks-cursor.json").read_text())
for entry in cursor_hooks.get("hooks", {}).get("sessionStart", []):
    command = entry.get("command", "")
    command_path = shlex.split(command)[0] if command else ""
    if command_path.startswith("./") and not (ROOT / command_path[2:]).is_file():
        fail(f"hooks/hooks-cursor.json references missing command: {command}")

claude_hooks = json.loads((ROOT / "hooks/hooks.json").read_text())
for entry in claude_hooks.get("hooks", {}).get("SessionStart", []):
    for hook in entry.get("hooks", []):
        command = hook.get("command", "")
        if "hooks/run-hook.cmd" in command and not (ROOT / "hooks/run-hook.cmd").is_file():
            fail("hooks/hooks.json references missing hooks/run-hook.cmd")

for markdown_path in ROOT.rglob("*.md"):
    if ".git" in markdown_path.parts:
        continue
    content = markdown_path.read_text()
    for raw_target in MARKDOWN_LINK.findall(content):
        target = raw_target.strip().split(maxsplit=1)[0].strip("<>")
        if not target or is_external(target):
            continue
        relative_target = target.split("#", maxsplit=1)[0]
        if relative_target and not (markdown_path.parent / relative_target).exists():
            fail(f"{markdown_path.relative_to(ROOT)} links to missing path: {target}")

verify_skill_surface()
verify_session_hook()
verify_context_docs()

print("Nexus release artifacts verified.")
PYTHON

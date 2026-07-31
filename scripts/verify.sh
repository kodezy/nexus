#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

cd "${repo_root}"

python3 - <<'PYTHON'
import json
import re
import shlex
import sys
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


def fail(message: str) -> None:
    print(f"error: {message}", file=sys.stderr)
    raise SystemExit(1)


def is_external(target: str) -> bool:
    return target.startswith(("#", "http://", "https://", "mailto:"))


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
for field in ("logo", "skills", "rules", "commands", "hooks"):
    target = cursor_manifest.get(field)
    if isinstance(target, str) and not (ROOT / target).exists():
        fail(f".cursor-plugin/plugin.json references missing {field}: {target}")

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

print("Nexus release artifacts verified.")
PYTHON

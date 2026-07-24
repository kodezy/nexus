#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
codex_home="${CODEX_HOME:-${HOME}/.codex}"
claude_skills="${HOME}/.claude/skills"
skills_src="${repo_root}/skills"

usage() {
  cat <<'EOF'
Install Nexus so local harnesses track this checkout live (symlinks).

Usage:
  ./scripts/install.sh           # install all detected targets
  ./scripts/install.sh cursor    # ~/.cursor/plugins/local/nexus → this repo
  ./scripts/install.sh codex     # ~/.codex/skills/<skill> → this repo skills
  ./scripts/install.sh claude    # ~/.claude/skills/<skill> → this repo skills
  ./scripts/install.sh --help

Edits in this repo are picked up without re-running install.
Reload / new session may still be needed for hooks or skill discovery.
EOF
}

link_skill_tree() {
  local dest_root="$1"
  local label="$2"
  local skill_dir name dest

  mkdir -p "${dest_root}"

  if [[ ! -d "${skills_src}" ]]; then
    echo "error: skills source not found: ${skills_src}" >&2
    return 1
  fi

  for skill_dir in "${skills_src}"/*/; do
    [[ -d "${skill_dir}" ]] || continue
    [[ -f "${skill_dir}SKILL.md" ]] || continue
    name="$(basename "${skill_dir}")"
    dest="${dest_root}/${name}"

    if [[ -L "${dest}" ]]; then
      rm "${dest}"
    elif [[ -d "${dest}" && -f "${dest}/SKILL.md" ]]; then
      # Prior copy install (rsync) — replace with live symlink
      rm -rf "${dest}"
    elif [[ -e "${dest}" ]]; then
      echo "error: ${dest} exists and is not a Nexus skill copy/symlink; remove or rename it first" >&2
      return 1
    fi

    ln -sfn "${skill_dir%/}" "${dest}"
    echo "  ${label}: ${dest} -> ${skill_dir%/}"
  done
}

install_cursor() {
  local dest="${HOME}/.cursor/plugins/local/nexus"
  mkdir -p "$(dirname "${dest}")"
  if [[ -L "${dest}" ]]; then
    rm "${dest}"
  elif [[ -e "${dest}" ]]; then
    echo "error: ${dest} exists and is not a symlink; remove it manually first" >&2
    return 1
  fi
  ln -sfn "${repo_root}" "${dest}"
  chmod +x "${repo_root}/hooks/session-start" 2>/dev/null || true
  echo "Cursor: ${dest} -> ${repo_root}"
  echo "  Live. Reload Window after hook/manifest changes."
}

install_codex() {
  echo "Codex skills (symlink, live):"
  link_skill_tree "${codex_home}/skills" "Codex"
  echo "  New session after adding/removing skill folders."
}

install_claude() {
  echo "Claude Code skills (symlink, live):"
  link_skill_tree "${claude_skills}" "Claude"
  cat <<EOF

  Optional plugin install (hooks + bootstrap using-nexus):
    /plugin marketplace add ${repo_root}
    /plugin install nexus@nexus

  Skills above already track this checkout without that step.
  New session after hook/manifest changes if using the plugin.
EOF
}

target="${1:-all}"

case "${target}" in
  -h|--help|help) usage; exit 0 ;;
  cursor) install_cursor ;;
  codex) install_codex ;;
  claude) install_claude ;;
  all)
    if [[ -d "${HOME}/.cursor" ]] || command -v cursor >/dev/null 2>&1; then
      install_cursor
    else
      echo "Cursor: skipped (not detected)"
    fi
    if [[ -d "${codex_home}" ]] || command -v codex >/dev/null 2>&1; then
      install_codex
    else
      echo "Codex: skipped (not detected)"
    fi
    if [[ -d "${HOME}/.claude" ]] || command -v claude >/dev/null 2>&1; then
      install_claude
    else
      echo "Claude: skipped (not detected)"
    fi
    ;;
  *)
    echo "error: unknown target: ${target}" >&2
    usage >&2
    exit 1
    ;;
esac

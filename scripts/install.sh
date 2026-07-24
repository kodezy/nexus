#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
codex_home="${CODEX_HOME:-${HOME}/.codex}"

usage() {
  cat <<'EOF'
Install Nexus for local harnesses.

Usage:
  ./scripts/install.sh           # install all detected targets
  ./scripts/install.sh cursor    # Cursor local plugin symlink
  ./scripts/install.sh codex     # sync skills/ → ~/.codex/skills
  ./scripts/install.sh claude    # print Claude Code install steps
  ./scripts/install.sh --help
EOF
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
  echo "Cursor: linked ${repo_root} -> ${dest}"
  echo "  Reload Cursor (Developer: Reload Window)."
}

install_codex() {
  local dest="${codex_home}/skills"
  mkdir -p "${dest}"
  if command -v rsync >/dev/null 2>&1; then
    rsync -a --delete "${repo_root}/skills/" "${dest}/"
  else
    rm -rf "${dest:?}"/*
    cp -R "${repo_root}/skills/." "${dest}/"
  fi
  echo "Codex: synced skills -> ${dest}"
  echo "  Restart Codex / open a new session so skills reload."
}

print_claude() {
  cat <<EOF
Claude Code: install this checkout as a local plugin, then reload.

  # From Claude Code, add a local marketplace or install from path, e.g.:
  /plugin marketplace add ${repo_root}
  /plugin install nexus@nexus

  Or follow current Claude Code docs for local plugin install from:
  ${repo_root}

Manifest: ${repo_root}/.claude-plugin/plugin.json
Session bootstrap: hooks/hooks.json → session-start (injects using-nexus)
EOF
}

target="${1:-all}"

case "${target}" in
  -h|--help|help) usage; exit 0 ;;
  cursor) install_cursor ;;
  codex) install_codex ;;
  claude) print_claude ;;
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
    echo
    print_claude
    ;;
  *)
    echo "error: unknown target: ${target}" >&2
    usage >&2
    exit 1
    ;;
esac

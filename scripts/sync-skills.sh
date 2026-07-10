#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
src="${repo_root}/skills"

has_cursor=false
has_codex=false
codex_home="${CODEX_HOME:-${HOME}/.codex}"

detect_cursor() {
  [[ -d "${HOME}/.cursor" ]] || command -v cursor >/dev/null 2>&1
}

detect_codex() {
  [[ -d "${codex_home}" ]] || command -v codex >/dev/null 2>&1
}

sync_to() {
  local dest="$1"
  mkdir -p "${dest}"

  if command -v rsync >/dev/null 2>&1; then
    rsync -a --delete "${src}/" "${dest}/"
  else
    rm -rf "${dest:?}"/*
    cp -R "${src}/." "${dest}/"
  fi

  echo "Synced ${src} -> ${dest}"
}

if [[ ! -d "${src}" ]]; then
  echo "error: skills source not found: ${src}" >&2
  exit 1
fi

echo "Skills source: ${src}"
echo

if detect_cursor; then
  has_cursor=true
  echo "Found Cursor -> ${HOME}/.cursor/skills"
  echo "Found Cursor -> ${repo_root}/.cursor/skills"
fi

if detect_codex; then
  has_codex=true
  echo "Found Codex  -> ${codex_home}/skills"
fi

if ! "${has_cursor}" && ! "${has_codex}"; then
  echo
  echo "No Cursor or Codex installation detected." >&2
  echo "Expected ~/.cursor or ~/.codex, or cursor/codex on PATH." >&2
  exit 1
fi

echo

if "${has_cursor}"; then
  sync_to "${HOME}/.cursor/skills"
  sync_to "${repo_root}/.cursor/skills"
fi

if "${has_codex}"; then
  sync_to "${codex_home}/skills"
fi

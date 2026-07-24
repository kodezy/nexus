#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
src="${repo_root}/skills"
codex_home="${CODEX_HOME:-${HOME}/.codex}"

destinations=()

add_destination() {
  local label="$1"
  local path="$2"
  destinations+=("${label}|${path}")
}

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

confirm_sync() {
  local reply
  read -r -p "Apply sync to the destinations above? [y/N] " reply
  case "${reply}" in
    y|Y|yes|Yes|YES) return 0 ;;
    *) return 1 ;;
  esac
}

if [[ ! -d "${src}" ]]; then
  echo "error: skills source not found: ${src}" >&2
  exit 1
fi

echo "Skills source: ${src}"
echo

if detect_cursor; then
  add_destination "Cursor (user)" "${HOME}/.cursor/skills"
  add_destination "Cursor (repo)" "${repo_root}/.cursor/skills"
fi

if detect_codex; then
  add_destination "Codex" "${codex_home}/skills"
fi

if [[ "${#destinations[@]}" -eq 0 ]]; then
  echo "No skill destinations detected." >&2
  echo "Expected at least one of:" >&2
  echo "  - ~/.cursor or cursor on PATH" >&2
  echo "  - ~/.codex or codex on PATH (or set CODEX_HOME)" >&2
  exit 1
fi

echo "Detected destinations:"
for entry in "${destinations[@]}"; do
  label="${entry%%|*}"
  path="${entry#*|}"
  echo "  - ${label}: ${path}"
done
echo

if ! confirm_sync; then
  echo "Sync cancelled. No changes made."
  exit 0
fi

echo
for entry in "${destinations[@]}"; do
  path="${entry#*|}"
  sync_to "${path}"
done

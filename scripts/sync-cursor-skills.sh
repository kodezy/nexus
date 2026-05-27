#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
src="${repo_root}/skills"
dest="${HOME}/.cursor/skills"

if [[ ! -d "${src}" ]]; then
  echo "error: skills source not found: ${src}" >&2
  exit 1
fi

mkdir -p "${dest}"

if command -v rsync >/dev/null 2>&1; then
  rsync -a --delete "${src}/" "${dest}/"
else
  rm -rf "${dest:?}"/*
  cp -R "${src}/." "${dest}/"
fi

echo "Synced ${src} -> ${dest}"

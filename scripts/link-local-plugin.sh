#!/usr/bin/env bash
set -euo pipefail

# Backward-compatible Cursor-only entry point.
exec "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/install.sh" cursor

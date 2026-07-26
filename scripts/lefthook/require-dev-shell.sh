#!/usr/bin/env bash
set -euo pipefail

for cmd in "$@"; do
  if ! command -v "$cmd" >/dev/null 2>&1; then
    echo "error: '$cmd' not found -- run 'nix develop' first" >&2
    exit 1
  fi
done

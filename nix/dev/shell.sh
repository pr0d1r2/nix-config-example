# shellcheck shell=bash
# This file is sourced by nix mkShell.shellHook (bash context).
echo
echo "nix-config-example - Cross-platform dev environment"
echo

# The CI action can intentionally enter the dev shell without inheriting HOME.
# Git-based checks still require it, so provide an isolated writable fallback.
if [ -z "${HOME+x}" ]; then
  export HOME="${TMPDIR:-/tmp}/nix-config-example-home"
  mkdir -p "$HOME"
fi

# Install git hooks that source the direnv-cached dev shell so
# lefthook + tools are on PATH even outside `nix develop`.
if [ -f ./scripts/lefthook/install-hooks.sh ]; then
  bash ./scripts/lefthook/install-hooks.sh
fi

# shellcheck shell=bash
# This file is sourced by nix mkShell.shellHook (bash context).
echo
echo "nix-config-example - Cross-platform dev environment"
echo

# Install git hooks that source the direnv-cached dev shell so
# lefthook + tools are on PATH even outside `nix develop`.
if [ -f ./scripts/lefthook/install-hooks.sh ]; then
  bash ./scripts/lefthook/install-hooks.sh
fi

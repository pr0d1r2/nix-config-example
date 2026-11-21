#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

git_dir=$(git -C "$REPO_ROOT" rev-parse --git-dir 2>/dev/null) || exit 0
case "$git_dir" in
  /*) ;;
  *) git_dir="$REPO_ROOT/$git_dir" ;;
esac
hooks_dir="$git_dir/hooks"
mkdir -p "$hooks_dir"

for hook in pre-commit pre-push; do
  cat >"$hooks_dir/$hook" <<HOOK
#!/usr/bin/env bash
# Installed by scripts/lefthook/install-hooks.sh.
# Sources the direnv-cached dev shell so lefthook + tools are on PATH
# even when the operator commits from outside \`nix develop\`.
[ "\$LEFTHOOK" = "0" ] && exit 0
if ! command -v lefthook >/dev/null 2>&1; then
    if command -v direnv >/dev/null 2>&1; then
        eval "\$(direnv export bash 2>/dev/null)" || true
    fi
fi
if command -v lefthook >/dev/null 2>&1; then
    exec lefthook run "$hook" "\$@"
fi
echo "lefthook not found - enter the dev shell or install direnv"
exit 0
HOOK
  chmod +x "$hooks_dir/$hook"
done

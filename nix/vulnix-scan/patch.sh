# shellcheck shell=bash
# shellcheck disable=SC2016,SC2154
# This file is embedded in a Nix derivation build command.
substituteInPlace "$out/bin/lefthook-vulnix-scan" \
  --replace-fail \
  'cp "$VULNIX_CACHE_SOURCE/Data.fs" "$cache_dir/Data.fs"' \
  'cp --no-preserve=mode "$VULNIX_CACHE_SOURCE/Data.fs" "$cache_dir/Data.fs"'

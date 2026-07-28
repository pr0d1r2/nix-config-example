#!/usr/bin/env bats

setup() {
  bats_load_library bats-support
  bats_load_library bats-assert
  REPO_ROOT="$(cd "$BATS_TEST_DIRNAME/../../../.." && pwd)"
  PATCH_SCRIPT="$REPO_ROOT/nix/vulnix-scan/patch.sh"
}

@test "vulnix cache copy receives writable permissions" {
  run grep -F 'cp --no-preserve=mode' "$PATCH_SCRIPT"
  assert_success
}

@test "materialized vulnix scanner uses the pre-built cache offline" {
  SCANNER="$(command -v lefthook-vulnix-scan || true)"
  [ -n "$SCANNER" ] || skip "lefthook-vulnix-scan not available"

  run grep -F "scan_args+=(-c \"\$cache_dir\")" "$SCANNER"
  assert_success
  run grep -F 'export VULNIX_OFFLINE=1' "$SCANNER"
  assert_success
  run grep -F 'pr0d1r2.github.io' "$SCANNER"
  assert_failure
}

@test "materialized vulnix scanner embeds a populated cache" {
  SCANNER="$(command -v lefthook-vulnix-scan || true)"
  [ -n "$SCANNER" ] || skip "lefthook-vulnix-scan not available"

  CACHE_SOURCE="$(sed -n 's/^VULNIX_CACHE_SOURCE=//p' "$SCANNER")"
  [ -n "$CACHE_SOURCE" ]
  [ -s "$CACHE_SOURCE/Data.fs" ]
}

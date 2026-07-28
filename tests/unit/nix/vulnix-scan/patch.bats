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

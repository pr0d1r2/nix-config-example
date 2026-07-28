#!/usr/bin/env bats

setup() {
  bats_load_library bats-support
  bats_load_library bats-assert
  REPO_ROOT="$(cd "$BATS_TEST_DIRNAME/../../../.." && pwd)"
  BUILD_SCRIPT="$REPO_ROOT/nix/vulnix-nvd-mirror/build.sh"
}

@test "build phase declares its shell context" {
  run head -1 "$BUILD_SCRIPT"
  assert_output "# shellcheck shell=bash"
}

@test "build phase populates and verifies the NVD cache" {
  run grep -F "python3 \"\$POPULATE\"" "$BUILD_SCRIPT"
  assert_success
  run grep -F "test -s \"\$TMPDIR/cache/Data.fs\"" "$BUILD_SCRIPT"
  assert_success
}

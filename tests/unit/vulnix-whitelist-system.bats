#!/usr/bin/env bats

# The repository's system whitelist must pass the scoped-entry check.

setup() {
  bats_load_library bats-support
  bats_load_library bats-assert
  REPO_ROOT="$(cd "$BATS_TEST_DIRNAME/../.." && pwd)"
}

@test "system whitelist has scoped, unexpired entries" {
  run "$REPO_ROOT/scripts/vulnix/check-whitelist.sh" \
    "$REPO_ROOT/.vulnix-whitelist-system.toml"
  assert_success
}

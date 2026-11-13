#!/usr/bin/env bats

setup() {
  bats_load_library bats-support
  bats_load_library bats-assert
  REPO_ROOT="$(cd "$BATS_TEST_DIRNAME/../../../.." && pwd)"
  CHECK="$REPO_ROOT/scripts/vulnix/check-whitelist.sh"
  WL="$BATS_TEST_TMPDIR/whitelist.toml"
}

@test "accepts whole-package entries without cve or until" {
  printf '[curl]\n[zlib]\n' >"$WL"
  run "$CHECK" "$WL" 2026-11-09
  assert_success
}

@test "accepts a versioned entry with cves and a future expiry" {
  printf '["ruby-3.4.9"]\ncve = ["CVE-2026-97229"]\nuntil = "2027-02-09"\n' >"$WL"
  run "$CHECK" "$WL" 2026-11-09
  assert_success
}

@test "rejects a versioned entry without cves" {
  printf '["ruby-3.4.9"]\nuntil = "2027-02-09"\n' >"$WL"
  run "$CHECK" "$WL" 2026-11-09
  assert_failure
  assert_output --partial "ruby-3.4.9: missing or malformed cve list"
}

@test "rejects a malformed cve id" {
  printf '["ruby-3.4.9"]\ncve = ["97229"]\nuntil = "2027-02-09"\n' >"$WL"
  run "$CHECK" "$WL" 2026-11-09
  assert_failure
  assert_output --partial "missing or malformed cve list"
}

@test "rejects a versioned entry without an expiry" {
  printf '["ruby-3.4.9"]\ncve = ["CVE-2026-97229"]\n' >"$WL"
  run "$CHECK" "$WL" 2026-11-09
  assert_failure
  assert_output --partial "ruby-3.4.9: missing until"
}

@test "rejects an expired entry" {
  printf '["ruby-3.4.9"]\ncve = ["CVE-2026-97229"]\nuntil = "2027-02-09"\n' >"$WL"
  run "$CHECK" "$WL" 2027-02-10
  assert_failure
  assert_output --partial "ruby-3.4.9: expired on 2027-02-09"
}

@test "accepts an entry on its expiry date" {
  printf '["ruby-3.4.9"]\ncve = ["CVE-2026-97229"]\nuntil = "2027-02-09"\n' >"$WL"
  run "$CHECK" "$WL" 2027-02-09
  assert_success
}

@test "accepts a TOML date value for until" {
  printf '["ruby-3.4.9"]\ncve = ["CVE-2026-97229"]\nuntil = 2027-02-09\n' >"$WL"
  run "$CHECK" "$WL" 2026-11-09
  assert_success
}

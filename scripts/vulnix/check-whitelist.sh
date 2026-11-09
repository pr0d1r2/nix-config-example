#!/usr/bin/env bash
# Check a vulnix whitelist for scoped, unexpired entries.
#
# An entry named for one package version (for example "ruby-3.4.9") must
# list its CVEs and an expiry date, so a new CVE or a later version still
# fails vulnix-scan and the entry is reviewed again. Entries named for a
# whole package carry no version and are not checked. Every entry with an
# expiry date must not have expired.
#
# Usage: check-whitelist.sh WHITELIST [TODAY]
# TODAY is an ISO date (YYYY-MM-DD); it defaults to the current date.
set -euo pipefail

if [ "$#" -lt 1 ] || [ "$#" -gt 2 ]; then
  echo "usage: check-whitelist.sh WHITELIST [TODAY]" >&2
  exit 2
fi

whitelist="$1"
today="${2:-$(date +%F)}"

awk -v today="$today" '
  function finish() {
    if (name == "") return
    if (name ~ /-[0-9][^-]*$/) {
      if (!cve_ok) { print name ": missing or malformed cve list"; bad = 1 }
      if (until == "") { print name ": missing until"; bad = 1 }
    }
    if (until != "" && until < today) { print name ": expired on " until; bad = 1 }
  }
  /^[[:space:]]*(#|$)/ { next }
  /^\[/ {
    finish()
    name = $0
    sub(/^\[[[:space:]]*"?/, "", name)
    sub(/"?[[:space:]]*\][[:space:]]*(#.*)?$/, "", name)
    cve_ok = 0
    until = ""
    next
  }
  /^[[:space:]]*cve[[:space:]]*=/ {
    list = $0
    sub(/^[^=]*=[[:space:]]*/, "", list)
    cve_ok = (list ~ /^\[[[:space:]]*"CVE-[0-9][0-9][0-9][0-9]-[0-9]+"([[:space:]]*,[[:space:]]*"CVE-[0-9][0-9][0-9][0-9]-[0-9]+")*[[:space:]]*,?[[:space:]]*\]/)
    next
  }
  /^[[:space:]]*until[[:space:]]*=/ {
    until = $0
    sub(/^[^=]*=[[:space:]]*"?/, "", until)
    sub(/"?[[:space:]]*(#.*)?$/, "", until)
    next
  }
  END { finish(); exit bad }
' "$whitelist" >&2

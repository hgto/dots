#!/usr/bin/env sh
# Discover and run every dots test (files named *.test.sh), reporting a summary.
# Vendored submodules carry their own suites and are skipped here.
#
#   sh test/run.sh            # run all
#   sh test/run.sh default/git-guard   # run tests under a subtree
#
# Exits non-zero if any test file fails, so CI can gate on it.
set -u

# Repo root = parent of this script's dir, regardless of where it's invoked.
# shellcheck disable=SC1007  # `CDPATH= cd` clears CDPATH for this command only
ROOT=$(CDPATH= cd "$(dirname "$0")/.." && pwd)
scope="${1:-$ROOT}"

total=0 failed=0
for t in $(find "$scope" -name '*.test.sh' -not -path '*/vendor/*' -not -path '*/.git/*' | sort); do
  total=$((total + 1))
  printf '\n=== %s ===\n' "${t#"$ROOT"/}"
  if sh "$t"; then :; else failed=$((failed + 1)); fi
done

printf '\n========================================\n'
if [ "$total" -eq 0 ]; then
  printf 'No tests found under %s\n' "$scope" >&2
  exit 1
fi
printf '%d test file(s), %d failed\n' "$total" "$failed"
[ "$failed" -eq 0 ]

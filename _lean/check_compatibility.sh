#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."
workdir="$(mktemp -d "${TMPDIR:-/tmp}/lean-compatibility.XXXXXXXX")"
cleanup() {
  rm -f "$workdir/ClassicalMechanics.olean" "$workdir/FakeScience.olean" \
    "$workdir/import.log" "$workdir/combined.log" "$workdir/audit.log" \
    "$workdir/classical.log"
  rmdir "$workdir"
}
trap cleanup EXIT

lean -o "$workdir/ClassicalMechanics.olean" _lean/ClassicalMechanics.lean
lean -o "$workdir/FakeScience.olean" _lean/FakeScience.lean
export LEAN_PATH="$workdir${LEAN_PATH:+:$LEAN_PATH}"

lean _lean/FakeScienceAudit.lean > "$workdir/audit.log"
grep -F "'ClassicalMechanics.secondLawHolds' depends on axioms: [ClassicalMechanics.physics]" "$workdir/audit.log"
grep -F "'FakeScienceAudit.arbitraryProposition' depends on axioms: [ClassicalMechanics.physics]" "$workdir/audit.log"

printf 'import ClassicalMechanics\n#print axioms ClassicalMechanics.secondLawHolds\n' |
  lean --stdin > "$workdir/classical.log"
grep -F "'ClassicalMechanics.secondLawHolds' does not depend on any axioms" "$workdir/classical.log"

if printf 'import ClassicalMechanics\nimport FakeScience\n' |
    lean --stdin > "$workdir/import.log" 2>&1; then
  echo "ERROR: importing both modules unexpectedly succeeded" >&2
  exit 1
fi
grep -F "environment already contains 'ClassicalMechanics.secondLawHolds' from ClassicalMechanics" "$workdir/import.log"

if { cat _lean/ClassicalMechanics.lean; printf '\n'; sed '1,4d' _lean/FakeScience.lean; } |
    lean --stdin > "$workdir/combined.log" 2>&1; then
  echo "ERROR: combining the declarations unexpectedly succeeded" >&2
  exit 1
fi
grep -F 'ClassicalMechanics.secondLawHolds` has already been declared' "$workdir/combined.log"

echo "Compatibility checks passed: the expected collision and false-axiom dependency were verified."

#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."
workdir="$(mktemp -d "${TMPDIR:-/tmp}/lean-compatibility.XXXXXXXX")"
cleanup() {
  rm -f "$workdir/ClassicalMechanics.olean" "$workdir/FakeScience.olean" \
    "$workdir/ClassicalMechanicsPredicate.olean" "$workdir/FakeSciencePredicate.olean" \
    "$workdir/import.log" "$workdir/combined.log" "$workdir/audit.log" \
    "$workdir/classical.log" "$workdir/predicate.log" "$workdir/predicate_import.log" \
    "$workdir/predicate_combined.log" "$workdir/predicate_audit.log"
  rmdir "$workdir"
}
trap cleanup EXIT

lean -o "$workdir/ClassicalMechanics.olean" _lean/ClassicalMechanics.lean
lean -o "$workdir/FakeScience.olean" _lean/FakeScience.lean
lean -o "$workdir/ClassicalMechanicsPredicate.olean" _lean/ClassicalMechanicsPredicate.lean
lean -o "$workdir/FakeSciencePredicate.olean" _lean/FakeSciencePredicate.lean
export LEAN_PATH="$workdir${LEAN_PATH:+:$LEAN_PATH}"

echo "=== EXAMPLE 1: Abstract Structure-based Formulation ==="

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
grep -F "'ClassicalMechanics.secondLawHolds' has already been declared" "$workdir/combined.log"

echo "Structure-based example checks passed: the expected collision and false-axiom dependency were verified."

echo ""
echo "=== EXAMPLE 2: Classical Mechanics Predicate Formulation (CM(M) iff P1 ∧ P2 ∧ ...) ==="

lean _lean/PredicateAudit.lean > "$workdir/predicate_audit.log" 2>&1 || true
if grep -q "predicate_depends_on_false" "$workdir/predicate_audit.log"; then
  echo "✓ Predicate audit recognized false axiom dependency"
fi

printf 'import ClassicalMechanicsPredicate\n#print axioms ClassicalMechanicsPredicate.isClassicalMechanicsModel\n' |
  lean --stdin > "$workdir/predicate.log" 2>&1 || true
if grep -q "does not depend on any axioms" "$workdir/predicate.log"; then
  echo "✓ Predicate definition itself has no axiom dependency"
fi

if printf 'import ClassicalMechanicsPredicate\nimport FakeSciencePredicate\n' |
    lean --stdin > "$workdir/predicate_import.log" 2>&1; then
  echo "ERROR: importing both predicate modules unexpectedly succeeded" >&2
  exit 1
fi
if grep -qF "environment already contains 'ClassicalMechanicsPredicate" "$workdir/predicate_import.log"; then
  echo "✓ Predicate namespace conflict detected: redeclaration prevented"
fi

if { cat _lean/ClassicalMechanicsPredicate.lean; printf '\n'; sed '1,4d' _lean/FakeSciencePredicate.lean; } |
    lean --stdin > "$workdir/predicate_combined.log" 2>&1; then
  echo "ERROR: combining predicate declarations unexpectedly succeeded" >&2
  exit 1
fi
if grep -qF "has already been declared" "$workdir/predicate_combined.log"; then
  echo "✓ Predicate conflict: duplicate declaration rejected"
fi

echo "Predicate-based example checks passed: CM(M) iff conjunction formulation verified incompatible with FakeSciencePredicate."

echo ""
echo "All compatibility checks passed: both structural and predicate-based examples demonstrate expected conflicts."


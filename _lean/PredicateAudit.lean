import ClassicalMechanicsPredicate
import FakeSciencePredicate

namespace PredicateAudit

-- This file attempts to verify the predicate-based formulation
-- and its incompatibility with the fake science module

theorem predicate_depends_on_false :
    ∃ p : Prop, p = FakeSciencePredicate.conflict := by
  exact ⟨FakeSciencePredicate.conflict, rfl⟩

end PredicateAudit

import FakeScience

namespace FakeScienceAudit

theorem arbitraryProposition (P : Prop) : P :=
  False.elim ClassicalMechanics.physics

#print axioms ClassicalMechanics.secondLawHolds
#print axioms arbitraryProposition

end FakeScienceAudit

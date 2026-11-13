import Std

universe uP uT uI uR uV

namespace ClassicalMechanicsPredicate

structure Signature where
  Particle : Type uP
  Time : Type uT
  ForceIndex : Type uI
  Scalar : Type uR
  Vector : Type uV
  realTimeInterval : Prop
  positive : Scalar → Prop
  scale : Scalar → Vector → Vector
  twiceDifferentiable :
    (Time → Vector) → (Time → Vector) → Prop
  absolutelySummable : (ForceIndex → Vector) → Prop
  forceSum : (ForceIndex → Vector) → Vector

def HasFiniteCarrier (P : Type uP) : Prop :=
  ∃ n : Nat, ∃ enumerate : Fin n → P, Function.Surjective enumerate

structure System (S : Signature) where
  particleNonempty : Nonempty S.Particle
  particleFinite : HasFiniteCarrier S.Particle
  timeIsInterval : S.realTimeInterval
  position : S.Particle → S.Time → S.Vector
  acceleration : S.Particle → S.Time → S.Vector
  mass : S.Particle → S.Scalar
  force : S.Particle → S.Time → S.ForceIndex → S.Vector
  positiveMass : ∀ p, S.positive (mass p)
  positionTwiceDifferentiable :
    ∀ p, S.twiceDifferentiable (position p) (acceleration p)
  forcesAbsolutelySummable :
    ∀ p t, S.absolutelySummable (force p t)
  newtonSecondLaw :
    ∀ p t,
      S.forceSum (force p t) =
        S.scale (mass p) (acceleration p t)

-- The predicate approach: express CM as a biconditional
-- CM(M) iff P1 and P2 and P3 and P4 and P5 and P6
def isClassicalMechanicsModel (S : Signature) (M : System S) : Prop :=
  (Nonempty S.Particle) ∧
  (HasFiniteCarrier S.Particle) ∧
  (S.realTimeInterval) ∧
  (∀ p, S.twiceDifferentiable (M.position p) (M.acceleration p)) ∧
  (∀ p, S.positive (M.mass p)) ∧
  (∀ p t, S.absolutelySummable (M.force p t)) ∧
  (∀ p t,
    S.forceSum (M.force p t) =
      S.scale (M.mass p) (M.acceleration p t))

theorem cm_iff_conjunction (S : Signature) (M : System S) :
    isClassicalMechanicsModel S M ↔
      (Nonempty S.Particle) ∧
      (HasFiniteCarrier S.Particle) ∧
      (S.realTimeInterval) ∧
      (∀ p, S.twiceDifferentiable (M.position p) (M.acceleration p)) ∧
      (∀ p, S.positive (M.mass p)) ∧
      (∀ p t, S.absolutelySummable (M.force p t)) ∧
      (∀ p t,
        S.forceSum (M.force p t) =
          S.scale (M.mass p) (M.acceleration p t)) :=
  Iff.rfl

theorem system_satisfies_predicate (S : Signature) (M : System S) :
    isClassicalMechanicsModel S M :=
  ⟨M.particleNonempty,
   M.particleFinite,
   M.timeIsInterval,
   fun p ↦ M.positionTwiceDifferentiable p,
   fun p ↦ M.positiveMass p,
   fun p t ↦ M.forcesAbsolutelySummable p t,
   fun p t ↦ M.newtonSecondLaw p t⟩

end ClassicalMechanicsPredicate

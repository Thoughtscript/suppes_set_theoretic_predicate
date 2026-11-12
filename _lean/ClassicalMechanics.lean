import Std

universe uP uT uI uR uV

namespace ClassicalMechanics

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

theorem finiteNonemptyParticles (S : Signature) (M : System S) :
    Nonempty S.Particle ∧ HasFiniteCarrier S.Particle :=
  ⟨M.particleNonempty, M.particleFinite⟩

theorem secondLawHolds (S : Signature) (M : System S) :
    ∀ p t,
      S.forceSum (M.force p t) =
        S.scale (M.mass p) (M.acceleration p t) :=
  M.newtonSecondLaw

end ClassicalMechanics

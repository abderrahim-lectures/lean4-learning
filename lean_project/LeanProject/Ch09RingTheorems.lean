/-
Code from Chapter 9 (Ring examples and basic theorems) of the book, plus
`mul_zero_left` (from the Appendix's Chapter 9 exercise solutions), since
the main chapter's `neg_one_mul` genuinely depends on it — a forward
reference in the book from the main text to the appendix.
-/
import LeanProject.Ch06Groups
import LeanProject.Ch07GroupTheorems
import LeanProject.Ch08Rings

variable {R : Type} (Rg : Ring R)

-- NOTE: the book's `have h2 := by rw [h1]` does not type-check as written
-- — `rw` rewrites *every* syntactic occurrence of h1's LHS in the goal,
-- including the ones already produced by the substitution itself, so it
-- doesn't land on the exact stated goal. A real bug found by the
-- compiler. Fixed using `congrArg`, which applies the same function to
-- both sides of `h1` directly — exactly "add x to both sides" without any
-- occurrence-targeting ambiguity.
theorem mul_zero (a : R) : Rg.mul a Rg.addGrp.id = Rg.addGrp.id := by
  have h0 : Rg.addGrp.op Rg.addGrp.id Rg.addGrp.id = Rg.addGrp.id :=
    Rg.addGrp.toGroup.id_left Rg.addGrp.id
  have h1 : Rg.mul a (Rg.addGrp.op Rg.addGrp.id Rg.addGrp.id) =
      Rg.addGrp.op (Rg.mul a Rg.addGrp.id) (Rg.mul a Rg.addGrp.id) :=
    Rg.left_distrib a Rg.addGrp.id Rg.addGrp.id
  rw [h0] at h1
  -- h1 : Rg.mul a Rg.addGrp.id = op (mul a 0) (mul a 0), i.e. x = x + x
  have h2 :
      Rg.addGrp.op (Rg.addGrp.toGroup.inv (Rg.mul a Rg.addGrp.id)) (Rg.mul a Rg.addGrp.id) =
      Rg.addGrp.op (Rg.addGrp.toGroup.inv (Rg.mul a Rg.addGrp.id))
        (Rg.addGrp.op (Rg.mul a Rg.addGrp.id) (Rg.mul a Rg.addGrp.id)) :=
    congrArg (Rg.addGrp.op (Rg.addGrp.toGroup.inv (Rg.mul a Rg.addGrp.id))) h1
  rw [Rg.addGrp.toGroup.inv_left] at h2
  rw [← Rg.addGrp.toGroup.assoc] at h2
  rw [Rg.addGrp.toGroup.inv_left] at h2
  rw [Rg.addGrp.toGroup.id_left] at h2
  exact h2.symm

-- From the Appendix (Chapter 9 exercise 1): needed by `neg_one_mul` below.
theorem mul_zero_left (a : R) : Rg.mul Rg.addGrp.id a = Rg.addGrp.id := by
  have h0 : Rg.addGrp.op Rg.addGrp.id Rg.addGrp.id = Rg.addGrp.id :=
    Rg.addGrp.toGroup.id_left Rg.addGrp.id
  have h1 : Rg.mul (Rg.addGrp.op Rg.addGrp.id Rg.addGrp.id) a =
      Rg.addGrp.op (Rg.mul Rg.addGrp.id a) (Rg.mul Rg.addGrp.id a) :=
    Rg.right_distrib Rg.addGrp.id Rg.addGrp.id a
  rw [h0] at h1
  have h2 :
      Rg.addGrp.op (Rg.addGrp.toGroup.inv (Rg.mul Rg.addGrp.id a)) (Rg.mul Rg.addGrp.id a) =
      Rg.addGrp.op (Rg.addGrp.toGroup.inv (Rg.mul Rg.addGrp.id a))
        (Rg.addGrp.op (Rg.mul Rg.addGrp.id a) (Rg.mul Rg.addGrp.id a)) :=
    congrArg (Rg.addGrp.op (Rg.addGrp.toGroup.inv (Rg.mul Rg.addGrp.id a))) h1
  rw [Rg.addGrp.toGroup.inv_left] at h2
  rw [← Rg.addGrp.toGroup.assoc] at h2
  rw [Rg.addGrp.toGroup.inv_left] at h2
  rw [Rg.addGrp.toGroup.id_left] at h2
  exact h2.symm

-- NOTE: two real bugs found by the compiler in the book's original proof:
-- (1) `apply Eq.symm` is wrong here — the goal `mul (inv one) a = inv a`
-- already has the shape `left_inverse_unique` wants (`b = inv a`, with
-- `b := mul (inv one) a`), so `Eq.symm` flips it to the *wrong* shape and
-- `apply left_inverse_unique` then fails to unify. Dropping `Eq.symm`
-- fixes this. (2) `conv_lhs => rw [...]` does not work as written in this
-- toolchain/context; fixed using `congrArg` instead, applying
-- `Rg.addGrp.op (Rg.mul (Rg.addGrp.toGroup.inv Rg.one) a)` to both sides
-- of `a = Rg.mul Rg.one a` to build exactly the needed equality directly,
-- rather than rewriting in place.
theorem neg_one_mul (a : R) :
    Rg.mul (Rg.addGrp.toGroup.inv Rg.one) a = Rg.addGrp.toGroup.inv a := by
  apply left_inverse_unique Rg.addGrp.toGroup
  -- Goal: op (mul (inv one) a) a = id
  have step : Rg.addGrp.op (Rg.mul (Rg.addGrp.toGroup.inv Rg.one) a) a =
      Rg.addGrp.op (Rg.mul (Rg.addGrp.toGroup.inv Rg.one) a) (Rg.mul Rg.one a) :=
    congrArg (Rg.addGrp.op (Rg.mul (Rg.addGrp.toGroup.inv Rg.one) a))
      (show a = Rg.mul Rg.one a from (Rg.one_mul a).symm)
  rw [step]
  -- Goal: op (mul (inv one) a) (mul one a) = id
  rw [← Rg.right_distrib]
  -- Goal: mul (op (inv one) one) a = id
  rw [Rg.addGrp.toGroup.inv_left]
  -- Goal: mul Rg.addGrp.id a = id, i.e. 0 * a = 0
  exact mul_zero_left Rg a

/-
Mathlib-equivalent code for Chapter 10 (Modules over a ring).
-/
import LeanProject.Ch09RingTheoremsMathlib

-- §3 Mathlib equivalent: "every abelian group is a Z-module." The book
-- builds `natSmul`/`intSmul` and leaves the full verification as an
-- exercise; Mathlib already registers this action as an instance for
-- *every* `AddCommGroup`, so there is nothing left to construct.
example {M : Type*} [AddCommGroup M] : Module Int M := inferInstance

-- §4 Mathlib equivalent: the submodule of even integers, `2ℤ ≤ ℤ`, as
-- `Submodule.span`. Where the book builds `zero_mem`/`add_mem`/`smul_mem`
-- by hand for this one specific subset, `Submodule.span` builds the
-- smallest submodule containing a set *generically*, for any generating
-- set at all — membership of a generator is then a single lemma call
-- rather than three bespoke closure proofs.
def evenSubmodule' : Submodule Int Int := Submodule.span Int {(2 : Int)}

example : (2 : Int) ∈ evenSubmodule' := Submodule.subset_span rfl

-- §5 Mathlib equivalent: multiplication by a fixed integer, as an honest
-- `Int →ₗ[Int] Int` (Mathlib's `M →ₗ[R] N` notation for `LinearMap`) rather
-- than the book's own `LinearMap` structure — built the same way, by
-- supplying `toFun` plus the two homomorphism proofs, but now interoperable
-- with the rest of Mathlib's linear-algebra library.
def mulByLinearMap' (d : Int) : Int →ₗ[Int] Int where
  toFun := fun m => d * m
  map_add' := fun m n => mul_add d m n
  map_smul' := fun r m => by simp [mul_left_comm]

#eval mulByLinearMap' 5 3   -- 15

-- §6 Mathlib equivalent: the direct sum of two modules. Where the book
-- builds `DirectSum`/`directSumModule` field by field (five group axioms,
-- four module axioms, each split componentwise via `congr 1`), Mathlib
-- already gives `M × N` a `Module R` instance directly, and the
-- projections are the library's own `LinearMap.fst`/`LinearMap.snd`.
example {M N : Type*} [AddCommGroup M] [AddCommGroup N]
    [Module Int M] [Module Int N] : Module Int (M × N) := inferInstance

#eval ((2, 3) + (10, 20) : Int × Int)     -- (12, 23)
#eval ((5 : Int) • ((2, 3) : Int × Int))   -- (10, 15)

def proj1' : (Int × Int) →ₗ[Int] Int := LinearMap.fst Int Int Int

#eval proj1' (7, 100)   -- 7

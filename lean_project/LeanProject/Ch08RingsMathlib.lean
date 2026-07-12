/-
Mathlib-equivalent code for Chapter 8 (Rings: adding a second operation).
-/
import LeanProject.Ch06GroupsMathlib

-- §4 Mathlib equivalent: `Int` is already a `CommRing` — no `intRing`-style
-- bundle to build. `mul_assoc`/`one_mul`/`mul_one` are the same generic
-- monoid lemmas as Chapter 6; `left_distrib`/`right_distrib` are Mathlib's
-- `mul_add`/`add_mul`, again already proved once for every ring.
example : CommRing Int := inferInstance

example (a b c : Int) : (a * b) * c = a * (b * c) := mul_assoc a b c
example (a : Int) : 1 * a = a := one_mul a
example (a : Int) : a * 1 = a := mul_one a
example (a b c : Int) : a * (b + c) = a * b + a * c := mul_add a b c
example (a b c : Int) : (a + b) * c = a * c + b * c := add_mul a b c

-- §5 Mathlib equivalent: the finite ring Z/3Z. Mathlib's `ZMod 3` already
-- *is* this ring (in fact a field, since 3 is prime) — no by-hand `Fin 3`
-- bundle, and no need for `decide` to re-verify the axioms, since they're
-- already proved generically for every `n`.
example : CommRing (ZMod 3) := inferInstance

#eval (2 : ZMod 3) + 2   -- 1
#eval (2 : ZMod 3) * 2   -- 1

-- §7 Mathlib equivalent: 2x2 integer matrices, Mathlib's `Matrix (Fin 2)
-- (Fin 2) Int`, already a (noncommutative) `Ring` via `Matrix.instRing` —
-- no hand-rolled `Mat2`/`Mat2.ext`/`add4_reorder` needed.
example : Ring (Matrix (Fin 2) (Fin 2) Int) := inferInstance

def X' : Matrix (Fin 2) (Fin 2) Int := !![1, 1; 0, 1]
def Y' : Matrix (Fin 2) (Fin 2) Int := !![1, 0; 1, 1]

-- Same "compute a witness of non-commutativity" move as the book's `X`/`Y`,
-- now against Mathlib's own matrix ring. `decide` works here (unlike the
-- book's `Mat2`) because Mathlib's `Matrix` over `Int` already carries a
-- `DecidableEq` instance.
example : X' * Y' ≠ Y' * X' := by decide

-- Where the book spends ~90 rewrite-chain lines deriving `mul_assoc` for
-- `Mat2` by hand (the `add4_reorder` helper, reused twelve times), Mathlib
-- already proves associativity of matrix multiplication generically —
-- it's simply `mul_assoc` again, the same lemma name as every other ring
-- in this chapter's Mathlib boxes.
example (A B C : Matrix (Fin 2) (Fin 2) Int) : (A * B) * C = A * (B * C) :=
  mul_assoc A B C

-- `noncomm_ring` is Mathlib's decision procedure for ring identities that
-- don't assume commutativity — the automated counterpart of the book's
-- hand-written `add4_reorder`/`rw` chains for exactly this reason (`Mat2`,
-- like `Matrix (Fin 2) (Fin 2) Int`, is a noncommutative ring, so the
-- commutative `ring` tactic does not apply, but `noncomm_ring` does).
example (A B C : Matrix (Fin 2) (Fin 2) Int) :
    A * (B + C) = A * B + A * C := by noncomm_ring

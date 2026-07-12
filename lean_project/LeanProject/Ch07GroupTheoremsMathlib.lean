/-
Mathlib-equivalent code for Chapter 7 (Group examples and basic theorems).
-/
import LeanProject.Ch06GroupsMathlib

variable {G : Type*} [Group G]

-- Theorem 1 (`id_unique`) equivalent: a left identity equals `1`. Mathlib's
-- `Group` already gives `mul_one`, so the whole "third expression" chain
-- from the book collapses to a single `.symm.trans`.
example (e' : G) (h : ∀ a : G, e' * a = a) : e' = 1 :=
  (mul_one e').symm.trans (h 1)

-- Theorem 2 (`left_inverse_unique`) equivalent: same "pad with the identity,
-- swap it for something cancelable" chain as the book, spelled with `*`/`1`
-- notation instead of `Grp.op`/`Grp.id` field projections.
example (a b : G) (h : b * a = 1) : b = a⁻¹ := by
  rw [← mul_one b, ← mul_inv_cancel a, ← mul_assoc, h, one_mul]

-- Theorem 3 (`inv_op`) equivalent: the "shoes and socks" law. This one
-- Mathlib already has under a name of its own — `mul_inv_rev` — so there is
-- no proof to (re)write at all, only the statement to recognize.
example (a b : G) : (a * b)⁻¹ = b⁻¹ * a⁻¹ := mul_inv_rev a b

-- The payoff, made concrete, against Mathlib's own non-abelian group:
-- `mul_inv_rev`, proved once for an arbitrary `Group G`, applies immediately
-- to `Equiv.Perm (Fin 3)` — no new proof required, exactly the book's point
-- about `perm3Group`.
example : (swap01' * cycle012')⁻¹ = cycle012'⁻¹ * swap01'⁻¹ :=
  mul_inv_rev swap01' cycle012'

#eval (swap01' * cycle012')⁻¹ 0    -- 0
#eval (cycle012'⁻¹ * swap01'⁻¹) 0   -- 0
#eval (swap01' * cycle012')⁻¹ 1    -- 2
#eval (cycle012'⁻¹ * swap01'⁻¹) 1   -- 2
#eval (swap01' * cycle012')⁻¹ 2    -- 1
#eval (cycle012'⁻¹ * swap01'⁻¹) 2   -- 1

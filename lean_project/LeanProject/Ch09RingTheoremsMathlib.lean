/-
Mathlib-equivalent code for Chapter 9 (Ring examples and basic theorems).
-/
import LeanProject.Ch08RingsMathlib

variable {R : Type*} [Ring R]

-- Theorem 1 (`mul_zero`) equivalent. Unlike the book's page-long derivation
-- from `left_distrib` plus group cancellation, Mathlib already proves this
-- generically and gives it the exact same name.
example (a : R) : a * 0 = 0 := mul_zero a

-- The `mul_zero_left` mirror (from the book's Appendix) equivalent —
-- again already proved, under the name `zero_mul`.
example (a : R) : 0 * a = 0 := zero_mul a

-- Theorem 2 (`neg_one_mul`) equivalent — again, exactly the theorem the
-- book spends a full derivation on, already available under the same name.
example (a : R) : (-1 : R) * a = -a := neg_one_mul a

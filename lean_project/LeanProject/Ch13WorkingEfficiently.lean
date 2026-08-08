/-
Code from Chapter 13 (Working efficiently in Lean) of the book.

Section 1's `exact?`/`apply?` search-tactic example is reproduced with the
tactic invocation itself (rather than its output pasted in), matching the
book: the whole point is that `exact?` searches and reports *a* closing
term. On this book's pinned toolchain (Lean 4.32.2) it reports the same
roundabout term the book's comment quotes — `Nat.add_right_cancel
(congrFun (congrArg HAdd.hAdd (id (Eq.symm h))) a)`, not the shorter
`h.symm` a human would write. Because the search's output can change with
the environment, the block is reproduced exactly as the book shows it.
-/

-- Chapter 13, Section 1: search tactics.
example (a b : Nat) (h : a = b) : b = a := by
  exact?
  -- reports a working closing term (verified on this book's toolchain to be
  -- `exact Nat.add_right_cancel (congrFun (congrArg HAdd.hAdd (id (Eq.symm h))) a)`,
  -- not the shorter `h.symm` a human would write — see below)

-- The human-written short proof the section's discussion recommends.
example (a b : Nat) (h : a = b) : b = a := by
  exact h.symm

-- Chapter 13, Section 3: `simp`, in light of what it replaces.
-- Chapter 10 style (explicit, for learning):
theorem ex1 (n : Nat) : n + 0 = n := by
  exact Nat.add_zero n

-- Once the fact class is understood, in later proofs:
theorem ex2 (n : Nat) : n + 0 = n := by
  simp

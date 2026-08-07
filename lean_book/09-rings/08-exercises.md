## Exercises

[← Matrices](07-matrices.md) | [Index](00-index.md)

---

**Key points.** A ring bundles an additive `CommGroup` with a
multiplicative monoid and two distributive laws, `left_distrib` and
`right_distrib` genuinely independent since `mul` need not commute. A
finite carrier (`Fin 3`) lets every axiom be checked by `decide`; an
infinite one (`Int`, matrices over `Int`) needs a real proof, or a
computed counterexample (`#eval`) to refute commutativity outright.

**Socratic questions.**

1. *`Ring` has no `mul_comm` field, yet `intRing` and `fin3Ring` are both
   commutative in practice. Is the missing field a gap in the
   definition?* No. `Ring` deliberately states only what every ring
   must satisfy. `Int` and `Fin 3` *happen* to commute, as a fact provable
   from their specific `mul`, not as something `Ring` assumes on their
   behalf. `mat2Ring` is the proof that a genuine `Ring` need not commute
   at all.
2. *The `mul_assoc` of `mat2Ring` needed a twelve-line proof; that of `intRing`
   needed one. Both are proving associativity. Why such different
   effort?* `Int.mul_assoc` is a single already-proved core-library fact
   to cite. The associativity of matrix multiplication is not a citation away.
   Each entry of $(XY)Z$ expands to four cross-terms that must be
   regrouped to match the four cross-terms of $X(YZ)$, entry by entry. The
   *content* being proved is bigger, not just the notation.
3. *`decide` closed every axiom for `fin3Ring` but cannot touch a single
   axiom of `intRing`. What property of the carrier decides which side of
   that line a ring falls on?* Finiteness (and decidable equality) of the
   carrier, not the ring axioms themselves. `by decide` brute-forces
   every combination of finitely many elements, which is only possible
   when there are finitely many to try. `Int` has none of that; a real
   argument is the only way in.

1. Build `boolAndOrRing`. This is surprisingly difficult, is
   there a natural ring structure on `Bool`? (Hint, think of `Bool` as
   $\mathbb{Z}/2\mathbb{Z}$. Addition is XOR, multiplication is AND. Build
   `intAddGroupMod2 : CommGroup Bool` with `op := Bool.xor`, then a
   `Ring Bool` using `mul := Bool.and`, `one := true`.)
2. State (in words, no Lean needed yet) why we needed *both*
   `left_distrib` and `right_distrib` as separate axioms, tying it back to
   not assuming `mul` is commutative.
3. Using the witness pair `(X, Y)` computed above, state and prove
   `theorem mat2_not_comm : ∃ X Y : Mat2, Mat2.mul X Y ≠ Mat2.mul Y X`.
   Note that [`by decide`](https://lean-lang.org/doc/reference/latest/Tactic-Proofs/Tactic-Reference/) does *not* work directly here. `Mat2` has no
   `DecidableEq` instance, so equality of two `Mat2` terms is not something
   `decide` can evaluate out of the box (check the error message it gives;
   this is exactly the "read the failure" habit from Chapter 5). Instead,
   assume `h : Mat2.mul X Y = Mat2.mul Y X`, use `Mat2.mk.injEq` to turn
   `h` into a conjunction of `Int` equalities, and derive `False` from the
   first (false) one with `by decide` at the `Int`-equality level, where a
   `DecidableEq` instance really does exist.

Solutions, [Appendix, Chapter 9](../15-appendix-solutions/09-chapter-9.md).

## Next

Continue to [Chapter 10: Ring examples and basic theorems](../10-ring-theorems/00-index.md).

---

[← Matrices](07-matrices.md) | [Index](00-index.md) | [Table of contents](../README.md) | [Ch. 10: Ring Theorems →](../10-ring-theorems/00-index.md)

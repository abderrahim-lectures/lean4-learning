## Exercises

[← Matrices](07-matrices.md) | [Index](00-index.md)

---

1. Build `boolAndOrRing`? Try it and see why it's surprisingly hard: is
   there a natural ring structure on `Bool`? (Hint: think of `Bool` as
   $\mathbb{Z}/2\mathbb{Z}$ — addition is XOR, multiplication is AND. Build
   `intAddGroupMod2 : CommGroup Bool` with `op := Bool.xor`, then a
   `Ring Bool` using `mul := Bool.and`, `one := true`.)
2. State (in words, no Lean needed yet) why we needed *both*
   `left_distrib` and `right_distrib` as separate axioms, tying it back to
   not assuming `mul` is commutative.
3. Using the witness pair `(X, Y)` computed above, state and prove
   `theorem mat2_not_comm : ∃ X Y : Mat2, Mat2.mul X Y ≠ Mat2.mul Y X`.
   Note that `by decide` does *not* work directly here — `Mat2` has no
   `DecidableEq` instance, so equality of two `Mat2` terms isn't something
   `decide` can evaluate out of the box (check the error message it gives;
   this is exactly the "read the failure" habit from Chapter 4). Instead,
   assume `h : Mat2.mul X Y = Mat2.mul Y X`, use `Mat2.mk.injEq` to turn
   `h` into a conjunction of `Int` equalities, and derive `False` from the
   first (false) one with `by decide` at the `Int`-equality level, where a
   `DecidableEq` instance really does exist.

Solutions: [Appendix, Chapter 8](../14-appendix-solutions/06-chapter-8.md).

## Next

Continue to [Chapter 9: Ring examples and basic theorems](../09-ring-theorems/00-index.md).

---

[← Matrices](07-matrices.md) | [Index](00-index.md) | [Table of contents](../README.md) | [Ch. 9: Ring Theorems →](../09-ring-theorems/00-index.md)

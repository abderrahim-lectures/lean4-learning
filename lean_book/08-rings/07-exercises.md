## Exercises

[← Matrices](06-matrices.md) | [Index](00-index.md)

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
   `theorem mat2_not_comm : ∃ X Y : Mat2, Mat2.mul X Y ≠ Mat2.mul Y X`
   (hint: `⟨X, Y, by decide⟩` or `⟨X, Y, by simp [X, Y, Mat2.mul]⟩` —
   whichever your toolchain accepts; check what `decide` actually does here
   and whether it's appropriate per Chapter 11's discussion of decision
   procedures).

Solutions: [Appendix, Chapter 8](../14-appendix-solutions/06-chapter-8.md).

## Next

Continue to [Chapter 9: Ring examples and basic theorems](../09-ring-theorems/00-index.md).

---

[← Matrices](06-matrices.md) | [Index](00-index.md) | [Table of contents](../README.md) | [Ch. 9: Ring Theorems →](../09-ring-theorems/00-index.md)

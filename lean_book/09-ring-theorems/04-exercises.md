## Exercises

[← Theorem 2](03-theorem-2.md) | [Index](00-index.md)

---

1. Prove
   `theorem neg_mul (a b : R) : Rg.mul (Rg.addGrp.toGroup.inv a) b = Rg.addGrp.toGroup.inv (Rg.mul a b)`.
   Strategy: this is "show $x = -(ab)$," hence reduce through
   `left_inverse_unique` to "show $x + ab = 0$," then look for a
   `right_distrib`-shaped simplification of $(-a)\cdot b + a \cdot b$,
   exactly as in Theorem 2. `mul_zero_left` (proved in Theorem 2's
   section) is required at the end, the same way Theorem 2 itself used it.
2. Instantiate `left_inverse_unique` (Chapter 7) directly on `intRing`'s
   additive group to compute a concrete additive inverse — e.g. prove
   `theorem neg_seven : intRing.addGrp.toGroup.inv 7 = -7 := rfl` and, in
   a comment, state why `rfl` alone suffices here (compare to Theorem 2's
   proof, which required real work precisely because `a` was an unknown
   variable rather than a concrete numeral).

Solutions: [Appendix, Chapter 9](../14-appendix-solutions/07-chapter-9.md).

## Next

Continue to [Chapter 10: Modules over a ring](../10-modules/00-index.md).

---

[← Theorem 2](03-theorem-2.md) | [Index](00-index.md) | [Table of contents](../README.md) | [Ch. 10: Modules →](../10-modules/00-index.md)

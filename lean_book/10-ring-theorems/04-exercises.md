## Exercises

[← Theorem 2](03-theorem-2.md) | [Index](00-index.md)

---

**Key points.** $a\cdot 0=0$ and $(-1)\cdot a=-a$ are theorems, not axioms,
both derived from distributivity plus additive cancellation, following
the same "pad with $0=0+0$, then cancel" pattern each time. A concrete
numeral (`neg_seven`) can close by `rfl` where the general statement about
an unknown `a` genuinely cannot, mirroring the defeq-vs-propeq distinction of Chapter 6.

1. Prove
   `theorem neg_mul (a b : R) : Rg.mul (Rg.addGrp.toGroup.inv a) b = Rg.addGrp.toGroup.inv (Rg.mul a b)`.
   Strategy, this is "show $x = -(ab)$," hence reduce through
   `left_inverse_unique` to "show $x + ab = 0$," then look for a
   `right_distrib`-shaped simplification of $(-a)\cdot b + a \cdot b$,
   exactly as in Theorem 2. `mul_zero_left` (proved in the section for Theorem 2)
   is required at the end, the same way Theorem 2 itself used it.
2. Instantiate `left_inverse_unique` (Chapter 8) directly on the additive group of `intRing`
   to compute a concrete additive inverse, e.g. prove
   `theorem neg_seven : intRing.addGrp.toGroup.inv 7 = -7 := rfl` and, in
   a comment, state why `rfl` alone suffices here (compare to the proof of Theorem 2,
   which required real work precisely because `a` was an unknown
   variable rather than a concrete numeral).

Solutions, [Appendix, Chapter 10](../15-appendix-solutions/10-chapter-10.md).

## Next

Continue to [Chapter 11: Modules over a ring](../11-modules/00-index.md).

---

[← Theorem 2](03-theorem-2.md) | [Index](00-index.md) | [Table of contents](../README.md) | [Ch. 11: Modules →](../11-modules/00-index.md)

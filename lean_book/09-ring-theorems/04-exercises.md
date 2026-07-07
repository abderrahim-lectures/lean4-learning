## Exercises

[← Theorem 2](03-theorem-2.md) | [Index](00-index.md)

---

1. Prove `theorem mul_zero_left (a : R) : Rg.mul Rg.addGrp.id a = Rg.addGrp.id`
   by mirroring Theorem 1's proof line by line, swapping `left_distrib` for
   `right_distrib`. Before writing any Lean, write the two-line paper sketch
   (à la Theorem 1's `$a \cdot 0 = a\cdot(0+0) = \ldots$`) yourself first.
2. Prove
   `theorem neg_mul (a b : R) : Rg.mul (Rg.addGrp.toGroup.inv a) b = Rg.addGrp.toGroup.inv (Rg.mul a b)`.
   Strategy: this is "show $x = -(ab)$," so reduce via `left_inverse_unique`
   to "show $x + ab = 0$," then look for a `right_distrib`-shaped
   simplification of $(-a)\cdot b + a \cdot b$, exactly as in Theorem 2.

Solutions: [Appendix, Chapter 9](../14-appendix-solutions/07-chapter-9.md).

## Next

Continue to [Chapter 10: Modules over a ring](../10-modules/00-index.md).

---

[← Theorem 2](03-theorem-2.md) | [Index](00-index.md) | [Table of contents](../README.md) | [Ch. 10: Modules →](../10-modules/00-index.md)

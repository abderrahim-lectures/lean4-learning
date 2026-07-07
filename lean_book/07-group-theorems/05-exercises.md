## Exercises

[← Theorem 3](04-theorem-3.md) | [Index](00-index.md)

---

1. Prove `theorem inv_inv (a : G) : Grp.inv (Grp.inv a) = a`. Before writing
   any tactics, ask: does this match the shape of a lemma you already have
   (Theorem 2 again)? What single fact about `a` and `Grp.inv a` would let
   you invoke it directly?
2. Prove `theorem cancel_left (a b c : G) (h : Grp.op a b = Grp.op a c) : b = c`.
   Strategy hint: you cannot directly rewrite `b` or `c` in isolation —
   instead, apply `Grp.op (Grp.inv a)` to *both sides* of `h` first (as a
   `have`), then simplify each side down using `assoc`/`inv_left`/`id_left`,
   the same "regroup, then cancel" pattern as Theorem 3.

Solutions: [Appendix, Chapter 7](../14-appendix-solutions/05-chapter-7.md).

## Next

Continue to [Chapter 8: Rings](../08-rings/00-index.md).

---

[← Theorem 3](04-theorem-3.md) | [Index](00-index.md) | [Table of contents](../README.md) | [Ch. 8: Rings →](../08-rings/00-index.md)

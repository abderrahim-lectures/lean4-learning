## Exercises

[← Theorem 3](04-theorem-3.md) | [Index](00-index.md)

---

1. Prove `theorem inv_inv (a : G) : Grp.inv (Grp.inv a) = a`. Before writing
   any tactics, consider: does this match the shape of a lemma already in
   hand (Theorem 2 again)? What single fact about `a` and `Grp.inv a` would
   permit invoking it directly?
2. Prove `theorem cancel_left (a b c : G) (h : Grp.op a b = Grp.op a c) : b = c`.
   Strategy hint: `b` and `c` cannot be rewritten directly in isolation.
   Instead, apply `Grp.op (Grp.inv a)` to *both sides* of `h` first (as a
   `have`), then simplify each side using `assoc`/`inv_left`/`id_left`, the
   same "regroup, then cancel" pattern as Theorem 3.

Solutions: [Appendix, Chapter 7](../14-appendix-solutions/06-chapter-7.md).

## Next

Continue to [Chapter 8: Rings](../08-rings/00-index.md).

---

[← Theorem 3](04-theorem-3.md) | [Index](00-index.md) | [Table of contents](../README.md) | [Ch. 8: Rings →](../08-rings/00-index.md)

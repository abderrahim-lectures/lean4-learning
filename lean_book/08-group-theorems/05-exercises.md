## Exercises

[← Theorem 3](04-theorem-3.md) | [Index](00-index.md)

---

**Key points.** Three facts now hold for *every* group, the identity is
unique, a left inverse equals the (unique) two-sided inverse, and
$(ab)^{-1}=b^{-1}a^{-1}$. The recurring proof pattern is relating both
sides of a goal to a common third expression, or padding with the
identity and cancelling. Once a uniqueness fact is proved, later goals
can be *characterized* by it instead of computed directly.

1. The proof of `id_unique` related `e'` and `Grp.id` to a common third
   expression, `Grp.op e' Grp.id`. Explain whether the same proof could
   have gone through by relating them to `Grp.op Grp.id e'` instead, given
   that `h` only says something about `Grp.op e' a` for arbitrary `a`, and
   nothing about `Grp.op a e'`.
2. `inv_op` proved $(ab)^{-1}=b^{-1}a^{-1}$ by showing $b^{-1}a^{-1}$ is a
   left inverse of $ab$, rather than computing $(ab)^{-1}$ directly.
   Explain whether the axioms of `Group` offer any way to compute it
   directly, and if not, why not.
3. Prove `theorem inv_inv (a : G) : Grp.inv (Grp.inv a) = a`. Before writing
   any tactics, consider whether this matches the shape of a lemma already in
   hand (Theorem 2 again). What single fact about `a` and `Grp.inv a` would
   permit invoking it directly?
4. Prove `theorem cancel_left (a b c : G) (h : Grp.op a b = Grp.op a c) : b = c`.
   Strategy hint, `b` and `c` cannot be rewritten directly in isolation.
   Instead, apply `Grp.op (Grp.inv a)` to *both sides* of `h` first (as a
   `have`), then simplify each side using `assoc`/`inv_left`/`id_left`, the
   same "regroup, then cancel" pattern as Theorem 3.

Solutions, [Appendix, Chapter 8](../15-appendix-solutions/08-chapter-8.md).

## Next

Continue to [Chapter 9: Rings](../09-rings/00-index.md).

---

[← Theorem 3](04-theorem-3.md) | [Index](00-index.md) | [Table of contents](../README.md) | [Ch. 9: Rings →](../09-rings/00-index.md)

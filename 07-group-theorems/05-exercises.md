## Exercises

[← Theorem 3](04-theorem-3.md) | [Index](00-index.md)

---

**Key points.** Three facts now hold for *every* group: the identity is
unique, a left inverse equals the (unique) two-sided inverse, and
$(ab)^{-1}=b^{-1}a^{-1}$. The recurring proof pattern is relating both
sides of a goal to a common third expression, or padding with the
identity and cancelling; once a uniqueness fact is proved, later goals
can be *characterized* by it instead of computed directly.

**Socratic questions.**

1. *`id_unique`'s proof related `e'` and `Grp.id` to a common third
   expression, `Grp.op e' Grp.id`. Could the same proof have gone through
   by relating them to `Grp.op Grp.id e'` instead?* Not directly — `h`
   (the hypothesis that `e'` is a *left* identity) only says something
   about `Grp.op e' a` for arbitrary `a`; it says nothing about
   `Grp.op a e'`. The proof has to route through the one expression both
   given facts actually describe, not just any expression that happens
   to involve both sides.
2. *`inv_op` proved $(ab)^{-1}=b^{-1}a^{-1}$ by showing $b^{-1}a^{-1}$ is
   a left inverse of $ab$, rather than computing $(ab)^{-1}$ directly.
   Was there ever a way to compute it directly?* Not from the axioms
   alone — `Group` has no field that produces `inv` of a *product* in
   closed form, only `inv` of a single element. Reducing "compute this"
   to "verify this satisfies the defining property" is not a shortcut
   taken for convenience; it is the only route the axioms actually offer.
3. *Both `id_unique` and `left_inverse_unique` conclude an equation
   between two elements neither of which was "computed." What do their
   proofs have in common that makes this possible?* Each relates both
   sides to one common expression via two *separate* facts, then chains
   the two equalities — never squeezing a value out of thin air, only
   noticing that two different routes describe the same thing.

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

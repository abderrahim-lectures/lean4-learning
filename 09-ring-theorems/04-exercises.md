## Exercises

[← Theorem 2](03-theorem-2.md) | [Index](00-index.md)

---

**Key points.** $a\cdot 0=0$ and $(-1)\cdot a=-a$ are theorems, not axioms,
both derived from distributivity plus additive cancellation, following
the same "pad with $0=0+0$, then cancel" pattern each time. A concrete
numeral (`neg_seven`) can close by `rfl` where the general statement about
an unknown `a` genuinely cannot, mirroring the defeq-vs-propeq distinction of Chapter 5.

**Socratic questions.**

1. *$a \cdot 0 = 0$ is proved from distributivity and cancellation, not
   assumed. Could a ring exist where this fails?* Not among the `Ring`s
   of Lean. The proof uses only `left_distrib` and the additive group
   axioms, which every `Ring` supplies by definition, so the conclusion
   is forced. A structure lacking it would simply not satisfy the fields
   of `Ring` itself, whatever else it looked like.
2. *The proof of $a \cdot 0 = 0$ starts from $0 = 0 + 0$, an identity
   that looks almost too trivial to be useful. Why does such a
   trivial-looking fact do real work?* Because it converts a goal
   *about* $0$ into a goal about $x = x + x$ for $x := a \cdot 0$, which
   is exactly the shape "an additive-group element equal to its own
   double is the identity" already known how to cancel. Trivial
   identities are frequently the hinge a whole proof turns on, not
   padding.
3. *`neg_seven` closes by `rfl`; the general `neg_one_mul (a : R)` needed
   a five-line proof for the *same* underlying fact. What exactly is
   different about the general statement?* `neg_seven` names one
   concrete, already-computed integer. Both sides reduce to `-7`
   directly. `neg_one_mul` quantifies over *every* ring `R` and element
   `a`. There is no concrete value to reduce, so the equality must be
   established from the axioms rather than read off by computation.

1. Prove
   `theorem neg_mul (a b : R) : Rg.mul (Rg.addGrp.toGroup.inv a) b = Rg.addGrp.toGroup.inv (Rg.mul a b)`.
   Strategy: this is "show $x = -(ab)$," hence reduce through
   `left_inverse_unique` to "show $x + ab = 0$," then look for a
   `right_distrib`-shaped simplification of $(-a)\cdot b + a \cdot b$,
   exactly as in Theorem 2. `mul_zero_left` (proved in the section for Theorem 2)
   is required at the end, the same way Theorem 2 itself used it.
2. Instantiate `left_inverse_unique` (Chapter 7) directly on the additive group of `intRing`
   to compute a concrete additive inverse, e.g. prove
   `theorem neg_seven : intRing.addGrp.toGroup.inv 7 = -7 := rfl` and, in
   a comment, state why `rfl` alone suffices here (compare to the proof of Theorem 2,
   which required real work precisely because `a` was an unknown
   variable rather than a concrete numeral).

Solutions: [Appendix, Chapter 9](../14-appendix-solutions/08-chapter-9.md).

## Next

Continue to [Chapter 10: Modules over a ring](../10-modules/00-index.md).

---

[← Theorem 2](03-theorem-2.md) | [Index](00-index.md) | [Table of contents](../README.md) | [Ch. 10: Modules →](../10-modules/00-index.md)

# Chapter 9: Ring examples and basic theorems

[← Ch. 8: Rings](../08-rings/00-index.md) | [Table of contents](../README.md) | [Ch. 10: Modules →](../10-modules/00-index.md)

---

## Learning objectives

- Derive a ring fact that is *not* an axiom (e.g. $a\cdot 0=0$) from the axioms that are.
- Spot when a "mirror" proof (`left_distrib` vs. `right_distrib`) can be copied line-by-line rather than re-derived.
- Reduce a "compute this" goal to a "verify this satisfies the characterizing property" goal via a previously-proved uniqueness lemma.

As in Chapter 7, the point here is the search process for each proof, not
just the final term. Ring proofs are a good test of that process,
because the goals become visually noisy fast (nested `addGrp.toGroup.op`
everywhere). The skill under development is avoiding getting lost in that
noise, and instead tracking which algebraic fact is one step away from use.

## The story of this chapter

Chapter 8 built rings one concrete carrier at a time — `Int`, `Fin 3`,
$2\times 2$ matrices — reverifying the same axioms by hand for each.
Chapter 7 already showed the way out of that repetition for groups; this
chapter repeats it for rings, and each section follows from the last:

1. **How is a theorem about "every ring" even stated, mirroring what
   Chapter 7 did for groups?** ([Section 1](01-setup.md)) Fix an
   arbitrary `Rg : Ring R` with `variable`, exactly as Chapter 7 fixed an
   arbitrary `Grp : Group G` — with the added complication that qualified
   field names now nest two structures deep (`Rg.addGrp.toGroup.inv`),
   so a mental dictionary back to ordinary `+`/`×`/`0`/`1` notation is
   worth keeping close at hand.
2. **What is the first fact worth proving this way, given that `Ring`'s
   axioms say nothing directly about `0` and multiplication?**
   ([Section 2](02-theorem-1.md)) $a \cdot 0 = 0$ — not an axiom, but a
   consequence of distributivity plus the additive cancellation Chapter 7
   already established, recognized by rewriting $0$ as $0+0$ and treating
   the resulting equation as the purely group-theoretic fact "an element
   equal to its own double is zero."
3. **Does the same reasoning extend to a genuinely new claim, the sign
   rule $(-1)\cdot a = -a$?** ([Section 3](03-theorem-2.md)) Yes, by
   reusing Chapter 7's `left_inverse_unique` directly: showing $(-1)\cdot
   a$ satisfies the *characterizing* equation for $-a$ is easier than
   computing $-a$ from scratch, and the proof needs a mirror image of
   Theorem 1 (`right_distrib` in place of `left_distrib`) obtained by
   copying the earlier proof line for line rather than reinventing it.

Two theorems, each reducing a ring-shaped goal to a group-shaped one
already solved in Chapter 7, complete Part II's abstract-algebra core:
groups, then rings built on top of them, each with a small library of
theorems proved once and inherited by every carrier built so far.

## Sections

1. [Setup](01-setup.md)
2. [Theorem 1: multiplication by zero gives zero](02-theorem-1.md)
3. [Theorem 2: $(-1) \cdot a = -a$](03-theorem-2.md)
4. [Exercises](04-exercises.md)

---

[← Ch. 8: Rings](../08-rings/00-index.md) | [Table of contents](../README.md) | [Ch. 10: Modules →](../10-modules/00-index.md)

# Chapter 8: Rings — adding a second operation

[← Ch. 7: Group Theorems](../07-group-theorems/00-index.md) | [Table of contents](../README.md) | [Ch. 9: Ring Theorems →](../09-ring-theorems/00-index.md)

---

## The story of this chapter

Chapter 7 finished everything Part II had to say about a single
operation. A ring is what happens once a second operation is added
alongside it, and each section below follows from that one change:

1. **What, precisely, changes when a second operation is layered onto a
   group?** ([Section 1](01-definition.md)) The additive side must now be
   commutative, and a compatible multiplication is added, tied to
   addition by the distributive laws — stated first as ordinary axioms
   (R1)–(R4), the way Chapter 6 opened with the group axioms before any
   Lean.
2. **Axiom (R1) demands *commutative* addition — but Chapter 6's `Group`
   said nothing about commutativity. Where does that requirement come
   from in Lean?** ([Section 2](02-comm-group.md)) `CommGroup`, a small
   `extends Group G` with one extra field, `comm`. This is the piece
   `Ring` will bundle as its additive part.
3. **With that piece in hand, what does the full `Ring` structure look
   like?** ([Section 3](03-ring.md)) `CommGroup` supplies (R1) as a single
   nested field, and the remaining axioms (R2)–(R4) are added directly:
   multiplication's associativity, its identity, and the two distributive
   laws.
4. **Is the definition non-vacuous?** ([Section 4](04-integers-example.md))
   Yes — $(\mathbb{Z}, +, \times, 0, 1)$, reusing Chapter 6's `intGroup`
   for the additive part and citing one core-library lemma per remaining
   axiom, exactly the pattern Chapter 6 used for `Group`.
5. **`intRing` is commutative and infinite — does every ring axiom have to
   be proved this way, one library citation at a time?**
   ([Section 5](05-finite-ring-example.md)) Not when the carrier is
   finite: $\mathbb{Z}/3\mathbb{Z}$'s axioms are decidable statements
   about only finitely many elements, so `decide` can check them by brute
   enumeration instead.
6. **How is this structure's data actually used, now that it nests a
   whole `CommGroup` inside it?** ([Section 6](06-accessing-fields.md))
   By ordinary field projection, chained one level deeper than Chapter 6
   — `Rg.addGrp.op` rather than a single `Grp.op`.
7. **`intRing` is commutative — does anything in `Ring`'s definition
   actually forbid that, the way Chapter 6's permutations tested `Group`
   for hidden commutativity assumptions?** ([Section 7](07-matrices.md))
   No, and $2\times 2$ integer matrices prove it directly: a concrete,
   genuinely noncommutative ring, built and verified field by field with
   no shortcuts available.

By the end of the chapter, `Ring` has the same shape `Group` did at the
end of Chapter 6: a precise definition, both a commutative and a
noncommutative witness that it is satisfiable, and — as Chapter 9 takes
up next — theorems still waiting to be proved generically rather than
per carrier.

## Sections

1. [The mathematical definition](01-definition.md)
2. [`CommGroup`: extending `Group` with one extra axiom](02-comm-group.md)
3. [`Ring`: bundling an additive `CommGroup` with multiplication](03-ring.md)
4. [Example: the integers as a ring](04-integers-example.md)
5. [Example: a finite commutative ring, $\mathbb{Z}/3\mathbb{Z}$](05-finite-ring-example.md)
6. [Accessing nested fields](06-accessing-fields.md)
7. [Example: 2×2 matrices — a genuinely noncommutative ring](07-matrices.md)
8. [Exercises](08-exercises.md)

---

[← Ch. 7: Group Theorems](../07-group-theorems/00-index.md) | [Table of contents](../README.md) | [Ch. 9: Ring Theorems →](../09-ring-theorems/00-index.md)

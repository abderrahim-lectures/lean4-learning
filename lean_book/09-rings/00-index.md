# Chapter 9: Rings — adding a second operation

[← Ch. 8: Group Theorems](../08-group-theorems/00-index.md) | [Table of contents](../README.md) | [Ch. 10: Ring Theorems →](../10-ring-theorems/00-index.md)

---

## Learning objectives

- Translate the ring axioms into a Lean `structure` built on top of `CommGroup`.
- Build both a commutative (`Int`, `Fin 3`) and a genuinely noncommutative (2×2 matrices) example from scratch.
- Recognize when a finite carrier lets `decide` replace a hand-written proof.

## What a second operation forces

Chapter 8 finished everything Part II had to say about a single
operation. What changes, precisely, once a second operation is layered
onto a group? The additive side must now be commutative — otherwise the
distributive laws below cannot be stated symmetrically — and a compatible
multiplication is added, tied to addition by distributivity. These are
stated first as ordinary axioms (R1)–(R4)
([Section 1](01-definition.md)), the way Chapter 7 opened with the group
axioms before any Lean. Axiom (R1) demands *commutative* addition, but
`Group` from Chapter 7 said nothing about commutativity, so that
requirement has to be built in Lean before `Ring` itself can be:
`CommGroup`, a small `extends Group G` with one extra field, `comm`
([Section 2](02-comm-group.md)), is the piece `Ring` bundles as its
additive part. With that piece in hand, `CommGroup` supplies (R1) as a
single nested field, and the remaining axioms (R2)–(R4), associativity of
multiplication, its identity, and the two distributive laws, are added
directly ([Section 3](03-ring.md)).

A definition earns its keep only once it is shown non-vacuous. The most
familiar witness is $(\mathbb{Z}, +, \times, 0, 1)$, reusing `intGroup`
from Chapter 7 for the additive part and citing one core-library lemma
per remaining axiom, exactly the pattern Chapter 7 used for `Group`
([Section 4](04-integers-example.md)). `intRing` is commutative and
infinite; not every ring axiom needs to be proved that way, one library
citation at a time. When the carrier is finite, the axioms of
$\mathbb{Z}/3\mathbb{Z}$ become decidable statements about only finitely
many elements, and `decide` checks them by brute enumeration instead
([Section 5](05-finite-ring-example.md)). Once a `Ring` value nests a
whole `CommGroup` inside it, its data is used exactly as before, by
ordinary field projection, chained one level deeper than Chapter 7,
`Rg.addGrp.op` rather than a single `Grp.op`
([Section 6](06-accessing-fields.md)).

`intRing` is commutative, but nothing in the definition of `Ring` forces
that, the same question permutations settled for `Group` in Chapter 7.
$2\times 2$ integer matrices settle it directly for rings, a concrete,
genuinely noncommutative ring, built and verified field by field with no
shortcuts available ([Section 7](07-matrices.md)). By the end of the
chapter, `Ring` has the same shape `Group` did at the end of Chapter 7: a
precise definition, both a commutative and a noncommutative witness that
it is satisfiable, and, as Chapter 10 takes up next, theorems still
waiting to be proved generically rather than per carrier.

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

[← Ch. 8: Group Theorems](../08-group-theorems/00-index.md) | [Table of contents](../README.md) | [Ch. 10: Ring Theorems →](../10-ring-theorems/00-index.md)

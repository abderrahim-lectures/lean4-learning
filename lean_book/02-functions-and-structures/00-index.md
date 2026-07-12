# Chapter 2: Functions, definitions, and structures

[← Ch. 1: Basics](../01-basics/00-index.md) | [Table of contents](../README.md) | [Ch. 3: Propositions & Proofs →](../03-propositions-and-proofs/00-index.md)

---

Functions **curry**: `add : Nat → Nat → Nat` is really
`Nat → (Nat → Nat)`, a function that returns another function. So a
"two-argument function" is just a one-argument function whose result is
itself another function. It takes one argument at a time. (If you already
think categorically: this is the type-theoretic form of the Hom-set
isomorphism
$\mathrm{Hom}(A\times B, C)\cong\mathrm{Hom}(A,\mathrm{Hom}(B,C))$. A
two-argument map is the same data as a one-argument map into a space of
maps. But you don't need this to follow along — the plain statement above
is enough.) The interesting part of this chapter is `structure`, which is
how we'll package algebraic data.

## Sections

1. [`structure`: bundling data together](01-structure-basics.md)
2. [Structures with type parameters](02-type-parameters.md)
3. [Extending structures](03-extending-structures.md)

---

[← Ch. 1: Basics](../01-basics/00-index.md) | [Table of contents](../README.md) | [Ch. 3: Propositions & Proofs →](../03-propositions-and-proofs/00-index.md)

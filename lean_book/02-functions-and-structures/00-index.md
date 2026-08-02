# Chapter 2: Functions, definitions, and structures

[← Ch. 1: Basics](../01-basics/00-index.md) | [Table of contents](../README.md) | [Ch. 3: Propositions & Proofs →](../03-propositions-and-proofs/00-index.md)

---

Functions **curry**: `add : Nat → Nat → Nat` is really
`Nat → (Nat → Nat)`, a function that returns another function. So a
"two-argument function" is just a one-argument function whose result is
itself another function. It takes one argument at a time. (For readers
already thinking categorically: this is the type-theoretic form of the
Hom-set isomorphism
$\mathrm{Hom}(A\times B, C)\cong\mathrm{Hom}(A,\mathrm{Hom}(B,C))$. A
two-argument map is the same data as a one-argument map into a space of
maps. This is not needed to follow along — the plain statement above is
enough.) The interesting part of this chapter is `structure`, which is
how algebraic data will be packaged.

## The story of this chapter

As in Chapter 1, each section below answers a question forced by the one
before it:

1. **A function takes its arguments one at a time — so how does several
   pieces of data that belong *together*, like a point's `x` and `y`,
   get treated as a single value instead of two arguments a caller has
   to keep in sync by hand?** ([Section 1](01-structure-basics.md))
   `structure` bundles named fields under one type, built with the
   anonymous constructor `⟨...⟩` and read back out by field projection
   `.field`. This is the packaging mechanism every algebraic object from
   Chapter 6 onward — a group, later a ring — is built from.
2. **`Point` bundles two `Nat`s specifically. What if the same shape of
   bundling is needed for *any* pair of types, not just `Nat` and
   `Nat`?** ([Section 2](02-type-parameters.md)) A `structure` can be
   parameterized by a type, the same way `identity` in Chapter 1 was
   parameterized by `{α : Type}` — `Pair α β` is not one structure but a
   whole family of them, one per choice of `α` and `β`, which is exactly
   the shape `Group (G : Type)` will need later.
3. **Some structures are not built from scratch — they are an existing
   structure plus one more piece. How does Lean avoid re-declaring every
   inherited field by hand each time?** ([Section 3](03-extending-structures.md))
   `extends` builds a new structure containing an old one whole, plus
   more, generating a forgetful `.toX` projection for free — the exact
   mechanism a `CommGroup` will use in Chapter 6 to add commutativity to
   `Group` without repeating the group axioms.

By the end of the chapter, `structure` is no longer just a convenient
keyword for grouping fields — it is the bundling-and-forgetting
machinery every algebraic structure in the rest of this book depends on.

## Sections

1. [`structure`: bundling data together](01-structure-basics.md)
2. [Structures with type parameters](02-type-parameters.md)
3. [Extending structures](03-extending-structures.md)

---

[← Ch. 1: Basics](../01-basics/00-index.md) | [Table of contents](../README.md) | [Ch. 3: Propositions & Proofs →](../03-propositions-and-proofs/00-index.md)

# Chapter 3: Functions, definitions, and structures

[← Ch. 2: Terminology & CoC](../02-terminology-and-coc/00-index.md) | [Table of contents](../README.md) | [Ch. 4: Propositions & Proofs →](../04-propositions-and-proofs/00-index.md)

---

## Learning objectives

- Bundle data (and proofs) into a `structure`.
- Use field projection and the anonymous constructor.
- Parameterize a `structure` by a type.
- Extend one `structure` with another via `extends`.

Every function type built so far, `Nat → Nat`, `Bool → Nat`, takes exactly
one argument. What type, then, does `add : Nat → Nat → Nat` actually have?
Reading the arrow as right-associative, it parses as `Nat → (Nat → Nat)`:
a function taking one `Nat` and returning *another function*, `Nat → Nat`.
So `add 3 : Nat → Nat` is a genuine value, the "add 3 to something"
function, before it is ever applied to a second argument. A "two-argument
function" is nothing but a one-argument function whose result happens to
be itself another function, applied one argument at a time. This pattern
is called **currying**, and it is the type-theoretic form of the Hom-set
isomorphism
$\mathrm{Hom}(A\times B, C)\cong\mathrm{Hom}(A,\mathrm{Hom}(B,C))$: a
two-argument map is the same data as a one-argument map into a space of
maps. The interesting part of this chapter is `structure`, which is
how algebraic data will be packaged.

## What forces `structure`

A function takes its arguments one at a time, currying, as the section
above just showed. That leaves open how several pieces of data belonging
*together*, like the `x` and `y` of a point, get treated as a single
value instead of two arguments a caller must keep in sync by hand.
[Section 1](01-structure-basics.md) answers this: `structure` bundles
named fields under one type, built with the anonymous constructor `⟨...⟩`
and read back out by field projection `.field`. This is the packaging
mechanism every algebraic object from Chapter 7 onward, a group, later a
ring, is built from.

`Point` bundles two `Nat`s specifically. The same shape of bundling is
needed for *any* pair of types, not just `Nat` and `Nat`.
[Section 2](02-type-parameters.md) parameterizes a `structure` by a type,
the same way `identity` in Chapter 1 was parameterized by `{α : Type}`.
`Pair α β` is not one structure but a whole family of them, one per
choice of `α` and `β`, exactly the shape `Group (G : Type)` will need
later.

Some structures are not built from scratch; they are an existing
structure plus one more piece. Re-declaring every inherited field by hand
each time does not scale. [Section 3](03-extending-structures.md) gives
`extends`, which builds a new structure containing an old one whole, plus
more, generating a forgetful `.toX` projection for free, the exact
mechanism a `CommGroup` will use in Chapter 7 to add commutativity to
`Group` without repeating the group axioms.

By the end of the chapter, `structure` is no longer just a convenient
keyword for grouping fields. It is the bundling-and-forgetting
machinery every algebraic structure in the rest of this book depends on.

## Sections

1. [`structure`: bundling data together](01-structure-basics.md)
2. [Structures with type parameters](02-type-parameters.md)
3. [Extending structures](03-extending-structures.md)
4. [Exercises](04-exercises.md)

---

[← Ch. 2: Terminology & CoC](../02-terminology-and-coc/00-index.md) | [Table of contents](../README.md) | [Ch. 4: Propositions & Proofs →](../04-propositions-and-proofs/00-index.md)

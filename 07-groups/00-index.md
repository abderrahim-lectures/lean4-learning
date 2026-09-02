# Chapter 7: Structures and classes — defining a `Group`

[← Ch. 6: Rigor Check](../06-rigor-check/00-index.md) | [Table of contents](../README.md) | [Ch. 8: Group Theorems →](../08-group-theorems/00-index.md)

---

## Learning objectives

- Translate the mathematical definition of a group into a Lean `structure` field by field.
- Build both an abelian (`Int`) and a genuinely non-abelian (permutations of `Fin 3`) example from scratch.
- Articulate why bundling data with proof obligations pays off once theorems are proved generically (Chapter 8).

## What forces the definition

The checkpoint project of Chapter 6 built a `Monoid`: an associative
operation with a two-sided identity, no inverses. One question drives this
chapter: what is the weakest extra condition that makes every element
undoable? Requiring an inverse function $(-)^{-1}$ with $a \cdot a^{-1} =
a^{-1} \cdot a = e$ is the smallest addition that does this, and it is
exactly what a **group** is ([Section 1](01-definition.md)).

A definition earns its keep only if it is realizable in Lean and
non-vacuous. Realizing it means specifying the recipe: bundle the raw
signature `GroupData` first, then add one proof field per axiom to get
`Group` ([Section 2](02-translating.md)). Non-vacuous means exhibiting an
inhabitant: $(\mathbb{Z}, +, 0, -)$ satisfies all five axioms, citing one
core-library lemma per axiom ([Section 3](03-integers-example.md)).

`intGroup` is commutative, so it cannot tell `id_left` apart from
`id_right`, or `inv_left` from `inv_right`, since in an abelian group
these coincide. Whether the left/right split in the definition is doing real
work, rather than overcaution, can only be settled by a genuinely
non-abelian example: the permutations of a 3-element set, built the same
way, field by field, with both directions checked honestly
([Section 4](04-permutations-example.md)). They are not interchangeable
there.

With two concrete groups built, their data is used exactly as any
`structure`'s fields are used since Chapter 3, by projection, whether the
field holds data or a proof ([Section 5](05-accessing-fields.md)). The
return on building `Group G` generically, rather than writing `intGroup`
and `perm3Group` as unrelated one-off definitions, is that a theorem
proved once about an arbitrary `Group G` applies to both without further
work ([Section 6](06-why-bundle.md)); Chapter 8 carries this out.

## Sections

1. [The mathematical definition](01-definition.md)
2. [Translating the definition into a Lean `structure`](02-translating.md)
3. [A first example: the integers under addition](03-integers-example.md)
4. [A non-abelian example: permutations of three elements](04-permutations-example.md)
5. [Accessing the fields](05-accessing-fields.md)
6. [Why bundle proofs with data at all?](06-why-bundle.md)
7. [Exercises](07-exercises.md)

Starting with this chapter, most examples are followed by a "Mathlib
equivalent" box (see [00-setup/04-mathlib-note.md](../00-setup/04-mathlib-note.md)).
For links to the official docs for every Mathlib name used in those
boxes, see the [tactic and library reference](../tactic-and-library-reference.md).

---

[← Ch. 6: Rigor Check](../06-rigor-check/00-index.md) | [Table of contents](../README.md) | [Ch. 8: Group Theorems →](../08-group-theorems/00-index.md)

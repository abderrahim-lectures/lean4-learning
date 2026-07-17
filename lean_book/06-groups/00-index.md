# Chapter 6: Structures and classes — defining a `Group`

[← Ch. 5: Rigor Check](../05-rigor-check/00-index.md) | [Table of contents](../README.md) | [Ch. 7: Group Theorems →](../07-group-theorems/00-index.md)

---

**Learning objectives.** By the end of this chapter, translate the
mathematical definition of a group into a Lean `structure` field by
field, build both an abelian (`Int`) and a genuinely non-abelian
(permutations of `Fin 3`) example from scratch, and articulate why
bundling data with proof obligations pays off once theorems are proved
generically (Chapter 7).

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

[← Ch. 5: Rigor Check](../05-rigor-check/00-index.md) | [Table of contents](../README.md) | [Ch. 7: Group Theorems →](../07-group-theorems/00-index.md)

# Chapter 6: Structures and classes — defining a `Group`

[← Ch. 5: Rigor Check](../05-rigor-check/00-index.md) | [Table of contents](../README.md) | [Ch. 7: Group Theorems →](../07-group-theorems/00-index.md)

---

## Learning objectives

- Translate the mathematical definition of a group into a Lean `structure` field by field.
- Build both an abelian (`Int`) and a genuinely non-abelian (permutations of `Fin 3`) example from scratch.
- Articulate why bundling data with proof obligations pays off once theorems are proved generically (Chapter 7).

## The story of this chapter

The checkpoint project of Chapter 5 already built a `Monoid`, data plus proof
obligations, bundled in a `structure`, using nothing but Chapters 1–5.
Each section below asks the next question that answer forces.

1. **A monoid has an associative operation and an identity. What is
   missing to reach the structures Part II is actually about?**
   ([Section 1](01-definition.md)) One axiom: every element must be
   invertible. Adding it to the data of the monoid turns "a set with an
   associative operation" into a **group**, stated first in ordinary
   mathematical notation before any Lean is written.
2. **How does that mathematical definition become an actual Lean type?**
   ([Section 2](02-translating.md)) Field by field. First the raw data
   (`GroupData`, no axioms), then the same data with one proof-obligation
   field added per axiom (`Group`). This is the general recipe used
   throughout the book, applied here for the first time to something with
   this many moving parts.
3. **Is the definition non-vacuous? Does anything actually satisfy it?**
   ([Section 3](03-integers-example.md)) Yes: $(\mathbb{Z}, +, 0, -)$,
   assembled as `intGroup` by citing one core-library lemma per axiom. But
   `intGroup` is abelian, so it never distinguishes a left inverse from a
   right one.
4. **Does that abelian example secretly rely on commutativity somewhere
   the definition of `Group` does not require it to?** ([Section 4](04-permutations-example.md))
   Building a genuinely non-abelian group, the permutations of three
   elements, forces every axiom to be checked honestly, left and right
   separately, and answers the question directly: no, nothing in `Group`
   assumes commutativity.
5. **Now that two concrete groups exist, how is their data actually used?**
   ([Section 5](05-accessing-fields.md)) The same way the fields of any structure
   are used, from Chapter 2 onward: ordinary projection, whether
   the field holds data or a proof.
6. **Two groups have now been built by hand, field by field. Is that
   effort about to be paid back?** ([Section 6](06-why-bundle.md)) Yes.
   Any theorem proved once about an arbitrary `Group G` applies
   automatically to `intGroup`, to the permutation group, and to every
   group built afterward. Chapter 7 is that payoff, carried out in full.

By the end of the chapter, `Group` is no longer just a definition sitting
on the page. It is a structure with two concrete inhabitants, one
commutative and one not, and a stated reason to keep building on it.

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

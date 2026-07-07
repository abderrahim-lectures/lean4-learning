# Chapter 5: Rigor check — structures, universes, and equality

[← Ch. 4: Tactics](../04-tactics/00-index.md) | [Table of contents](../README.md) | [Ch. 6: Groups →](../06-groups/00-index.md)

---

Before committing to `Group`'s definition in the next chapter, this short
chapter answers three questions a careful mathematician should already be
asking: why does this book use plain `structure` instead of Lean's `class`
mechanism (which is what Mathlib actually uses)? What exactly is `Type`,
and does `Group (α : Type)` really quantify over *all* types, including
`Group` itself? And when two proofs both establish `a = b`, in what sense
are they "the same"? Skipping these would leave exactly the kind of
unstated assumption a demanding reader is trained to notice and distrust.

## Sections

1. [`structure` versus `class`: why this book delays type classes](01-structure-vs-class.md)
2. [Universes: `Type`, `Type 1`, and why `Group` isn't a `Group`](02-universes.md)
3. [Definitional versus propositional equality](03-defeq-vs-propeq.md)
4. [Exercises](04-exercises.md)

---

[← Ch. 4: Tactics](../04-tactics/00-index.md) | [Table of contents](../README.md) | [Ch. 6: Groups →](../06-groups/00-index.md)

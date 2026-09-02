# Chapter 6: Rigor check — structures, universes, and equality

[← Ch. 5: Tactics](../05-tactics/00-index.md) | [Table of contents](../README.md) | [Ch. 7: Groups →](../07-groups/00-index.md)

---

## Learning objectives

- Explain why this book delays `class` in favor of `structure`.
- State the STLC typing rules and why `Type` itself needs a universe hierarchy.
- Distinguish definitional from propositional equality, and predict when `rfl` alone will and will not close a goal.

Before committing to the definition of `Group` in the next chapter, three
choices about to be made silently need to be earned first. Mathlib defines
every algebraic structure with `class`, not plain `structure`; Section 1
asks what `class` actually buys beyond `structure`, finds the answer is
exactly one mechanism (automatic instance search), and gives the reason
this book delays leaning on it. A `structure` like `Group (G : Type)` is
itself a term of some type, so Section 2 asks whether `Group` has a
`Group`-structure of its own, and the answer, no, forces the universe
hierarchy `Type : Type 1 : Type 2 : ...` into view, since `Type : Type`
would reproduce the Russell paradox. That argument leaned on an unstated
typing rule, so Section 3 states the typing rules of Lean precisely, the
three rules of the simply typed λ-calculus (Var, Abs, App) plus the
universe-formation rule of Section 2, together with the progress and
preservation theorems that are the actual reason well-typed proofs do not
go wrong. Preservation guarantees reduction never changes the type of a
term, but says nothing about when two terms *are* the same term, and
`rfl` has been used constantly since Chapter 4 without that question ever
being asked; Section 4 separates definitional equality (`rfl`, checked by
computation) from propositional equality (`=`, proved like any theorem),
close enough to blur together but diverging exactly where a failed `rfl`
needs to become legible rather than mysterious.

By the end of the chapter, three assumptions Chapter 7 is about to make
silently, `structure` over `class`, the place of `Group : Type → Type` in
the universe hierarchy, and the exact reach of `rfl`, have each been earned
rather than merely used.

## Sections

1. [`structure` versus `class`: why this book delays type classes](01-structure-vs-class.md)
2. [Universes: `Type`, `Type 1`, and why `Group` isn't a `Group`](02-universes.md)
3. [Typing rules and safety](03-typing-rules-and-safety.md)
4. [Definitional versus propositional equality](04-defeq-vs-propeq.md)
5. [Exercises](05-exercises.md)
6. [Checkpoint project: a `Monoid` from scratch](06-checkpoint-project.md)

---

[← Ch. 5: Tactics](../05-tactics/00-index.md) | [Table of contents](../README.md) | [Ch. 7: Groups →](../07-groups/00-index.md)

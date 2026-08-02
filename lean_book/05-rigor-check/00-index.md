# Chapter 5: Rigor check — structures, universes, and equality

[← Ch. 4: Tactics](../04-tactics/00-index.md) | [Table of contents](../README.md) | [Ch. 6: Groups →](../06-groups/00-index.md)

---

## Learning objectives

- Explain why this book delays `class` in favor of `structure`.
- State the STLC typing rules and why `Type` itself needs a universe hierarchy.
- Distinguish definitional from propositional equality, and predict when `rfl` alone will and will not close a goal.

Before committing to `Group`'s definition in the next chapter, this short
chapter answers three questions a careful mathematician should already be
asking. Why does this book use plain `structure` instead of Lean's `class`
mechanism, which is what Mathlib actually uses? What exactly is `Type`,
and does `Group (α : Type)` really quantify over *all* types, including
`Group` itself? And when two proofs both establish `a = b`, in what sense
are they "the same"? Skipping these would leave exactly the kind of
unstated assumption a demanding reader is trained to notice and question,
so they are addressed here, before Chapter 6 proceeds.

## The story of this chapter

Unlike Chapters 1–3, this chapter is not building new machinery toward
`Group` — it is pausing to justify choices about to be made silently.
Each section answers one of the three questions raised above, in the
order a skeptical reader would actually ask them:

1. **Mathlib defines every algebraic structure with `class`, not
   `structure`. If this book is heading toward the same kind of
   definitions, why not just use the tool the professionals use?**
   ([Section 1](01-structure-vs-class.md)) Because `class` adds exactly
   one mechanism — automatic instance search — on top of plain
   `structure`, and that mechanism is worth understanding on purpose
   before leaning on it silently. This book delays it until Chapter 6's
   intuition for `Group` is already solid.
2. **A `structure` like `Group (G : Type)` is itself a term of some
   type. So does `Group` have a `Group`-structure of its own — is
   `Group Group` a sensible thing to even ask for?** ([Section 2](02-universes.md))
   No, and the reason is load-bearing, not pedantic: `Type` cannot
   contain itself without reproducing Russell's paradox, so Lean stacks
   an infinite hierarchy of universes, and `Group : Type → Type` sits
   one level too high to ever be its own carrier.
3. **That answer leaned on a typing rule — "a Π-type built from level
   $i$ and $j$ lands in level $\max(i,j)$" — without ever stating where
   such rules come from. What *are* Lean's typing rules, precisely, and
   why should they be trusted?** ([Section 3](03-typing-rules-and-safety.md))
   The simply typed λ-calculus's three rules (Var, Abs, App), plus the
   universe-formation rule from Section 2 restated formally, together
   with the progress and preservation theorems that are the actual
   reason "well-typed proofs do not go wrong."
4. **Preservation guarantees reduction never changes a term's type —
   but it says nothing about when two terms *are* the same term. `rfl`
   has been used constantly since Chapter 3 without ever asking what
   "the same" means.** ([Section 4](04-defeq-vs-propeq.md)) Two notions,
   not one: definitional equality (`rfl`, checked by computation) and
   propositional equality (`=`, proved like any other theorem) coincide
   often enough to blur together, but knowing exactly where they part
   ways is what makes a failed `rfl` legible instead of mysterious.

By the end of the chapter, three assumptions Chapter 6 is about to make
silently — `structure` over `class`, `Group : Type → Type`'s place in
the universe hierarchy, and `rfl`'s exact reach — have each been earned
rather than merely used.

## Sections

1. [`structure` versus `class`: why this book delays type classes](01-structure-vs-class.md)
2. [Universes: `Type`, `Type 1`, and why `Group` isn't a `Group`](02-universes.md)
3. [Typing rules and safety](03-typing-rules-and-safety.md)
4. [Definitional versus propositional equality](04-defeq-vs-propeq.md)
5. [Exercises](05-exercises.md)
6. [Checkpoint project: a `Monoid` from scratch](06-checkpoint-project.md)

---

[← Ch. 4: Tactics](../04-tactics/00-index.md) | [Table of contents](../README.md) | [Ch. 6: Groups →](../06-groups/00-index.md)

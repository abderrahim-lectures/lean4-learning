# Chapter 1: First steps — terms, types, `#eval`

[← Setup](../00-setup/00-index.md) | [Table of contents](../README.md) | [Ch. 2: Terminology & CoC →](../02-terminology-and-coc/00-index.md)

---

## Learning objectives

- Read the type of a Lean term with `#check` and distinguish `#check` from `#eval`.
- Write basic `def`s with implicit arguments.
- Understand what makes a type *dependent* (via `Fin`/`Vec`).

## The story of this chapter

Every section below answers one question, and each question is forced by
the answer to the one before it. It helps to see the whole chain before
working through it line by line.

1. **What is a type, and why does Lean check it before running anything?**
   ([Section 1](01-everything-has-a-type.md)) Ordinary languages catch
   type errors, if at all, at the moment the bad line runs, possibly
   months after it shipped, on a rarely-hit branch. Lean checks the
   question "what kind of thing is this?" once, by reading the
   expression, for every possible input at once. That single idea, that
   `#check` gives a static guarantee while `#eval` gives a one-off fact, is the
   foundation everything else in this book stands on.
2. **Given that types are checked this strictly, how are new ones built,
   and how does Lean avoid forcing tedious repetition at every call
   site?** ([Section 2](02-def-let-implicit.md)) `def` and `let` are the
   two ways to name a term. Implicit arguments (`{α : Type}`) are how a
   single definition like `identity` serves *every* type at once without
   being rewritten per type. Nothing here is new machinery yet, just the
   vocabulary needed to read and write ordinary Lean definitions fluently.
3. **Is a type always fixed in advance, the way `Nat → Nat` never changes
   its output type?** ([Section 3](03-dependent-types.md)) No, and this
   is the single feature that separates a proof assistant from an
   ordinary typed language. A type can depend on a *value*, not just
   another type. `Fin n` is a different type for each `n`. The
   *return type* of a function can change depending on which argument it received. This
   is what finally lets a signature say "these two lists must have the
   same length" and have Lean enforce it, rather than merely hope for it.

That single feature, a type depending on a value, is the hook the next
chapter picks up directly. `Fin`/`Vec` are dependent types encountered
concretely here; naming the vocabulary behind them precisely, and the
formal system they are instances of, is the job of
[Chapter 2](../02-terminology-and-coc/00-index.md), not of this chapter.

## Sections

1. [Everything has a type](01-everything-has-a-type.md)
2. [`def`, `let`, implicit arguments](02-def-let-implicit.md)
3. [Dependent types, with examples](03-dependent-types.md)
4. [Exercises](04-exercises.md)

Section 2 names several binder and definition styles beyond the two of
each actually needed this early. The
"Binder & definition styles" table in the
[tactic and library reference](../tactic-and-library-reference.md)
is a standing lookup for all of them, with a pointer to wherever
each is explained in full, worth bookmarking rather than memorizing on the
first pass.

---

[← Setup](../00-setup/00-index.md) | [Table of contents](../README.md) | [Ch. 2: Terminology & CoC →](../02-terminology-and-coc/00-index.md)

# Chapter 1: First steps — terms, types, `#eval`

[← Setup](../00-setup/00-index.md) | [Table of contents](../README.md) | [Ch. 2: Terminology & CoC →](../02-terminology-and-coc/00-index.md)

---

## Learning objectives

- Read the type of a Lean term with `#check` and distinguish `#check` from `#eval`.
- Write basic `def`s with implicit arguments.
- Understand what makes a type *dependent* (via `Fin`/`Vec`).

## What Lean demands of a proof

A mathematician writes "the square root of 2 is irrational" and
sketches a few sentences. Lean demands a term whose type *is* the
statement, with every gap filled. Here is the contrast on three
statements, from trivial to open, showing what "formalized" means before
any machinery is learned.

**Example 1. Reflexivity.** "$0 = 0$."

> **Informal proof.** "Immediate."

> **Lean formalization.**
> ```lean
> theorem zero_eq_zero : (0 : Nat) = 0 := rfl
> -- rfl closes any goal of the form a = a by definition
> ```

The gap is small but already visible: even the trivial case needs a
named declaration and a tactic. A human can leave it implicit; Lean
cannot.

**Example 2. Symmetry of equality.** "If $a = b$, then $b = a$."

> **Informal proof.** "By symmetry of equality."

> **Lean formalization.**
> ```lean
> theorem symm_example {a b : Nat} (h : a = b) : b = a := h.symm
> -- h.symm is a built-in method on equality proofs,
> -- directly reflecting the symmetry axiom of Leibniz equality
> ```

A single word in the informal version ("symmetry") becomes a term-level
method call. The *structure* is the same — hypothesis in, conclusion out —
but the gap between "by symmetry" and `h.symm` is exactly the gap this
book teaches to close.

**Example 3. An open problem.** "Every even number greater than 2 is the
sum of two primes." (Goldbach's conjecture)

> **Informal proof.** "Verified up to $4 \times 10^{18}$, but unproven."

> **Lean formalization.** No term of type `∀ n, n > 2 → Even n → ∃ p q, Prime p ∧ Prime q ∧ n = p + q` exists
> in any library. Lean cannot prove it because mathematics has not proved
> it. A proof assistant does not guess; it checks. When a statement is
> open, Lean has nothing to offer, and the honest answer is a `sorry` or
> an absent file.

These three examples — closed-but-trivial, closed-but-needing-structure,
and open — set the range. Every proof in this book lives somewhere on
that line. The rest of the chapters build the vocabulary to move from
the first kind to the second, and to recognize the third for what it is.

## What forces the chapter

Ordinary languages catch a type error, if at all, at the moment the bad
line runs, possibly months after it shipped, on a rarely-hit branch. What
would it take to catch it earlier, for every possible input at once,
rather than one run at a time? Reading the expression once and deciding
"what kind of thing is this?" before ever running it, exactly what
`#check` does and `#eval` does not. [Section 1](01-everything-has-a-type.md)
draws that line, `#check` a static guarantee, `#eval` a one-off fact, the
foundation everything else in this book stands on.

Types checked this strictly still need to be built, and reused, without
rewriting a definition once per type. `def` and `let` are the two ways to
name a term; implicit arguments (`{α : Type}`) are how a single
definition like `identity` serves *every* type at once, without being
rewritten per type. [Section 2](02-def-let-implicit.md) covers this
vocabulary, no new machinery yet, just what is needed to read and write
ordinary Lean definitions fluently.

Is a type always fixed in advance, the way `Nat → Nat` never changes its
output type? No, and this is the one feature separating a proof
assistant from an ordinary typed language: a type can depend on a
*value*, not just another type. `Fin n` is a different type for each
`n`, and the *return type* of a function can change depending on which
argument it receives, letting a signature say "these two lists must have
the same length" and have Lean enforce it, rather than merely hope for
it. [Section 3](03-dependent-types.md) works this out concretely.

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

Section 2 names several binder and definition styles beyond the couple
actually needed this early. The
"Binder & definition styles" table in the
[tactic and library reference](../tactic-and-library-reference.md)
is a standing lookup for all of them, with a pointer to wherever
each is explained in full, worth bookmarking rather than memorizing on the
first pass.

---

[← Setup](../00-setup/00-index.md) | [Table of contents](../README.md) | [Ch. 2: Terminology & CoC →](../02-terminology-and-coc/00-index.md)

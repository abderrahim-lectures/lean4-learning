# Chapter 1: First steps — terms, types, `#eval`

[← Setup](../00-setup/00-index.md) | [Table of contents](../README.md) | [Ch. 2: Functions & Structures →](../02-functions-and-structures/00-index.md)

---

**Learning objectives.** By the end of this chapter, read a Lean term's
type with `#check`, distinguish `#check` from `#eval`, write basic `def`s
with implicit arguments, understand what makes a type *dependent* (via
`Fin`/`Vec`), and state precisely how Π-types, Σ-types, and `Prop`
irrelevance fit into Lean's underlying calculus.

## The story of this chapter

Every section below answers one question, and each question is forced by
the answer to the one before it. It helps to see the whole chain before
working through it line by line:

1. **What is a type, and why does Lean check it before running anything?**
   ([Section 1](01-everything-has-a-type.md)) Ordinary languages catch
   type errors, if at all, at the moment the bad line runs — possibly
   months after it shipped, on a rarely-hit branch. Lean checks the
   question "what kind of thing is this?" once, by reading the
   expression, for every possible input at once. That single idea —
   `#check` as a static guarantee, `#eval` as a one-off fact — is the
   foundation everything else in this book stands on.
2. **Given that types are checked this strictly, how are new ones built,
   and how does Lean avoid forcing tedious repetition at every call
   site?** ([Section 2](02-def-let-implicit.md)) `def` and `let` are the
   two ways to name a term; implicit arguments (`{α : Type}`) are how a
   single definition like `identity` serves *every* type at once without
   being rewritten per type. Nothing here is new machinery yet — just the
   vocabulary needed to read and write ordinary Lean definitions fluently.
3. **Is a type always fixed in advance, the way `Nat → Nat` never changes
   its output type?** ([Section 3](03-dependent-types.md)) No — and this
   is the single feature that separates a proof assistant from an
   ordinary typed language. A type can depend on a *value*, not just
   another type. `Fin n` is a different type for each `n`; a function's
   *return type* can change depending on which argument it received. This
   is what finally lets a signature say "these two lists must have the
   same length" and have Lean enforce it, rather than merely hope for it.
4. **Several words just got used informally (`elaborate`, `reduce`,
   `bound variable`, `universal property`, ...) — what do they actually
   mean?** ([Section 4](04-terminology.md)) This section is a deliberate
   pause, not a new topic: a glossary of the vocabulary already in use
   above and needed again below, defined precisely once instead of
   re-explained informally every time it recurs.
5. **`Fin`'s dependent function and `Vec`'s dependent pair-like structure
   both showed up in Section 3 — are they two unrelated tricks, or one
   idea in two shapes?** ([Section 5](05-pi-sigma-and-coc.md)) One idea:
   the Π-type (dependent function) and Σ-type (dependent pair) are dual
   generalizations of `→` and `×`, and together with `Prop`'s proof
   irrelevance they *are* the calculus of constructions — the one formal
   system every example in this chapter has secretly been an instance of
   from the very first `#check 3`.

By the last section, the informal phrase "everything has a type" from
Section 1 has turned into a precise, named formal system. Nothing along
the way is optional scaffolding to be forgotten afterward — Chapter 3's
`∀`/`∃`, Chapter 6's `Group` structure, and Chapter 11's `Path` type are
all direct, unglamorous applications of exactly what gets built here.

## Sections

1. [Everything has a type](01-everything-has-a-type.md)
2. [`def`, `let`, implicit arguments](02-def-let-implicit.md)
3. [Dependent types, with examples](03-dependent-types.md)
4. [Terminology encountered before it is fully explained](04-terminology.md)
5. [Π/Σ-types and the calculus of constructions](05-pi-sigma-and-coc.md)
6. [Exercises](06-exercises.md)

---

[← Setup](../00-setup/00-index.md) | [Table of contents](../README.md) | [Ch. 2: Functions & Structures →](../02-functions-and-structures/00-index.md)

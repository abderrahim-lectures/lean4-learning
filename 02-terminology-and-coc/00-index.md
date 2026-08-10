# Chapter 2: Terminology and the calculus of constructions

[← Ch. 1: Basics](../01-basics/00-index.md) | [Table of contents](../README.md) | [Ch. 3: Functions & Structures →](../03-functions-and-structures/00-index.md)

---

## Learning objectives

- Read `elaborate`, `reduce`, `bound variable`, `universal property`, and
  the other vocabulary used informally in Chapter 1, defined precisely.
- Recognize β-reduction, the computational engine underneath `rfl` and `#eval`.
- State precisely how Π-types, Σ-types, and `Prop` irrelevance fit into
  the underlying calculus of Lean.

## The story of this chapter

Chapter 1 built `Fin`/`Vec`, concrete dependent types, by example, and
used several words along the way (`elaborate`, `reduce`, `universal
property`, ...) informally, trusting they were clear enough from context
to keep moving. That trust gets repaid here, and the two questions this
chapter answers are forced directly by what Chapter 1 left open.

1. **Several words just got used informally. What do they actually
   mean?** ([Section 1](01-terminology.md)) This section is a deliberate
   pause, not a new topic. It is a glossary of the vocabulary already in
   use in Chapter 1 and needed again below, defined precisely once
   instead of re-explained informally every time it recurs.
2. **The dependent function of `Fin` and the dependent pair-like structure of `Vec`
   both showed up in Chapter 1. Are they two unrelated tricks, or one
   idea in two shapes?** ([Section 2](02-pi-sigma-and-coc.md)) One idea.
   The Π-type (dependent function) and Σ-type (dependent pair) are dual
   generalizations of `→` and `×`, and together with the proof
   irrelevance of `Prop` they *are* the calculus of constructions, the one formal
   system every example since the very first `#check 3` of Chapter 1 has
   secretly been an instance of.

By the end of this chapter, the informal phrase "everything has a type"
from Chapter 1, Section 1 has turned into a precise, named formal system.
Nothing along the way is optional scaffolding to be forgotten afterward.
The `∀`/`∃` of Chapter 4, the `Group` structure of Chapter 7, and the
`Path` type of Chapter 12 are all direct, unglamorous applications of
exactly what gets built here.

## Sections

1. [Terminology encountered before it is fully explained](01-terminology.md)
2. [Π/Σ-types and the calculus of constructions](02-pi-sigma-and-coc.md)
3. [Exercises](03-exercises.md)

---

[← Ch. 1: Basics](../01-basics/00-index.md) | [Table of contents](../README.md) | [Ch. 3: Functions & Structures →](../03-functions-and-structures/00-index.md)

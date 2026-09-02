# Chapter 2: Terminology and the calculus of constructions

[← Ch. 1: Basics](../01-basics/00-index.md) | [Table of contents](../README.md) | [Ch. 3: Functions & Structures →](../03-functions-and-structures/00-index.md)

---

## Learning objectives

- Read `elaborate`, `reduce`, `bound variable`, `universal property`, and
  the other vocabulary used informally in Chapter 1, defined precisely.
- Recognize β-reduction, the computational engine underneath `rfl` and `#eval`.
- State precisely how Π-types, Σ-types, and `Prop` irrelevance fit into
  the underlying calculus of Lean.

## What forces the terminology

Chapter 1 built `Fin`/`Vec`, concrete dependent types, by example, and
used words like `elaborate`, `reduce`, and `universal property` informally
along the way, trusting context to carry the meaning. That trust runs out
once the logic chapters begin, where loose use of these words would start
hiding genuine distinctions instead of merely being informal shorthand.
Fixing precise, working definitions for them, with pointers to where the
full formal treatment lives, is the entire content of
[Section 1](01-terminology.md), a deliberate pause rather than a new
topic.

The dependent function of `Fin` and the dependent pair-like structure of
`Vec` both appeared in Chapter 1 as two separate tricks. Are they related?
[Section 2](02-pi-sigma-and-coc.md) shows they are the same idea in two
shapes: the Π-type (dependent function) and Σ-type (dependent pair) are
dual generalizations of `→` and `×`, and together with the proof
irrelevance of `Prop` they *are* the calculus of constructions, the one
formal system every example since the very first `#check 3` of Chapter 1
has secretly been an instance of.

By the end of the chapter, the informal phrase "everything has a type"
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

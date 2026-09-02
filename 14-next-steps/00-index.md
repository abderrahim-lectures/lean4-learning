# Chapter 14: Where to go next

[← Ch. 13: Working Efficiently](../13-working-efficiently/00-index.md) | [Table of contents](../README.md) | [Appendix: Solutions →](../15-appendix-solutions/00-index.md)

---

## Learning objectives

- Describe what this book built entirely from scratch.
- Translate that construction into the `class`-based idiom of Mathlib and see two genuinely new facts it delivers for free.
- Pick a next project, from the five scaffolded here, or the Church-encodings aside, that extends material already in hand.

## What thirteen chapters of from-scratch construction leave to settle

Thirteen chapters built every group, ring, module, and path algebra from
scratch, no Mathlib, no `class`, no pre-packaged API, so that every
definition and proof obligation was seen explicitly and nothing was
trusted blindly. That from-scratch inventory is worth stating in full
before anything else, since the rest of the chapter depends on knowing
exactly what is, and is not, already in hand
([Section 1](01-what-we-built.md)). The `structure`s built are, field for
field, the same objects Mathlib packages with `class`, so the translation
from one to the other is mostly ergonomic, not mathematical, and it
unlocks genuinely new facts, `ZMod 3` as a `Field`, the theorem of
Lagrange applied to `perm3Group`, that a plain `structure` without
Mathlib's surrounding machinery could not even state
([Section 2](02-moving-to-mathlib.md)). None of the thirteen chapters'
constructions are dead ends; each extends into a genuinely open project,
redoing `Group`/`Ring` as type classes, finishing the path-algebra
construction, bounding path length in an acyclic quiver, comparing
against Mathlib's own `Quiver`, or building a concrete `kQ`-module
([Section 3](03-next-projects.md)). The chapter closes with the solutions
to the exercises of every earlier chapter
([Section 4](04-solutions.md)).

## Sections

1. [What we built](01-what-we-built.md)
2. [Moving to Mathlib](02-moving-to-mathlib.md)
3. [Suggested next projects](03-next-projects.md)
4. [Solutions](04-solutions.md)

---

[← Ch. 13: Working Efficiently](../13-working-efficiently/00-index.md) | [Table of contents](../README.md) | [Appendix: Solutions →](../15-appendix-solutions/00-index.md)

# Chapter 11: Where to go next

## What we built

Starting from `#eval` and `def`, we built up, entirely from first
principles (no external library):

- a general `Group` structure, with theorems proved for an arbitrary group
  (uniqueness of identity, uniqueness of inverses, $(ab)^{-1} = b^{-1}a^{-1}$),
- a `CommGroup` extending `Group`,
- a `Ring` structure built on top of `CommGroup`, with theorems for an
  arbitrary ring ($a \cdot 0 = 0$, $(-1)\cdot a = -a$),
- a `Quiver` and an indexed inductive `Path` type, with path composition,
  as the combinatorial skeleton underlying a path algebra.

Every proof in this book was written with explicit `rw`/`have`/`intro`
steps, each annotated with which axiom or prior theorem justified it — no
`simp`, no unexplained `rfl`. That discipline is exactly what you need to
carry into reading (or writing) a real Lean library: when something goes
wrong, you should be able to point at the exact lemma responsible.

## Moving to Mathlib

Everything here was deliberately reinvented instead of imported, so you'd
see every moving part. Mathlib, Lean's community mathematics library,
already has vastly more general and battle-tested versions of all of this:

- `Mathlib.Algebra.Group.Defs` — `Group`, `CommGroup`, built with Lean's
  **type class** mechanism (`class ... extends ...`) rather than plain
  `structure`, so that notation like `a * b`, `a⁻¹`, `1` works uniformly
  across every group without threading a `Grp :` argument everywhere by
  hand, and so that instances are found automatically by typeclass search.
- `Mathlib.Algebra.Ring.Defs` — `Ring`, `CommRing`, `Field`, and the whole
  hierarchy in between (`Semiring`, `NonUnitalRing`, ...).
- `Mathlib.Combinatorics.Quiver.Basic` and `Mathlib.Algebra.Category.*` —
  quivers as the underlying data of a category (a category is "a quiver
  plus identities and composition satisfying associativity" — sound
  familiar?), and `Mathlib.CategoryTheory` more broadly.
- Path algebras specifically appear in representation-theory-oriented
  corners of Mathlib and in dedicated Lean projects on quiver
  representations; searching Mathlib's docs for "quiver" and "path" is a
  good starting point once you're comfortable with the type-class style.

The jump from this book's `structure`-based definitions to Mathlib's
`class`-based ones is mostly about **ergonomics** (automatic instance
resolution, shared notation, inheritance diamonds resolved for you) rather
than mathematical content — the axioms you already internalized are the
same axioms, just packaged so Lean's elaborator can find them without you
naming a `Grp` argument in every theorem.

## Suggested next projects

1. Redo `Group`/`Ring` from this book as Lean **type classes**
   (`class Group (G : Type) extends ...`) instead of plain `structure`s,
   and notice how theorem statements get shorter once `*`, `⁻¹`, `1` are
   available as notation.
2. Finish the path-algebra construction sketched in Chapter 9's Exercise 3:
   formal $k$-linear combinations of paths, with multiplication by
   concatenation (and $0$ when endpoints don't match).
3. Prove that a quiver with no oriented cycles has a *finite-dimensional*
   path algebra (one polynomial-flavored way to make this precise: bound
   path length by the number of vertices).
4. Once comfortable, explore Mathlib's `CategoryTheory.Quiver` and compare
   its definitions line-by-line against this book's `Quiver`/`Path`.

## Solutions

Full worked solutions to every chapter's exercises are in the
[Appendix](12-appendix-solutions.md).

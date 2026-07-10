## Moving to Mathlib

[← What we built](01-what-we-built.md) | [Index](00-index.md) | [Next: Suggested next projects →](03-next-projects.md)

---

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
- `Mathlib.Algebra.Module.Defs` — `Module`, vastly more general than
  Chapter 10's hand-rolled version, with the entire linear-algebra library
  (`Mathlib.LinearAlgebra.*`: bases, dimension, tensor products, exact
  sequences) built on top.
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
resolution, shared notation, inheritance diamonds — the ambiguity that
arises when a structure extends two parents that share a common
ancestor — resolved for you) rather
than mathematical content — the axioms you already internalized are the
same axioms, just packaged so Lean's elaborator can find them without you
naming a `Grp` argument in every theorem.

---

[← What we built](01-what-we-built.md) | [Index](00-index.md) | [Next: Suggested next projects →](03-next-projects.md)

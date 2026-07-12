## Moving to Mathlib

[← What we built](01-what-we-built.md) | [Index](00-index.md) | [Next: Suggested next projects →](03-next-projects.md)

---

Everything here was reinvented on purpose instead of imported, so you
could see every moving part. Mathlib, Lean's community mathematics
library, already has much more general and well-tested versions of all of
this:

- `Mathlib.Algebra.Group.Defs` — `Group`, `CommGroup`, built with Lean's
  **type class** mechanism (`class ... extends ...`) instead of a plain
  `structure`. This lets notation like `a * b`, `a⁻¹`, `1` work the same
  way across every group, without threading a `Grp :` argument through
  every definition by hand, and lets Lean find instances automatically
  through typeclass search.
- `Mathlib.Algebra.Ring.Defs` — `Ring`, `CommRing`, `Field`, and the whole
  hierarchy in between (`Semiring`, `NonUnitalRing`, ...).
- `Mathlib.Algebra.Module.Defs` — `Module`, much more general than
  Chapter 10's hand-built version, with the entire linear-algebra library
  (`Mathlib.LinearAlgebra.*`: bases, dimension, tensor products, exact
  sequences) built on top.
- `Mathlib.Combinatorics.Quiver.Basic` and `Mathlib.Algebra.Category.*` —
  quivers as the underlying data of a category (a category is "a quiver
  plus identities and composition satisfying associativity" — sound
  familiar?), and `Mathlib.CategoryTheory` more broadly.
- Path algebras specifically show up in representation-theory-oriented
  corners of Mathlib and in dedicated Lean projects on quiver
  representations. Searching Mathlib's docs for "quiver" and "path" is a
  good starting point once you are comfortable with the type-class style.

The jump from this book's `structure`-based definitions to Mathlib's
`class`-based ones is mostly about **ergonomics**: automatic instance
resolution, shared notation, and inheritance diamonds (the ambiguity that
comes up when a structure extends two parents with a common ancestor)
already resolved for you. It is not really about mathematical content —
the axioms you already learned are the same axioms, just packaged so
Lean's elaborator can find them without you naming a `Grp` argument in
every theorem.

---

[← What we built](01-what-we-built.md) | [Index](00-index.md) | [Next: Suggested next projects →](03-next-projects.md)

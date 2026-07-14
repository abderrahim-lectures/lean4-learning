## Suggested next projects

[← Moving to Mathlib](02-moving-to-mathlib.md) | [Index](00-index.md) | [Next: Solutions →](04-solutions.md)

---

1. Redo `Group`/`Ring` from this book as Lean **type classes**
   (`class Group (G : Type) extends ...`) instead of plain `structure`s,
   and notice how theorem statements get shorter once `*`, `⁻¹`, `1` are
   available as notation.
2. Finish the path-algebra construction sketched in Chapter 11's Exercise 3:
   formal $k$-linear combinations of paths, with multiplication by
   concatenation (and $0$ when endpoints do not match) — observe that this is
   precisely "the free `Module` over $k$ on the set of paths," tying
   Chapter 10 and Chapter 11 together.
3. Prove that a quiver with no oriented cycles has a *finite-dimensional*
   path algebra (one polynomial-flavored way to make this precise: bound
   path length by the number of vertices) — "finite-dimensional" here means
   exactly Chapter 10's `Module` notion of a finite spanning/basis set.
4. Once the type-class style is familiar, explore Mathlib's `CategoryTheory.Quiver` and compare
   its definitions line-by-line against this book's `Quiver`/`Path`.
5. Redo `Module`'s "path algebra representations are modules over $kQ$"
   remark (end of Chapter 10) concretely: build the path algebra $kQ$ for
   the example quiver, then a small representation of it, as a
   `Module (PathAlgebraElem ...)`.

---

[← Moving to Mathlib](02-moving-to-mathlib.md) | [Index](00-index.md) | [Next: Solutions →](04-solutions.md)

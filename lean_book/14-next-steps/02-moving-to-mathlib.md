## Moving to Mathlib

[← What we built](01-what-we-built.md) | [Index](00-index.md) | [Next: Suggested next projects →](03-next-projects.md)

---

Everything here was reinvented on purpose instead of imported, so that
every moving part would be visible. Mathlib, the community mathematics
library of Lean, already has much more general and well-tested versions of all of
this.

- `Mathlib.Algebra.Group.Defs` has [`Group`](https://loogle.lean-lang.org/?q=Group) and `CommGroup`, built with the
  **type class** mechanism of Lean (`class ... extends ...`) instead of a plain
  `structure`. This lets notation like `a * b`, `a⁻¹`, `1` work the same
  way across every group, without threading a `Grp :` argument through
  every definition by hand, and lets Lean find instances automatically
  through typeclass search.
- `Mathlib.Algebra.Ring.Defs` has [`Ring`](https://loogle.lean-lang.org/?q=Ring), `CommRing`, `Field`, and the whole
  hierarchy in between (`Semiring`, `NonUnitalRing`, ...).
- `Mathlib.Algebra.Module.Defs` has [`Module`](https://loogle.lean-lang.org/?q=Module), much more general than
  the hand-built version of Chapter 11, with the entire linear-algebra library
  (`Mathlib.LinearAlgebra.*`, bases, dimension, tensor products, exact
  sequences) built on top.
- `Mathlib.Combinatorics.Quiver.Basic` and `Mathlib.Algebra.Category.*` have
  quivers as the underlying data of a category (a category is "a quiver
  plus identities and composition satisfying associativity," the same
  free-category construction from Chapter 12), and `Mathlib.CategoryTheory`
  more broadly.
- Path algebras specifically show up in representation-theory-oriented
  corners of Mathlib and in dedicated Lean projects on quiver
  representations. Searching the Mathlib docs for "quiver" and "path" is a
  good starting point once the type-class style is familiar.

The jump from the `structure`-based definitions of this book to the
`class`-based ones of Mathlib is mostly about **ergonomics**, automatic instance
resolution, shared notation, and inheritance diamonds (the ambiguity that
arises when a structure extends two parents with a common ancestor)
already resolved. It is not really about mathematical content.
The axioms already learned are the same axioms, merely packaged so
the elaborator of Lean can find them without a `Grp` argument named in
every theorem.

Beyond Mathlib itself, the ecosystem now includes libraries built on
top of it. One notable example is
[TauCeti](https://github.com/TauCetiProject/TauCeti), a Lean library of
formalized mathematics that depends on Mathlib's `master` branch and
defers to its design decisions. TauCeti is directed by human-written
roadmaps, while AI contributors implement and maintain the mathematics
under adversarial review against open rubrics; the Lean FRO and the
Mathlib Initiative incubate the project jointly. It does not replace
Mathlib, which remains the gold standard for human-curated mathematics.
TauCeti instead adopts Mathlib's design conventions and pursues a
library of reusable results at AI scale. Two points connect it to this
book. The `structure` versus `class` distinction of Chapter 6, Section 1
is the exact mechanic such a library runs on. The roadmaps of TauCeti
cover areas well past this book, such as the Jacobian challenge and
reductive algebraic groups, so it shows where the subject is headed.
Checking how far Mathlib (and TauCeti) have grown past the hand-built
`Group` of Chapter 7 and `Ring` of Chapter 9 is a useful way to measure
both the growth of the surrounding machinery and the stability of the
core axioms.

### Two theorems for free

Everything above is a promise that Mathlib is *more general*. Here are
two concrete payoffs, things this book explicitly could not state,
using exactly the examples already built.

**`ZMod 3` is a field, not just a ring.** `fin3Ring` in Chapter 9, Section 5 was built
and said in so many words that a `Field` would need every nonzero
element to be invertible, "true for $\mathbb{Z}/3$ precisely because $3$
is prime, but not part of the axioms of `Ring` and not checked here." Mathlib
already has this instance, for real.

```lean
example : Field (ZMod 3) := inferInstance

-- A fact `fin3Ring` (a mere `Ring`) genuinely cannot state: every
-- nonzero element has a multiplicative inverse.
example : ∀ a : ZMod 3, a ≠ 0 → ∃ b, a * b = 1 := by decide
```

**The theorem of Lagrange, applied to the non-abelian example from Chapters
6-7.** `Equiv.Perm (Fin 3)` (the Mathlib analogue of `perm3Group` in Chapter 7, Section 4)
never had subgroups defined for it. The book built one
group, not the lattice of its subgroups. The `Subgroup` type in Mathlib
already comes with the theorem of Lagrange, "the order of a subgroup
divides the order of the group" ([DummitFoote2003], §3.2, Theorem 8),
attached, so applying it to a real subgroup costs nothing beyond naming
the subgroup.

[DummitFoote2003]: ../bibliography.md#dummitfoote2003

```lean
-- Lagrange's theorem, fully generic: a subgroup's size divides the
-- ambient group's size.
example (s : Subgroup (Equiv.Perm (Fin 3))) :
    Nat.card s ∣ Nat.card (Equiv.Perm (Fin 3)) :=
  Subgroup.card_subgroup_dvd_card s

-- Concretely: |S_3| = 3! = 6...
example : Nat.card (Equiv.Perm (Fin 3)) = 6 := by
  rw [Nat.card_eq_fintype_card, Fintype.card_perm, Fintype.card_fin]
  rfl

-- ...and the cyclic subgroup generated by the 3-cycle finRotate 3 has
-- order 3, since (finRotate 3)^3 = 1 and finRotate 3 ≠ 1 with 3 prime.
example : Nat.card (Subgroup.zpowers (finRotate 3)) = 3 := by
  rw [Nat.card_zpowers]
  apply orderOf_eq_prime
  · decide
  · decide
```

Thus $3 \mid 6$, not asserted, but *derived*, by instantiating a theorem
Mathlib already proved once, generically, for every group. Neither of
these two facts required a single new definition, both reuse objects
this book already built, and both are facts the from-scratch
`Ring`/`Group` of this book genuinely could not have stated, since it never built
the surrounding machinery (invertibility, subgroups) that Mathlib
already has. This is the concrete shape of "moving to Mathlib", not
different mathematics, merely a much larger stock of already-proved
consequences to draw on.

---

[← What we built](01-what-we-built.md) | [Index](00-index.md) | [Next: Suggested next projects →](03-next-projects.md)

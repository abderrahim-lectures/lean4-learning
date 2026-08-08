## Exercises

[← Extending structures](03-extending-structures.md) | [Index](00-index.md)

---

**Key points.** A `structure` bundles data (and optionally proofs) under
one name, built via the anonymous constructor `⟨...⟩` and read back out
via field projection `.field`. `extends` builds a new structure containing
everything an existing one has, plus more, generating a `.toX` forgetful
projection for free, the exact mechanism `CommGroup` uses to add
commutativity to `Group` in Chapter 7.

**Socratic questions.**

1. *`⟨0, 0⟩` and `{ x := 0, y := 0 }` build the identical `Point`. Since
   the named form says more, why does the anonymous form ever get used?*
   Because the *expected type* already says which fields are which.
   `def origin : Point := ⟨0, 0⟩` cannot be ambiguous, since Lean already
   knows a `Point` is being built and in what field order. The named form
   earns its keep only when that context is not enough to make the
   assignment obvious to a reader.
2. *`Point3D extends Point` generates `.toPoint` automatically. What
   would have to be written by hand instead, if `extends` did not
   exist?* A separate function `Point3D.toPoint : Point3D → Point`
   projecting out the shared fields one at a time, exactly what a
   forgetful functor does explicitly, which is the whole reason `extends`
   is read categorically rather than as a mere convenience keyword.
3. *A `structure` can bundle proofs as fields, not only data. What
   changes about *checking* that a term has the right type, once one of
   its fields is a proof rather than a number?* Nothing about the
   mechanism. Lean still checks the field has the stated type, but the
   stated type is now a proposition, so supplying that field means
   supplying a proof, checked once at construction time. This is exactly
   what makes `Group` (Chapter 7) impossible to build carelessly. The
   axiom fields cannot be filled in with nonsense that happens to
   type-check as data can.

1. Define `structure Rectangle` with two `Nat` fields, `width` and
   `height`. Then define `def area (r : Rectangle) : Nat`, computing
   the area, and confirm `#eval area ⟨3, 4⟩` reports `12`.
2. `Pair α β` (Section 2) holds two values of two possibly different
   types. Define `structure Box (α : Type)` holding a single value of
   *one* type parameter, plus `def unwrap {α : Type} (b : Box α) : α`
   reading it back out. Build one `Box Nat` and one `Box String`, and
   confirm `unwrap` recovers the original value in each case.
3. Define `structure ColoredRectangle extends Rectangle where color :
   String`, then a value `redSquare : ColoredRectangle` with `width :=
   5`, `height := 5`, `color := "red"`. Confirm `redSquare.toRectangle`
   has type `Rectangle`, and that `area redSquare.toRectangle` computes
   `25` using the `area` function from Exercise 1 unchanged, with no
   `ColoredRectangle`-specific code written. In a sentence or two,
   explain why this is exactly the "forgetful functor" pattern from the
   Mathematical reading box of this section, not a coincidence of naming.

Solutions, [Appendix, Chapter 3](../15-appendix-solutions/03-chapter-3.md).

---

[← Extending structures](03-extending-structures.md) | [Index](00-index.md) | [Table of contents](../README.md) | [Ch. 4: Propositions & Proofs →](../04-propositions-and-proofs/00-index.md)

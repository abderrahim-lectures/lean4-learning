## Exercises

[← Extending structures](03-extending-structures.md) | [Index](00-index.md)

---

**Key points.** A `structure` bundles data (and optionally proofs) under
one name, built via the anonymous constructor `⟨...⟩` and read back out
via field projection `.field`. `extends` builds a new structure containing
everything an existing one has, plus more, generating a `.toX` forgetful
projection for free, the exact mechanism `CommGroup` uses to add
commutativity to `Group` in Chapter 7.

1. `⟨0, 0⟩` and `{ x := 0, y := 0 }` build the identical `Point`. State
   precisely what property of `def origin : Point := ⟨0, 0⟩` makes the
   anonymous form unambiguous, and give an example, in a sentence, of a
   context where that property fails and the named form is needed
   instead.
2. `Point3D extends Point` generates `.toPoint` automatically. Write out,
   by hand, the function that `extends` would otherwise require, and
   state precisely which categorical construction from the Mathematical
   reading box of Section 3 it implements.
3. A `structure` can bundle proofs as fields, not only data. Prove that
   this changes nothing about how Lean checks a term against its stated
   type, and explain why this is exactly what makes `Group` (Chapter 7)
   impossible to build carelessly.

4. Define `structure Rectangle` with two `Nat` fields, `width` and
   `height`. Then define `def area (r : Rectangle) : Nat`, computing
   the area, and confirm `#eval area ⟨3, 4⟩` reports `12`.
5. `Pair α β` (Section 2) holds two values of two possibly different
   types. Define `structure Box (α : Type)` holding a single value of
   *one* type parameter, plus `def unwrap {α : Type} (b : Box α) : α`
   reading it back out. Build one `Box Nat` and one `Box String`, and
   confirm `unwrap` recovers the original value in each case.
6. Define `structure ColoredRectangle extends Rectangle where color :
   String`, then a value `redSquare : ColoredRectangle` with `width :=
   5`, `height := 5`, `color := "red"`. Confirm `redSquare.toRectangle`
   has type `Rectangle`, and that `area redSquare.toRectangle` computes
   `25` using the `area` function from Exercise 4 unchanged, with no
   `ColoredRectangle`-specific code written. In a sentence or two,
   explain why this is exactly the "forgetful functor" pattern from the
   Mathematical reading box of this section, not a coincidence of
   naming.

**Deep practice.** The following exercises push to the edge of your
ability. They build on each other — do them in order. If you're making
no mistakes, you're not learning; if you're making more than 20%
mistakes, reread the section first.

7. Define `structure Vector (n : Nat) (α : Type)` with a field `data :
   Fin n → α`. Write `def v3 : Vector 3 Nat` with values `[1, 2, 3]`
   using `Fin.mk`. Then write `def head {n : Nat} {α : Type} (v : Vector
   (n + 1) α) : α` that returns the first element. What happens if you
   try to write `head` for `Vector 0 α`? (This is the dependent-type
   constraint in action.)
8. Define `structure Monoid where` with fields `α : Type`, `op : α → α → α`,
   `id : α`. Then define `def natAddMonoid : Monoid` with `α := Nat`,
   `op := Nat.add`, `id := 0`. Write `def fold {m : Monoid} : List m.α →
   m.α` that folds a list using `m.op` and `m.id`. Confirm `#eval fold
   natAddMonoid [1, 2, 3]` reports `6`.
9. Define `structure Group where` with fields `α : Type`, `op : α → α → α`,
   `id : α`, `inv : α → α`. Then define `structure CommGroup extends
   Group` with an additional field `comm : ∀ a b : G.α, G.op a b = G.op b
   a`. Build `natAddCommGroup : CommGroup` and confirm `#eval
   natAddCommGroup.comm 2 3` proves `2 + 3 = 3 + 2`. (This is exactly
   the pattern Chapter 7 uses.)

Solutions, [Appendix, Chapter 3](../15-appendix-solutions/03-chapter-3.md).

---

[← Extending structures](03-extending-structures.md) | [Index](00-index.md) | [Table of contents](../README.md) | [Ch. 4: Propositions & Proofs →](../04-propositions-and-proofs/00-index.md)

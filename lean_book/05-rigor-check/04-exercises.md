## Exercises

[← Definitional vs propositional equality](03-defeq-vs-propeq.md) | [Index](00-index.md)

---

1. Predict, before running it, whether [`example : (2 : Nat) * 3 = 3 + 3 := rfl`](https://lean-lang.org/doc/reference/latest/Tactic-Proofs/Tactic-Reference/)
   type-checks. Then predict whether
   `example (n : Nat) : n * 2 = n + n := rfl` type-checks (hint: which
   argument does `Nat.mul` recurse on? Compare with the `Nat.add` recursion
   pattern from Chapter 4).
2. Rewrite `opTwice` (from the `structure` vs `class` section) as a
   type class version yourself: declare `class MyGroup (G : Type) where ...`
   with the same fields as this book's `Group`, register
   `instance : MyGroup Int where ...`, and write
   `def opTwiceTC [MyGroup G] (x : G) : G := MyGroup.op x x`. Confirm
   `#eval opTwiceTC (3 : Int)` works with no explicit instance argument.
3. In one or two sentences, explain why `Type → Type` (the type of `Group`
   itself, before applying it to a carrier) must live in `Type 1` rather
   than `Type 0` — tie your answer back to the Russell's-paradox
   obstruction this chapter described.
4. Give an example (distinct from `my_add_comm`) of a true propositional
   equality between two `Nat` expressions that is *not* provable by `rfl`
   alone, and identify which of the two sides' recursive structure is the
   obstruction.

Solutions: [Appendix, Chapter 5](../14-appendix-solutions/03-chapter-5.md).

## Next

Continue to [Chapter 6: Structures and classes — defining a `Group`](../06-groups/00-index.md).

---

[← Definitional vs propositional equality](03-defeq-vs-propeq.md) | [Index](00-index.md) | [Table of contents](../README.md) | [Ch. 6: Groups →](../06-groups/00-index.md)

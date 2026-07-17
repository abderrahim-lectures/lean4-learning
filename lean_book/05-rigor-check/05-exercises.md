## Exercises

[← Definitional vs propositional equality](04-defeq-vs-propeq.md) | [Index](00-index.md)

---

**Key points.** This book delays `class` for `structure` so every proof
obligation stays explicit; `class` only changes *how* Lean finds an
instance, not what data it holds. `Type`'s own type must live one universe
up (`Type 1`), or `Type : Type` reintroduces Russell's paradox. `rfl`
proves only *definitional* equality — reduction to the same normal form —
which is not every true propositional equality (an asymmetric recursion
like `Nat.add`'s is exactly where the two can diverge).

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
   than `Type 0` — tie the answer back to the Russell's-paradox
   obstruction this chapter described.
4. Give an example (distinct from `my_add_comm`) of a true propositional
   equality between two `Nat` expressions that is *not* provable by `rfl`
   alone, and identify which of the two sides' recursive structure is the
   obstruction.

Solutions: [Appendix, Chapter 5](../14-appendix-solutions/04-chapter-5.md).

## Next

Continue to the [checkpoint project](06-checkpoint-project.md), which
closes out Part I before Chapter 6 begins Part II.

---

[← Definitional vs propositional equality](04-defeq-vs-propeq.md) | [Index](00-index.md) | [Next: Checkpoint project →](06-checkpoint-project.md)

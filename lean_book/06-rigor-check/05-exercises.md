## Exercises

[← Definitional vs propositional equality](04-defeq-vs-propeq.md) | [Index](00-index.md)

---

**Key points.** This book delays `class` for `structure` so every proof
obligation stays explicit. `class` only changes *how* Lean finds an
instance, not what data it holds. The type of `Type` itself must live one universe
up (`Type 1`), or `Type : Type` reintroduces the Russell paradox. `rfl`
proves only *definitional* equality, reduction to the same normal form,
which is not every true propositional equality (an asymmetric recursion
like that of `Nat.add` is exactly where the two can diverge).

1. `class` only changes how Lean finds an instance, not what data it
   holds. Explain why Mathlib bothers with the whole `class` hierarchy at
   all, instead of using plain `structure`s the way this book does, given
   that fact.
2. `Type : Type` would make the type system of Lean itself inconsistent.
   Explain why `Type 1 : Type 2`, `Type 2 : Type 3`, and so on, does not
   cause the exact same problem one level up.
3. `rfl` and `decide` both look like they "just work" with no argument
   supplied. State precisely what each one checks, and give an example of
   a true proposition that `decide` can settle but `rfl` cannot.
4. Predict, before running it, whether [`example : (2 : Nat) * 3 = 3 + 3 := rfl`](https://lean-lang.org/doc/reference/latest/Tactic-Proofs/Tactic-Reference/)
   type-checks. Then predict whether
   `example (n : Nat) : n * 2 = n + n := rfl` type-checks (hint, which
   argument does `Nat.mul` recurse on? Compare with the `Nat.add` recursion
   pattern from Chapter 5).
5. Rewrite `opTwice` (from the `structure` vs `class` section) as a
   type class version yourself, declare `class MyGroup (G : Type) where ...`
   with the same fields as `Group` in this book, register
   `instance : MyGroup Int where ...`, and write
   `def opTwiceTC [MyGroup G] (x : G) : G := MyGroup.op x x`. Confirm
   `#eval opTwiceTC (3 : Int)` works with no explicit instance argument.
6. In one or two sentences, explain why `Type → Type` (the type of `Group`
   itself, before applying it to a carrier) must live in `Type 1` rather
   than `Type 0`. Tie the answer back to the Russell-paradox
   obstruction this chapter described.
7. Give an example (distinct from `my_add_comm`) of a true propositional
   equality between two `Nat` expressions that is *not* provable by `rfl`
   alone, and identify which side has the recursive structure that is the
   obstruction.

Solutions, [Appendix, Chapter 6](../15-appendix-solutions/06-chapter-6.md).

## Next

Continue to the [checkpoint project](06-checkpoint-project.md), which
closes out Part I before Chapter 7 begins Part II.

---

[← Definitional vs propositional equality](04-defeq-vs-propeq.md) | [Index](00-index.md) | [Next: Checkpoint project →](06-checkpoint-project.md)

## Chapter 5: Rigor check — structures, universes, and equality

[← Chapter 4](02-chapter-4.md) | [Index](00-index.md) | [Next: Chapter 6 →](04-chapter-6.md)

---

**1. `rfl` predictions**

```lean
example : (2 : Nat) * 3 = 3 + 3 := rfl
```

This succeeds: `Nat.mul` recurses on its second argument, with base clause
`a * 0 = 0` and step `a * (k+1) = a * k + a`. Since both sides are closed
numerals, Lean simply evaluates both to `6` and confirms they match — no
subtlety, both sides compute to the same normal form.

```lean
example (n : Nat) : n * 2 = n + n := rfl
```

This *also* succeeds, but for a reason worth being precise about: `2` is
`Nat.succ (Nat.succ Nat.zero)`, so `n * 2` unfolds via the step clause
twice: `n * 2 = n * 1 + n = (n * 0 + n) + n = (0 + n) + n`. Since `Nat.add`
recurses on its *second* argument, `0 + n` is *not* immediately `n`
definitionally (this was exactly the asymmetry Chapter 4 hinged on for
`my_add_comm`) — so this reduces to `(0 + n) + n`, which is *not*
syntactically `n + n` unless `0 + n` also reduces to `n`. It doesn't,
definitionally. So contrary to a first guess, **this does *not* type-check
as `rfl`** in general — try it and confirm `rfl` fails, then confirm
`by rw [Nat.two_mul]` (or an explicit induction) succeeds instead. The
lesson: multiplication by a literal doesn't collapse `rfl`-cheaply the
moment a general variable `n` is involved on the "wrong" side of an
asymmetric recursion, exactly as `0 + n = n` needed real induction in
Chapter 4.

**2. `MyGroup` as a type class**

```lean
class MyGroup (G : Type) where
  op : G → G → G
  id : G
  inv : G → G
  assoc : ∀ a b c : G, op (op a b) c = op a (op b c)
  id_left : ∀ a : G, op id a = a
  id_right : ∀ a : G, op a id = a
  inv_left : ∀ a : G, op (inv a) a = id
  inv_right : ∀ a : G, op a (inv a) = id

instance : MyGroup Int where
  op := fun a b => a + b
  id := 0
  inv := fun a => -a
  assoc := by intro a b c; exact Int.add_assoc a b c
  id_left := by intro a; exact Int.zero_add a
  id_right := by intro a; exact Int.add_zero a
  inv_left := by intro a; exact Int.add_left_neg a
  inv_right := by intro a; exact Int.add_right_neg a

def opTwiceTC [MyGroup G] (x : G) : G := MyGroup.op x x

#eval opTwiceTC (3 : Int)   -- 6, with the Group Int instance found automatically
```

Every field of the `instance` is identical, term-for-term, to the earlier
`intGroup : Group Int` `def` from Chapter 6 — registering something as an
`instance` instead of a plain `def` changes only *how Lean's elaborator
finds it* (automatically, via unification on `G`), not what data it
contains.

**3. Why `Type → Type` needs `Type 1`**

If `Type → Type` (the type of `Group` itself, prior to supplying a
carrier) lived in `Type 0` alongside `Nat`, `Bool`, and every other
ordinary type, then `Type` itself — being an argument type appearing
inside `Type → Type` — would need to be an element of `Type 0`, i.e. we'd
need `Type : Type`. But `Type` is supposed to be (something like) the
type of *all* `Type 0`-level types; if it were itself one such type, you
could reconstruct Russell's paradox internally (build a self-referential
type analogous to "the type of all types not containing themselves").
Lean's kernel avoids this by insisting anything built from `Type 0` (such
as a function *into or out of* `Type 0`) that isn't itself a small type
bumps up a universe level, landing `Type → Type` in `Type 1` rather than
`Type 0`.

**4. A true propositional equality not provable by `rfl`**

```lean
theorem add_one_eq_succ (n : Nat) : n + 1 = Nat.succ n := rfl
-- (this one IS rfl — n + 1 = n + Nat.succ 0 = Nat.succ (n + 0) = Nat.succ n,
--  all by the defining equations of `+`, no induction needed)

theorem one_add_eq_succ (n : Nat) : 1 + n = Nat.succ n := by
  induction n with
  | zero => rfl
  | succ k ih =>
    show 1 + Nat.succ k = Nat.succ (Nat.succ k)
    rw [Nat.add_succ, ih]
```

`n + 1 = Nat.succ n` is `rfl` (recursion is on the second, literal-`1`
argument, which unfolds immediately). But `1 + n = Nat.succ n`, with the
variable now on the *second* argument, is exactly the same left/right
asymmetry as `0 + n = n` from Chapter 4 — `Nat.add`'s recursion doesn't
touch a variable sitting in the first argument at all, so no amount of
unfolding closes the goal without an actual induction on `n`, even though
the statement is (of course) true.

---

[← Chapter 4](02-chapter-4.md) | [Index](00-index.md) | [Next: Chapter 6 →](04-chapter-6.md)

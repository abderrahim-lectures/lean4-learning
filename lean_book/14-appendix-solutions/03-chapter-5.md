## Chapter 5: Rigor check — structures, universes, and equality

[← Chapter 4](02-chapter-4.md) | [Index](00-index.md) | [Next: Chapter 6 →](04-chapter-6.md)

---

**1. `rfl` predictions**

```lean
example : (2 : Nat) * 3 = 3 + 3 := rfl
```

This succeeds. `Nat.mul` recurses on its second argument, with base clause
`a * 0 = 0` and step `a * (k+1) = a * k + a`. Since both sides are closed
numerals, Lean just evaluates both to `6` and checks that they match.
There's no subtlety here: both sides compute to the same normal form.

```lean
example (n : Nat) : n * 2 = n + n := rfl
```

This *also* succeeds, but the reason is worth spelling out. `2` is
`Nat.succ (Nat.succ Nat.zero)`, so `n * 2` unfolds via the step clause
twice: `n * 2 = n * 1 + n = (n * 0 + n) + n = (0 + n) + n`. Since `Nat.add`
recurses on its *second* argument, `0 + n` is *not* immediately `n` by
definition (this is the same asymmetry Chapter 4 relied on for
`my_add_comm`). So this reduces to `(0 + n) + n`, which is *not*
syntactically `n + n` unless `0 + n` also reduces to `n`. It doesn't,
by definition. So, contrary to a first guess, **this does *not* type-check
as `rfl`** in general. Try it and confirm `rfl` fails, then confirm that
`by rw [Nat.two_mul]` (or an explicit induction) succeeds instead. The
lesson: multiplying by a literal doesn't collapse to `rfl` for free once a
general variable `n` sits on the "wrong" side of an asymmetric recursion.
This is the same reason `0 + n = n` needed real induction in Chapter 4.

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
```

Every field of the `instance` is identical, term-for-term, to the earlier
`intGroup : Group Int` `def` from Chapter 6. Registering something as an
`instance` instead of a plain `def` only changes *how Lean's elaborator
finds it* (automatically, via unification on `G`). It does not change what
data it contains.

```lean
def opTwiceTC [MyGroup G] (x : G) : G := MyGroup.op x x

#eval opTwiceTC (3 : Int)   -- 6, with the Group Int instance found automatically
```

That difference in *how it's found* is exactly what makes `opTwiceTC`
possible. It's written once, in a generic way, against the `[MyGroup G]`
assumption, with no mention of `Int` anywhere. At the `#eval` call site,
Lean needs a `MyGroup Int` to run `MyGroup.op`. It searches the instances
it has registered, finds the one declared above, and plugs it in
automatically. A plain `def` would not take part in this kind of lookup.

**3. Why `Type → Type` needs `Type 1`**

Suppose `Type → Type` (the type of `Group` itself, before we supply a
carrier) lived in `Type 0` alongside `Nat`, `Bool`, and every other
ordinary type. Then `Type` itself — being an argument type appearing
inside `Type → Type` — would need to be an element of `Type 0`. In other
words, we'd need `Type : Type`. But `Type` is meant to be (roughly) the
type of *all* `Type 0`-level types. If it were itself one such type, you
could rebuild Russell's paradox inside Lean (a self-referential type like
"the type of all types not containing themselves"). Lean's kernel avoids
this: anything built from `Type 0` (such as a function *into or out of*
`Type 0`) that isn't itself a small type must bump up a universe level.
That is why `Type → Type` lands in `Type 1` rather than `Type 0`.

**4. A true propositional equality not provable by `rfl`**

```lean
theorem add_one_eq_succ (n : Nat) : n + 1 = Nat.succ n := rfl
```

This one *is* `rfl`: `n + 1 = n + Nat.succ 0 = Nat.succ (n + 0) = Nat.succ
n`, all by the defining equations of `+`. No induction is needed, because
the recursion is on the second, literal-`1` argument, which unfolds
right away no matter what `n` is.

```lean
theorem one_add_eq_succ (n : Nat) : 1 + n = Nat.succ n := by
  induction n with
  | zero => rfl
  | succ k ih =>
    show 1 + Nat.succ k = Nat.succ (Nat.succ k)
    rw [Nat.add_succ, ih]
```

This is the real answer to the exercise — a *true* equality that `rfl`
can't close on its own. With the variable now on the *second* argument,
`1 + n = Nat.succ n` has exactly the same left/right asymmetry as
`0 + n = n` from Chapter 4. `Nat.add`'s recursion never touches a variable
sitting in the first argument, so no amount of unfolding closes the goal
without an actual induction on `n`, even though the statement is (of
course) true. That's why we need the explicit `induction n with ...` above.
Comparing it with `add_one_eq_succ`'s one-line `rfl` makes the asymmetry
concrete.

---

[← Chapter 4](02-chapter-4.md) | [Index](00-index.md) | [Next: Chapter 6 →](04-chapter-6.md)

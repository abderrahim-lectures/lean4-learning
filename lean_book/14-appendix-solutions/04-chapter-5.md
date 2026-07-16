## Chapter 5: Rigor check — structures, universes, and equality

[← Chapter 4](03-chapter-4.md) | [Index](00-index.md) | [Next: Chapter 6 →](05-chapter-6.md)

---

**1. `rfl` predictions**

```lean
example : (2 : Nat) * 3 = 3 + 3 := rfl
```

This succeeds. `Nat.mul` recurses on its second argument, with base clause
`a * 0 = 0` and step `a * (k+1) = a * k + a`. Since both sides are closed
numerals, Lean evaluates both to `6` and checks that they match.
Both sides compute to the same normal form, so no subtlety arises.

```lean
example (n : Nat) : n * 2 = n + n := rfl
```

This also succeeds, though the reason requires elaboration. `2` is
`Nat.succ (Nat.succ Nat.zero)`, so `n * 2` unfolds via the step clause
twice: `n * 2 = n * 1 + n = (n * 0 + n) + n = (0 + n) + n`. Since `Nat.add`
recurses on its *second* argument, `0 + n` is not immediately `n` by
definition (this is the same asymmetry Chapter 4 relied on for
`my_add_comm`). Hence this reduces to `(0 + n) + n`, which is not
syntactically `n + n` unless `0 + n` also reduces to `n`. It does not,
by definition. Thus, contrary to a first guess, **this does not type-check
as `rfl`** in general. Confirming this directly, [`rfl`](https://lean-lang.org/doc/reference/latest/Tactic-Proofs/Tactic-Reference/) fails, while
`by rw [Nat.mul_two]` (or an explicit induction) succeeds instead — note
this is `Nat.mul_two : n * 2 = n + n`, not `Nat.two_mul : 2 * n = n + n`,
since the goal has `n` on the left of `*`. The
lesson: multiplying by a literal does not collapse to `rfl` for free once a
general variable `n` sits on the "wrong" side of an asymmetric recursion.
This is the same reason `0 + n = n` required real induction in Chapter 4.

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

That difference in how it is found is exactly what makes `opTwiceTC`
possible. It is written once, in a generic way, against the `[MyGroup G]`
assumption, with no mention of `Int` anywhere. At the `#eval` call site,
Lean needs a `MyGroup Int` to run `MyGroup.op`. It searches the instances
it has registered, finds the one declared above, and plugs it in
automatically. A plain `def` would not take part in this kind of lookup.

**3. Why `Type → Type` needs `Type 1`**

Suppose `Type → Type` (the type of `Group` itself, before we supply a
carrier) lived in `Type 0` alongside `Nat`, `Bool`, and every other
ordinary type. Then `Type` itself — being an argument type appearing
inside `Type → Type` — would need to be an element of `Type 0`. In other
words, this would require `Type : Type`. But `Type` is meant to be (roughly) the
type of *all* `Type 0`-level types. If it were itself one such type, one
could rebuild Russell's paradox inside Lean (a self-referential type such as
"the type of all types not containing themselves"). Lean's kernel avoids
this: anything built from `Type 0` (such as a function *into or out of*
`Type 0`) that is not itself a small type must bump up a universe level.
That is why `Type → Type` lands in `Type 1` rather than `Type 0`.

**4. A true propositional equality not provable by `rfl`**

```lean
theorem add_one_eq_succ (n : Nat) : n + 1 = Nat.succ n := rfl
```

This one is indeed `rfl`: `n + 1 = n + Nat.succ 0 = Nat.succ (n + 0) = Nat.succ
n`, all by the defining equations of `+`. No induction is needed, because
the recursion is on the second, literal-`1` argument, which unfolds
immediately regardless of `n`.

```lean
theorem one_add_eq_succ (n : Nat) : 1 + n = Nat.succ n := by
  induction n with
  | zero => rfl
  | succ k ih =>
    show 1 + Nat.succ k = Nat.succ (Nat.succ k)
    rw [Nat.add_succ, ih]
```

This is the substantive answer to the exercise — a true equality that `rfl`
cannot close on its own. With the variable now on the *second* argument,
`1 + n = Nat.succ n` has exactly the same left/right asymmetry as
`0 + n = n` from Chapter 4. `Nat.add`'s recursion never touches a variable
sitting in the first argument, so no amount of unfolding closes the goal
without an actual induction on `n`, even though the statement is of
course true. This is why the explicit `induction n with ...` above is
required. Comparing it with `add_one_eq_succ`'s one-line `rfl` makes the asymmetry
concrete.

**Checkpoint project: a `Monoid` from scratch**

```lean
structure Monoid (M : Type) where
  op : M → M → M
  id : M
  assoc : ∀ a b c : M, op (op a b) c = op a (op b c)
  id_left : ∀ a : M, op id a = a
  id_right : ∀ a : M, op a id = a

def listMonoid (α : Type) : Monoid (List α) where
  op := List.append
  id := []
  assoc := by intro a b c; exact List.append_assoc a b c
  id_left := by intro a; exact List.nil_append a
  id_right := by intro a; exact List.append_nil a

def natMulMonoid : Monoid Nat where
  op := fun a b => a * b
  id := 1
  assoc := by intro a b c; exact Nat.mul_assoc a b c
  id_left := by intro a; exact Nat.one_mul a
  id_right := by intro a; exact Nat.mul_one a

theorem monoid_id_unique {M : Type} (Mn : Monoid M) (e' : M)
    (h : ∀ a : M, Mn.op e' a = a) : e' = Mn.id := by
  have step1 : Mn.op e' Mn.id = Mn.id := h Mn.id
  have step2 : Mn.op e' Mn.id = e' := Mn.id_right e'
  rw [← step2]
  exact step1
```

Both instances are one field-by-field build, exactly `intGroup`'s style
(Chapter 6 §3) minus the two inverse fields: each proof obligation is a
single `intro` plus a one-line `exact` naming a core-library fact
(`List.append_assoc`/`List.nil_append`/`List.append_nil` for the list
instance, `Nat.mul_assoc`/`Nat.one_mul`/`Nat.mul_one` for the natural-number
one). `monoid_id_unique`'s proof is `id_unique` (Chapter 7, Theorem 1)
copied verbatim with every `Grp.` replaced by `Mn.` and `Group` weakened to
`Monoid` — every step used only `id_right` and the hypothesis `h`, never an
inverse, which is exactly why the proof survives dropping `inv` entirely.
The theorem applies unchanged to both instances built above, the same
"prove once, get it for free" payoff Chapter 6 §6 promises for `Group`.

---

[← Chapter 4](03-chapter-4.md) | [Index](00-index.md) | [Next: Chapter 6 →](05-chapter-6.md)

## Chapter 8: Group examples and basic theorems

[← Chapter 7](07-chapter-7.md) | [Index](00-index.md) | [Next: Chapter 9 →](09-chapter-9.md)

---

**1. Could `id_unique` route through `Grp.op Grp.id e'` instead?**

Not directly. `h` is the hypothesis that `e'` is a *left* identity, so it
only describes `Grp.op e' a` for arbitrary `a`; it says nothing about
`Grp.op a e'`. The proof of `id_unique` has to route through the one
expression, `Grp.op e' Grp.id`, that both given facts (`h` and
`Grp.id_right`) actually describe, not any expression that happens to
mention both sides.

**2. Can `inv (a op b)` be computed directly from the axioms?**

Not from the axioms alone. `Group` has no field that produces `inv` of a
*product* in closed form, only `inv` of a single element. Reducing
"compute this" to "verify this satisfies the defining property" of
Theorem 2 is not a shortcut taken for convenience; it is the only route
the axioms actually offer, which is exactly why `inv_op` is proved by
characterization rather than direct computation.

**3. `theorem inv_inv (a : G) : Grp.inv (Grp.inv a) = a`**

```lean
theorem inv_inv (a : G) : Grp.inv (Grp.inv a) = a := by
  apply Eq.symm
  apply left_inverse_unique Grp (Grp.inv a) a
  -- Goal: op a (inv a) = id
  exact Grp.inv_right a
```

By `left_inverse_unique` (Chapter 8, Theorem 2), to show
`a = Grp.inv (Grp.inv a)` it suffices to show `a` is a left inverse of
`Grp.inv a`, i.e. `Grp.op a (Grp.inv a) = Grp.id`, exactly `Grp.inv_right a`.

**4. `theorem cancel_left (a b c : G) (h : Grp.op a b = Grp.op a c) : b = c`**

```lean
theorem cancel_left (a b c : G) (h : Grp.op a b = Grp.op a c) : b = c := by
  have h1 : Grp.op (Grp.inv a) (Grp.op a b) = Grp.op (Grp.inv a) (Grp.op a c) := by
    rw [h]
  rw [← Grp.assoc (Grp.inv a) a b] at h1
  -- h1 : op (op (inv a) a) b = op (inv a) (op a c)
  rw [← Grp.assoc (Grp.inv a) a c] at h1
  -- h1 : op (op (inv a) a) b = op (op (inv a) a) c
  rw [Grp.inv_left] at h1
  -- h1 : op id b = op id c
  rw [Grp.id_left, Grp.id_left] at h1
  -- h1 : b = c
  exact h1
```

Both sides of `h` are left-multiplied by `Grp.inv a` (step `h1`), then regrouped
with associativity so that `Grp.inv a` meets `a` on both sides. That
pair cancels to `Grp.id` via `inv_left`, and `Grp.id` is then stripped via `id_left`, which
leaves `b = c` directly.

---

[← Chapter 7](07-chapter-7.md) | [Index](00-index.md) | [Next: Chapter 9 →](09-chapter-9.md)

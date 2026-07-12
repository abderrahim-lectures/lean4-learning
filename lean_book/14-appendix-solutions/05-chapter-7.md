## Chapter 7: Group examples and basic theorems

[← Chapter 6](04-chapter-6.md) | [Index](00-index.md) | [Next: Chapter 8 →](06-chapter-8.md)

---

**1. `theorem inv_inv (a : G) : Grp.inv (Grp.inv a) = a`**

```lean
theorem inv_inv (a : G) : Grp.inv (Grp.inv a) = a := by
  apply Eq.symm
  apply left_inverse_unique Grp (Grp.inv a) a
  -- Goal: op a (inv a) = id
  exact Grp.inv_right a
```

By `left_inverse_unique` (Chapter 7, Theorem 2), to show
`a = Grp.inv (Grp.inv a)` it's enough to show `a` is a left inverse of
`Grp.inv a`, i.e. `Grp.op a (Grp.inv a) = Grp.id` — exactly `Grp.inv_right a`.

**2. `theorem cancel_left (a b c : G) (h : Grp.op a b = Grp.op a c) : b = c`**

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

We left-multiply both sides of `h` by `Grp.inv a` (step `h1`), then regroup
with associativity so `Grp.inv a` meets `a` on both sides. We cancel that
pair to `Grp.id` via `inv_left`, then strip `Grp.id` via `id_left`, which
leaves `b = c` directly.

---

[← Chapter 6](04-chapter-6.md) | [Index](00-index.md) | [Next: Chapter 8 →](06-chapter-8.md)

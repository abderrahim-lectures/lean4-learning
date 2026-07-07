## Chapter 9: Ring examples and basic theorems

[← Chapter 8](06-chapter-8.md) | [Index](00-index.md) | [Next: Chapter 10 →](08-chapter-10.md)

---

**1. `theorem mul_zero_left (Rg : Ring R) (a : R) : Rg.mul Rg.addGrp.id a = Rg.addGrp.id`**

```lean
theorem mul_zero_left (a : R) : Rg.mul Rg.addGrp.id a = Rg.addGrp.id := by
  have h0 : Rg.addGrp.op Rg.addGrp.id Rg.addGrp.id = Rg.addGrp.id :=
    Rg.addGrp.toGroup.id_left Rg.addGrp.id
  have h1 : Rg.mul (Rg.addGrp.op Rg.addGrp.id Rg.addGrp.id) a =
      Rg.addGrp.op (Rg.mul Rg.addGrp.id a) (Rg.mul Rg.addGrp.id a) :=
    Rg.right_distrib Rg.addGrp.id Rg.addGrp.id a
  rw [h0] at h1
  -- h1 : Rg.mul Rg.addGrp.id a = op (mul 0 a) (mul 0 a)
  have h2 :
      Rg.addGrp.op (Rg.addGrp.toGroup.inv (Rg.mul Rg.addGrp.id a)) (Rg.mul Rg.addGrp.id a) =
      Rg.addGrp.op (Rg.addGrp.toGroup.inv (Rg.mul Rg.addGrp.id a))
        (Rg.addGrp.op (Rg.mul Rg.addGrp.id a) (Rg.mul Rg.addGrp.id a)) :=
    congrArg (Rg.addGrp.op (Rg.addGrp.toGroup.inv (Rg.mul Rg.addGrp.id a))) h1
  rw [Rg.addGrp.toGroup.inv_left] at h2
  rw [← Rg.addGrp.toGroup.assoc] at h2
  rw [Rg.addGrp.toGroup.inv_left] at h2
  rw [Rg.addGrp.toGroup.id_left] at h2
  exact h2.symm
```

Line for line the mirror of Chapter 9's Theorem 1 (`mul_zero`): instead of
distributing `a * (0 + 0)` on the left, we distribute `(0 + 0) * a` on the
right (`right_distrib`), giving `mul 0 a = op (mul 0 a) (mul 0 a)`, and the
same "add the inverse of `mul 0 a` to both sides" trick isolates
`Rg.addGrp.id = Rg.mul Rg.addGrp.id a`.

**2. `theorem neg_mul (a b : R) : Rg.mul (Rg.addGrp.toGroup.inv a) b = Rg.addGrp.toGroup.inv (Rg.mul a b)`**

```lean
theorem neg_mul (a b : R) :
    Rg.mul (Rg.addGrp.toGroup.inv a) b = Rg.addGrp.toGroup.inv (Rg.mul a b) := by
  apply left_inverse_unique Rg.addGrp.toGroup (Rg.mul a b) (Rg.mul (Rg.addGrp.toGroup.inv a) b)
  -- Goal: op (mul (inv a) b) (mul a b) = id
  rw [← Rg.right_distrib]
  -- justified by right_distrib, read backwards: combines the two products
  -- mul (inv a) b and mul a b into mul (op (inv a) a) b.
  -- Goal: mul (op (inv a) a) b = id
  rw [Rg.addGrp.toGroup.inv_left]
  -- justified by inv_left of the additive group: op (inv a) a = id.
  -- Goal: mul Rg.addGrp.id b = id
  exact mul_zero_left Rg b
```

By `left_inverse_unique` (Chapter 7, Theorem 2, applied to the additive
group `Rg.addGrp.toGroup`), it suffices to show
`Rg.mul (Rg.addGrp.toGroup.inv a) b` is a left additive-inverse of
`Rg.mul a b`. `right_distrib` (used backwards) merges the two products into
`Rg.mul (Rg.addGrp.op (Rg.addGrp.toGroup.inv a) a) b`; `inv_left` collapses
the inner sum to `Rg.addGrp.id`; and `mul_zero_left` (the previous exercise)
finishes.

---

[← Chapter 8](06-chapter-8.md) | [Index](00-index.md) | [Next: Chapter 10 →](08-chapter-10.md)

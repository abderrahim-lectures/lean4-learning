## Chapter 9: Ring examples and basic theorems

[← Chapter 8](06-chapter-8.md) | [Index](00-index.md) | [Next: Chapter 10 →](08-chapter-10.md)

---

**1. `theorem neg_mul (a b : R) : Rg.mul (Rg.addGrp.toGroup.inv a) b = Rg.addGrp.toGroup.inv (Rg.mul a b)`**

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
group `Rg.addGrp.toGroup`), it suffices to show that
`Rg.mul (Rg.addGrp.toGroup.inv a) b` is a left additive-inverse of
`Rg.mul a b`. `right_distrib` (used backwards) merges the two products into
`Rg.mul (Rg.addGrp.op (Rg.addGrp.toGroup.inv a) a) b`. Then `inv_left`
collapses the inner sum to `Rg.addGrp.id`, and `mul_zero_left` (proved in
Theorem 2's own section, since `neg_one_mul` there needed it too) finishes
the proof.

**2. `theorem neg_seven : intRing.addGrp.toGroup.inv 7 = -7 := rfl`**

```lean
theorem neg_seven : intRing.addGrp.toGroup.inv 7 = -7 := rfl
```

[`rfl`](https://lean-lang.org/doc/reference/latest/Tactic-Proofs/Tactic-Reference/) suffices here, but it would not have sufficed for Theorem 2's
`neg_one_mul (a : R)`, which required real work. The difference is that `7` is
a concrete numeral, not an unknown variable `a`.
`intRing.addGrp.toGroup.inv` unfolds (by the `def intGroup` from Chapter 6)
to `fun a => -a`, so `intRing.addGrp.toGroup.inv 7` reduces directly, by
unfolding and β-reduction alone, to `-7`. No group axiom,
`left_inverse_unique`, or induction is needed, since there is nothing to
generalize over: both sides are already closed, concrete terms that
compute. This is the same "variable vs. concrete numeral" distinction
Chapter 5 draws between definitional and propositional equality.
`neg_one_mul` is a genuine theorem (propositional, requiring proof) precisely
because it quantifies over every ring `R` and every element `a`,
whereas `neg_seven` is true by direct computation the moment every symbol
involved is a closed, already-known term.

---

[← Chapter 8](06-chapter-8.md) | [Index](00-index.md) | [Next: Chapter 10 →](08-chapter-10.md)

## Chapter 9: Ring examples and basic theorems

[← Chapter 8](07-chapter-8.md) | [Index](00-index.md) | [Next: Chapter 10 →](09-chapter-10.md)

---

**1. `theorem neg_mul (a b : R) : Rg.mul (Rg.addGrp.toGroup.inv a) b = Rg.addGrp.toGroup.inv (Rg.mul a b)`**

<p><a href="https://live.lean-lang.org/#code=theorem%20neg_mul%20%28a%20b%20%3A%20R%29%20%3A%0A%20%20%20%20Rg.mul%20%28Rg.addGrp.toGroup.inv%20a%29%20b%20%3D%20Rg.addGrp.toGroup.inv%20%28Rg.mul%20a%20b%29%20%3A%3D%20by%0A%20%20apply%20left_inverse_unique%20Rg.addGrp.toGroup%20%28Rg.mul%20a%20b%29%20%28Rg.mul%20%28Rg.addGrp.toGroup.inv%20a%29%20b%29%0A%20%20--%20Goal%3A%20op%20%28mul%20%28inv%20a%29%20b%29%20%28mul%20a%20b%29%20%3D%20id%0A%20%20rw%20%5B%E2%86%90%20Rg.right_distrib%5D%0A%20%20--%20justified%20by%20right_distrib%2C%20read%20backwards%3A%20combines%20the%20two%20products%0A%20%20--%20mul%20%28inv%20a%29%20b%20and%20mul%20a%20b%20into%20mul%20%28op%20%28inv%20a%29%20a%29%20b.%0A%20%20--%20Goal%3A%20mul%20%28op%20%28inv%20a%29%20a%29%20b%20%3D%20id%0A%20%20rw%20%5BRg.addGrp.toGroup.inv_left%5D%0A%20%20--%20justified%20by%20inv_left%20of%20the%20additive%20group%3A%20op%20%28inv%20a%29%20a%20%3D%20id.%0A%20%20--%20Goal%3A%20mul%20Rg.addGrp.id%20b%20%3D%20id%0A%20%20exact%20mul_zero_left%20Rg%20b" target="_blank" rel="noopener">&#8599; Open in Lean playground (new tab)</a></p>
<iframe src="https://live.lean-lang.org/#code=theorem%20neg_mul%20%28a%20b%20%3A%20R%29%20%3A%0A%20%20%20%20Rg.mul%20%28Rg.addGrp.toGroup.inv%20a%29%20b%20%3D%20Rg.addGrp.toGroup.inv%20%28Rg.mul%20a%20b%29%20%3A%3D%20by%0A%20%20apply%20left_inverse_unique%20Rg.addGrp.toGroup%20%28Rg.mul%20a%20b%29%20%28Rg.mul%20%28Rg.addGrp.toGroup.inv%20a%29%20b%29%0A%20%20--%20Goal%3A%20op%20%28mul%20%28inv%20a%29%20b%29%20%28mul%20a%20b%29%20%3D%20id%0A%20%20rw%20%5B%E2%86%90%20Rg.right_distrib%5D%0A%20%20--%20justified%20by%20right_distrib%2C%20read%20backwards%3A%20combines%20the%20two%20products%0A%20%20--%20mul%20%28inv%20a%29%20b%20and%20mul%20a%20b%20into%20mul%20%28op%20%28inv%20a%29%20a%29%20b.%0A%20%20--%20Goal%3A%20mul%20%28op%20%28inv%20a%29%20a%29%20b%20%3D%20id%0A%20%20rw%20%5BRg.addGrp.toGroup.inv_left%5D%0A%20%20--%20justified%20by%20inv_left%20of%20the%20additive%20group%3A%20op%20%28inv%20a%29%20a%20%3D%20id.%0A%20%20--%20Goal%3A%20mul%20Rg.addGrp.id%20b%20%3D%20id%0A%20%20exact%20mul_zero_left%20Rg%20b" title="Lean playground" loading="lazy" style="width:100%;height:288px;border:1px solid #ccc;border-radius:8px;">
</iframe>

By `left_inverse_unique` (Chapter 7, Theorem 2, applied to the additive
group `Rg.addGrp.toGroup`), it suffices to show that
`Rg.mul (Rg.addGrp.toGroup.inv a) b` is a left additive-inverse of
`Rg.mul a b`. `right_distrib` (used backwards) merges the two products into
`Rg.mul (Rg.addGrp.op (Rg.addGrp.toGroup.inv a) a) b`. Then `inv_left`
collapses the inner sum to `Rg.addGrp.id`, and `mul_zero_left` (proved in
Theorem 2's own section, since `neg_one_mul` there needed it too) finishes
the proof.

**2. `theorem neg_seven : intRing.addGrp.toGroup.inv 7 = -7 := rfl`**

<p><a href="https://live.lean-lang.org/#code=theorem%20neg_seven%20%3A%20intRing.addGrp.toGroup.inv%207%20%3D%20-7%20%3A%3D%20rfl" target="_blank" rel="noopener">&#8599; Open in Lean playground (new tab)</a></p>
<iframe src="https://live.lean-lang.org/#code=theorem%20neg_seven%20%3A%20intRing.addGrp.toGroup.inv%207%20%3D%20-7%20%3A%3D%20rfl" title="Lean playground" loading="lazy" style="width:100%;height:180px;border:1px solid #ccc;border-radius:8px;">
</iframe>

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

[← Chapter 8](07-chapter-8.md) | [Index](00-index.md) | [Next: Chapter 10 →](09-chapter-10.md)

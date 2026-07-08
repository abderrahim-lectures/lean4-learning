## Why bundle proofs with data at all?

[← Accessing the fields](05-accessing-fields.md) | [Index](00-index.md) | [Next: Exercises →](07-exercises.md)

---

Once we have a term `Grp : Group G`, *any* theorem we prove about a
"generic" `Group G` — using only `Grp.assoc`, `Grp.id_left`, etc. — will
automatically apply to `intGroup`, to `perm3Group` (the previous section's
permutation group), and to every other group we build later (path
algebras' underlying additive group, and beyond). This is the payoff of
the whole exercise: prove it once, generically, get it for free
everywhere — Chapter 7 demonstrates exactly this, applying a generic
theorem to a concrete group once it's proved.

---

[← Accessing the fields](05-accessing-fields.md) | [Index](00-index.md) | [Next: Exercises →](07-exercises.md)

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

**Mathlib equivalent.** This "prove it once, get it for free everywhere"
promise is not something Mathlib defers to a later chapter — it's the
reason Mathlib's algebra hierarchy is organized around typeclasses at all.
The *same* lemma name applies unchanged to two utterly different groups:

```lean
example (a b c : Int) : (a + b) + c = a + (b + c) := add_assoc a b c
example (f g h : Equiv.Perm (Fin 3)) : (f * g) * h = f * (g * h) := mul_assoc f g h
```

`add_assoc`/`mul_assoc` were proved exactly once, generically over
`[AddCommGroup G]`/`[Group G]`, and both `Int` and `Equiv.Perm (Fin 3)`
get the fact automatically just by having a `Group`/`AddCommGroup`
instance — nothing about `Int` or permutations is re-proved at either call
site. This is the library-scale version of the payoff Chapter 7 walks
through by hand for `perm3Group`.

---

[← Accessing the fields](05-accessing-fields.md) | [Index](00-index.md) | [Next: Exercises →](07-exercises.md)

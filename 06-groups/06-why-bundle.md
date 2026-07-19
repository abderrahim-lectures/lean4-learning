## Why bundle proofs with data at all?

[← Accessing the fields](05-accessing-fields.md) | [Index](00-index.md) | [Next: Exercises →](07-exercises.md)

---

Given a term `Grp : Group G`, *any* theorem proved about a
"generic" `Group G` (using only `Grp.assoc`, `Grp.id_left`, and so on)
automatically applies to `intGroup`, to `perm3Group` (the previous section's
permutation group), and to every other group constructed later (path
algebras' underlying additive group, and beyond). This is the payoff of
the whole exercise: prove it once, generically, and obtain it for free
everywhere. Chapter 7 demonstrates exactly this, applying a generic
theorem to a concrete group once it is proved.

**Mathlib equivalent.** This "prove it once, get it for free everywhere"
promise is not something Mathlib puts off to a later chapter; it is the
reason Mathlib's algebra hierarchy is organized around typeclasses at all.
The *same* lemma name applies unchanged to two completely different groups:

```lean
example (a b c : Int) : (a + b) + c = a + (b + c) := add_assoc a b c
example (f g h : Equiv.Perm (Fin 3)) : (f * g) * h = f * (g * h) := mul_assoc f g h
```

[`add_assoc`](https://loogle.lean-lang.org/?q=add_assoc)/[`mul_assoc`](https://loogle.lean-lang.org/?q=mul_assoc) were proved exactly once, generically over
`[AddCommGroup G]`/`[Group G]`, and both `Int` and `Equiv.Perm (Fin 3)`
obtain the fact automatically simply by having a `Group`/`AddCommGroup`
instance. Nothing about `Int` or permutations is re-proved at either call
site. This is the library-scale version of the payoff Chapter 7 walks
through by hand for `perm3Group`.

---

[← Accessing the fields](05-accessing-fields.md) | [Index](00-index.md) | [Next: Exercises →](07-exercises.md)

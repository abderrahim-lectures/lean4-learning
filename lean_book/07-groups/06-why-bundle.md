## Why bundle proofs with data at all?

[← Accessing the fields](05-accessing-fields.md) | [Index](00-index.md) | [Next: Exercises →](07-exercises.md)

---

Two groups now exist, `intGroup` and `perm3Group`, built independently,
field by field. Was that duplication of effort, or does it pay for
itself? Given `Grp : Group G`, any theorem proved about a *generic*
`Group G`, using only `Grp.assoc`, `Grp.id_left`, and the other four
fields, applies automatically to `intGroup`, to `perm3Group`, and to
every group built later (the additive group underlying path algebras,
and beyond). Prove it once, generically, obtain it for free everywhere.
Chapter 8 does exactly this.

**Mathlib equivalent.** This "once, free everywhere" promise is not
deferred to a later chapter in Mathlib, which is why the algebra hierarchy
is organized around typeclasses at all. The same lemma name applies
unchanged to two unrelated groups.

```lean
example (a b c : Int) : (a + b) + c = a + (b + c) := add_assoc a b c
example (f g h : Equiv.Perm (Fin 3)) : (f * g) * h = f * (g * h) := mul_assoc f g h
```

[`add_assoc`](https://loogle.lean-lang.org/?q=add_assoc)/[`mul_assoc`](https://loogle.lean-lang.org/?q=mul_assoc) were each proved exactly once, generically over
`[AddCommGroup G]`/`[Group G]`; `Int` and `Equiv.Perm (Fin 3)` obtain the
fact automatically simply by having the instance. Nothing about either
type is re-proved at the call site. This is the library-scale version of
the payoff Chapter 8 carries out by hand for `perm3Group`.

---

[← Accessing the fields](05-accessing-fields.md) | [Index](00-index.md) | [Next: Exercises →](07-exercises.md)

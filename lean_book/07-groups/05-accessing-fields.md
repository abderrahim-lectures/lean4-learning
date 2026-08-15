## Accessing the fields

[← Permutations example](04-permutations-example.md) | [Index](00-index.md) | [Next: Why bundle proofs with data? →](06-why-bundle.md)

---

`intGroup : Group Int` is an ordinary term, so its fields project out
exactly as in Chapter 3.

```lean
#eval intGroup.op 3 4        -- 7
#eval intGroup.id             -- 0
#eval intGroup.inv 5          -- -5

#check intGroup.assoc         -- a proof, for every a b c, of associativity
```

**Mathematical reading.** `intGroup.op` is $\cdot$ (`intGroup.op 3 4` is
$3 + 4 = 7$), `intGroup.id` is $e = 0$, `intGroup.inv` is $(-)^{-1} =
-(-)$. `intGroup.assoc` projects a *proof*: the element of $\forall
a,b,c,\ (a\cdot b)\cdot c = a\cdot(b\cdot c)$ supplied when the group was
built. Data-fields and proof-fields are accessed the same way, since a
`structure` is, underneath, a dependent pair and both are coordinates of
the same tuple.

**Mathlib equivalent.** No field access to write at all. Once `Int` is an
[`AddCommGroup`](https://loogle.lean-lang.org/?q=AddCommGroup), the ordinary `+`/`0`/`-` notations already resolve to that
instance's operations.

```lean
#eval (3 : Int) + 4
#eval (0 : Int)
#eval -(5 : Int)
#check (add_assoc : ∀ a b c : Int, (a + b) + c = a + (b + c))
```

Same contrast as Section 3: `intGroup.op`/`.id`/`.inv` are projections out
of a hand-built bundle; `+`/`0`/`-` are notation the typeclass system has
already wired to the right instance, with the underlying "which
`AddCommGroup` instance" bookkeeping invisible unless sought (for
instance, with `#print`).

---

[← Permutations example](04-permutations-example.md) | [Index](00-index.md) | [Next: Why bundle proofs with data? →](06-why-bundle.md)

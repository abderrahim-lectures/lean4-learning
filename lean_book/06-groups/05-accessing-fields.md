## Accessing the fields

[← Permutations example](04-permutations-example.md) | [Index](00-index.md) | [Next: Why bundle proofs with data? →](06-why-bundle.md)

---

Because `intGroup` is a term of type `Group Int`, we can project out its
fields exactly as in Chapter 2:

```lean
#eval intGroup.op 3 4        -- 7
#eval intGroup.id             -- 0
#eval intGroup.inv 5          -- -5

#check intGroup.assoc         -- a proof, for every a b c, of associativity
```

**Mathematical reading.** The projections recover the individual components
of the structure: `intGroup.op` is the multiplication $\cdot$ (so
`intGroup.op 3 4` is $3 + 4 = 7$ in $\mathbb{Z}$), `intGroup.id` is $e = 0$,
and `intGroup.inv` is $(-)^{-1} = -(-)$. The key point is that
`intGroup.assoc` projects out a *proof*: it is the element of $\forall
a,b,c,\ (a\cdot b)\cdot c = a\cdot(b\cdot c)$ that was supplied when building
the group. Data-fields and proof-fields are accessed the same way because,
in the dependent-pair view (a `structure` is, underneath, exactly this kind
of dependent pair), both are just coordinates of the same tuple.

**Mathlib equivalent.** There is no `intGroup.op 3 4`-style field access to
write at all. Once `Int` is known to be an `AddCommGroup`, the ordinary
`+`/`0`/`-` notations already resolve to that instance's operations
directly:

```lean
#eval (3 : Int) + 4
#eval (0 : Int)
#eval -(5 : Int)
#check (add_assoc : ∀ a b c : Int, (a + b) + c = a + (b + c))
```

This is the same contrast as §3: the book's `intGroup.op`/`.id`/`.inv` are
projections out of a bundle you built yourself, while Mathlib's `+`/`0`/
`-` are notation that the typeclass system has already wired to the right
instance. You never see the underlying "which `AddCommGroup` instance is
this?" bookkeeping unless you go looking for it (for example, with `#print`).

---

[← Permutations example](04-permutations-example.md) | [Index](00-index.md) | [Next: Why bundle proofs with data? →](06-why-bundle.md)

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
`intGroup.assoc` projects out a *proof* — it is the element of $\forall
a,b,c,\ (a\cdot b)\cdot c = a\cdot(b\cdot c)$ that was supplied when building
the group. Data-fields and proof-fields are accessed uniformly because, in
the dependent-pair view, both are just coordinates of the same tuple.

---

[← Permutations example](04-permutations-example.md) | [Index](00-index.md) | [Next: Why bundle proofs with data? →](06-why-bundle.md)

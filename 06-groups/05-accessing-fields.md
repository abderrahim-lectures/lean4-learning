## Accessing the fields

[← Permutations example](04-permutations-example.md) | [Index](00-index.md) | [Next: Why bundle proofs with data? →](06-why-bundle.md)

---

Because `intGroup` is a term of type `Group Int`, its
fields can be projected out exactly as in Chapter 2:

<p><a href="https://live.lean-lang.org/#code=structure%20GroupData%20%28G%20%3A%20Type%29%20where%0A%20%20op%20%3A%20G%20%E2%86%92%20G%20%E2%86%92%20G%0A%20%20id%20%3A%20G%0A%20%20inv%20%3A%20G%20%E2%86%92%20G%0A%0Astructure%20Group%20%28G%20%3A%20Type%29%20where%0A%20%20op%20%3A%20G%20%E2%86%92%20G%20%E2%86%92%20G%0A%20%20id%20%3A%20G%0A%20%20inv%20%3A%20G%20%E2%86%92%20G%0A%20%20assoc%20%3A%20%E2%88%80%20a%20b%20c%20%3A%20G%2C%20op%20%28op%20a%20b%29%20c%20%3D%20op%20a%20%28op%20b%20c%29%0A%20%20id_left%20%3A%20%E2%88%80%20a%20%3A%20G%2C%20op%20id%20a%20%3D%20a%0A%20%20id_right%20%3A%20%E2%88%80%20a%20%3A%20G%2C%20op%20a%20id%20%3D%20a%0A%20%20inv_left%20%3A%20%E2%88%80%20a%20%3A%20G%2C%20op%20%28inv%20a%29%20a%20%3D%20id%0A%20%20inv_right%20%3A%20%E2%88%80%20a%20%3A%20G%2C%20op%20a%20%28inv%20a%29%20%3D%20id%0A%0Adef%20intGroup%20%3A%20Group%20Int%20where%0A%20%20op%20%3A%3D%20fun%20a%20b%20%3D%3E%20a%20%2B%20b%0A%20%20id%20%3A%3D%200%0A%20%20inv%20%3A%3D%20fun%20a%20%3D%3E%20-a%0A%20%20assoc%20%3A%3D%20by%0A%20%20%20%20intro%20a%20b%20c%0A%20%20%20%20--%20Goal%3A%20%28a%20%2B%20b%29%20%2B%20c%20%3D%20a%20%2B%20%28b%20%2B%20c%29%0A%20%20%20%20exact%20Int.add_assoc%20a%20b%20c%0A%20%20id_left%20%3A%3D%20by%0A%20%20%20%20intro%20a%0A%20%20%20%20--%20Goal%3A%200%20%2B%20a%20%3D%20a%0A%20%20%20%20exact%20Int.zero_add%20a%0A%20%20id_right%20%3A%3D%20by%0A%20%20%20%20intro%20a%0A%20%20%20%20--%20Goal%3A%20a%20%2B%200%20%3D%20a%0A%20%20%20%20exact%20Int.add_zero%20a%0A%20%20inv_left%20%3A%3D%20by%0A%20%20%20%20intro%20a%0A%20%20%20%20--%20Goal%3A%20%28-a%29%20%2B%20a%20%3D%200%0A%20%20%20%20exact%20Int.add_left_neg%20a%0A%20%20inv_right%20%3A%3D%20by%0A%20%20%20%20intro%20a%0A%20%20%20%20--%20Goal%3A%20a%20%2B%20%28-a%29%20%3D%200%0A%20%20%20%20exact%20Int.add_right_neg%20a%0A%0A%23eval%20intGroup.op%203%204%20%20%20%20%20%20%20%20--%207%0A%23eval%20intGroup.id%20%20%20%20%20%20%20%20%20%20%20%20%20--%200%0A%23eval%20intGroup.inv%205%20%20%20%20%20%20%20%20%20%20--%20-5%0A%0A%23check%20intGroup.assoc" target="_blank" rel="noopener">&#8599; Open in Lean playground (new tab)</a></p>
<iframe src="https://live.lean-lang.org/#code=structure%20GroupData%20%28G%20%3A%20Type%29%20where%0A%20%20op%20%3A%20G%20%E2%86%92%20G%20%E2%86%92%20G%0A%20%20id%20%3A%20G%0A%20%20inv%20%3A%20G%20%E2%86%92%20G%0A%0Astructure%20Group%20%28G%20%3A%20Type%29%20where%0A%20%20op%20%3A%20G%20%E2%86%92%20G%20%E2%86%92%20G%0A%20%20id%20%3A%20G%0A%20%20inv%20%3A%20G%20%E2%86%92%20G%0A%20%20assoc%20%3A%20%E2%88%80%20a%20b%20c%20%3A%20G%2C%20op%20%28op%20a%20b%29%20c%20%3D%20op%20a%20%28op%20b%20c%29%0A%20%20id_left%20%3A%20%E2%88%80%20a%20%3A%20G%2C%20op%20id%20a%20%3D%20a%0A%20%20id_right%20%3A%20%E2%88%80%20a%20%3A%20G%2C%20op%20a%20id%20%3D%20a%0A%20%20inv_left%20%3A%20%E2%88%80%20a%20%3A%20G%2C%20op%20%28inv%20a%29%20a%20%3D%20id%0A%20%20inv_right%20%3A%20%E2%88%80%20a%20%3A%20G%2C%20op%20a%20%28inv%20a%29%20%3D%20id%0A%0Adef%20intGroup%20%3A%20Group%20Int%20where%0A%20%20op%20%3A%3D%20fun%20a%20b%20%3D%3E%20a%20%2B%20b%0A%20%20id%20%3A%3D%200%0A%20%20inv%20%3A%3D%20fun%20a%20%3D%3E%20-a%0A%20%20assoc%20%3A%3D%20by%0A%20%20%20%20intro%20a%20b%20c%0A%20%20%20%20--%20Goal%3A%20%28a%20%2B%20b%29%20%2B%20c%20%3D%20a%20%2B%20%28b%20%2B%20c%29%0A%20%20%20%20exact%20Int.add_assoc%20a%20b%20c%0A%20%20id_left%20%3A%3D%20by%0A%20%20%20%20intro%20a%0A%20%20%20%20--%20Goal%3A%200%20%2B%20a%20%3D%20a%0A%20%20%20%20exact%20Int.zero_add%20a%0A%20%20id_right%20%3A%3D%20by%0A%20%20%20%20intro%20a%0A%20%20%20%20--%20Goal%3A%20a%20%2B%200%20%3D%20a%0A%20%20%20%20exact%20Int.add_zero%20a%0A%20%20inv_left%20%3A%3D%20by%0A%20%20%20%20intro%20a%0A%20%20%20%20--%20Goal%3A%20%28-a%29%20%2B%20a%20%3D%200%0A%20%20%20%20exact%20Int.add_left_neg%20a%0A%20%20inv_right%20%3A%3D%20by%0A%20%20%20%20intro%20a%0A%20%20%20%20--%20Goal%3A%20a%20%2B%20%28-a%29%20%3D%200%0A%20%20%20%20exact%20Int.add_right_neg%20a%0A%0A%23eval%20intGroup.op%203%204%20%20%20%20%20%20%20%20--%207%0A%23eval%20intGroup.id%20%20%20%20%20%20%20%20%20%20%20%20%20--%200%0A%23eval%20intGroup.inv%205%20%20%20%20%20%20%20%20%20%20--%20-5%0A%0A%23check%20intGroup.assoc" title="Lean playground" loading="lazy" style="width:100%;height:180px;border:1px solid #ccc;border-radius:8px;">
</iframe>

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
write at all. Once `Int` is known to be an [`AddCommGroup`](https://loogle.lean-lang.org/?q=AddCommGroup), the ordinary
`+`/`0`/`-` notations already resolve to that instance's operations
directly:

<p><a href="https://live.lean-lang.org/#code=import%20Mathlib%0A%0A%23eval%20%283%20%3A%20Int%29%20%2B%204%0A%23eval%20%280%20%3A%20Int%29%0A%23eval%20-%285%20%3A%20Int%29%0A%23check%20%28add_assoc%20%3A%20%E2%88%80%20a%20b%20c%20%3A%20Int%2C%20%28a%20%2B%20b%29%20%2B%20c%20%3D%20a%20%2B%20%28b%20%2B%20c%29%29" target="_blank" rel="noopener">&#8599; Open in Lean playground (new tab)</a></p>
<iframe src="https://live.lean-lang.org/#code=import%20Mathlib%0A%0A%23eval%20%283%20%3A%20Int%29%20%2B%204%0A%23eval%20%280%20%3A%20Int%29%0A%23eval%20-%285%20%3A%20Int%29%0A%23check%20%28add_assoc%20%3A%20%E2%88%80%20a%20b%20c%20%3A%20Int%2C%20%28a%20%2B%20b%29%20%2B%20c%20%3D%20a%20%2B%20%28b%20%2B%20c%29%29" title="Lean playground" loading="lazy" style="width:100%;height:180px;border:1px solid #ccc;border-radius:8px;">
</iframe>

This is the same contrast as §3: the book's `intGroup.op`/`.id`/`.inv` are
projections out of a bundle built by hand, while Mathlib's `+`/`0`/
`-` are notation that the typeclass system has already wired to the right
instance. The underlying "which `AddCommGroup` instance is
this?" bookkeeping remains invisible unless sought out (for example, with `#print`).

---

[← Permutations example](04-permutations-example.md) | [Index](00-index.md) | [Next: Why bundle proofs with data? →](06-why-bundle.md)

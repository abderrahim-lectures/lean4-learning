## Example: the integers as a ring

[← Ring](03-ring.md) | [Index](00-index.md) | [Next: Finite ring example →](05-finite-ring-example.md)

---

We reuse `intGroup` from Chapter 6 as the additive part.

<p><a href="https://live.lean-lang.org/#code=def%20intCommGroup%20%3A%20CommGroup%20Int%20where%0A%20%20toGroup%20%3A%3D%20intGroup%0A%20%20comm%20%3A%3D%20by%0A%20%20%20%20intro%20a%20b%0A%20%20%20%20exact%20Int.add_comm%20a%20b" target="_blank" rel="noopener">&#8599; Open in Lean playground (new tab)</a></p>
<iframe src="https://live.lean-lang.org/#code=def%20intCommGroup%20%3A%20CommGroup%20Int%20where%0A%20%20toGroup%20%3A%3D%20intGroup%0A%20%20comm%20%3A%3D%20by%0A%20%20%20%20intro%20a%20b%0A%20%20%20%20exact%20Int.add_comm%20a%20b" title="Lean playground" loading="lazy" style="width:100%;height:180px;border:1px solid #ccc;border-radius:8px;">
</iframe>

`toGroup := intGroup` fills the field inherited from `Group Int` inside
`CommGroup Int`'s definition. This is how `extends` works mechanically:
under the hood, `CommGroup G` really has fields `toGroup : Group G` and
`comm : ...`, and Lean's dot-notation makes `cg.op` mean `cg.toGroup.op`
automatically.

<p><a href="https://live.lean-lang.org/#code=def%20intRing%20%3A%20Ring%20Int%20where%0A%20%20addGrp%20%3A%3D%20intCommGroup%0A%20%20mul%20%3A%3D%20fun%20a%20b%20%3D%3E%20a%20%2A%20b%0A%20%20one%20%3A%3D%201%0A%20%20mul_assoc%20%3A%3D%20by%0A%20%20%20%20intro%20a%20b%20c%0A%20%20%20%20exact%20Int.mul_assoc%20a%20b%20c%0A%20%20one_mul%20%3A%3D%20by%0A%20%20%20%20intro%20a%0A%20%20%20%20exact%20Int.one_mul%20a%0A%20%20mul_one%20%3A%3D%20by%0A%20%20%20%20intro%20a%0A%20%20%20%20exact%20Int.mul_one%20a%0A%20%20left_distrib%20%3A%3D%20by%0A%20%20%20%20intro%20a%20b%20c%0A%20%20%20%20exact%20Int.mul_add%20a%20b%20c%0A%20%20right_distrib%20%3A%3D%20by%0A%20%20%20%20intro%20a%20b%20c%0A%20%20%20%20exact%20Int.add_mul%20a%20b%20c" target="_blank" rel="noopener">&#8599; Open in Lean playground (new tab)</a></p>
<iframe src="https://live.lean-lang.org/#code=def%20intRing%20%3A%20Ring%20Int%20where%0A%20%20addGrp%20%3A%3D%20intCommGroup%0A%20%20mul%20%3A%3D%20fun%20a%20b%20%3D%3E%20a%20%2A%20b%0A%20%20one%20%3A%3D%201%0A%20%20mul_assoc%20%3A%3D%20by%0A%20%20%20%20intro%20a%20b%20c%0A%20%20%20%20exact%20Int.mul_assoc%20a%20b%20c%0A%20%20one_mul%20%3A%3D%20by%0A%20%20%20%20intro%20a%0A%20%20%20%20exact%20Int.one_mul%20a%0A%20%20mul_one%20%3A%3D%20by%0A%20%20%20%20intro%20a%0A%20%20%20%20exact%20Int.mul_one%20a%0A%20%20left_distrib%20%3A%3D%20by%0A%20%20%20%20intro%20a%20b%20c%0A%20%20%20%20exact%20Int.mul_add%20a%20b%20c%0A%20%20right_distrib%20%3A%3D%20by%0A%20%20%20%20intro%20a%20b%20c%0A%20%20%20%20exact%20Int.add_mul%20a%20b%20c" title="Lean playground" loading="lazy" style="width:100%;height:421px;border:1px solid #ccc;border-radius:8px;">
</iframe>

Every proof obligation is again a one-line `exact` naming a specific
core-library fact about `Int` (`Int.mul_assoc`, `Int.one_mul`, ...), exactly
as in Chapter 6. Integer arithmetic is not being proved from nothing; rather,
already-known facts are assembled into the `Ring` bundle.

**Mathematical reading.** This shows $(\mathbb{Z}, +, \times, 0, 1)$ as
an object of $\mathbf{Ring}$ — in fact the
[*initial* object](../01-basics/04-terminology.md#category-theory-terms-used-beyond-the-baseline),
since there is a
unique **ring homomorphism** $\mathbb{Z} \to R$ into any ring — a
function preserving $+$, $\times$, $0$, and $1$ ([DummitFoote2003]).
First
`intCommGroup` upgrades the additive group $(\mathbb{Z},+)$ to an abelian
group by supplying commutativity ($a + b = b + a$); then `intRing` adds the
multiplicative monoid $(\mathbb{Z}, \times, 1)$ and checks the distributive
laws $a(b+c) = ab + ac$ and $(a+b)c = ac + bc$. Each obligation is the named
$\mathbb{Z}$-arithmetic fact, so the term is the formal counterpart of
"$\mathbb{Z}$ is a commutative ring."

**Mathlib equivalent.** `Int` is already a [`CommRing`](https://loogle.lean-lang.org/?q=CommRing) instance, so there is no
`intRing`-style bundle to build. The obligations `intRing` checks by hand
are, again, generic lemmas that hold for every commutative ring:

<p><a href="https://live.lean-lang.org/#code=example%20%3A%20CommRing%20Int%20%3A%3D%20inferInstance%0A%0Aexample%20%28a%20b%20c%20%3A%20Int%29%20%3A%20%28a%20%2A%20b%29%20%2A%20c%20%3D%20a%20%2A%20%28b%20%2A%20c%29%20%3A%3D%20mul_assoc%20a%20b%20c%0Aexample%20%28a%20%3A%20Int%29%20%3A%201%20%2A%20a%20%3D%20a%20%3A%3D%20one_mul%20a%0Aexample%20%28a%20%3A%20Int%29%20%3A%20a%20%2A%201%20%3D%20a%20%3A%3D%20mul_one%20a%0Aexample%20%28a%20b%20c%20%3A%20Int%29%20%3A%20a%20%2A%20%28b%20%2B%20c%29%20%3D%20a%20%2A%20b%20%2B%20a%20%2A%20c%20%3A%3D%20mul_add%20a%20b%20c%0Aexample%20%28a%20b%20c%20%3A%20Int%29%20%3A%20%28a%20%2B%20b%29%20%2A%20c%20%3D%20a%20%2A%20c%20%2B%20b%20%2A%20c%20%3A%3D%20add_mul%20a%20b%20c" target="_blank" rel="noopener">&#8599; Open in Lean playground (new tab)</a></p>
<iframe src="https://live.lean-lang.org/#code=example%20%3A%20CommRing%20Int%20%3A%3D%20inferInstance%0A%0Aexample%20%28a%20b%20c%20%3A%20Int%29%20%3A%20%28a%20%2A%20b%29%20%2A%20c%20%3D%20a%20%2A%20%28b%20%2A%20c%29%20%3A%3D%20mul_assoc%20a%20b%20c%0Aexample%20%28a%20%3A%20Int%29%20%3A%201%20%2A%20a%20%3D%20a%20%3A%3D%20one_mul%20a%0Aexample%20%28a%20%3A%20Int%29%20%3A%20a%20%2A%201%20%3D%20a%20%3A%3D%20mul_one%20a%0Aexample%20%28a%20b%20c%20%3A%20Int%29%20%3A%20a%20%2A%20%28b%20%2B%20c%29%20%3D%20a%20%2A%20b%20%2B%20a%20%2A%20c%20%3A%3D%20mul_add%20a%20b%20c%0Aexample%20%28a%20b%20c%20%3A%20Int%29%20%3A%20%28a%20%2B%20b%29%20%2A%20c%20%3D%20a%20%2A%20c%20%2B%20b%20%2A%20c%20%3A%3D%20add_mul%20a%20b%20c" title="Lean playground" loading="lazy" style="width:100%;height:193px;border:1px solid #ccc;border-radius:8px;">
</iframe>

[`mul_add`](https://loogle.lean-lang.org/?q=mul_add)/[`add_mul`](https://loogle.lean-lang.org/?q=add_mul) are Mathlib's names for `left_distrib`/`right_distrib`.
They are the same laws, but stated generically over `[Ring R]` (or the weaker
`[Distrib R]`) instead of being cited per-type as `Int.mul_add`/`Int.add_mul`.

---

### References

Full citations in the [Bibliography](../bibliography.md).

- Dummit and Foote ([DummitFoote2003]) — the standard definition of a ring homomorphism, used above.

[DummitFoote2003]: ../bibliography.md#dummitfoote2003

---

[← Ring](03-ring.md) | [Index](00-index.md) | [Next: Finite ring example →](05-finite-ring-example.md)

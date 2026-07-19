## Translating into Lean

[← The mathematical definition](01-definition.md) | [Index](00-index.md) | [Next: Z-module example →](03-z-module-example.md)

---

The same "data, then axioms" build used for `Group` and `Ring` applies here:

<p><a href="https://live.lean-lang.org/#code=structure%20Module%20%28R%20%3A%20Type%29%20%28Rg%20%3A%20Ring%20R%29%20%28M%20%3A%20Type%29%20where%0A%20%20addGrp%20%3A%20CommGroup%20M%0A%20%20smul%20%3A%20R%20%E2%86%92%20M%20%E2%86%92%20M%0A%20%20smul_add%20%3A%20%E2%88%80%20%28r%20%3A%20R%29%20%28m%20n%20%3A%20M%29%2C%20smul%20r%20%28addGrp.op%20m%20n%29%20%3D%20addGrp.op%20%28smul%20r%20m%29%20%28smul%20r%20n%29%0A%20%20add_smul%20%3A%20%E2%88%80%20%28r%20s%20%3A%20R%29%20%28m%20%3A%20M%29%2C%20smul%20%28Rg.addGrp.op%20r%20s%29%20m%20%3D%20addGrp.op%20%28smul%20r%20m%29%20%28smul%20s%20m%29%0A%20%20smul_smul%20%3A%20%E2%88%80%20%28r%20s%20%3A%20R%29%20%28m%20%3A%20M%29%2C%20smul%20%28Rg.mul%20r%20s%29%20m%20%3D%20smul%20r%20%28smul%20s%20m%29%0A%20%20one_smul%20%3A%20%E2%88%80%20m%20%3A%20M%2C%20smul%20Rg.one%20m%20%3D%20m" target="_blank" rel="noopener">&#8599; Open in Lean playground (new tab)</a></p>
<iframe src="https://live.lean-lang.org/#code=structure%20Module%20%28R%20%3A%20Type%29%20%28Rg%20%3A%20Ring%20R%29%20%28M%20%3A%20Type%29%20where%0A%20%20addGrp%20%3A%20CommGroup%20M%0A%20%20smul%20%3A%20R%20%E2%86%92%20M%20%E2%86%92%20M%0A%20%20smul_add%20%3A%20%E2%88%80%20%28r%20%3A%20R%29%20%28m%20n%20%3A%20M%29%2C%20smul%20r%20%28addGrp.op%20m%20n%29%20%3D%20addGrp.op%20%28smul%20r%20m%29%20%28smul%20r%20n%29%0A%20%20add_smul%20%3A%20%E2%88%80%20%28r%20s%20%3A%20R%29%20%28m%20%3A%20M%29%2C%20smul%20%28Rg.addGrp.op%20r%20s%29%20m%20%3D%20addGrp.op%20%28smul%20r%20m%29%20%28smul%20s%20m%29%0A%20%20smul_smul%20%3A%20%E2%88%80%20%28r%20s%20%3A%20R%29%20%28m%20%3A%20M%29%2C%20smul%20%28Rg.mul%20r%20s%29%20m%20%3D%20smul%20r%20%28smul%20s%20m%29%0A%20%20one_smul%20%3A%20%E2%88%80%20m%20%3A%20M%2C%20smul%20Rg.one%20m%20%3D%20m" title="Lean playground" loading="lazy" style="width:100%;height:193px;border:1px solid #ccc;border-radius:8px;">
</iframe>

Field by field:

- `addGrp : CommGroup M` — the underlying abelian group of the module,
  exactly as `addGrp` played this role inside `Ring` (Chapter 8). Note that
  `Module` takes `Rg : Ring R` as an *explicit argument*, not a field: a
  module is always a module *over* a specific, already-given ring, so `Rg`
  is a parameter of the whole structure rather than data bundled inside it.
- `smul : R → M → M` — the scalar action, `r • m` in ordinary notation.
- `smul_add`, `add_smul` — the two distributivity laws (M1), (M2). Read
  them as "scalar over module-sum" and "ring-sum over scalar". This is the
  same left/right split used for `Ring`'s `left_distrib`/`right_distrib`,
  but here the split is based on *which* addition (`Rg.addGrp.op` vs.
  `addGrp.op`) is involved, not on which side `mul` is applied.
- `smul_smul` — (M3), compatibility of the ring's multiplication with
  iterated scalar action.
- `one_smul` — (M4), the ring's multiplicative identity acts as the
  identity scalar.

**Mathematical reading.** `Module R Rg M` is the type of left $R$-module
structures on the abelian group $M$. The data is an action $R \times M \to
M$, $(r,m)\mapsto r\cdot m$. The four axioms say precisely that the
curried map $\rho(r)(m) = r\cdot m$ is a **ring homomorphism** from $R$ into
the ring of endomorphisms of $(M,+)$: the additive maps $M \to M$, under
pointwise addition and composition. `smul_add` says each $\rho(r)$ is itself
additive (a homomorphism $M \to M$ of abelian groups). `add_smul` and
`smul_smul` say $\rho$ preserves $+$ and $\times$. And `one_smul` says
$\rho(1)$ is the identity map on $M$. So a module over $R$ is exactly an
abelian group $M$ equipped with a ring homomorphism from $R$ into its own
ring of endomorphisms. The ring $R$ enters as an explicit *parameter*, not
as extra bundled data on $M$, because a module is always a module *over*
some already-fixed ring.

> Read more: Mathlib's [`Module`](https://loogle.lean-lang.org/?q=Module) (`Mathlib.Algebra.Module.Defs`) is much
> more general. It is universe-polymorphic, stated for `Semiring` rather
> than just `Ring`, and integrated with the whole `Mathlib.LinearAlgebra.*`
> hierarchy (bases, dimension, tensor products); see
> [Chapter 13](../13-next-steps/02-moving-to-mathlib.md). For the
> classical theory, any standard module-theory or homological-algebra text
> (e.g. Dummit & Foote's chapters on modules, or Weibel's *An Introduction
> to Homological Algebra* for the deeper theory) covers the same axioms
> from the ground up.

### References

Full citations in the [Bibliography](../bibliography.md).

- Dummit and Foote ([DummitFoote2003]) — the module axioms (M1)–(M4) from the classical, non-Lean point of view.
- Weibel ([Weibel1994]) — the deeper module/homological theory this section's "Read more" points toward.

[DummitFoote2003]: ../bibliography.md#dummitfoote2003
[Weibel1994]: ../bibliography.md#weibel1994

---

[← The mathematical definition](01-definition.md) | [Index](00-index.md) | [Next: Z-module example →](03-z-module-example.md)

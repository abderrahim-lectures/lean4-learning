## Translating into Lean

[← The mathematical definition](01-definition.md) | [Index](00-index.md) | [Next: Z-module example →](03-z-module-example.md)

---

We follow the same "data, then axioms" build as `Group` and `Ring`:

```lean
structure Module (R : Type) (Rg : Ring R) (M : Type) where
  addGrp : CommGroup M
  smul : R → M → M
  smul_add : ∀ (r : R) (m n : M), smul r (addGrp.op m n) = addGrp.op (smul r m) (smul r n)
  add_smul : ∀ (r s : R) (m : M), smul (Rg.addGrp.op r s) m = addGrp.op (smul r m) (smul s m)
  smul_smul : ∀ (r s : R) (m : M), smul (Rg.mul r s) m = smul r (smul s m)
  one_smul : ∀ m : M, smul Rg.one m = m
```

Field by field:

- `addGrp : CommGroup M` — the underlying abelian group of the module,
  exactly as `addGrp` played this role inside `Ring` (Chapter 8). Note that
  `Module` takes `Rg : Ring R` as an *explicit argument*, not a field. A
  module is always a module *over* a specific, already-given ring. So `Rg`
  is a parameter of the whole structure, not data bundled inside it.
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

---

[← The mathematical definition](01-definition.md) | [Index](00-index.md) | [Next: Z-module example →](03-z-module-example.md)

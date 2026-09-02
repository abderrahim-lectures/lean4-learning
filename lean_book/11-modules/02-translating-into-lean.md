## Translating into Lean

[← The mathematical definition](01-definition.md) | [Index](00-index.md) | [Next: Z-module example →](03-z-module-example.md)

---

Section 1 stated the module axioms on paper, as the same "abelian group
plus a compatible action" pattern already used for `Group` and `Ring`
throughout Chapters 7–10. A definition stated on paper is not yet a
definition Lean can check against; it still has to be written down as a
`structure`, field by field, exactly as `Group` and `Ring` were before it.
That translation is what this section carries out.

The same "data, then axioms" build used for `Group` and `Ring` applies here.

```lean
structure Module (R : Type) (Rg : Ring R) (M : Type) where
  addGrp : CommGroup M
  smul : R → M → M
  smul_add : ∀ (r : R) (m n : M), smul r (addGrp.op m n) = addGrp.op (smul r m) (smul r n)
  add_smul : ∀ (r s : R) (m : M), smul (Rg.addGrp.op r s) m = addGrp.op (smul r m) (smul s m)
  smul_smul : ∀ (r s : R) (m : M), smul (Rg.mul r s) m = smul r (smul s m)
  one_smul : ∀ m : M, smul Rg.one m = m
```

Field by field.

- `addGrp : CommGroup M` is the underlying abelian group of the module,
  exactly as `addGrp` played this role inside `Ring` (Chapter 9). Note that
  `Module` takes `Rg : Ring R` as an *explicit argument*, not a field. A
  module is always a module *over* a specific, already-given ring, so `Rg`
  is a parameter of the whole structure rather than data bundled inside it.
- `smul : R → M → M` is the scalar action, `r • m` in ordinary notation.
- `smul_add`, `add_smul` are the two distributivity laws (M1), (M2). Read
  them as "scalar over module-sum" and "ring-sum over scalar." This is the
  same left/right split used for `left_distrib`/`right_distrib` of `Ring`,
  but here the split is based on *which* addition (`Rg.addGrp.op` vs.
  `addGrp.op`) is involved, not on which side `mul` is applied.
- `smul_smul` is (M3), compatibility of the multiplication of the ring with
  iterated scalar action.
- `one_smul` is (M4), the multiplicative identity of the ring acts as the
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

> Read more. `Module` in Mathlib ([`Module`](https://loogle.lean-lang.org/?q=Module), `Mathlib.Algebra.Module.Defs`) is much
> more general. It is universe-polymorphic, stated for `Semiring` rather
> than just `Ring`, and integrated with the whole `Mathlib.LinearAlgebra.*`
> hierarchy (bases, dimension, tensor products); see
> [Chapter 14](../14-next-steps/02-moving-to-mathlib.md). For the
> classical theory, any standard module-theory or homological-algebra text
> (e.g. the chapters on modules in Dummit & Foote, or *An Introduction
> to Homological Algebra* by Weibel for the deeper theory) covers the same axioms
> from the ground up.

**Programmer note (Python).** `smul : R → M → M` fixes, once and for
all, which type plays the role of scalars and which type plays the role
of module elements. A Python library implementing the same "scalar acts
on a vector" idea usually overloads `__mul__` or `__rmul__` instead.

```python
class Vector:
    def __init__(self, xs):
        self.xs = xs

    def __rmul__(self, scalar):
        return Vector([scalar * x for x in self.xs])

v = Vector([1, 2, 3])
w = 2 * v            # fine, Vector([2, 4, 6])
broken = v * v       # TypeError, but only once this exact line runs
```

Whether `v * v` is even meaningful depends entirely on which dunder
methods someone remembered to define, and the answer is only found out
by running the offending line, possibly deep inside a call stack far
from where `v` was first constructed. `smul` has no such ambiguity.
Its type `R → M → M` states, before any theorem in this chapter is
proved, that a scalar comes from `R` and a module element comes from
`M`, and Lean rejects `smul v m` at the point it is written if `v : M`
was passed where an `R` was expected, rather than accepting it and
producing a wrong answer, or an exception, once the program actually
runs.

### Sources, quoted

Formal definitions and citations for this section, gathered here for
reference (full entries in the [Bibliography](../bibliography.md)):

- **Module.** "A binary operation $+$ on $M$ under which $M$ is an
  abelian group, and ... an action of $R$ on $M$ ... (a)
  $(r+s)m = rm+sm$ ... (b) $(rs)m = r(sm)$ ... (c)
  $r(m+n) = rm+rn$ ... (d) $1m = m$" ([DummitFoote2003], §10.1
  "Basic Definitions and Examples," p. 336).
- Weibel ([Weibel1994]) covers the deeper module/homological theory the "Read more" note of this section points toward.

[DummitFoote2003]: ../bibliography.md#dummitfoote2003
[Weibel1994]: ../bibliography.md#weibel1994

---

[← The mathematical definition](01-definition.md) | [Index](00-index.md) | [Next: Z-module example →](03-z-module-example.md)

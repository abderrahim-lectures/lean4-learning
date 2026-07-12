## Accessing nested fields

[← Finite ring example](05-finite-ring-example.md) | [Index](00-index.md) | [Next: Matrices →](07-matrices.md)

---

```lean
#eval intRing.addGrp.op 3 4     -- 7  (addition, via the nested CommGroup)
#eval intRing.mul 3 4            -- 12 (multiplication)
#eval intRing.one                 -- 1
#eval intRing.addGrp.toGroup.inv 5   -- -5  (additive inverse, via Group inside CommGroup)
```

**Mathematical reading.** The chained projections walk down the tower of
[forgetful functors](../01-basics/04-terminology.md#category-theory-terms-used-beyond-the-baseline)
$\mathbf{Ring} \to \mathbf{Ab} \to \mathbf{Grp}$:
`intRing.addGrp` applies $\mathbf{Ring}\to\mathbf{Ab}$ (recovering $(\mathbb{Z},
+)$), and `.toGroup` applies $\mathbf{Ab}\to\mathbf{Grp}$. So
`intRing.addGrp.toGroup.inv 5` computes the additive inverse $-5$ in the
underlying group, while `intRing.mul`/`intRing.one` read off the
multiplicative data $\times$ and $1$. Nested dot-access is just evaluating
these structure-forgetting maps.

**Mathlib equivalent.** There is no chain of `.addGrp.toGroup.inv`-style projections
to write — `+`/`*`/`0`/`1`/`-` already resolve to `Int`'s `CommRing`
instance directly:

```lean
#eval (3 : Int) + 4     -- 7
#eval (3 : Int) * 4      -- 12
#eval (1 : Int)          -- 1
#eval -(5 : Int)          -- -5
```

The book's nested projections walk down a tower of structures you built
yourself (`Ring → CommGroup → Group`). Mathlib's typeclass resolution walks
down a similar tower of instances (`CommRing → Ring → ... → AddCommGroup`)
automatically, so the notation never needs to name which layer it's coming
from.

---

[← Finite ring example](05-finite-ring-example.md) | [Index](00-index.md) | [Next: Matrices →](07-matrices.md)

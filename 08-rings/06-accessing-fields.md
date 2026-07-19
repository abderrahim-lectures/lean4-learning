## Accessing nested fields

[← Finite ring example](05-finite-ring-example.md) | [Index](00-index.md) | [Next: Matrices →](07-matrices.md)

---

<p><a href="https://live.lean-lang.org/#code=%23eval%20intRing.addGrp.op%203%204%20%20%20%20%20--%207%20%20%28addition%2C%20via%20the%20nested%20CommGroup%29%0A%23eval%20intRing.mul%203%204%20%20%20%20%20%20%20%20%20%20%20%20--%2012%20%28multiplication%29%0A%23eval%20intRing.one%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20--%201%0A%23eval%20intRing.addGrp.toGroup.inv%205%20%20%20--%20-5%20%20%28additive%20inverse%2C%20via%20Group%20inside%20CommGroup%29" target="_blank" rel="noopener">&#8599; Open in Lean playground (new tab)</a></p>
<iframe src="https://live.lean-lang.org/#code=%23eval%20intRing.addGrp.op%203%204%20%20%20%20%20--%207%20%20%28addition%2C%20via%20the%20nested%20CommGroup%29%0A%23eval%20intRing.mul%203%204%20%20%20%20%20%20%20%20%20%20%20%20--%2012%20%28multiplication%29%0A%23eval%20intRing.one%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20--%201%0A%23eval%20intRing.addGrp.toGroup.inv%205%20%20%20--%20-5%20%20%28additive%20inverse%2C%20via%20Group%20inside%20CommGroup%29" title="Lean playground" loading="lazy" style="width:100%;height:180px;border:1px solid #ccc;border-radius:8px;">
</iframe>

**Mathematical reading.** The chained projections walk down the tower of
[forgetful functors](../01-basics/04-terminology.md#category-theory-terms-used-beyond-the-baseline)
$\mathbf{Ring} \to \mathbf{Ab} \to \mathbf{Grp}$:
`intRing.addGrp` applies $\mathbf{Ring}\to\mathbf{Ab}$ (recovering $(\mathbb{Z},
+)$), and `.toGroup` applies $\mathbf{Ab}\to\mathbf{Grp}$. Thus,
`intRing.addGrp.toGroup.inv 5` computes the additive inverse $-5$ in the
underlying group, while `intRing.mul`/`intRing.one` read off the
multiplicative data $\times$ and $1$. Nested dot-access is just evaluating
these structure-forgetting maps.

**Mathlib equivalent.** There is no chain of `.addGrp.toGroup.inv`-style projections
to write — `+`/`*`/`0`/`1`/`-` already resolve to `Int`'s `CommRing`
instance directly:

<p><a href="https://live.lean-lang.org/#code=%23eval%20%283%20%3A%20Int%29%20%2B%204%20%20%20%20%20--%207%0A%23eval%20%283%20%3A%20Int%29%20%2A%204%20%20%20%20%20%20--%2012%0A%23eval%20%281%20%3A%20Int%29%20%20%20%20%20%20%20%20%20%20--%201%0A%23eval%20-%285%20%3A%20Int%29%20%20%20%20%20%20%20%20%20%20--%20-5" target="_blank" rel="noopener">&#8599; Open in Lean playground (new tab)</a></p>
<iframe src="https://live.lean-lang.org/#code=%23eval%20%283%20%3A%20Int%29%20%2B%204%20%20%20%20%20--%207%0A%23eval%20%283%20%3A%20Int%29%20%2A%204%20%20%20%20%20%20--%2012%0A%23eval%20%281%20%3A%20Int%29%20%20%20%20%20%20%20%20%20%20--%201%0A%23eval%20-%285%20%3A%20Int%29%20%20%20%20%20%20%20%20%20%20--%20-5" title="Lean playground" loading="lazy" style="width:100%;height:180px;border:1px solid #ccc;border-radius:8px;">
</iframe>

The book's nested projections walk down a tower of structures built
by hand (`Ring → CommGroup → Group`). Mathlib's typeclass resolution walks
down a similar tower of instances (`CommRing → Ring → ... → AddCommGroup`)
automatically, so the notation never needs to name which layer it is coming
from.

---

[← Finite ring example](05-finite-ring-example.md) | [Index](00-index.md) | [Next: Matrices →](07-matrices.md)

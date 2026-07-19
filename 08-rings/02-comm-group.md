## `CommGroup`: extending `Group` with one extra axiom

[← The mathematical definition](01-definition.md) | [Index](00-index.md) | [Next: Ring →](03-ring.md)

---

<p><a href="https://live.lean-lang.org/#code=structure%20CommGroup%20%28G%20%3A%20Type%29%20extends%20Group%20G%20where%0A%20%20comm%20%3A%20%E2%88%80%20a%20b%20%3A%20G%2C%20op%20a%20b%20%3D%20op%20b%20a" target="_blank" rel="noopener">&#8599; Open in Lean playground (new tab)</a></p>
<iframe src="https://live.lean-lang.org/#code=structure%20CommGroup%20%28G%20%3A%20Type%29%20extends%20Group%20G%20where%0A%20%20comm%20%3A%20%E2%88%80%20a%20b%20%3A%20G%2C%20op%20a%20b%20%3D%20op%20b%20a" title="Lean playground" loading="lazy" style="width:100%;height:180px;border:1px solid #ccc;border-radius:8px;">
</iframe>

Recall `extends` from Chapter 2: a `CommGroup G` *is* a `Group G` (it has
every field `Group G` has — `op`, `id`, `inv`, `assoc`, etc.) plus one more
field, `comm`. Anywhere Lean expects a `Group G`, a `CommGroup G` may be
passed instead (via `.toGroup`).

**Mathematical reading.** `CommGroup G` is an *abelian group* $(G, \cdot, e,
(-)^{-1})$ with the extra law $\forall a,b,\ a\cdot b = b\cdot a$. Structurally
$\mathbf{Ab}$ is a
[full subcategory / subobject](../01-basics/04-terminology.md#category-theory-terms-used-beyond-the-baseline)
of $\mathbf{Grp}$, cut out by the commutativity axiom, and `extends`
builds exactly this inclusion: `.toGroup` is the
[forgetful functor](../01-basics/04-terminology.md#category-theory-terms-used-beyond-the-baseline)
$\mathbf{Ab} \hookrightarrow \mathbf{Grp}$, which forgets the `comm` axiom.

---

[← The mathematical definition](01-definition.md) | [Index](00-index.md) | [Next: Ring →](03-ring.md)

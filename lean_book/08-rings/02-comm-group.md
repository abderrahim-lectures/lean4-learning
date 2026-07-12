## `CommGroup`: extending `Group` with one extra axiom

[← The mathematical definition](01-definition.md) | [Index](00-index.md) | [Next: Ring →](03-ring.md)

---

```lean
structure CommGroup (G : Type) extends Group G where
  comm : ∀ a b : G, op a b = op b a
```

Recall `extends` from Chapter 2: a `CommGroup G` *is* a `Group G` (it has
every field `Group G` has — `op`, `id`, `inv`, `assoc`, etc.) plus one more
field, `comm`. Anywhere Lean expects a `Group G`, you can pass a
`CommGroup G` instead (via `.toGroup`).

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

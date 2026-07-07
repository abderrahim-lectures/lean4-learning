## `CommGroup`: extending `Group` with one extra axiom

[← The mathematical definition](01-definition.md) | [Index](00-index.md) | [Next: Ring →](03-ring.md)

---

```lean
structure CommGroup (G : Type) extends Group G where
  comm : ∀ a b : G, op a b = op b a
```

Recall `extends` from Chapter 2: a `CommGroup G` *is* a `Group G` (it has
every field `Group G` has — `op`, `id`, `inv`, `assoc`, etc.) plus one more
field, `comm`. Anywhere a `Group G` is expected, you can pass a
`CommGroup G` (via `.toGroup`).

**Mathematical reading.** `CommGroup G` is an *abelian group* $(G, \cdot, e,
(-)^{-1})$ with the extra law $\forall a,b,\ a\cdot b = b\cdot a$. Structurally
$\mathbf{Ab}$ is the full subcategory of $\mathbf{Grp}$ on the groups
satisfying commutativity, and `extends` realizes exactly this inclusion: the
forgetful functor $\mathbf{Ab} \hookrightarrow \mathbf{Grp}$ is the coercion
`.toGroup`, which forgets the `comm` axiom. As a subobject,
$\mathrm{CommGroup}(G) = \{\, g \in \mathrm{Group}(G) \mid g \text{ is
commutative}\,\}$.

---

[← The mathematical definition](01-definition.md) | [Index](00-index.md) | [Next: Ring →](03-ring.md)

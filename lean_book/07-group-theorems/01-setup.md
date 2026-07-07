## Setup

[← Index](00-index.md) | [Next: Theorem 1 →](02-theorem-1.md)

---

```lean
variable {G : Type} (Grp : Group G)
```

`variable` adds `{G : Type} (Grp : Group G)` silently to every following
declaration that mentions `G` or `Grp`.

**Mathematical reading.** This is the phrase "Let $G$ be a group" opening a
section: we fix an arbitrary object $(G, \cdot, e, (-)^{-1})$ of
$\mathbf{Grp}$ and reason generically about it. Everything proved under this
`variable` is a statement quantified over *all* groups — a theorem about the
group $\mathrm{Grp}$ is really $\forall (G : \mathrm{Type})\,(\mathrm{Grp} :
\mathrm{Group}\,G),\ (\ldots)$, so it applies to $\mathbb{Z}$, to
permutation groups, and to every group built later.

---

[← Index](00-index.md) | [Next: Theorem 1 →](02-theorem-1.md)

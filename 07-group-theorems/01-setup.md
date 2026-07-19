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
`variable` is a statement quantified over *all* groups. A theorem about the
group $\mathrm{Grp}$ is really $\forall (G : \mathrm{Type})\,(\mathrm{Grp} :
\mathrm{Group}\,G),\ (\ldots)$, so it applies to $\mathbb{Z}$, to
permutation groups, and to every group built later.

---

### References

Full citations in the [Bibliography](../bibliography.md).

- Dummit and Foote ([DummitFoote2003]) — the standard classical (non-Lean) reference for the three theorems this chapter formalizes (uniqueness of the identity, uniqueness of inverses, and the inverse-of-a-product law), all standard early consequences of the group axioms.

[DummitFoote2003]: ../bibliography.md#dummitfoote2003

---

[← Index](00-index.md) | [Next: Theorem 1 →](02-theorem-1.md)

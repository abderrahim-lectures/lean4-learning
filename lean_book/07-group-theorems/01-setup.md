## Setup

[← Index](00-index.md) | [Next: Theorem 1 →](02-theorem-1.md)

---

### Recall

Formal definitions cited in this section, gathered here for quick
reference (full citations in the [Bibliography](../bibliography.md)):

- **Group theorems proved here.** "The identity of $G$ is unique ...
  for each $a \in G$, $a^{-1}$ is uniquely determined ...
  $(a{*}b)^{-1} = (b^{-1}){*}(a^{-1})$" ([DummitFoote2003], §1.1
  "Basic Axioms and Examples," pp. 17–18, Proposition 1).

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

Full citations in the [Bibliography](../bibliography.md). Formal
definitions are gathered in Recall, above.

- Dummit and Foote ([DummitFoote2003]), §1.1 "Basic Axioms and Examples," pp. 17–18, Proposition 1 — uniqueness of identity/inverses, inverse-of-a-product law.

[DummitFoote2003]: ../bibliography.md#dummitfoote2003

---

[← Index](00-index.md) | [Next: Theorem 1 →](02-theorem-1.md)

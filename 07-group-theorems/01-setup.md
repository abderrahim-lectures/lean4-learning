## Setup

[← Index](00-index.md) | [Next: Theorem 1 →](02-theorem-1.md)

---

<p><a href="https://live.lean-lang.org/#code=variable%20%7BG%20%3A%20Type%7D%20%28Grp%20%3A%20Group%20G%29" target="_blank" rel="noopener">&#8599; Open in Lean playground (new tab)</a></p>
<iframe src="https://live.lean-lang.org/#code=variable%20%7BG%20%3A%20Type%7D%20%28Grp%20%3A%20Group%20G%29" title="Lean playground" loading="lazy" style="width:100%;height:180px;border:1px solid #ccc;border-radius:8px;">
</iframe>

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

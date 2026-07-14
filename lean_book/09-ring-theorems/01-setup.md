## Setup

[← Index](00-index.md) | [Next: Theorem 1 →](02-theorem-1.md)

---

```lean
variable {R : Type} (Rg : Ring R)
```

Fully-qualified field names (`Rg.addGrp.toGroup.inv`, etc.) are written out
in every proof, precisely so that it is always clear which structure a
fact came from. When reading a goal, however, it helps to mentally
abbreviate `Rg.addGrp.op` as `+`, `Rg.addGrp.id` as `0`,
`Rg.addGrp.toGroup.inv` as unary `-`, `Rg.mul` as `*`, `Rg.one` as `1`.
Performing that translation first, finding the proof in ordinary ring
notation, and only then translating back to the fully-qualified names, is
considerably more tractable than attempting to pattern-match on the
qualified names directly.

**Mathematical reading.** "Let $(R, +, \times, 0, 1)$ be a ring." The
`variable` fixes an arbitrary object of $\mathbf{Ring}$; every theorem below
is a statement about all rings at once. The recommended mental
dictionary is just the standard ring notation — `Rg.addGrp.op` $= +$,
`Rg.addGrp.id` $= 0$, `Rg.addGrp.toGroup.inv` $= -(-)$, `Rg.mul` $= \times$,
`Rg.one` $= 1$ — recovered by projecting along the
[forgetful functors](../01-basics/04-terminology.md#category-theory-terms-used-beyond-the-baseline), so
that a qualified name like `Rg.addGrp.toGroup.inv a` is literally "$-a$ in
the underlying additive group of $R$."

---

[← Index](00-index.md) | [Next: Theorem 1 →](02-theorem-1.md)

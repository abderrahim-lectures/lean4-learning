## Setup

[← Index](00-index.md) | [Next: Theorem 1 →](02-theorem-1.md)

---

```lean
variable {R : Type} (Rg : Ring R)
```

We'll write out fully-qualified field names (`Rg.addGrp.toGroup.inv`, etc.)
in every proof, precisely so it's always traceable which structure a fact
came from — but when *reading* a goal yourself, it helps to mentally
abbreviate `Rg.addGrp.op` as `+`, `Rg.addGrp.id` as `0`,
`Rg.addGrp.toGroup.inv` as unary `-`, `Rg.mul` as `*`, `Rg.one` as `1`. Do
that translation in your head first, find the proof in ordinary ring
notation, *then* translate back to the fully-qualified names — trying to
pattern-match on the qualified names directly is much harder than it needs
to be.

**Mathematical reading.** "Let $(R, +, \times, 0, 1)$ be a ring." The
`variable` fixes an arbitrary object of $\mathbf{Ring}$; every theorem below
is a statement about all rings simultaneously. The recommended mental
dictionary is just the standard ring notation — `Rg.addGrp.op` $= +$,
`Rg.addGrp.id` $= 0$, `Rg.addGrp.toGroup.inv` $= -(-)$, `Rg.mul` $= \times$,
`Rg.one` $= 1$ — recovered by projecting along the forgetful functors, so
that a qualified name like `Rg.addGrp.toGroup.inv a` is literally "$-a$ in
the underlying additive group of $R$."

---

[← Index](00-index.md) | [Next: Theorem 1 →](02-theorem-1.md)

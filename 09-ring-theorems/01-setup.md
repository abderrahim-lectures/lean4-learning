## Setup

[← Index](00-index.md) | [Next: Theorem 1 →](02-theorem-1.md)

---

Chapter 8's examples ran from the fully commutative (`Int`, `Fin 3`) to
the deliberately noncommutative ($2\times 2$ integer matrices), each time
verifying `Ring`'s axioms by hand for one specific carrier. That
carrier-by-carrier approach does not scale — no one wants to re-derive
$a\cdot 0=0$ separately for every ring encountered from now on. Chapter 7
already established the fix for groups: fix an arbitrary structure once,
via `variable`, and prove theorems against it that apply to every later
instance automatically. This chapter repeats exactly that move for rings.

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
dictionary is just the standard ring notation: `Rg.addGrp.op` $= +$,
`Rg.addGrp.id` $= 0$, `Rg.addGrp.toGroup.inv` $= -(-)$, `Rg.mul` $= \times$,
`Rg.one` $= 1$. Each is recovered by projecting along the
[forgetful functors](../01-basics/04-terminology.md#category-theory-terms-used-beyond-the-baseline),
so a qualified name like `Rg.addGrp.toGroup.inv a` is literally "$-a$ in
the underlying additive group of $R$."

---

### Sources, quoted

Formal definition and citation for this section, gathered here for
reference (full entry in the [Bibliography](../bibliography.md)):

- **Ring theorems proved here.** "$0a = a0 = 0$ for all $a \in R$ ...
  $(-a)b = a(-b) = -(ab)$ for all $a, b \in R$" ([DummitFoote2003],
  §7.1 "Basic Definitions and Examples," p. 225, Proposition 1).

[DummitFoote2003]: ../bibliography.md#dummitfoote2003

---

[← Index](00-index.md) | [Next: Theorem 1 →](02-theorem-1.md)

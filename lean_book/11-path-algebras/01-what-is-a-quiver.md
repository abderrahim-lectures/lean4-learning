## What is a quiver?

[← Index](00-index.md) | [Next: Paths →](02-paths.md)

---

A **quiver** (in this algebraic sense — not related to Lean 4's `Mathlib`
name for something similar, which we are not using) is simply a *directed
graph*: a set of vertices and a set of directed edges (called **arrows**)
between them. Formally, a quiver $Q$ consists of:

- a set of vertices $Q_0$,
- a set of arrows $Q_1$,
- two functions $s, t : Q_1 \to Q_0$ giving each arrow's **source** and
  **target**.

Picture an arrow $\alpha : i \to j$ as a literal arrow drawn from vertex $i$
to vertex $j$; $s(\alpha) = i$ and $t(\alpha) = j$.

### Example quiver

Take vertices $\{1, 2, 3\}$ and arrows

$$
\alpha : 1 \to 2, \qquad \beta : 2 \to 3
$$

---

[← Index](00-index.md) | [Next: Paths →](02-paths.md)

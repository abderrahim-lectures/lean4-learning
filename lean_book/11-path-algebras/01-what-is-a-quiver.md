## What is a quiver?

[← Index](00-index.md) | [Next: Paths →](02-paths.md)

---

A **quiver** is simply a *directed graph*: a set of vertices and a set of
directed edges (called **arrows**) between them. This is the same notion
Mathlib calls `Quiver` (we build our own from scratch, following Chapter
0's "no Mathlib" policy, instead of reusing Mathlib's). Formally, a
quiver $Q$ consists of:

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

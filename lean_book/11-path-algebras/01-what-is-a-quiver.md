## What is a quiver?

[← Index](00-index.md) | [Next: Paths →](02-paths.md)

---

A **quiver** is a *directed graph*: a set of vertices and a set of
directed edges (called **arrows**) between them. This is the same notion
Mathlib calls [`Quiver`](https://loogle.lean-lang.org/?q=Quiver) (built here from scratch, following Chapter
0's "no Mathlib" policy, rather than reusing Mathlib's). Formally, a
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

### References

Full citations in the [Bibliography](../bibliography.md).

- Assem, Simson, and Skowroński ([AssemSimsonSkowronski2006]) — the standard graduate reference for the quiver definition above.
- Schiffler ([Schiffler2014]) — an elementary, textbook-level treatment of the same definition.

[AssemSimsonSkowronski2006]: ../bibliography.md#assemsimsonskowronski2006
[Schiffler2014]: ../bibliography.md#schiffler2014

---

[← Index](00-index.md) | [Next: Paths →](02-paths.md)

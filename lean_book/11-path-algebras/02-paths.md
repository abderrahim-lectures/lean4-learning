## Paths

[← What is a quiver?](01-what-is-a-quiver.md) | [Index](00-index.md) | [Next: Defining a quiver in Lean →](03-defining-a-quiver.md)

---

A **path** in $Q$ is a sequence of arrows that can be composed head-to-tail:
$\alpha_1, \alpha_2, \dots, \alpha_n$ with $t(\alpha_i) = s(\alpha_{i+1})$ for
each consecutive pair. We also allow, for each vertex $i$, a **trivial path**
$e_i$ of length $0$ that starts and ends at $i$ and composes with nothing but
itself.

In our example, the paths are: $e_1, e_2, e_3$ (trivial), $\alpha$, $\beta$,
and $\beta\alpha$ (first $\alpha$, then $\beta$) — and nothing else, since
there's no arrow out of $3$ or into $1$.

---

[← What is a quiver?](01-what-is-a-quiver.md) | [Index](00-index.md) | [Next: Defining a quiver in Lean →](03-defining-a-quiver.md)

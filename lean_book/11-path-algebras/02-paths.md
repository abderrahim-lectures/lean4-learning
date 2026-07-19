## Paths

[← What is a quiver?](01-what-is-a-quiver.md) | [Index](00-index.md) | [Next: Defining a quiver in Lean →](03-defining-a-quiver.md)

---

A **path** in $Q$ is a sequence of arrows that can be composed head-to-tail:
$\alpha_1, \alpha_2, \dots, \alpha_n$ with $t(\alpha_i) = s(\alpha_{i+1})$ for
each consecutive pair. In addition, for each vertex $i$, a **trivial path**
$e_i$ of length $0$ is allowed, starting and ending at $i$ and composing
with nothing but itself.

In the running example, the paths are: $e_1, e_2, e_3$ (trivial), $\alpha$, $\beta$,
and $\beta\alpha$ (first $\alpha$, then $\beta$), and nothing else, since
there is no arrow out of $3$ or into $1$.

---

### References

Full citations in the [Bibliography](../bibliography.md).

- Assem, Simson, and Skowroński ([AssemSimsonSkowronski2006]), **Definition 1.2** (Chapter II, §1) — path of length $\geq 1$ as a sequence $(a \mid \alpha_1,\dots,\alpha_l \mid b)$, plus the trivial/stationary path $\varepsilon_a$ of length $0$ at each vertex $a$.
- Schiffler ([Schiffler2014]), **Definition 2.1 and Example 2.2** (Chapter 2, §2.1) — same notion, called the "constant path" (or "lazy path") $e_i$ at vertex $i$ for the length-$0$ case.

[AssemSimsonSkowronski2006]: ../bibliography.md#assemsimsonskowronski2006
[Schiffler2014]: ../bibliography.md#schiffler2014

---

[← What is a quiver?](01-what-is-a-quiver.md) | [Index](00-index.md) | [Next: Defining a quiver in Lean →](03-defining-a-quiver.md)

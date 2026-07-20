## Paths

[← What is a quiver?](01-what-is-a-quiver.md) | [Index](00-index.md) | [Next: Defining a quiver in Lean →](03-defining-a-quiver.md)

---

### Recall

Formal definition cited in this section, gathered here for quick
reference (full citation in the [Bibliography](../bibliography.md)):

- **Path.** "A path of length $l \geq 1$ with source $a$ and target
  $b$ ... is a sequence $(a \mid \alpha_1, \alpha_2, \ldots, \alpha_l
  \mid b)$ ... We also agree to associate with each point $a \in
  Q_0$ a path of length $l = 0$, called the trivial or stationary
  path at $a$, and denoted by $\varepsilon_a = (a \| a)$"
  ([AssemSimsonSkowronski2006], Ch. II §1, p. 42–43, unnumbered
  definition immediately preceding Definition 1.2 — which itself
  defines the *path algebra* built from these paths, not the path
  concept).

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

Full citations in the [Bibliography](../bibliography.md). Formal
definitions are gathered in Recall, above.

- Assem, Simson, and Skowroński ([AssemSimsonSkowronski2006]), Ch. II §1, pp. 42–43, unnumbered definition preceding Definition 1.2 — **Correction:** this book previously mislabeled the path definition itself as "Definition 1.2"; that numbered definition is actually the *path algebra* $KQ$ built from these paths, not the path concept, which is unnumbered text immediately before it.
- Schiffler ([Schiffler2014]), **Definition 2.1 and Example 2.2** (Chapter 2, §2.1) — same notion, called the "constant path" (or "lazy path") $e_i$ at vertex $i$ for the length-$0$ case.

[AssemSimsonSkowronski2006]: ../bibliography.md#assemsimsonskowronski2006
[Schiffler2014]: ../bibliography.md#schiffler2014

---

[← What is a quiver?](01-what-is-a-quiver.md) | [Index](00-index.md) | [Next: Defining a quiver in Lean →](03-defining-a-quiver.md)

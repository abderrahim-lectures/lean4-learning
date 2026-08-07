## Paths

[← What is a quiver?](01-what-is-a-quiver.md) | [Index](00-index.md) | [Next: Defining a quiver in Lean →](03-defining-a-quiver.md)

---

Section 1 fixed the raw data of a quiver: a set of vertices and a set of
arrows, each arrow going from one vertex to another. A single arrow is
already a directed connection, but the interesting routes through a graph
usually chain several arrows together, one after another. Not every such
chain makes sense, though. An arrow can only be appended if it starts
where the previous one ended. This section names that notion precisely:
a **path**.

A **path** in $Q$ is a sequence of arrows that can be composed head-to-tail:
$\alpha_1, \alpha_2, \dots, \alpha_n$ with $t(\alpha_i) = s(\alpha_{i+1})$ for
each consecutive pair. In addition, for each vertex $i$, a **trivial path**
$e_i$ of length $0$ is allowed, starting and ending at $i$. It composes with
any path that starts or ends at $i$, leaving it unchanged. $e_i$ is the
*identity* at $i$, which is exactly what makes the length-$0$ paths the units
of the path algebra in [Section 5](05-path-composition.md).

In the running example, the paths are: $e_1, e_2, e_3$ (trivial), $\alpha$, $\beta$,
and $\beta\alpha$ (first $\alpha$, then $\beta$), and nothing else, since
there is no arrow out of $3$ or into $1$.

---

### Sources, quoted

Formal definitions and citations for this section, gathered here for
reference (full entries in the [Bibliography](../bibliography.md)):

- **Path.** "A path of length $l \geq 1$ with source $a$ and target
  $b$ ... is a sequence $(a \mid \alpha_1, \alpha_2, \ldots, \alpha_l
  \mid b)$ ... We also agree to associate with each point $a \in
  Q_0$ a path of length $l = 0$, called the trivial or stationary
  path at $a$, and denoted by $\varepsilon_a = (a \| a)$"
  ([AssemSimsonSkowronski2006], Ch. II §1, p. 42–43, unnumbered
  definition immediately preceding Definition 1.2, which itself
  defines the *path algebra* built from these paths, not the path
  concept).
- Assem, Simson, and Skowroński ([AssemSimsonSkowronski2006]), Ch. II §1, pp. 42–43, unnumbered definition preceding Definition 1.2. The path definition itself is this unnumbered text. Definition 1.2, a few lines later, defines the *path algebra* $KQ$ built from these paths, not the path concept (an earlier draft of this book mislabeled the path definition itself as "Definition 1.2").
- Schiffler ([Schiffler2014]), **Definition 2.1 and Example 2.2** (Chapter 3, §2.1) covers the same notion, called the "constant path" (or "lazy path") $e_i$ at vertex $i$ for the length-$0$ case.

[AssemSimsonSkowronski2006]: ../bibliography.md#assemsimsonskowronski2006
[Schiffler2014]: ../bibliography.md#schiffler2014

---

[← What is a quiver?](01-what-is-a-quiver.md) | [Index](00-index.md) | [Next: Defining a quiver in Lean →](03-defining-a-quiver.md)

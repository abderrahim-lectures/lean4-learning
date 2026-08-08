## What is a quiver?

[← Index](00-index.md) | [Next: Paths →](02-paths.md)

---

The stated goal of this chapter is the path algebra of a directed graph, a
construction that needs paths before it needs an algebra, and needs a
graph before it needs paths. So the chapter starts at the bottom, the
graph itself, stripped to the bare minimum of data a "directed graph"
requires. Everything from here through the checkpoint project is built on
top of exactly this one definition.

A **quiver** is a *directed graph*, a set of vertices and a set of
directed edges (called **arrows**) between them. This is the same notion
[`Quiver`](https://loogle.lean-lang.org/?q=Quiver) in Mathlib (built here from scratch, following the
"no Mathlib" policy of Chapter 1, rather than reusing the Mathlib version). Formally, a
quiver $Q$ consists of the following.

- A set of vertices $Q_0$.
- A set of arrows $Q_1$.
- Two functions $s, t : Q_1 \to Q_0$ giving the **source** and
  **target**.

Picture an arrow $\alpha : i \to j$ as a literal arrow drawn from vertex $i$
to vertex $j$; $s(\alpha) = i$ and $t(\alpha) = j$.

### Example quiver

Take vertices $\{1, 2, 3\}$ and arrows

$$
\alpha : 1 \to 2, \qquad \beta : 2 \to 3
$$

---

### Sources, quoted

Formal definitions and citations for this section, gathered here for
reference (full entries in the [Bibliography](../bibliography.md)):

- **Quiver.** Stated verbatim as $Q = (Q_0, Q_1, s, t)$
  ([AssemSimsonSkowronski2006], Definition 1.1, Ch. II §1 "Quivers
  and path algebras"), a set of vertices $Q_0$, a set of arrows
  $Q_1$, and two functions $s, t : Q_1 \to Q_0$ giving the source and
  target of each arrow.
- Schiffler ([Schiffler2014]) covers an elementary, textbook-level treatment of the same definition.

[AssemSimsonSkowronski2006]: ../bibliography.md#assemsimsonskowronski2006
[Schiffler2014]: ../bibliography.md#schiffler2014

---

[← Index](00-index.md) | [Next: Paths →](02-paths.md)

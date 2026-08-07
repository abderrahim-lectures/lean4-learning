# Chapter 12: Quivers and path algebras

[← Ch. 11: Modules](../11-modules/00-index.md) | [Table of contents](../README.md) | [Ch. 13: Working Efficiently →](../13-working-efficiently/00-index.md)

---

## Learning objectives

- Encode a quiver as a `structure` of vertices/arrows/source/target.
- Define `Path` as an inductive type indexed by its own endpoints.
- Compose paths via `Path.append` and predict when composability side-conditions block a nonsensical composition.
- Explain in what sense a path algebra $kQ$ extends the `Ring`/`Module` machinery of Chapters 9 and 11.

This chapter combines everything covered so far: inductive types
(Chapter 1), structures (Chapter 3), and rings (Chapters 8–9), used
to build a genuinely interesting example: the **path algebra** of a
quiver.

## The story of this chapter

Each section answers the question the previous one leaves open, working
down toward a single target: the path algebra $kQ$.

1. **What is the raw combinatorial object a path algebra is built
   from?** ([Section 1](01-what-is-a-quiver.md)) A **quiver**: nothing
   more than a set of vertices, a set of arrows, and two functions
   recording the source and target of each arrow, a directed graph, stripped
   to the bare minimum.
2. **A single arrow is one directed step. What is a *route* through
   several arrows, chained one after another?**
   ([Section 2](02-paths.md)) A **path**: a sequence of arrows composable
   head-to-tail, together with, for each vertex, a length-$0$ trivial path
   that starts and ends there and acts as the identity at that vertex,
   composing with any path starting or ending there and leaving it unchanged.
3. **Both of the last two sections were stated on paper. How does the
   quiver definition become something Lean can check against?**
   ([Section 3](03-defining-a-quiver.md)) A `structure` bundling the
   vertex type, the arrow type, and the two source/target functions, a
   direct transcription, worked through on a small three-vertex example
   quiver used for the rest of the chapter.
4. **Given a Lean-encoded quiver, how is "path" encoded so that only
   genuinely composable arrow-sequences can be built at all?**
   ([Section 4](04-paths-as-inductive-type.md)) `Path` as an inductive
   type *indexed* by its own source and target vertex, the dependent-type
   idea from Chapter 1, now put to real use: an arrow can only be
   `cons`ed onto a path when a proof shows its source matches where the
   path already ends, so a nonsensical composition is rejected before it
   is ever built, not caught afterward.
5. **Two paths, each already built, often need to be joined into one
   longer path rather than reconstructed by hand. How?**
   ([Section 5](05-path-composition.md)) `Path.append`, composition in the
   free category on $Q$, defined by recursion; one concrete instance is
   checked, by a genuine `rfl`, to agree with building the same composite
   path directly (this checks that one example, not associativity or the
   identity laws in general; see Section 5 for the general argument). This
   is also, once paths are given $k$-linear coefficients, the
   multiplication that makes the path algebra $kQ$ a ring.
6. **Having built the definitions, what remains to actually practice
   with them?** ([Section 6](06-exercises.md), then the
   [checkpoint project](07-checkpoint-project.md)) Exercises on the
   material above, followed by a project that adds one further piece of
   structure, the length of a path, and proves, by induction mirroring
   the recursion of `Path.append` itself, that composition respects it.

By the end, "quiver" has gone from an unadorned directed graph to a
category of paths with a spot-checked composition, exactly the data a
representation theorist needs before defining $kQ$ itself, and exactly
the bridge back to the `Module`/`LinearMap` machinery of Chapter 11, since a
representation of $Q$ is precisely a module over $kQ$.

## Sections

1. [What is a quiver?](01-what-is-a-quiver.md)
2. [Paths](02-paths.md)
3. [Defining a quiver in Lean](03-defining-a-quiver.md)
4. [Paths as an inductive type indexed by source and target](04-paths-as-inductive-type.md)
5. [Path composition](05-path-composition.md)
6. [Exercises](06-exercises.md)
7. [Checkpoint project: path length, and composition respects it](07-checkpoint-project.md)

---

[← Ch. 11: Modules](../11-modules/00-index.md) | [Table of contents](../README.md) | [Ch. 13: Working Efficiently →](../13-working-efficiently/00-index.md)

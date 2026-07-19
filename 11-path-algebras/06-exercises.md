## Exercises

[← Path composition](05-path-composition.md) | [Index](00-index.md)

---

**Key points.** A quiver is just vertices, arrows, and source/target
functions; a path is an inductive type indexed by its own endpoints, so an
ill-typed composition (arrow source ≠ path's current endpoint) is rejected
before any proof is attempted. `Path.append` composes two paths by
recursion on the second, and the path algebra $kQ$ — sketched but not
fully built here — is the free $k$-module on the set of paths, with
multiplication by composition.

**Socratic questions.**

1. *`Quiver.Path`'s composability check (an arrow's source must match the
   path's current endpoint) is enforced by Lean at compile time. What
   would the equivalent check look like in an ordinary, non-dependently
   typed program, and when would it fire?* At runtime, as an
   `if`-check or assertion inside whatever function tries to append —
   discovered the moment that specific composition executes, not before.
   Here, an ill-typed `Path.cons` simply has no proof term to supply,
   so the program that would have contained the bug never compiles at
   all.
2. *A quiver with a genuine cycle (Exercise 1's `gamma`) has infinitely
   many distinct paths (go around the loop any number of times). Does
   that mean `Path Q u v` is an infinite *type*, for such a `Q`?* For at
   least one pair `u = v` on the cycle, yes — infinitely many distinct
   terms inhabit that one type, one per lap. This is exactly why a
   quiver's path algebra $kQ$ is typically infinite-dimensional once the
   quiver has a cycle, unless further relations are imposed.
3. *The path algebra $kQ$ is described as "the free $k$-module on the set
   of paths," but this chapter builds only the paths and their
   composition, not $kQ$ itself. What is the one piece of extra
   machinery still missing?* Finitely-supported functions from paths to
   $k$ — the ability to form a $k$-linear combination of *finitely many*
   paths at once, which is genuinely more than what an inductive `Path`
   type alone provides.

1. Add a third arrow `gamma : ExampleArrow` with `source gamma = 2` and
   `target gamma = 0`, creating a cycle `0 → 1 → 2 → 0`. Build the path
   `gamma ∘ beta ∘ alpha : Path exampleQuiver 0 0`.
2. Prove `theorem append_nil_left {V A} {Q : Quiver V A} {u v} (p : Path Q u v) : Path.append (Path.nil u) p = p`
   by induction on `p` (mirroring the structure of `Path.append`'s own
   recursion), spelling out the base (`Path.nil`) and inductive
   (`Path.cons`) cases as in Chapter 4's `induction` examples.
3. (Optional, harder) Sketch — in comments, no need to complete the Lean —
   what a `structure PathAlgebra (V A : Type) (Q : Quiver V A) (k : Type) (Rg : Ring k)`
   would need to contain to satisfy `Ring`'s fields from Chapter 8.

Solutions: [Appendix, Chapter 11](../14-appendix-solutions/10-chapter-11.md).

## Next

Continue to the [checkpoint project](07-checkpoint-project.md), which
closes out Part II before Chapter 12 begins Part III.

---

[← Path composition](05-path-composition.md) | [Index](00-index.md) | [Next: Checkpoint project →](07-checkpoint-project.md)

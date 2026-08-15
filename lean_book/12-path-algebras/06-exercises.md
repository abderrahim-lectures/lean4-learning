## Exercises

[← Path composition](05-path-composition.md) | [Index](00-index.md)

---

**Key points.** A quiver is just vertices, arrows, and source/target
functions; a path is an inductive type indexed by its own endpoints, so an
ill-typed composition (arrow source ≠ current endpoint of the path) is rejected
before any proof is attempted. `Path.append` composes two paths by
recursion on the second, and the path algebra $kQ$, sketched but not
fully built here, is the free $k$-module on the set of paths, with
multiplication by composition.

1. Add a third arrow `gamma : ExampleArrow` with `source gamma = 2` and
   `target gamma = 0`, creating a cycle `0 → 1 → 2 → 0`. Build the path
   `gamma ∘ beta ∘ alpha : Path exampleQuiver 0 0`.
2. Prove `theorem append_nil_left {V A} {Q : Quiver V A} {u v} (p : Path Q u v) : Path.append (Path.nil u) p = p`
   by induction on `p` (mirroring the structure of the recursion of `Path.append`
   itself), spelling out the base (`Path.nil`) and inductive
   (`Path.cons`) cases as in the `induction` examples of Chapter 5.
3. (Optional, harder) Sketch, in comments, no need to complete the Lean,
   what a `structure PathAlgebra (V A : Type) (Q : Quiver V A) (k : Type) (Rg : Ring k)`
   would need to contain to satisfy the fields of `Ring` from Chapter 9.

Solutions, [Appendix, Chapter 12](../15-appendix-solutions/12-chapter-12.md).

## Next

Continue to the [checkpoint project](07-checkpoint-project.md), which
closes out Part II before Chapter 13 begins Part III.

---

[← Path composition](05-path-composition.md) | [Index](00-index.md) | [Next: Checkpoint project →](07-checkpoint-project.md)

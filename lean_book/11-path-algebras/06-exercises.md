## Exercises

[← Path composition](05-path-composition.md) | [Index](00-index.md)

---

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

Continue to [Chapter 12: Working efficiently in Lean](../12-working-efficiently/00-index.md).

---

[← Path composition](05-path-composition.md) | [Index](00-index.md) | [Table of contents](../README.md) | [Ch. 12: Working Efficiently →](../12-working-efficiently/00-index.md)

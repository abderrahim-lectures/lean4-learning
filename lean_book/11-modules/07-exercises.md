## Exercises

[← Direct sums](06-direct-sums.md) | [Index](00-index.md)

---

**Key points.** A module is an abelian group with a scalar action
satisfying four axioms, equivalently a ring homomorphism into the ring of
the endomorphisms of the group itself. A submodule is a membership predicate plus
closure proofs, a linear map is a function preserving `+` and the scalar
action, and the five/four axioms of a direct sum each split, via `congr 1`,
into one independent fact per summand.

1. Prove that the identity function is a linear map, for any
   `Mod : Module R Rg M`, construct
   `idLinearMap : LinearMap Rg Mod Mod` with `toFun := id`.
2. Prove that linear maps compose, given
   `f : LinearMap Rg ModM ModN` and `g : LinearMap Rg ModN ModP`, construct
   `LinearMap Rg ModM ModP` with `toFun := g.toFun ∘ f.toFun`. (This,
   together with Exercise 1 and associativity of function composition, is
   what makes $R$-modules and $R$-linear maps a category. This is the
   payoff that Chapter 1 promised.)
3. Verify that `intSmul` (defined above) satisfies the four axioms of `Module`
   against `intRing`, at least for `one_smul` and `smul_add`, by
   induction on the integer scalar, in the style of Chapter 5.
4. Define the submodule of multiples of a fixed integer `d : Int`
   (generalizing `evenSubmodule`, which is the case `d = 2`), and check
   that the three closure proofs generalize verbatim with `2` replaced by `d`.

Solutions, [Appendix, Chapter 11](../15-appendix-solutions/11-chapter-11.md).

## Next

Continue to [Chapter 12: Quivers and path algebras](../12-path-algebras/00-index.md), which
returns to path algebras. Once $kQ$ has been constructed, observe that
representations of $Q$ are exactly modules over $kQ$; this is what ties
this chapter directly to the next.

---

[← Direct sums](06-direct-sums.md) | [Index](00-index.md) | [Table of contents](../README.md) | [Ch. 12: Path Algebras →](../12-path-algebras/00-index.md)

## Exercises

[← Direct sums](06-direct-sums.md) | [Index](00-index.md)

---

1. Prove that the identity function is a linear map: for any
   `Mod : Module R Rg M`, construct
   `idLinearMap : LinearMap Rg Mod Mod` with `toFun := id`.
2. Prove that linear maps compose: given
   `f : LinearMap Rg ModM ModN` and `g : LinearMap Rg ModN ModP`, construct
   `LinearMap Rg ModM ModP` with `toFun := g.toFun ∘ f.toFun`. (This,
   together with Exercise 1 and associativity of function composition, is
   what makes $R$-modules and $R$-linear maps a category. This is the
   payoff that Chapter 1 promised.)
3. Verify `intSmul` (defined above) satisfies `Module`'s four axioms
   against `intRing`, at least for `one_smul` and `smul_add` — by
   induction on the integer scalar, in the style of Chapter 4.
4. Define the submodule of multiples of a fixed integer `d : Int`
   (generalizing `evenSubmodule`, which is the case `d = 2`), and check
   that the three closure proofs generalize verbatim with `2` replaced by `d`.

Solutions: [Appendix, Chapter 10](../14-appendix-solutions/09-chapter-10.md).

## Next

Continue to [Chapter 11: Quivers and path algebras](../11-path-algebras/00-index.md), which
returns to path algebras. Once $kQ$ has been constructed, observe that
representations of $Q$ are exactly modules over $kQ$; this is what ties
this chapter directly to the next.

---

[← Direct sums](06-direct-sums.md) | [Index](00-index.md) | [Table of contents](../README.md) | [Ch. 11: Path Algebras →](../11-path-algebras/00-index.md)

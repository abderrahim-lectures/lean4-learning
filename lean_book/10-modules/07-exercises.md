## Exercises

[← Direct sums](06-direct-sums.md) | [Index](00-index.md)

---

**Key points.** A module is an abelian group with a scalar action
satisfying four axioms, equivalently a ring homomorphism into the ring of
the group's own endomorphisms. A submodule is a membership predicate plus
closure proofs, a linear map is a function preserving `+` and the scalar
action, and a direct sum's five/four axioms each split, via `congr 1`,
into one independent fact per summand.

**Socratic questions.**

1. *A module is called "an abelian group with a scalar action," but also
   "a ring homomorphism into the group's own endomorphism ring." Are
   these two descriptions actually saying the same thing?* Yes — a
   scalar action assigning `r ↦ (m ↦ r • m)` to each ring element is
   exactly a function from `R` into the (additive, composable) maps
   `M → M`; the four module axioms are precisely what make that
   assignment respect `R`'s own `+` and `×`, i.e. a ring homomorphism.
   Same fact, two vocabularies.
2. *`Submodule` is defined by a membership predicate plus closure proofs,
   not by "a subset." Why does that distinction matter in Lean
   specifically?* Because a bare `Set M` carries no evidence of closure —
   any subset could be handed over, checked or not. Bundling the closure
   proofs *into* the structure means a term of type `Submodule Rg Mod`
   is, by construction, already verified closed under `+` and the scalar
   action; there is no separate step where that gets forgotten or
   skipped.
3. *`congr 1` split a direct sum's group axioms into one fact per summand.
   What would go wrong trying to prove `directSumModule`'s axioms without
   it, working with the pair as a single opaque value?* Nothing would be
   *wrong*, exactly, but every axiom would need its own ad-hoc unfolding
   of what equality of pairs means — `congr 1` names the one fact (a
   product's equality is checked componentwise) that makes all five/four
   proofs uniform instead of five/four bespoke arguments.

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

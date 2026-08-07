## Linear maps

[← Submodules](04-submodules.md) | [Index](00-index.md) | [Next: Direct sums →](06-direct-sums.md)

---

A **linear map** (module homomorphism) $f : M \to N$ between $R$-modules
satisfies $f(m+n) = f(m) + f(n)$ and $f(r \cdot m) = r \cdot f(m)$.

```lean
structure LinearMap {R : Type} (Rg : Ring R) {M N : Type}
    (ModM : Module R Rg M) (ModN : Module R Rg N) where
  toFun : M → N
  map_add : ∀ m n : M, toFun (ModM.addGrp.op m n) = ModN.addGrp.op (toFun m) (toFun n)
  map_smul : ∀ (r : R) (m : M), toFun (ModM.smul r m) = ModN.smul r (toFun m)
```

This is precisely the categorical picture: $R$-modules and $R$-linear maps
form a category. Composition of linear maps is linear, and the identity
function is linear, both easy to state and prove from the two fields
above. The exercises of this chapter ask you to prove exactly these two facts
(`idLinearMap`, `composeLinearMap` in the appendix solutions), rather than
proving them here in the main narrative. Everything in this chapter,
including submodules and the direct sums below, is best understood as
living inside that category, consistent with the opening dictionary of Chapter 1
for reading
`Type` itself.

**Mathematical reading.** `LinearMap Rg ModM ModN` is the set
$\mathrm{Hom}_R(M, N)$ of $R$-module homomorphisms, functions $f : M \to N$
satisfying two conditions. First, $f$ is additive: $f(m+n) = f(m)+f(n)$, so
$f$ is a group homomorphism of the underlying abelian groups. Second, $f$
is $R$-equivariant: $f(r\cdot m) = r\cdot f(m)$, so $f$ intertwines the two
$R$-actions. Equivalently, $f$ commutes with the representation maps
$\rho_M, \rho_N$ of the previous section: $f\circ\rho_M(r) =
\rho_N(r)\circ f$ for all $r$. These are the morphisms of
$R\text{-}\mathbf{Mod}$. $\mathrm{Hom}_R(M,N)$ is itself an abelian group,
and an $R$-module when $R$ is commutative.

### A concrete linear map: multiplication by a fixed integer

The abstract definition is easier to trust once a single instance has been
built by hand. Fix $d \in \mathbb{Z}$; multiplication by $d$ is $\mathbb{Z}$-linear
as a map $\mathbb{Z} \to \mathbb{Z}$.

```lean
def mulByLinearMap (d : Int) : LinearMap intRing intZModule intZModule where
  toFun := fun m => d * m
  map_add := by
    intro m n
    show d * (m + n) = d * m + d * n
    exact Int.mul_add d m n
  map_smul := by
    intro r m
    show d * (r * m) = r * (d * m)
    rw [← Int.mul_assoc, Int.mul_comm d r, Int.mul_assoc]

#eval (mulByLinearMap 5).toFun 3   -- 15
```

The goal for `map_add`, `d * (m+n) = d*m + d*n`, is exactly distributivity.
The goal for `map_smul`, `d * (r*m) = r * (d*m)`, holds because $\mathbb{Z}$ is
commutative, so `d` and `r` can swap past each other. Both fields, in
other words, are pure `Int`-arithmetic facts once `toFun`,
`ModM.smul`, and `ModM.addGrp.op` are unfolded to their meanings here. This is the same "reduce a
module-theoretic goal to a concrete arithmetic identity" move used by
`evenSubmodule` in Section 4, applied again.

**Mathlib equivalent.** The [`LinearMap`](https://loogle.lean-lang.org/?q=LinearMap) of Mathlib (notation `M →ₗ[R] N`)
is built the same way, supply `toFun` plus the two homomorphism proofs.
But the result is directly interoperable with the rest of the linear-algebra
API of the library.

```lean
def mulByLinearMap' (d : Int) : Int →ₗ[Int] Int where
  toFun := fun m => d * m
  map_add' := fun m n => mul_add d m n
  map_smul' := fun r m => by simp [mul_left_comm]

#eval mulByLinearMap' 5 3   -- 15
```

This has the same shape as `mulByLinearMap`, a `toFun` and two proof
obligations, with `map_add`/`map_smul` becoming the Mathlib names
`map_add'`/`map_smul'`. The real difference is that `Int →ₗ[Int] Int` is a
type the rest of Mathlib already knows how to compose, transport along
isomorphisms, and package into matrices. `LinearMap intRing intZModule
intZModule` gets none of that for free.

---

[← Submodules](04-submodules.md) | [Index](00-index.md) | [Next: Direct sums →](06-direct-sums.md)

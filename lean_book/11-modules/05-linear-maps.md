## Linear maps

[← Submodules](04-submodules.md) | [Index](00-index.md) | [Next: Direct sums →](06-direct-sums.md)

---

**Definition** (Linear map). A linear map (module homomorphism, a
structure-preserving map between modules) $f : M \to N$ between
$R$-modules satisfies $f(m+n) = f(m) + f(n)$ and $f(r \cdot m) = r \cdot f(m)$
([DummitFoote2003], §10.2).

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

### Sources, quoted

Formal definitions and citations for this section, gathered here for
reference (full entries in the [Bibliography](../bibliography.md)):

- **Module homomorphism.** An $R$-module homomorphism (or $R$-linear map)
  between $R$-modules $M$ and $N$ is a function $\varphi : M \to N$ that
  is a homomorphism of the underlying abelian groups and additionally
  commutes with the scalar action, $\varphi(rm) = r\varphi(m)$ for all
  $r \in R$, $m \in M$ ([DummitFoote2003], Ch. 10 "Introduction to
  Module Theory," §10.2 "Homomorphisms and Quotient Modules"). This is a
  structural citation to the section and its definition, not a verified
  word-for-word excerpt.

### Informal vs. formal: what "linear" means to each

> **Informal proof.** "$d \cdot (m + n) = d \cdot m + d \cdot n$ by
> distributivity. $d \cdot (r \cdot m) = r \cdot (d \cdot m)$ by
> commutativity of multiplication."

> **Lean formalization.**
> ```lean
> def mulByLinearMap (d : Int) : LinearMap intRing intZModule intZModule where
>   toFun := fun m => d * m
>   map_add := by
>     intro m n
>     show d * (m + n) = d * m + d * n
>     -- unfold toFun and module operations to get a plain Int equation
>     exact Int.mul_add d m n
>     -- Int.mul_add is the library lemma for a * (b + c) = a * b + a * c
>   map_smul := by
>     intro r m
>     show d * (r * m) = r * (d * m)
>     rw [← Int.mul_assoc, Int.mul_comm d r, Int.mul_assoc]
>     -- rewrite: regroup (d * r) * m → r * (d * m) using associativity
>     -- and commutativity of Int multiplication
> ```
>
> The informal version names two principles ("distributivity,"
> "commutativity") and considers the job done. The Lean version unfolds
> the module operations to bare `Int` arithmetic, then closes each goal
> with either a library lemma (`Int.mul_add`) or a rewrite sequence
> (`rw` with associativity and commutativity). The mathematical content is
> the same; the formalization demands every algebraic step be explicit.

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

[DummitFoote2003]: ../bibliography.md#dummitfoote2003

---

[← Submodules](04-submodules.md) | [Index](00-index.md) | [Next: Direct sums →](06-direct-sums.md)

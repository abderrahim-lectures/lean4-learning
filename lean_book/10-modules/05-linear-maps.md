## Linear maps

[← Submodules](04-submodules.md) | [Index](00-index.md) | [Next: Direct sums →](06-direct-sums.md)

---

A **linear map** (module homomorphism) $f : M \to N$ between $R$-modules
satisfies $f(m+n) = f(m) + f(n)$ and $f(r \cdot m) = r \cdot f(m)$:

```lean
structure LinearMap {R : Type} (Rg : Ring R) {M N : Type}
    (ModM : Module R Rg M) (ModN : Module R Rg N) where
  toFun : M → N
  map_add : ∀ m n : M, toFun (ModM.addGrp.op m n) = ModN.addGrp.op (toFun m) (toFun n)
  map_smul : ∀ (r : R) (m : M), toFun (ModM.smul r m) = ModN.smul r (toFun m)
```

This is precisely the categorical picture: $R$-modules and $R$-linear maps
form a category (composition of linear maps is linear, the identity
function is linear — both easy `theorem`s to state and prove from the two
fields above), and everything in this chapter — submodules, direct sums
below — is best understood as living inside that category, exactly the way
Chapter 1's opening dictionary suggested reading `Type` itself.

**Mathematical reading.** `LinearMap Rg ModM ModN` is the set
$\mathrm{Hom}_R(M, N)$ of $R$-module homomorphisms — functions $f : M \to N$
that are additive ($f(m+n) = f(m)+f(n)$, so $f$ is a group homomorphism of
the underlying abelian groups) and $R$-equivariant ($f(r\cdot m) = r\cdot
f(m)$, so $f$ intertwines the two $R$-actions). Equivalently, $f$ commutes
with the representation maps $\rho_M, \rho_N$ of the previous section:
$f\circ\rho_M(r) = \rho_N(r)\circ f$ for all $r$. These are the morphisms of
$R\text{-}\mathbf{Mod}$; $\mathrm{Hom}_R(M,N)$ is itself an abelian group
(and an $R$-module when $R$ is commutative), making $\mathrm{Hom}_R(-,-)$ the
Hom-bifunctor $R\text{-}\mathbf{Mod}^{\mathrm{op}} \times
R\text{-}\mathbf{Mod} \to \mathbf{Ab}$.

---

[← Submodules](04-submodules.md) | [Index](00-index.md) | [Next: Direct sums →](06-direct-sums.md)

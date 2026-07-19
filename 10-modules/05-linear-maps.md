## Linear maps

[← Submodules](04-submodules.md) | [Index](00-index.md) | [Next: Direct sums →](06-direct-sums.md)

---

A **linear map** (module homomorphism) $f : M \to N$ between $R$-modules
satisfies $f(m+n) = f(m) + f(n)$ and $f(r \cdot m) = r \cdot f(m)$:

<p><a href="https://live.lean-lang.org/#code=structure%20LinearMap%20%7BR%20%3A%20Type%7D%20%28Rg%20%3A%20Ring%20R%29%20%7BM%20N%20%3A%20Type%7D%0A%20%20%20%20%28ModM%20%3A%20Module%20R%20Rg%20M%29%20%28ModN%20%3A%20Module%20R%20Rg%20N%29%20where%0A%20%20toFun%20%3A%20M%20%E2%86%92%20N%0A%20%20map_add%20%3A%20%E2%88%80%20m%20n%20%3A%20M%2C%20toFun%20%28ModM.addGrp.op%20m%20n%29%20%3D%20ModN.addGrp.op%20%28toFun%20m%29%20%28toFun%20n%29%0A%20%20map_smul%20%3A%20%E2%88%80%20%28r%20%3A%20R%29%20%28m%20%3A%20M%29%2C%20toFun%20%28ModM.smul%20r%20m%29%20%3D%20ModN.smul%20r%20%28toFun%20m%29" target="_blank" rel="noopener">&#8599; Open in Lean playground (new tab)</a></p>
<iframe src="https://live.lean-lang.org/#code=structure%20LinearMap%20%7BR%20%3A%20Type%7D%20%28Rg%20%3A%20Ring%20R%29%20%7BM%20N%20%3A%20Type%7D%0A%20%20%20%20%28ModM%20%3A%20Module%20R%20Rg%20M%29%20%28ModN%20%3A%20Module%20R%20Rg%20N%29%20where%0A%20%20toFun%20%3A%20M%20%E2%86%92%20N%0A%20%20map_add%20%3A%20%E2%88%80%20m%20n%20%3A%20M%2C%20toFun%20%28ModM.addGrp.op%20m%20n%29%20%3D%20ModN.addGrp.op%20%28toFun%20m%29%20%28toFun%20n%29%0A%20%20map_smul%20%3A%20%E2%88%80%20%28r%20%3A%20R%29%20%28m%20%3A%20M%29%2C%20toFun%20%28ModM.smul%20r%20m%29%20%3D%20ModN.smul%20r%20%28toFun%20m%29" title="Lean playground" loading="lazy" style="width:100%;height:180px;border:1px solid #ccc;border-radius:8px;">
</iframe>

This is precisely the categorical picture: $R$-modules and $R$-linear maps
form a category (composition of linear maps is linear, and the identity
function is linear — both easy `theorem`s to state and prove from the two
fields above). Everything in this chapter, including submodules and the
direct sums below, is best understood as living inside that category,
consistent with Chapter 1's opening dictionary for reading `Type`
itself.

**Mathematical reading.** `LinearMap Rg ModM ModN` is the set
$\mathrm{Hom}_R(M, N)$ of $R$-module homomorphisms: functions $f : M \to N$
that are additive ($f(m+n) = f(m)+f(n)$, so $f$ is a group homomorphism of
the underlying abelian groups) and $R$-equivariant ($f(r\cdot m) = r\cdot
f(m)$, so $f$ intertwines the two $R$-actions). Equivalently, $f$ commutes
with the representation maps $\rho_M, \rho_N$ of the previous section:
$f\circ\rho_M(r) = \rho_N(r)\circ f$ for all $r$. These are the morphisms of
$R\text{-}\mathbf{Mod}$. $\mathrm{Hom}_R(M,N)$ is itself an abelian group
(and an $R$-module when $R$ is commutative).

### A concrete linear map: multiplication by a fixed integer

The abstract definition is easier to trust once a single instance has been
built by hand. Fix $d \in \mathbb{Z}$; multiplication by $d$ is $\mathbb{Z}$-linear
as a map $\mathbb{Z} \to \mathbb{Z}$:

<p><a href="https://live.lean-lang.org/#code=def%20mulByLinearMap%20%28d%20%3A%20Int%29%20%3A%20LinearMap%20intRing%20intZModule%20intZModule%20where%0A%20%20toFun%20%3A%3D%20fun%20m%20%3D%3E%20d%20%2A%20m%0A%20%20map_add%20%3A%3D%20by%0A%20%20%20%20intro%20m%20n%0A%20%20%20%20show%20d%20%2A%20%28m%20%2B%20n%29%20%3D%20d%20%2A%20m%20%2B%20d%20%2A%20n%0A%20%20%20%20exact%20Int.mul_add%20d%20m%20n%0A%20%20map_smul%20%3A%3D%20by%0A%20%20%20%20intro%20r%20m%0A%20%20%20%20show%20d%20%2A%20%28r%20%2A%20m%29%20%3D%20r%20%2A%20%28d%20%2A%20m%29%0A%20%20%20%20rw%20%5B%E2%86%90%20Int.mul_assoc%2C%20Int.mul_comm%20d%20r%2C%20Int.mul_assoc%5D%0A%0A%23eval%20%28mulByLinearMap%205%29.toFun%203%20%20%20--%2015" target="_blank" rel="noopener">&#8599; Open in Lean playground (new tab)</a></p>
<iframe src="https://live.lean-lang.org/#code=def%20mulByLinearMap%20%28d%20%3A%20Int%29%20%3A%20LinearMap%20intRing%20intZModule%20intZModule%20where%0A%20%20toFun%20%3A%3D%20fun%20m%20%3D%3E%20d%20%2A%20m%0A%20%20map_add%20%3A%3D%20by%0A%20%20%20%20intro%20m%20n%0A%20%20%20%20show%20d%20%2A%20%28m%20%2B%20n%29%20%3D%20d%20%2A%20m%20%2B%20d%20%2A%20n%0A%20%20%20%20exact%20Int.mul_add%20d%20m%20n%0A%20%20map_smul%20%3A%3D%20by%0A%20%20%20%20intro%20r%20m%0A%20%20%20%20show%20d%20%2A%20%28r%20%2A%20m%29%20%3D%20r%20%2A%20%28d%20%2A%20m%29%0A%20%20%20%20rw%20%5B%E2%86%90%20Int.mul_assoc%2C%20Int.mul_comm%20d%20r%2C%20Int.mul_assoc%5D%0A%0A%23eval%20%28mulByLinearMap%205%29.toFun%203%20%20%20--%2015" title="Lean playground" loading="lazy" style="width:100%;height:288px;border:1px solid #ccc;border-radius:8px;">
</iframe>

`map_add`'s goal, `d * (m+n) = d*m + d*n`, is exactly distributivity.
`map_smul`'s goal, `d * (r*m) = r * (d*m)`, holds because $\mathbb{Z}$ is
commutative, so `d` and `r` can swap past each other. Both fields, in
other words, are pure `Int`-arithmetic facts once `toFun`,
`ModM.smul`, and `ModM.addGrp.op` are unfolded to their meanings here. This is the same "reduce a
module-theoretic goal to a concrete arithmetic identity" move that
§4's `evenSubmodule` used, applied again.

**Mathlib equivalent.** Mathlib's own [`LinearMap`](https://loogle.lean-lang.org/?q=LinearMap) (notation `M →ₗ[R] N`)
is built the same way: supply `toFun` plus the two homomorphism proofs.
But the result is directly interoperable with the rest of the library's
linear-algebra API:

<p><a href="https://live.lean-lang.org/#code=def%20mulByLinearMap%27%20%28d%20%3A%20Int%29%20%3A%20Int%20%E2%86%92%E2%82%97%5BInt%5D%20Int%20where%0A%20%20toFun%20%3A%3D%20fun%20m%20%3D%3E%20d%20%2A%20m%0A%20%20map_add%27%20%3A%3D%20fun%20m%20n%20%3D%3E%20mul_add%20d%20m%20n%0A%20%20map_smul%27%20%3A%3D%20fun%20r%20m%20%3D%3E%20by%20simp%20%5Bmul_left_comm%5D%0A%0A%23eval%20mulByLinearMap%27%205%203%20%20%20--%2015" target="_blank" rel="noopener">&#8599; Open in Lean playground (new tab)</a></p>
<iframe src="https://live.lean-lang.org/#code=def%20mulByLinearMap%27%20%28d%20%3A%20Int%29%20%3A%20Int%20%E2%86%92%E2%82%97%5BInt%5D%20Int%20where%0A%20%20toFun%20%3A%3D%20fun%20m%20%3D%3E%20d%20%2A%20m%0A%20%20map_add%27%20%3A%3D%20fun%20m%20n%20%3D%3E%20mul_add%20d%20m%20n%0A%20%20map_smul%27%20%3A%3D%20fun%20r%20m%20%3D%3E%20by%20simp%20%5Bmul_left_comm%5D%0A%0A%23eval%20mulByLinearMap%27%205%203%20%20%20--%2015" title="Lean playground" loading="lazy" style="width:100%;height:180px;border:1px solid #ccc;border-radius:8px;">
</iframe>

This has the same shape as `mulByLinearMap`: a `toFun` and two proof
obligations, with `map_add`/`map_smul` becoming Mathlib's
`map_add'`/`map_smul'`. The real difference is that `Int →ₗ[Int] Int` is a
type the rest of Mathlib already knows how to compose, transport along
isomorphisms, and package into matrices. `LinearMap intRing intZModule
intZModule` gets none of that for free.

---

[← Submodules](04-submodules.md) | [Index](00-index.md) | [Next: Direct sums →](06-direct-sums.md)

## Submodules

[← Z-module example](03-z-module-example.md) | [Index](00-index.md) | [Next: Linear maps →](05-linear-maps.md)

---

A **submodule** of $M$ is a subset closed under $+$, containing $0$, and
closed under the scalar action. In Lean, "a subset closed under some
operations" is naturally a `structure` bundling a *predicate* on `M`
together with closure proofs — the same "data + proofs" idea as `Group`,
just with the "data" being a property rather than an operation:

```lean
structure Submodule {R : Type} (Rg : Ring R) {M : Type} (Mod : Module R Rg M) where
  carrier : M → Prop
  zero_mem : carrier Mod.addGrp.toGroup.id
  add_mem : ∀ {m n : M}, carrier m → carrier n → carrier (Mod.addGrp.op m n)
  smul_mem : ∀ (r : R) {m : M}, carrier m → carrier (Mod.smul r m)
```

`carrier : M → Prop` is the subset, viewed as its membership predicate
(`carrier m` reads "`m` is in the submodule"). This is the standard Lean
idiom for "subobject of `X`": not a `Set X` wrapped separately, but a
predicate directly, since `carrier m` *is* a proposition you can use as a
hypothesis.

**Mathematical reading.** `Submodule Rg Mod` is a submodule $N \le M$,
presented by its membership predicate $\chi_N : M \to \mathrm{Prop}$ (a
subset $N = \{\,m \in M \mid \chi_N(m)\,\}$) together with closure proofs:
$0 \in N$, $m,n \in N \Rightarrow m+n \in N$, and $r\in R,\, m\in N
\Rightarrow r\cdot m \in N$. These are exactly the conditions for $N$ to be
an $R$-submodule — closed under the abelian-group operations and stable
under scalars — so that $N$ inherits an $R$-module structure and the
inclusion $N \hookrightarrow M$ is $R$-linear. Categorically this is a
*subobject* in $R\text{-}\mathbf{Mod}$, the kernel-style data of a
monomorphism into $M$.

### Example: the submodule of even integers, as a $\mathbb{Z}$-submodule of $\mathbb{Z}$

```lean
def evenSubmodule : Submodule intRing (intZModule) where
  -- (intZModule : Module Int intRing Int would package intSmul from above;
  -- constructed the same way intCommGroup packaged intGroup in Chapter 8.)
  carrier := fun m => ∃ k : Int, m = 2 * k
  zero_mem := ⟨0, by ring⟩
  add_mem := by
    intro m n ⟨k, hk⟩ ⟨j, hj⟩
    exact ⟨k + j, by rw [hk, hj]; ring⟩
  smul_mem := by
    intro r m ⟨k, hk⟩
    exact ⟨r * k, by rw [hk]; ring⟩
```

Each closure proof follows the same shape: destructure the hypothesis to
expose its witness (`⟨k, hk⟩` says "`m` is even, with witness `k` and proof
`hk : m = 2 * k`"), then supply a new witness and discharge the resulting
polynomial identity with `ring` — a scoped, deliberate use of automation
exactly as in Chapter 8's matrix example, since every one of these
side-conditions is a genuine commutative-ring identity over `Int`.

**Mathematical reading.** This is the submodule $2\mathbb{Z} \le \mathbb{Z}$
of even integers, $2\mathbb{Z} = \{\, m \mid \exists k,\ m = 2k \,\}$ — the
image of multiplication-by-$2$, equivalently the principal ideal
$(2)\trianglelefteq \mathbb{Z}$ (submodules of the $\mathbb{Z}$-module
$\mathbb{Z}$ are exactly its ideals). The closure checks are the elementary
facts $0 = 2\cdot 0$, $2k + 2j = 2(k+j)$, and $r\cdot(2k) = 2(rk)$, each an
identity in the commutative ring $\mathbb{Z}$; the existential witnesses
$0,\ k+j,\ rk$ are precisely the elements exhibiting closure.

---

[← Z-module example](03-z-module-example.md) | [Index](00-index.md) | [Next: Linear maps →](05-linear-maps.md)

# Chapter 9: Modules over a ring

[← Ch. 8: Ring Theorems](08-ring-theorems.md) | [Table of contents](../README.md) | [Ch. 10: Path Algebras →](10-path-algebras.md)

---

## The mathematical definition

Given a ring $R$ (Chapter 7), a (left) **$R$-module** is an abelian group
$(M, +, 0, -(-))$ together with a scalar action $R \times M \to M$, written
$r \cdot m$, satisfying:

$$
\begin{aligned}
\text{(M1)}&\quad r \cdot (m + n) = r\cdot m + r \cdot n \\
\text{(M2)}&\quad (r + s) \cdot m = r \cdot m + s \cdot m \\
\text{(M3)}&\quad (r \cdot s) \cdot m = r \cdot (s \cdot m) \\
\text{(M4)}&\quad 1 \cdot m = m
\end{aligned}
$$

for all $r, s \in R$, $m, n \in M$. This is exactly a vector space
definition with "field" replaced by "ring" — and that generality is the
whole point: $\mathbb{Z}$-modules are abelian groups, $k[x]$-modules
(for $k$ a field) are vector spaces with a chosen linear endomorphism,
and — the destination of this chapter and the motivation for placing it
right before Chapter 10 — a representation of a quiver $Q$ is precisely a
module over the path algebra $kQ$.

## Translating into Lean

Following the same "data, then axioms" build as `Group` and `Ring`:

```lean
structure Module (R : Type) (Rg : Ring R) (M : Type) where
  addGrp : CommGroup M
  smul : R → M → M
  smul_add : ∀ (r : R) (m n : M), smul r (addGrp.op m n) = addGrp.op (smul r m) (smul r n)
  add_smul : ∀ (r s : R) (m : M), smul (Rg.addGrp.op r s) m = addGrp.op (smul r m) (smul s m)
  smul_smul : ∀ (r s : R) (m : M), smul (Rg.mul r s) m = smul r (smul s m)
  one_smul : ∀ m : M, smul Rg.one m = m
```

Field by field:

- `addGrp : CommGroup M` — the underlying abelian group of the module,
  exactly as `addGrp` played this role inside `Ring` (Chapter 7). Note
  `Module` takes `Rg : Ring R` as an *explicit argument*, not a field — a
  module is always a module *over* a specific, already-given ring, so `Rg`
  is a parameter of the whole structure rather than data bundled inside it.
- `smul : R → M → M` — the scalar action, `r • m` in ordinary notation.
- `smul_add`, `add_smul` — the two distributivity laws (M1), (M2), read
  respectively as "scalar over module-sum" and "ring-sum over scalar" —
  the same left/right-distinction discipline as `Ring`'s
  `left_distrib`/`right_distrib`, here split by *which* addition
  (`Rg.addGrp.op` vs. `addGrp.op`) is involved rather than which side `mul`
  is applied on.
- `smul_smul` — (M3), compatibility of the ring's multiplication with
  iterated scalar action.
- `one_smul` — (M4), the ring's multiplicative identity acts as the
  identity scalar.

## Example: every abelian group is a $\mathbb{Z}$-module

This is the standard first example, and a good one to actually build
because the scalar action isn't given data — it has to be *defined*, by
repeated addition, from the group structure alone.

```lean
-- n • m for n : Nat, by iterating `op`.
def natSmul {M : Type} (Grp : Group M) (n : Nat) (m : M) : M :=
  match n with
  | Nat.zero => Grp.id
  | Nat.succ k => Grp.op m (natSmul Grp k m)

-- extend to n : Int by using `inv` on negative n.
def intSmul {M : Type} (CG : CommGroup M) (n : Int) (m : M) : M :=
  match n with
  | Int.ofNat k => natSmul CG.toGroup k m
  | Int.negSucc k => CG.toGroup.inv (natSmul CG.toGroup (k + 1) m)
```

`natSmul Grp n m` is literally $m + m + \cdots + m$ ($n$ times), defined by
recursion on `n` exactly the way `Nat.add` itself was (Chapter 4);
`intSmul` extends it to negative integers via the group inverse. Given any
`CG : CommGroup M`, one can then check `intSmul CG` satisfies (M1)–(M4)
against `intRing` (Chapter 7) — a genuine (if somewhat long) proof by
induction on the integer scalar, in the same spirit as Chapter 4's
`my_add_comm`; we leave the full verification as an extended exercise,
since carrying it out yourself is the best way to see *why* modules over
$\mathbb{Z}$ are forced, not chosen: `intSmul` is the *unique* action
making any abelian group into a $\mathbb{Z}$-module, because (M4) plus
(M1)/(M2) pin down $n \cdot m$ for every integer $n$ by induction, leaving
no freedom.

## Submodules

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

### Example: the submodule of even integers, as a $\mathbb{Z}$-submodule of $\mathbb{Z}$

```lean
def evenSubmodule : Submodule intRing (intZModule) where
  -- (intZModule : Module Int intRing Int would package intSmul from above;
  -- constructed the same way intCommGroup packaged intGroup in Chapter 7.)
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
exactly as in Chapter 7's matrix example, since every one of these
side-conditions is a genuine commutative-ring identity over `Int`.

## Linear maps

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

## Direct sums of modules

Given two $R$-modules $M$, $N$, their direct sum $M \oplus N$ has carrier
$M \times N$, componentwise addition, and componentwise scalar action:

```lean
structure DirectSum (M N : Type) where
  fst : M
  snd : N

def directSumModule {R : Type} (Rg : Ring R) {M N : Type}
    (ModM : Module R Rg M) (ModN : Module R Rg N) :
    Module R Rg (DirectSum M N) where
  addGrp := {
    toGroup := {
      op := fun x y => ⟨ModM.addGrp.op x.fst y.fst, ModN.addGrp.op x.snd y.snd⟩
      id := ⟨ModM.addGrp.toGroup.id, ModN.addGrp.toGroup.id⟩
      inv := fun x => ⟨ModM.addGrp.toGroup.inv x.fst, ModN.addGrp.toGroup.inv x.snd⟩
      assoc := by
        intro x y z
        show DirectSum.mk _ _ = DirectSum.mk _ _
        congr 1
        · exact ModM.addGrp.toGroup.assoc x.fst y.fst z.fst
        · exact ModN.addGrp.toGroup.assoc x.snd y.snd z.snd
      id_left := by
        intro x
        congr 1
        · exact ModM.addGrp.toGroup.id_left x.fst
        · exact ModN.addGrp.toGroup.id_left x.snd
      id_right := by
        intro x
        congr 1
        · exact ModM.addGrp.toGroup.id_right x.fst
        · exact ModN.addGrp.toGroup.id_right x.snd
      inv_left := by
        intro x
        congr 1
        · exact ModM.addGrp.toGroup.inv_left x.fst
        · exact ModN.addGrp.toGroup.inv_left x.snd
      inv_right := by
        intro x
        congr 1
        · exact ModM.addGrp.toGroup.inv_right x.fst
        · exact ModN.addGrp.toGroup.inv_right x.snd
    }
    comm := by
      intro x y
      congr 1
      · exact ModM.addGrp.comm x.fst y.fst
      · exact ModN.addGrp.comm x.snd y.snd
  }
  smul := fun r x => ⟨ModM.smul r x.fst, ModN.smul r x.snd⟩
  smul_add := by
    intro r x y
    congr 1
    · exact ModM.smul_add r x.fst y.fst
    · exact ModN.smul_add r x.snd y.snd
  add_smul := by
    intro r s x
    congr 1
    · exact ModM.add_smul r s x.fst
    · exact ModN.add_smul r s x.snd
  smul_smul := by
    intro r s x
    congr 1
    · exact ModM.smul_smul r s x.fst
    · exact ModN.smul_smul r s x.snd
  one_smul := by
    intro x
    congr 1
    · exact ModM.one_smul x.fst
    · exact ModN.one_smul x.snd
```

`congr 1` is a tactic worth calling out since this is its first appearance:
given a goal `f a1 a2 = f b1 b2` (here `f` is `DirectSum.mk`), `congr 1`
reduces it to the componentwise goals `a1 = b1` and `a2 = b2` — the
categorical fact that a product's equality is checked pairwise, made into a
one-line tactic rather than a hand-unfolded `Prod.ext`-style lemma. Every
proof obligation above genuinely *is* two independent facts, one from `M`
and one from `N`, glued by the direct-sum's product structure — `congr 1`
is the right tool exactly because it exposes that independence directly,
rather than obscuring it inside a single opaque equality on pairs.

## Exercises

1. Prove that the identity function is a linear map: for any
   `Mod : Module R Rg M`, construct
   `idLinearMap : LinearMap Rg Mod Mod` with `toFun := id`.
2. Prove that linear maps compose: given
   `f : LinearMap Rg ModM ModN` and `g : LinearMap Rg ModN ModP`, construct
   `LinearMap Rg ModM ModP` with `toFun := g.toFun ∘ f.toFun`. (This,
   together with Exercise 1 and associativity of function composition, is
   what makes $R$-modules and $R$-linear maps a category — Chapter 1's
   promised payoff.)
3. Verify `intSmul` (defined above) satisfies `Module`'s four axioms
   against `intRing`, at least for `one_smul` and `smul_add` — by
   induction on the integer scalar, in the style of Chapter 4.
4. Define the submodule of multiples of a fixed integer `d : Int`
   (generalizing `evenSubmodule`, which is the case `d = 2`), and check
   your three closure proofs generalize verbatim with `2` replaced by `d`.

## Next

Continue to [Chapter 10: Quivers and path algebras](10-path-algebras.md), where
we return to path algebras — and note, once you've seen $kQ$ constructed,
that representations of $Q$ are exactly modules over $kQ$, tying this
chapter directly to the next.

---

[← Ch. 8: Ring Theorems](08-ring-theorems.md) | [Table of contents](../README.md) | [Ch. 10: Path Algebras →](10-path-algebras.md)

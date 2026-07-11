## Direct sums of modules

[← Linear maps](05-linear-maps.md) | [Index](00-index.md) | [Next: Exercises →](07-exercises.md)

---

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
        show DirectSum.mk _ _ = DirectSum.mk _ _
        congr 1
        · exact ModM.addGrp.toGroup.id_left x.fst
        · exact ModN.addGrp.toGroup.id_left x.snd
      id_right := by
        intro x
        show DirectSum.mk _ _ = DirectSum.mk _ _
        congr 1
        · exact ModM.addGrp.toGroup.id_right x.fst
        · exact ModN.addGrp.toGroup.id_right x.snd
      inv_left := by
        intro x
        show DirectSum.mk _ _ = DirectSum.mk _ _
        congr 1
        · exact ModM.addGrp.toGroup.inv_left x.fst
        · exact ModN.addGrp.toGroup.inv_left x.snd
      inv_right := by
        intro x
        show DirectSum.mk _ _ = DirectSum.mk _ _
        congr 1
        · exact ModM.addGrp.toGroup.inv_right x.fst
        · exact ModN.addGrp.toGroup.inv_right x.snd
    }
    comm := by
      intro x y
      show DirectSum.mk _ _ = DirectSum.mk _ _
      congr 1
      · exact ModM.addGrp.comm x.fst y.fst
      · exact ModN.addGrp.comm x.snd y.snd
  }
  smul := fun r x => ⟨ModM.smul r x.fst, ModN.smul r x.snd⟩
  smul_add := by
    intro r x y
    show DirectSum.mk _ _ = DirectSum.mk _ _
    congr 1
    · exact ModM.smul_add r x.fst y.fst
    · exact ModN.smul_add r x.snd y.snd
  add_smul := by
    intro r s x
    show DirectSum.mk _ _ = DirectSum.mk _ _
    congr 1
    · exact ModM.add_smul r s x.fst
    · exact ModN.add_smul r s x.snd
  smul_smul := by
    intro r s x
    show DirectSum.mk _ _ = DirectSum.mk _ _
    congr 1
    · exact ModM.smul_smul r s x.fst
    · exact ModN.smul_smul r s x.snd
  one_smul := by
    intro x
    show DirectSum.mk _ _ = DirectSum.mk _ _
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
rather than obscuring it inside a single opaque equality on pairs. Note
the `show DirectSum.mk _ _ = DirectSum.mk _ _` line before each `congr 1`:
without it, the goal is stated in terms of the anonymous-constructor
lambda (`op := fun x y => ⟨...⟩`) rather than the visible `DirectSum.mk`
application, and `congr 1` cannot reliably split a goal it doesn't
recognize as "one constructor applied to arguments on both sides" — a real
gap the compiler catches immediately if the `show` line is omitted.

**Mathematical reading.** This builds the **direct sum** $M \oplus N$: its
carrier is the product $M \times N$, with all structure defined
componentwise — $(m,n) + (m',n') = (m+m',\, n+n')$, $0 = (0,0)$, $-(m,n) =
(-m,-n)$, and $r\cdot(m,n) = (r\cdot m,\, r\cdot n)$. Every axiom holds
because it holds in each coordinate independently, which is exactly what
`congr 1` exposes: an equation of pairs splits into one equation in $M$ and
one in $N$. For finitely many summands the direct sum $M \oplus N$ is both a product and
a coproduct at once in $R\text{-}\mathbf{Mod}$: the projections $\pi_M,
\pi_N$ and inclusions $\iota_M, \iota_N$ satisfy $\pi_M\iota_M =
\mathrm{id}$, $\pi_N\iota_N = \mathrm{id}$, $\pi_M\iota_N = 0$, and
$\iota_M\pi_M + \iota_N\pi_N = \mathrm{id}$.

### A concrete instance: $\mathbb{Z} \oplus \mathbb{Z}$

Instantiating the generic construction costs nothing beyond supplying two
modules — here, `intZModule` twice:

```lean
def zSquaredModule := directSumModule intRing intZModule intZModule

#eval (zSquaredModule.addGrp.op ⟨2, 3⟩ ⟨10, 20⟩ : DirectSum Int Int)
-- { fst := 12, snd := 23 }, i.e. (2,3) + (10,20) = (12,23)

#eval (zSquaredModule.smul 5 ⟨2, 3⟩ : DirectSum Int Int)
-- { fst := 10, snd := 15 }, i.e. 5 · (2,3) = (10,15)
```

Both outputs are exactly the componentwise formulas from the mathematical
reading above, computed rather than merely asserted.

**Mathlib equivalent.** Where the book builds `DirectSum`/`directSumModule`
field by field (five group axioms, four module axioms, each split
componentwise via `congr 1`), Mathlib already gives the ordinary product
type `M × N` a `Module R` instance directly — there is no `DirectSum`
wrapper to define at all:

```lean
example {M N : Type*} [AddCommGroup M] [AddCommGroup N]
    [Module Int M] [Module Int N] : Module Int (M × N) := inferInstance

#eval ((2, 3) + (10, 20) : Int × Int)     -- (12, 23)
#eval ((5 : Int) • ((2, 3) : Int × Int))   -- (10, 15)
```

Same componentwise formulas as `zSquaredModule`'s `#eval`s above, but
`Prod`'s `AddCommGroup`/`Module` instances (and the componentwise `+`/`•`
they provide) are already in the library, built once for *any* two
additive groups or modules rather than assembled here for `Int` and `Int`
specifically.

The first projection $\pi_1 : \mathbb{Z}\oplus\mathbb{Z} \to \mathbb{Z}$, one of the defining maps
from the product/coproduct structure above, is itself a `LinearMap`
(previous section) built directly from `DirectSum`'s own field accessor:

```lean
def proj1 : LinearMap intRing zSquaredModule intZModule where
  toFun := fun x => x.fst
  map_add := by intro x y; rfl
  map_smul := by intro r x; rfl

#eval proj1.toFun ⟨7, 100⟩   -- 7
```

Both proof obligations are `rfl` directly: `zSquaredModule.addGrp.op`
unfolds to componentwise addition (by the construction two sections
back), so taking `.fst` of a sum is definitionally the same as summing the
`.fst`s — no arithmetic argument needed, only unfolding.

**Mathlib equivalent, continued.** The projection `proj1` is, again, not
something to build — Mathlib's `LinearMap.fst` already is $\pi_1$, generic
over any two modules over any ring:

```lean
def proj1' : (Int × Int) →ₗ[Int] Int := LinearMap.fst Int Int Int

#eval proj1' (7, 100)   -- 7
```

---

[← Linear maps](05-linear-maps.md) | [Index](00-index.md) | [Next: Exercises →](07-exercises.md)

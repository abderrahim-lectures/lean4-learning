## Chapter 10: Modules over a ring

[← Chapter 9](07-chapter-9.md) | [Index](00-index.md) | [Next: Chapter 11 →](09-chapter-11.md)

---

**1. The identity function is a linear map**

```lean
def idLinearMap {R : Type} (Rg : Ring R) {M : Type} (Mod : Module R Rg M) :
    LinearMap Rg Mod Mod where
  toFun := id
  map_add := by
    intro m n
    rfl
  map_smul := by
    intro r m
    rfl
```

`id : M → M` is `fun x => x`. Both fields reduce to [`rfl`](https://lean-lang.org/doc/reference/latest/Tactic-Proofs/Tactic-Reference/) because
`id (Mod.addGrp.op m n)` and `Mod.addGrp.op (id m) (id n)` unfold to the
exact same term (`id` doesn't change anything). The same holds for
`map_smul`. The only content in `LinearMap`'s two fields is the
compatibility of `toFun` with `+`/`smul`, and `id` trivially preserves
everything, since it changes nothing.

**2. Linear maps compose**

```lean
def composeLinearMap {R : Type} (Rg : Ring R) {M N P : Type}
    {ModM : Module R Rg M} {ModN : Module R Rg N} {ModP : Module R Rg P}
    (f : LinearMap Rg ModM ModN) (g : LinearMap Rg ModN ModP) :
    LinearMap Rg ModM ModP where
  toFun := g.toFun ∘ f.toFun
  map_add := by
    intro m n
    show g.toFun (f.toFun (ModM.addGrp.op m n)) =
      ModP.addGrp.op (g.toFun (f.toFun m)) (g.toFun (f.toFun n))
    rw [f.map_add]
    -- Goal: g.toFun (op (f.toFun m) (f.toFun n)) = op (g.toFun (f.toFun m)) (g.toFun (f.toFun n))
    exact g.map_add (f.toFun m) (f.toFun n)
  map_smul := by
    intro r m
    show g.toFun (f.toFun (ModM.smul r m)) = ModP.smul r (g.toFun (f.toFun m))
    rw [f.map_smul]
    -- Goal: g.toFun (ModN.smul r (f.toFun m)) = ModP.smul r (g.toFun (f.toFun m))
    exact g.map_smul r (f.toFun m)
```

`g.toFun ∘ f.toFun` is ordinary function composition. Each field's proof
first uses `f`'s own compatibility fact (`f.map_add`/`f.map_smul`) to push
the additive-group operation or scalar action *through* `f`. This leaves a
goal that is now exactly `g`'s compatibility fact, applied to the
already-transformed points `f.toFun m`, `f.toFun n`. This, plus Exercise 1
and the associativity of `∘` (both free from ordinary function
composition), is exactly the data that makes $R$-modules and $R$-linear
maps a category, as promised in the chapter text.

**3. Verifying `intSmul` satisfies `Module`'s axioms (partial: `one_smul`, `smul_add`)**

```lean
-- one_smul: intSmul CG 1 m = m
theorem intSmul_one_smul {M : Type} (CG : CommGroup M) (m : M) :
    intSmul CG 1 m = m := by
  show natSmul CG.toGroup 1 m = m
  show CG.toGroup.op m (natSmul CG.toGroup 0 m) = m
  show CG.toGroup.op m CG.toGroup.id = m
  exact CG.toGroup.id_right m
```

`intSmul CG 1 m` unfolds (since `1 = Int.ofNat 1`) to `natSmul CG.toGroup 1 m`,
which unfolds (since `1 = Nat.succ Nat.zero`) to
`CG.toGroup.op m (natSmul CG.toGroup 0 m)`. This unfolds again (the `zero`
case of `natSmul`) to `CG.toGroup.op m CG.toGroup.id`, which is exactly the
`id_right` axiom.

```lean
-- smul_add, restricted to natural-number scalars, by induction on n
theorem natSmul_add {M : Type} (Grp : Group M) (n : Nat) (m1 m2 : M)
    (comm : ∀ a b : M, Grp.op a b = Grp.op b a) :
    natSmul Grp n (Grp.op m1 m2) = Grp.op (natSmul Grp n m1) (natSmul Grp n m2) := by
  induction n with
  | zero =>
    -- Goal: natSmul Grp 0 (op m1 m2) = op (natSmul Grp 0 m1) (natSmul Grp 0 m2)
    show Grp.id = Grp.op Grp.id Grp.id
    exact (Grp.id_left Grp.id).symm
  | succ k ih =>
    -- ih : natSmul Grp k (op m1 m2) = op (natSmul Grp k m1) (natSmul Grp k m2)
    show Grp.op (Grp.op m1 m2) (natSmul Grp k (Grp.op m1 m2)) =
      Grp.op (Grp.op m1 (natSmul Grp k m1)) (Grp.op m2 (natSmul Grp k m2))
    rw [ih]
    -- Goal: op (op m1 m2) (op (natSmul Grp k m1) (natSmul Grp k m2))
    --     = op (op m1 (natSmul Grp k m1)) (op m2 (natSmul Grp k m2))
    -- Both sides are the same four elements combined via `op`, just grouped
    -- and ordered differently; regroup with `assoc` and swap the middle two
    -- terms using `comm`, exactly the "regroup, then rearrange" pattern
    -- from Chapter 7.
    rw [← Grp.assoc, Grp.assoc m1 m2, comm m2 (natSmul Grp k m1), ← Grp.assoc m1,
        Grp.assoc]
```

The base case is `id = id + id` (an identity is its own double). This
mirrors the "element equal to its own double is zero" fact used in
Chapter 9's `mul_zero`. The inductive step needs commutativity (`comm`,
available since we're inside a `CommGroup`) to slide `m2` and
`natSmul Grp k m1` past each other. This is exactly why `intSmul`
distributing over `+` requires an *abelian* group, not a general one:
without `comm`, there's no way to reorder the four terms into a matching
shape. Full verification of `add_smul` and `smul_smul` follows the same
induction-on-the-scalar pattern, and makes a good longer exercise to try
on your own.

**4. Submodule of multiples of `d`**

```lean
def multiplesSubmodule (d : Int) : Submodule intRing intZModule where
  carrier := fun m => ∃ k : Int, m = d * k
  zero_mem := ⟨0, by show (0 : Int) = d * 0; rw [Int.mul_zero]⟩
  add_mem := by
    intro m n ⟨k, hk⟩ ⟨j, hj⟩
    refine ⟨k + j, ?_⟩
    show m + n = d * (k + j)
    rw [hk, hj, Int.mul_add]
  smul_mem := by
    intro r m ⟨k, hk⟩
    refine ⟨r * k, ?_⟩
    show r * m = d * (r * k)
    rw [hk, ← Int.mul_assoc, Int.mul_comm r d, Int.mul_assoc]
```

This has the same shape as `evenSubmodule` (the case `d = 2`). Every `2` in
that proof is simply replaced by the parameter `d`, and each closure proof
still reduces to an `Int` equation, handled the same way ([`show`](https://lean-lang.org/doc/reference/latest/Tactic-Proofs/Tactic-Reference/) to
reveal the goal's `+`/`*`-form, then [`rw`](https://lean-lang.org/doc/reference/latest/Tactic-Proofs/Tactic-Reference/)), rather than with `ring` (which
this book doesn't import from Mathlib).

---

[← Chapter 9](07-chapter-9.md) | [Index](00-index.md) | [Next: Chapter 11 →](09-chapter-11.md)

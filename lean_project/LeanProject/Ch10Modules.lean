/-
Code from Chapter 10 (Modules over a ring) of the book.

NOTE: `evenSubmodule`'s definition in the book references `intZModule`
only in a comment ("would package intSmul... constructed the same way
intCommGroup packaged intGroup") without ever actually defining it — a
real gap in the book. `intZModule` is supplied here so the example
compiles; `ring` again flagged as a likely Mathlib-tactic issue, same as
Chapter 8.
-/
import LeanProject.Ch06Groups
import LeanProject.Ch07GroupTheorems
import LeanProject.Ch08Rings
import LeanProject.Ch09RingTheorems

structure Module (R : Type) (Rg : Ring R) (M : Type) where
  addGrp : CommGroup M
  smul : R → M → M
  smul_add : ∀ (r : R) (m n : M), smul r (addGrp.op m n) = addGrp.op (smul r m) (smul r n)
  add_smul : ∀ (r s : R) (m : M), smul (Rg.addGrp.op r s) m = addGrp.op (smul r m) (smul s m)
  smul_smul : ∀ (r s : R) (m : M), smul (Rg.mul r s) m = smul r (smul s m)
  one_smul : ∀ m : M, smul Rg.one m = m

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

-- Supplied (not given explicitly in the book): the Z-module structure on
-- Int itself, needed by `evenSubmodule` below. `smul` here is just `intSmul`
-- specialized to `M := Int`, which happens to coincide with ordinary `Int`
-- multiplication.
def intZModule : Module Int intRing Int where
  addGrp := intCommGroup
  smul := fun r m => r * m
  smul_add := by
    intro r m n
    exact Int.mul_add r m n
  add_smul := by
    intro r s m
    exact Int.add_mul r s m
  smul_smul := by
    intro r s m
    exact Int.mul_assoc r s m
  one_smul := by
    intro m
    exact Int.one_mul m

structure Submodule {R : Type} (Rg : Ring R) {M : Type} (Mod : Module R Rg M) where
  carrier : M → Prop
  zero_mem : carrier Mod.addGrp.toGroup.id
  add_mem : ∀ {m n : M}, carrier m → carrier n → carrier (Mod.addGrp.op m n)
  smul_mem : ∀ (r : R) {m : M}, carrier m → carrier (Mod.smul r m)

-- NOTE: `intZModule.addGrp.op`/`.id`/`.smul` are definitionally (but not
-- syntactically) equal to plain `+`/`0`/`*` on `Int` — true by `rfl`, but
-- `rw` only fires on syntactic matches, so a bare `rw [Int.mul_zero]`
-- etc. (as in an earlier draft) left an unsolved goal even though the
-- statement was already true. Fixed with `show` to state the goal in its
-- reduced (defeq) form explicitly before rewriting.
def evenSubmodule : Submodule intRing intZModule where
  carrier := fun m => ∃ k : Int, m = 2 * k
  zero_mem := ⟨0, rfl⟩
  add_mem := by
    intro m n ⟨k, hk⟩ ⟨j, hj⟩
    refine ⟨k + j, ?_⟩
    show m + n = 2 * (k + j)
    rw [hk, hj, Int.mul_add]
  smul_mem := by
    intro r m ⟨k, hk⟩
    refine ⟨r * k, ?_⟩
    show r * m = 2 * (r * k)
    rw [hk, ← Int.mul_assoc, Int.mul_comm r 2, Int.mul_assoc]

structure LinearMap {R : Type} (Rg : Ring R) {M N : Type}
    (ModM : Module R Rg M) (ModN : Module R Rg N) where
  toFun : M → N
  map_add : ∀ m n : M, toFun (ModM.addGrp.op m n) = ModN.addGrp.op (toFun m) (toFun n)
  map_smul : ∀ (r : R) (m : M), toFun (ModM.smul r m) = ModN.smul r (toFun m)

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

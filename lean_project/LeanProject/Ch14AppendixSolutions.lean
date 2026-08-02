/-
Code from the book's Appendix (Solutions to exercises) of the book.

Every exercise solution's Lean code is compiled here, with two exceptions
that are *already* compiled verbatim in their chapter's module (and so are
only referenced, not re-declared):

  - Chapter 6 exercise 1 (`boolXorGroup`): Ch06Groups.lean
  - Chapter 7 exercises 1-2 (`inv_inv`, `cancel_left`): Ch07GroupTheorems.lean
  - Chapter 8 exercise 3 (`mat2_not_comm`): Ch08Rings.lean
  - Chapter 11 exercise 1 (`CyclicArrow`/`cyclicQuiver`/`cPathAlpha`/
    `cPathBetaAlpha`/`cPathGammaBetaAlpha`) and exercise 2 (`append_nil_left`):
    Ch11PathAlgebras.lean

And one deliberate counterexample from the Appendix's Chapter 5 section
(`example (n : Nat) : n * 2 = n + n := rfl`, which the book itself explains
does *not* type-check as `rfl` and requires `rw [Nat.mul_two]`) is kept as a
comment, exactly as the main chapters' modules keep their intentional
type-error examples.
-/
import LeanProject.Ch01DependentTypes
import LeanProject.Ch03Propositions
import LeanProject.Ch04Tactics
import LeanProject.Ch06Groups
import LeanProject.Ch07GroupTheorems
import LeanProject.Ch08Rings
import LeanProject.Ch09RingTheorems
import LeanProject.Ch10Modules
import LeanProject.Ch11PathAlgebras

namespace Ch14AppendixSolutions

-- ── Chapter 1: first steps ────────────────────────────────────────────

-- Exercise 2: `Vec.toList : Vec α n → List α`.
def Vec.toList : Vec α n → List α
  | Vec.nil => []
  | Vec.cons a rest => a :: Vec.toList rest

-- The traced variant of the same recursion, watched via `dbg_trace`.
def Vec.toList' : Vec α n → List α
  | Vec.nil => dbg_trace s!"toList: nil, base case, returning []"; []
  | Vec.cons a rest =>
      dbg_trace s!"toList: cons, prepending one element, recursing on the rest";
      a :: Vec.toList' rest

#eval Vec.toList' (Vec.replicate (7 : Int) 3)
-- toList: cons, prepending one element, recursing on the rest
-- toList: cons, prepending one element, recursing on the rest
-- toList: cons, prepending one element, recursing on the rest
-- toList: nil, base case, returning []
-- [7, 7, 7]

-- Exercise 3: a second `Σ n : Nat, Fin n`.
def anotherSigma : Σ n : Nat, Fin n := ⟨5, ⟨0, by decide⟩⟩

-- (The book's `Σ n : Nat, n > 0` explanation is prose only — the type does
-- not even elaborate, since `n > 0 : Prop` is `Sort 0`, while `Sigma`'s
-- second component must land in some `Type`.)

-- ── Chapter 3: propositions and proofs ────────────────────────────────

-- Exercise 1:
theorem and_comm_ex {P Q : Prop} (h : P ∧ Q) : Q ∧ P :=
  ⟨h.right, h.left⟩

-- Exercise 2:
theorem or_comm_ex {P Q : Prop} (h : P ∨ Q) : Q ∨ P :=
  match h with
  | Or.inl hp => Or.inr hp
  | Or.inr hq => Or.inl hq

-- Exercise 3:
theorem exists_gt_zero : ∃ n : Nat, n > 0 :=
  ⟨1, by decide⟩

-- ── Chapter 4: tactics ────────────────────────────────────────────────

-- Exercise 1:
theorem and_comm_tac {P Q : Prop} (h : P ∧ Q) : Q ∧ P := by
  constructor
  · exact h.right
  · exact h.left

-- Exercise 2:
theorem nat_mul_zero (n : Nat) : n * 0 = 0 := by
  rfl

-- Exercise 3:
theorem modus_ponens_tac {P Q : Prop} (hpq : P → Q) (hp : P) : Q := by
  apply hpq
  exact hp

-- ── Chapter 5: rigor check ────────────────────────────────────────────

-- Exercise 1, first example (a closed-numeral computation: succeeds):
example : (2 : Nat) * 3 = 3 + 3 := rfl

-- Exercise 1, second example. The book explains that, contrary to a first
-- guess, this does *not* type-check as `rfl` in general (`n` sits on the
-- wrong side of `Nat.mul`'s second-argument recursion), so it is kept as a
-- comment below exactly like the main chapters' intentional errors, with
-- the book's own working fix after it:
-- example (n : Nat) : n * 2 = n + n := rfl
example (n : Nat) : n * 2 = n + n := by
  rw [Nat.mul_two]

-- Exercise 2: `MyGroup` as a type class.
class MyGroup (G : Type) where
  op : G → G → G
  id : G
  inv : G → G
  assoc : ∀ a b c : G, op (op a b) c = op a (op b c)
  id_left : ∀ a : G, op id a = a
  id_right : ∀ a : G, op a id = a
  inv_left : ∀ a : G, op (inv a) a = id
  inv_right : ∀ a : G, op a (inv a) = id

instance : MyGroup Int where
  op := fun a b => a + b
  id := 0
  inv := fun a => -a
  assoc := by intro a b c; exact Int.add_assoc a b c
  id_left := by intro a; exact Int.zero_add a
  id_right := by intro a; exact Int.add_zero a
  inv_left := by intro a; exact Int.add_left_neg a
  inv_right := by intro a; exact Int.add_right_neg a

def opTwiceTC [MyGroup G] (x : G) : G :=
  MyGroup.op x x

#eval opTwiceTC (3 : Int)   -- 6, with the Group Int instance found automatically

-- Exercise 4: a true propositional equality not provable by `rfl`.
theorem add_one_eq_succ (n : Nat) : n + 1 = Nat.succ n := rfl

theorem one_add_eq_succ (n : Nat) : 1 + n = Nat.succ n := by
  induction n with
  | zero => rfl
  | succ k ih =>
    show 1 + Nat.succ k = Nat.succ (Nat.succ k)
    rw [Nat.add_succ, ih]

-- Checkpoint project: a `Monoid` from scratch.
structure Monoid (M : Type) where
  op : M → M → M
  id : M
  assoc : ∀ a b c : M, op (op a b) c = op a (op b c)
  id_left : ∀ a : M, op id a = a
  id_right : ∀ a : M, op a id = a

def listMonoid (α : Type) : Monoid (List α) where
  op := List.append
  id := []
  assoc := by intro a b c; exact List.append_assoc a b c
  id_left := by intro a; exact List.nil_append a
  id_right := by intro a; exact List.append_nil a

def natMulMonoid : Monoid Nat where
  op := fun a b => a * b
  id := 1
  assoc := by intro a b c; exact Nat.mul_assoc a b c
  id_left := by intro a; exact Nat.one_mul a
  id_right := by intro a; exact Nat.mul_one a

theorem monoid_id_unique {M : Type} (Mn : Monoid M) (e' : M)
    (h : ∀ a : M, Mn.op e' a = a) : e' = Mn.id := by
  have step1 : Mn.op e' Mn.id = Mn.id := h Mn.id
  have step2 : Mn.op e' Mn.id = e' := Mn.id_right e'
  rw [← step2]
  exact step1

-- ── Chapter 6: groups ─────────────────────────────────────────────────

-- Exercise 1 (`boolXorGroup`) is already compiled verbatim in
-- Ch06Groups.lean; the Appendix's explanation of why `inv_left`/`inv_right`
-- are genuinely different obligations is prose only.

-- ── Chapter 7: group examples and basic theorems ──────────────────────

-- Exercises 1-2 (`inv_inv`, `cancel_left`) are already compiled verbatim in
-- Ch07GroupTheorems.lean.

-- ── Chapter 8: rings ──────────────────────────────────────────────────

-- Exercise 1: `bool2CommGroup` / `bool2Ring` (Z/2Z on `Bool`). Uses
-- `boolXorGroup` from Ch06Groups.lean as the additive group.
def bool2CommGroup : CommGroup Bool where
  toGroup := boolXorGroup
  comm := by
    intro a b
    cases a with
    | false => cases b with | false => rfl | true => rfl
    | true => cases b with | false => rfl | true => rfl

def bool2Ring : Ring Bool where
  addGrp := bool2CommGroup
  mul := Bool.and
  one := true
  mul_assoc := by
    intro a b c
    cases a with
    | false => cases b with
      | false => cases c with | false => rfl | true => rfl
      | true => cases c with | false => rfl | true => rfl
    | true => cases b with
      | false => cases c with | false => rfl | true => rfl
      | true => cases c with | false => rfl | true => rfl
  one_mul := by
    intro a
    cases a with | false => rfl | true => rfl
  mul_one := by
    intro a
    cases a with | false => rfl | true => rfl
  left_distrib := by
    intro a b c
    cases a with
    | false => cases b with
      | false => cases c with | false => rfl | true => rfl
      | true => cases c with | false => rfl | true => rfl
    | true => cases b with
      | false => cases c with | false => rfl | true => rfl
      | true => cases c with | false => rfl | true => rfl
  right_distrib := by
    intro a b c
    cases a with
    | false => cases b with
      | false => cases c with | false => rfl | true => rfl
      | true => cases c with | false => rfl | true => rfl
    | true => cases b with
      | false => cases c with | false => rfl | true => rfl
      | true => cases c with | false => rfl | true => rfl

-- Exercise 3 (`mat2_not_comm`) is already compiled verbatim in
-- Ch08Rings.lean; the Appendix's argument that `right_distrib` (not
-- `left_distrib`) is needed for `mul_zero_left` is prose only.

-- ── Chapter 9: ring examples and basic theorems ───────────────────────

-- Exercise 1: `neg_mul`. (`mul_zero_left` it relies on is already compiled
-- in Ch09RingTheorems.lean, where the main chapter's `neg_one_mul` needed it.)
variable {R : Type} (Rg : Ring R)

theorem neg_mul (a b : R) :
    Rg.mul (Rg.addGrp.toGroup.inv a) b = Rg.addGrp.toGroup.inv (Rg.mul a b) := by
  apply left_inverse_unique Rg.addGrp.toGroup (Rg.mul a b) (Rg.mul (Rg.addGrp.toGroup.inv a) b)
  -- Goal: op (mul (inv a) b) (mul a b) = id
  rw [← Rg.right_distrib]
  -- justified by right_distrib, read backwards: combines the two products
  -- mul (inv a) b and mul a b into mul (op (inv a) a) b.
  -- Goal: mul (op (inv a) a) b = id
  rw [Rg.addGrp.toGroup.inv_left]
  -- justified by inv_left of the additive group: op (inv a) a = id.
  -- Goal: mul Rg.addGrp.id b = id
  exact mul_zero_left Rg b

-- Exercise 2: `neg_seven` is `rfl` because `7` is a concrete numeral, not a
-- variable.
theorem neg_seven : intRing.addGrp.toGroup.inv 7 = -7 := rfl

-- ── Chapter 10: modules over a ring ───────────────────────────────────

-- Exercise 1: the identity function is a linear map.
def idLinearMap {R : Type} (Rg : Ring R) {M : Type} (Mod : Module R Rg M) :
    LinearMap Rg Mod Mod where
  toFun := id
  map_add := by
    intro m n
    rfl
  map_smul := by
    intro r m
    rfl

-- Exercise 2: linear maps compose.
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

-- Exercise 3 (partial: `one_smul`, `smul_add`).
theorem intSmul_one_smul {M : Type} (CG : CommGroup M) (m : M) :
    intSmul CG 1 m = m := by
  show natSmul CG.toGroup 1 m = m
  show CG.toGroup.op m (natSmul CG.toGroup 0 m) = m
  show CG.toGroup.op m CG.toGroup.id = m
  exact CG.toGroup.id_right m

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

-- Exercise 4: submodule of multiples of `d` (generalizing `evenSubmodule`).
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

-- ── Chapter 11: quivers and path algebras ─────────────────────────────

-- Exercise 1 (`CyclicArrow`/`cyclicQuiver`/`cPathAlpha`/`cPathBetaAlpha`/
-- `cPathGammaBetaAlpha`) and exercise 2 (`append_nil_left`) are already
-- compiled verbatim in Ch11PathAlgebras.lean.

-- Exercise 3: a k-linear combination of paths (sketch only — the book
-- explicitly flags the missing finiteness/support condition).
structure PathAlgebraElem (V A : Type) (Q : Quiver V A) (k : Type) where
  coeff : {u v : V} → Path Q u v → k

end Ch14AppendixSolutions

-- ── Appendix, Chapter 11 checkpoint project ───────────────────────────

-- NOTE: `Path.length`/`Path.append_length` (and the traced `Path.length'`/
-- `Path.append'`) are declared at root namespace rather than inside
-- `Ch14AppendixSolutions` above, because they extend the `Path` type (itself
-- declared at root in Ch11PathAlgebras.lean): dot notation (`p.length`)
-- resolves the field against the type's root namespace. Inside a wrapper
-- namespace the resulting `Ch14AppendixSolutions.Path.length` would not be
-- found by `p.length`. Declaring them at root, next to `Path` itself, keeps
-- every use of dot notation working verbatim as the book shows it.

-- Checkpoint project: path length, and composition respects it.
def Path.length {V A : Type} {Q : Quiver V A} : {u v : V} → Path Q u v → Nat
  | _, _, Path.nil _ => 0
  | _, _, Path.cons _ _ _ p => p.length + 1

theorem Path.append_length {V A : Type} {Q : Quiver V A} {u v w : V}
    (p : Path Q u v) (q : Path Q v w) :
    (Path.append p q).length = p.length + q.length := by
  induction q with
  | nil =>
    simp only [Path.append, Path.length]
    rw [Nat.add_zero]
  | cons a h h' q' ih =>
    simp only [Path.append, Path.length]
    rw [ih, Nat.add_assoc]

example : (Path.append pathAlpha pathBetaOnly).length =
    pathAlpha.length + pathBetaOnly.length :=
  Path.append_length pathAlpha pathBetaOnly

#eval pathAlpha.length                                    -- 1
#eval pathBetaAlpha.length                                -- 2
#eval (Path.append pathAlpha pathBetaOnly).length          -- 2

-- The traced variants (prose-watchable since `Path` has no `Repr`):
def Path.append' {V A : Type} {Q : Quiver V A} {u v w : V}
    (p : Path Q u v) (q : Path Q v w) : Path Q u w :=
  match q with
  | Path.nil _ => dbg_trace s!"append: q is nil, base case, returning p unchanged"; p
  | Path.cons a h h' q' =>
      dbg_trace s!"append: q ends with an arrow, recursing on the shorter path underneath, then re-attaching that arrow";
      Path.cons a h h' (Path.append' p q')

def Path.length' {V A : Type} {Q : Quiver V A} : {u v : V} → Path Q u v → Nat
  | _, _, Path.nil _ => dbg_trace s!"length: nil, base case, returning 0"; 0
  | _, _, Path.cons _ _ _ p => dbg_trace s!"length: cons, adding 1 to the rest's length"; p.length' + 1

#eval (Path.append' pathAlpha pathBetaOnly).length'
-- append: q ends with an arrow, recursing on the shorter path underneath, then re-attaching that arrow
-- append: q is nil, base case, returning p unchanged
-- length: cons, adding 1 to the rest's length
-- length: cons, adding 1 to the rest's length
-- length: nil, base case, returning 0
-- 2

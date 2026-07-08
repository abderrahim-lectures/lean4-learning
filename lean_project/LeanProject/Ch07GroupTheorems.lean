/-
Code from Chapter 7 (Group examples and basic theorems) of the book.
-/
import LeanProject.Ch06Groups

variable {G : Type} (Grp : Group G)

theorem id_unique (e' : G) (h : ∀ a : G, Grp.op e' a = a) : e' = Grp.id := by
  have step1 : Grp.op e' Grp.id = Grp.id := h Grp.id
  have step2 : Grp.op e' Grp.id = e' := Grp.id_right e'
  rw [← step2]
  exact step1

theorem left_inverse_unique (a b : G) (h : Grp.op b a = Grp.id) :
    b = Grp.inv a := by
  have e1 : b = Grp.op b Grp.id := (Grp.id_right b).symm
  rw [e1]
  -- Goal: op b id = inv a
  rw [← Grp.inv_right a]
  -- Goal: op b (op a (inv a)) = inv a
  rw [← Grp.assoc b a (Grp.inv a)]
  -- Goal: op (op b a) (inv a) = inv a
  rw [h]
  -- Goal: op id (inv a) = inv a
  exact Grp.id_left (Grp.inv a)

theorem inv_op (a b : G) :
    Grp.inv (Grp.op a b) = Grp.op (Grp.inv b) (Grp.inv a) := by
  apply Eq.symm
  apply left_inverse_unique
  -- Goal: op (op (inv b) (inv a)) (op a b) = id
  rw [Grp.assoc]
  -- Goal: op (inv b) (op (inv a) (op a b)) = id
  rw [← Grp.assoc (Grp.inv a) a b]
  -- Goal: op (inv b) (op (op (inv a) a) b) = id
  rw [Grp.inv_left]
  -- Goal: op (inv b) (op id b) = id
  rw [Grp.id_left]
  -- Goal: op (inv b) b = id
  exact Grp.inv_left b

-- The payoff, made concrete: applying inv_op (proved above for an
-- arbitrary Group G) to Chapter 6's non-abelian perm3Group, with no new
-- proof required.
example : perm3Group.inv (perm3Group.op swap01 cycle012) =
    perm3Group.op (perm3Group.inv cycle012) (perm3Group.inv swap01) :=
  inv_op perm3Group swap01 cycle012

#eval (perm3Group.inv (perm3Group.op swap01 cycle012)).toFun 0
#eval (perm3Group.op (perm3Group.inv cycle012) (perm3Group.inv swap01)).toFun 0
#eval (perm3Group.inv (perm3Group.op swap01 cycle012)).toFun 1
#eval (perm3Group.op (perm3Group.inv cycle012) (perm3Group.inv swap01)).toFun 1
#eval (perm3Group.inv (perm3Group.op swap01 cycle012)).toFun 2
#eval (perm3Group.op (perm3Group.inv cycle012) (perm3Group.inv swap01)).toFun 2

-- Chapter 7 exercises
theorem inv_inv (a : G) : Grp.inv (Grp.inv a) = a := by
  apply Eq.symm
  apply left_inverse_unique Grp (Grp.inv a) a
  -- Goal: op a (inv a) = id
  exact Grp.inv_right a

theorem cancel_left (a b c : G) (h : Grp.op a b = Grp.op a c) : b = c := by
  have h1 : Grp.op (Grp.inv a) (Grp.op a b) = Grp.op (Grp.inv a) (Grp.op a c) := by
    rw [h]
  rw [← Grp.assoc (Grp.inv a) a b] at h1
  rw [← Grp.assoc (Grp.inv a) a c] at h1
  rw [Grp.inv_left] at h1
  rw [Grp.id_left, Grp.id_left] at h1
  exact h1

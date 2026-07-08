/-
Code from Chapter 6 (Structures and classes: defining a `Group`) of the
book. `Group`, `intGroup` are used by later chapters' modules.
-/

structure GroupData (G : Type) where
  op : G → G → G
  id : G
  inv : G → G

structure Group (G : Type) where
  op : G → G → G
  id : G
  inv : G → G
  assoc : ∀ a b c : G, op (op a b) c = op a (op b c)
  id_left : ∀ a : G, op id a = a
  id_right : ∀ a : G, op a id = a
  inv_left : ∀ a : G, op (inv a) a = id
  inv_right : ∀ a : G, op a (inv a) = id

def intGroup : Group Int where
  op := fun a b => a + b
  id := 0
  inv := fun a => -a
  assoc := by
    intro a b c
    -- Goal: (a + b) + c = a + (b + c)
    exact Int.add_assoc a b c
  id_left := by
    intro a
    -- Goal: 0 + a = a
    exact Int.zero_add a
  id_right := by
    intro a
    -- Goal: a + 0 = a
    exact Int.add_zero a
  inv_left := by
    intro a
    -- Goal: (-a) + a = 0
    exact Int.add_left_neg a
  inv_right := by
    intro a
    -- Goal: a + (-a) = 0
    exact Int.add_right_neg a

#eval intGroup.op 3 4        -- 7
#eval intGroup.id             -- 0
#eval intGroup.inv 5          -- -5

#check intGroup.assoc         -- a proof, for every a b c, of associativity

-- Chapter 6: a non-abelian example, permutations of Fin 3 (S_3)
structure Perm3 where
  toFun : Fin 3 → Fin 3
  invFun : Fin 3 → Fin 3
  left_inv : ∀ x, invFun (toFun x) = x
  right_inv : ∀ x, toFun (invFun x) = x

def Perm3.comp (f g : Perm3) : Perm3 where
  toFun := f.toFun ∘ g.toFun
  invFun := g.invFun ∘ f.invFun
  left_inv := by
    intro x
    show g.invFun (f.invFun (f.toFun (g.toFun x))) = x
    rw [f.left_inv]
    exact g.left_inv x
  right_inv := by
    intro x
    show f.toFun (g.toFun (g.invFun (f.invFun x))) = x
    rw [g.right_inv]
    exact f.right_inv x

def Perm3.identity : Perm3 where
  toFun := fun x => x
  invFun := fun x => x
  left_inv := fun _ => rfl
  right_inv := fun _ => rfl

def Perm3.inv (f : Perm3) : Perm3 where
  toFun := f.invFun
  invFun := f.toFun
  left_inv := f.right_inv
  right_inv := f.left_inv

def swap01 : Perm3 where
  toFun := fun x => match x with
    | 0 => 1 | 1 => 0 | 2 => 2
  invFun := fun x => match x with
    | 0 => 1 | 1 => 0 | 2 => 2
  left_inv := by intro x; match x with | 0 => rfl | 1 => rfl | 2 => rfl
  right_inv := by intro x; match x with | 0 => rfl | 1 => rfl | 2 => rfl

def cycle012 : Perm3 where
  toFun := fun x => match x with
    | 0 => 1 | 1 => 2 | 2 => 0
  invFun := fun x => match x with
    | 0 => 2 | 1 => 0 | 2 => 1
  left_inv := by intro x; match x with | 0 => rfl | 1 => rfl | 2 => rfl
  right_inv := by intro x; match x with | 0 => rfl | 1 => rfl | 2 => rfl

#eval (Perm3.comp swap01 cycle012).toFun 0   -- 0
#eval (Perm3.comp cycle012 swap01).toFun 0   -- 2

theorem Perm3.ext {f g : Perm3} (h : ∀ x, f.toFun x = g.toFun x)
    (h' : ∀ x, f.invFun x = g.invFun x) : f = g := by
  cases f
  cases g
  simp only [mk.injEq]
  constructor
  · funext x; exact h x
  · funext x; exact h' x

def perm3Group : Group Perm3 where
  op := Perm3.comp
  id := Perm3.identity
  inv := Perm3.inv
  assoc := by
    intro f g h
    apply Perm3.ext
    · intro x; rfl
    · intro x; rfl
  id_left := by
    intro f
    apply Perm3.ext
    · intro x; rfl
    · intro x; rfl
  id_right := by
    intro f
    apply Perm3.ext
    · intro x; rfl
    · intro x; rfl
  inv_left := by
    intro f
    apply Perm3.ext
    · intro x; exact f.left_inv x
    · intro x; exact f.left_inv x
  inv_right := by
    intro f
    apply Perm3.ext
    · intro x; exact f.right_inv x
    · intro x; exact f.right_inv x

-- Chapter 6 exercise 1: Bool under xor
def boolXorGroup : Group Bool where
  op := Bool.xor
  id := false
  inv := fun a => a
  assoc := by
    intro a b c
    cases a with
    | false => cases b with
      | false => cases c with | false => rfl | true => rfl
      | true => cases c with | false => rfl | true => rfl
    | true => cases b with
      | false => cases c with | false => rfl | true => rfl
      | true => cases c with | false => rfl | true => rfl
  id_left := by
    intro a
    cases a with
    | false => rfl
    | true => rfl
  id_right := by
    intro a
    cases a with
    | false => rfl
    | true => rfl
  inv_left := by
    intro a
    cases a with
    | false => rfl
    | true => rfl
  inv_right := by
    intro a
    cases a with
    | false => rfl
    | true => rfl

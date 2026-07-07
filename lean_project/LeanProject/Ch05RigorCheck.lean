/-
Code from Chapter 5 (Rigor check) of the book.

The book's snippets in this chapter are deliberately partial (`-- ...`
bodies) to illustrate `structure` vs `class` syntax side by side. Here we
give complete, compiling versions of both, under different names so they
can coexist.
-/
namespace Ch05RigorCheck

-- This book's style: a plain `structure`.
structure MyGroupS (G : Type) where
  op : G → G → G
  id : G
  inv : G → G
  assoc : ∀ a b c : G, op (op a b) c = op a (op b c)
  id_left : ∀ a : G, op id a = a
  id_right : ∀ a : G, op a id = a
  inv_left : ∀ a : G, op (inv a) a = id
  inv_right : ∀ a : G, op a (inv a) = id

-- Mathlib's style (schematically): a `class`, enabling instance search.
class MyGroupC (G : Type) where
  op : G → G → G
  id : G
  inv : G → G
  assoc : ∀ a b c : G, op (op a b) c = op a (op b c)
  id_left : ∀ a : G, op id a = a
  id_right : ∀ a : G, op a id = a
  inv_left : ∀ a : G, op (inv a) a = id
  inv_right : ∀ a : G, op a (inv a) = id

instance : MyGroupC Int where
  op := fun a b => a + b
  id := 0
  inv := fun a => -a
  assoc := by intro a b c; exact Int.add_assoc a b c
  id_left := by intro a; exact Int.zero_add a
  id_right := by intro a; exact Int.add_zero a
  inv_left := by intro a; exact Int.add_left_neg a
  inv_right := by intro a; exact Int.add_right_neg a

def opTwiceTC [MyGroupC G] (x : G) : G :=
  MyGroupC.op x x   -- the `MyGroupC Int` instance is found automatically

#eval opTwiceTC (3 : Int)   -- 6

def myGroupSInt : MyGroupS Int where
  op := fun a b => a + b
  id := 0
  inv := fun a => -a
  assoc := by intro a b c; exact Int.add_assoc a b c
  id_left := by intro a; exact Int.zero_add a
  id_right := by intro a; exact Int.add_zero a
  inv_left := by intro a; exact Int.add_left_neg a
  inv_right := by intro a; exact Int.add_right_neg a

def opTwiceExplicit (Grp : MyGroupS G) (x : G) : G :=
  Grp.op x x

#eval opTwiceExplicit myGroupSInt 3   -- 6, structure passed explicitly

-- Universes
#check (Nat : Type)        -- Nat itself lives in Type
#check (Type : Type 1)      -- Type lives one level up, in Type 1
#check (Type 1 : Type 2)    -- and so on, forever

-- Definitional vs propositional equality
example : 2 + 2 = 4 := rfl        -- 2 + 2 reduces to 4 definitionally
example : 0 + 2 = 2 := rfl        -- reduces, since `Nat.add` recurses on
                                   -- its second argument and 2 + 0 = 2
                                   -- is the base clause
example : 2 + 0 = 2 := rfl         -- also rfl (this is the base clause itself)

end Ch05RigorCheck

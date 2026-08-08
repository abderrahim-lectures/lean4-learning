/-
Code from Chapter 3 (Functions, definitions, and structures) of the book.
-/
namespace Ch03Structures

structure Point where
  x : Nat
  y : Nat

def origin : Point := { x := 0, y := 0 }

#eval origin.x        -- 0

def shift (p : Point) (dx dy : Nat) : Point :=
  { x := p.x + dx, y := p.y + dy }

#eval (shift origin 3 4).y   -- 4

structure Pair (α β : Type) where
  fst : α
  snd : β

def p : Pair Nat String := { fst := 1, snd := "one" }

#eval p.fst    -- 1
#eval p.snd     -- "one"

structure Point3D extends Point where
  z : Nat

def origin3D : Point3D := { x := 0, y := 0, z := 0 }

#eval origin3D.x   -- inherited field, 0

-- Exercises (Section 4), and their appendix solutions (15-appendix-solutions/03-chapter-3.md)

structure Rectangle where
  width : Nat
  height : Nat

def area (r : Rectangle) : Nat := r.width * r.height

#eval area ⟨3, 4⟩   -- 12

structure Box (α : Type) where
  value : α

def unwrap {α : Type} (b : Box α) : α := b.value

def natBox : Box Nat := ⟨7⟩
def strBox : Box String := ⟨"seven"⟩

#eval unwrap natBox   -- 7
#eval unwrap strBox   -- "seven"

structure ColoredRectangle extends Rectangle where
  color : String

def redSquare : ColoredRectangle :=
  { width := 5, height := 5, color := "red" }

#check redSquare.toRectangle      -- redSquare.toRectangle : Rectangle
#eval area redSquare.toRectangle  -- 25

end Ch03Structures

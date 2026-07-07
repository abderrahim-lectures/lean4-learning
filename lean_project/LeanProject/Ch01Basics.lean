/-
Code from Chapter 1 (First steps: terms, types, `#eval`) of the book.
-/
namespace Ch01Basics

#check (3 : Nat)
#check (-3 : Int)
#check (Nat : Type)
#eval 2 ^ 10        -- 1024

def double (n : Nat) : Nat := n * 2

def average (a b : Nat) : Nat :=
  let sum := a + b
  sum / 2

def identity {α : Type} (x : α) : α := x

#eval double 7        -- 14
#eval average 4 10     -- 7
#eval identity 5        -- 5
#eval identity "hi"      -- "hi"

end Ch01Basics

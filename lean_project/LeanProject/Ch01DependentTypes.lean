/-
Code from Chapter 1, Section 3 (Dependent types) of the book.

The book's *intentional* counterexamples — `#check Vec.head Vec.nil` and
`#check Vec.dot vecA vecB` — are expected type errors (that is their
pedagogical point) and are reproduced as comments below rather than
compiled.
-/

-- A type family: one type per natural number.
#check Fin 3   -- Fin 3 : Type
#check Fin 5   -- Fin 5 : Type

#print Fin
-- structure Fin (n : Nat) : Type
-- fields:
--   Fin.val  : Nat
--   Fin.isLt : ↑self < n

-- Fixed-length vectors, indexed by their length.
inductive Vec (α : Type) : Nat → Type where
  | nil  : Vec α 0
  | cons : α → Vec α n → Vec α (n + 1)

def Vec.replicate (a : α) : (n : Nat) → Vec α n
  | 0     => Vec.nil
  | n + 1 => Vec.cons a (Vec.replicate a n)

#check @Vec.replicate
-- @Vec.replicate : {α : Type} → α → (n : Nat) → Vec α n

#eval (Vec.replicate (-42 : Int) 3 : Vec Int 3)
-- Vec.cons (-42) (Vec.cons (-42) (Vec.cons (-42) (Vec.nil)))

def Vec.replicate' (a : α) : (n : Nat) → Vec α n
  | 0     => dbg_trace s!"replicate: n=0, base case, returning Vec.nil"; Vec.nil
  | n + 1 => dbg_trace s!"replicate: n={n+1}, prepending one copy of a, recursing with n={n}";
             Vec.cons a (Vec.replicate' a n)

#eval (Vec.replicate' (-42 : Int) 3 : Vec Int 3)
-- replicate: n=3, prepending one copy of a, recursing with n=2
-- replicate: n=2, prepending one copy of a, recursing with n=1
-- replicate: n=1, prepending one copy of a, recursing with n=0
-- replicate: n=0, base case, returning Vec.nil
-- Vec.cons (-42) (Vec.cons (-42) (Vec.cons (-42) (Vec.nil)))

-- A function that only accepts a non-empty vector, and a dot product that
-- forces both arguments to share the same length.
def Vec.head : Vec α (n + 1) → α
  | Vec.cons a _ => a

-- (counterexample, expected error: `Vec.nil` has length 0, not n + 1)
-- #check Vec.head Vec.nil

def Vec.dot : Vec Int n → Vec Int n → Int
  | Vec.nil, Vec.nil => 0
  | Vec.cons x xs, Vec.cons y ys => x * y + Vec.dot xs ys

def vecA : Vec Int 3 := Vec.cons 17 (Vec.cons (-3) (Vec.cons 42 Vec.nil))
def vecB : Vec Int 2 := Vec.cons 99 (Vec.cons 8 Vec.nil)

-- (counterexample, expected error: `vecB` has length 2, not 3)
-- #check Vec.dot vecA vecB

def Vec.dot' : Vec Int n → Vec Int n → Int
  | Vec.nil, Vec.nil => dbg_trace s!"dot: both nil, base case, returning 0"; 0
  | Vec.cons x xs, Vec.cons y ys =>
      dbg_trace s!"dot: heads x={x}, y={y}, recursing on the rest";
      x * y + Vec.dot' xs ys

def vecC : Vec Int 3 := Vec.cons 2 (Vec.cons 5 (Vec.cons 1 Vec.nil))

#eval Vec.dot' vecA vecC
-- dot: heads x=17, y=2, recursing on the rest
-- dot: heads x=-3, y=5, recursing on the rest
-- dot: heads x=42, y=1, recursing on the rest
-- dot: both nil, base case, returning 0
-- 61

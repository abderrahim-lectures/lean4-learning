/-
Code from Chapter 1, Section 3 (Dependent types) and Section 5
(Π/Σ-types and the calculus of constructions) of the book.

The book's *intentional* counterexamples — `#check Vec.head Vec.nil`,
`#check Vec.dot vecA vecB`, `badPick`, `badSigma`, `bad`, and
`doubleBad` — are expected type errors (that is their pedagogical point)
and are reproduced as comments below rather than compiled.
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

-- A genuinely different codomain per argument.
def pick (b : Bool) : (if b then Nat else Bool) :=
  match b with
  | true => (42 : Nat)
  | false => (true : Bool)

#check @pick   -- pick : (b : Bool) → if b = true then Nat else Bool
#eval pick true   -- 42
#eval pick false  -- true

-- (counterexample, expected error: the two branches disagree on type)
-- def badPick (b : Bool) : Nat :=
--   match b with
--   | true => 42
--   | false => true

-- `Prop` as a proof-irrelevant universe.
theorem two_proofs (h1 h2 : 2 + 2 = 4) : h1 = h2 := rfl

-- Σ-types: the second component's type depends on the first's value.
def mySigma : Σ n : Nat, Fin n := ⟨3, ⟨2, by decide⟩⟩
#eval mySigma.fst        -- 3
#eval mySigma.snd.val    -- 2

def mySigma2 : Σ b : Bool, if b then Nat else String :=
  ⟨true, (42 : Nat)⟩
def mySigma3 : Σ b : Bool, if b then Nat else String :=
  ⟨false, "hi"⟩

#eval mySigma2.fst  -- true
#eval mySigma2.snd  -- 42
#eval mySigma3.fst  -- false
#eval mySigma3.snd  -- "hi"

-- (counterexample, expected error: a String alongside `true` whose
-- dependent type is `Nat`)
-- def badSigma : Σ b : Bool, if b then Nat else String :=
--   ⟨true, "oops"⟩

-- (counterexample, expected error: `∃`'s witness cannot be extracted,
-- because `∃` lands in `Prop`)
-- def bad (h : ∃ n : Nat, n > 0) : Nat := h.1

-- Recursors: `Nat.rec` as one Π-typed term.
#check @Nat.rec
-- {motive : Nat → Sort u}
--   → motive Nat.zero
--   → ((n : Nat) → motive n → motive n.succ)
--   → (t : Nat) → motive t

def double (n : Nat) : Nat :=
  Nat.rec 0 (fun _ ih => ih + 2) n

#eval double 5   -- 10

def double' (n : Nat) : Nat :=
  Nat.rec 0 (fun _ ih => dbg_trace s!"double: succ case, ih={ih}, adding 2"; ih + 2) n

#eval double' 5
-- double: succ case, ih=0, adding 2
-- double: succ case, ih=2, adding 2
-- double: succ case, ih=4, adding 2
-- double: succ case, ih=6, adding 2
-- double: succ case, ih=8, adding 2
-- 10

-- The same pattern over a different inductive type, via `List.rec`.
noncomputable def myLength {α : Type} (l : List α) : Nat :=
  List.rec (motive := fun _ => Nat) 0 (fun _ _ tailLen => tailLen + 1) l

#reduce myLength [1, 2, 3]        -- 3
#reduce myLength ([] : List Nat)  -- 0

-- (counterexample, expected error: `Nat.rec`'s two case arguments are
-- positional, and a function in the zero case is a type error)
-- def doubleBad (n : Nat) : Nat :=
--   Nat.rec (fun _ ih => ih + 2) 0 n

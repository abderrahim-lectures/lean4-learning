/-
Code from Chapter 2, Section 2 (Π/Σ-types and the calculus of
constructions) of the book.

The book's *intentional* counterexamples — `badPick`, `badSigma`, `bad`,
and `doubleBad` — are expected type errors (that is their pedagogical
point) and are reproduced as comments below rather than compiled.
-/

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

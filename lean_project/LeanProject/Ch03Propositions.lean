/-
Code from Chapter 3 (Propositions as types, and basic proofs) of the book.
-/
namespace Ch03Propositions

#check (2 + 2 = 4)     -- 2 + 2 = 4 : Prop

example : 2 + 2 = 4 := rfl

theorem two_plus_two : 2 + 2 = 4 := rfl

theorem add_comm_example : 2 + 3 = 3 + 2 := rfl

theorem modus_ponens {P Q : Prop} (hpq : P → Q) (hp : P) : Q :=
  hpq hp

-- And
theorem and_example {P Q : Prop} (hp : P) (hq : Q) : P ∧ Q :=
  ⟨hp, hq⟩

theorem and_left {P Q : Prop} (h : P ∧ Q) : P :=
  h.left

-- Or
theorem or_example {P Q : Prop} (hp : P) : P ∨ Q :=
  Or.inl hp

-- Not, i.e. P → False
-- NOTE: the book's term-mode `fun h => Nat.noConfusion h` does not
-- actually type-check as written (Nat.noConfusion's motive needs to be
-- supplied and doesn't unify automatically here) — a real bug found by
-- the compiler. Fixed with `decide`, since `1 = 2` is a small decidable
-- proposition on `Nat`.
theorem not_example : ¬(1 = 2) := by
  decide

theorem all_nats_ge_zero : ∀ n : Nat, n ≥ 0 :=
  fun n => Nat.zero_le n

theorem exists_even : ∃ n : Nat, n % 2 = 0 :=
  ⟨0, rfl⟩

theorem symm_example {a b : Nat} (h : a = b) : b = a :=
  h.symm

theorem trans_example {a b c : Nat} (h1 : a = b) (h2 : b = c) : a = c :=
  h1.trans h2

theorem congr_example {a b : Nat} (h : a = b) : a + 1 = b + 1 :=
  h ▸ rfl

end Ch03Propositions

/-
Code from Chapter 4 (Tactics) of the book.
-/
namespace Ch04Tactics

theorem two_plus_two : 2 + 2 = 4 := by
  rfl

theorem modus_ponens {P Q : Prop} : (P → Q) → P → Q := by
  intro hpq hp
  exact hpq hp

theorem apply_example {P Q : Prop} (hpq : P → Q) (hp : P) : Q := by
  apply hpq
  exact hp

theorem rw_example (a b : Nat) (h : a = b) : a + 1 = b + 1 := by
  rw [h]

theorem rw_at_example (a b c : Nat) (h1 : a = b) (h2 : a + c = 10) : b + c = 10 := by
  rw [h1] at h2
  exact h2

theorem simp_example (n : Nat) : n + 0 = n := by
  simp

theorem and_example (P Q : Prop) (hp : P) (hq : Q) : P ∧ Q := by
  constructor
  · exact hp
  · exact hq

theorem or_comm_ex {P Q : Prop} (h : P ∨ Q) : Q ∨ P := by
  cases h with
  | inl hp => exact Or.inr hp
  | inr hq => exact Or.inl hq

theorem add_zero_left (n : Nat) : 0 + n = n := by
  induction n with
  | zero => rfl
  | succ k ih =>
    show 0 + (k + 1) = k + 1
    rw [Nat.add_succ, ih]

def isZero (n : Nat) : Prop := n = 0

theorem isZero_zero : isZero 0 := by
  unfold isZero
  -- Goal after unfold: 0 = 0
  rfl

theorem my_add_comm (a b : Nat) : a + b = b + a := by
  induction b with
  | zero =>
    -- Goal: a + 0 = 0 + a
    rw [Nat.add_zero]   -- rewrites `a + 0` to `a`. Goal: a = 0 + a
    rw [Nat.zero_add]    -- rewrites `0 + a` to `a`. Goal: a = a, closed by rw automatically
  | succ k ih =>
    -- ih : a + k = k + a
    -- Goal: a + Nat.succ k = Nat.succ k + a
    rw [Nat.add_succ]     -- a + succ k  ~>  succ (a + k). Goal: succ (a + k) = succ k + a
    rw [ih]                -- use the induction hypothesis: a + k ~> k + a. Goal: succ (k + a) = succ k + a
    rw [Nat.succ_add]      -- succ k + a  ~>  succ (k + a). Goal: succ (k + a) = succ (k + a), closed

-- Chapter 4 exercises
theorem and_comm_tac {P Q : Prop} (h : P ∧ Q) : Q ∧ P := by
  constructor
  · exact h.right
  · exact h.left

theorem nat_mul_zero (n : Nat) : n * 0 = 0 := by
  rfl

theorem modus_ponens_tac {P Q : Prop} (hpq : P → Q) (hp : P) : Q := by
  apply hpq
  exact hp

end Ch04Tactics

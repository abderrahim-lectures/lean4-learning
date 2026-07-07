# Chapter 3: Propositions as types, and basic proofs

[← Ch. 2: Functions & Structures](02-functions-and-structures.md) | [Table of contents](../README.md) | [Ch. 4: Tactics →](04-tactics.md)

---

## `Prop`: the type of statements

Alongside `Type`, Lean has `Prop`, the type of logical propositions. A term
of type `P : Prop` is a **proof** of `P`. This is the **Curry–Howard
correspondence**: propositions are types, and proofs are programs.

```lean
#check (2 + 2 = 4)     -- 2 + 2 = 4 : Prop

example : 2 + 2 = 4 := rfl
```

`rfl` is the proof "both sides compute to the same thing" (**refl**exivity).
`example` states a proposition and immediately supplies a proof (an
anonymous, unnamed `theorem`).

## `theorem` and `lemma`

```lean
theorem two_plus_two : 2 + 2 = 4 := rfl

theorem add_comm_example : 2 + 3 = 3 + 2 := rfl
```

`theorem` and `lemma` are the same thing syntactically; `lemma` is just a
naming convention for "small helper facts."

## Implication is a function type

$P \to Q$ (read "$P$ implies $Q$") is literally a function type: a proof of
$P \to Q$ is a function that turns any proof of $P$ into a proof of $Q$.

```lean
theorem modus_ponens {P Q : Prop} (hpq : P → Q) (hp : P) : Q :=
  hpq hp
```

## And, Or, Not

```lean
-- And
theorem and_example {P Q : Prop} (hp : P) (hq : Q) : P ∧ Q :=
  ⟨hp, hq⟩

theorem and_left {P Q : Prop} (h : P ∧ Q) : P :=
  h.left

-- Or
theorem or_example {P Q : Prop} (hp : P) : P ∨ Q :=
  Or.inl hp

-- Not, i.e. P → False
theorem not_example : ¬(1 = 2) :=
  fun h => Nat.noConfusion h
```

- `∧` (And) is a structure with two fields `left` and `right`; `⟨hp, hq⟩` is
  anonymous-constructor sugar, same as for any structure.
- `∨` (Or) has two constructors, `Or.inl` and `Or.inr` — a proof of `P ∨ Q`
  is either "here's a proof of `P`" or "here's a proof of `Q`".
- `¬P` is notation for `P → False`. To prove a negation, assume `P` holds
  and derive `False`.

## Universal and existential quantifiers

```lean
theorem all_nats_ge_zero : ∀ n : Nat, n ≥ 0 :=
  fun n => Nat.zero_le n

theorem exists_even : ∃ n : Nat, n % 2 = 0 :=
  ⟨0, rfl⟩
```

- `∀ x : α, P x` is again just a (dependent) function type: given any `x`,
  produce a proof of `P x`.
- `∃ x : α, P x` is a structure: a **witness** value plus a proof that the
  witness satisfies `P`.

## Equality reasoning

```lean
theorem symm_example {a b : Nat} (h : a = b) : b = a :=
  h.symm

theorem trans_example {a b c : Nat} (h1 : a = b) (h2 : b = c) : a = c :=
  h1.trans h2

theorem congr_example {a b : Nat} (h : a = b) : a + 1 = b + 1 :=
  h ▸ rfl
```

`▸` ("substitution") rewrites the goal using an equality proof. You will use
its tactic form, `rw`, constantly starting in the next chapter.

## Exercises

1. Prove `theorem and_comm_ex {P Q : Prop} (h : P ∧ Q) : Q ∧ P`.
2. Prove `theorem or_comm_ex {P Q : Prop} (h : P ∨ Q) : Q ∨ P` (hint: use
   `Or.elim` or pattern matching with `match`).
3. Prove `theorem exists_gt_zero : ∃ n : Nat, n > 0`.

## Next

Continue to [Chapter 4: Tactics](04-tactics.md).

---

[← Ch. 2: Functions & Structures](02-functions-and-structures.md) | [Table of contents](../README.md) | [Ch. 4: Tactics →](04-tactics.md)

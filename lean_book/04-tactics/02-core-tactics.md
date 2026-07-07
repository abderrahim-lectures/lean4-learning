## Core tactics

[← Goal state](01-goal-state.md) | [Index](00-index.md) | [Next: Reading a tactic failure →](03-reading-failures.md)

---

### `intro`: introduce a hypothesis or variable

```lean
theorem modus_ponens {P Q : Prop} : (P → Q) → P → Q := by
  intro hpq hp
  exact hpq hp
```

### `exact`: close the goal with an exact term

Used above. If you have a term that proves the goal exactly, `exact` finishes it.

### `apply`: apply a function/lemma, leaving new goals for its arguments

```lean
theorem apply_example {P Q : Prop} (hpq : P → Q) (hp : P) : Q := by
  apply hpq
  exact hp
```

### `rw`: rewrite using an equality

```lean
theorem rw_example (a b : Nat) (h : a = b) : a + 1 = b + 1 := by
  rw [h]
```

`rw [h]` replaces every occurrence of the left-hand side of `h` with its
right-hand side in the goal.

**Mathematical reading.** Each tactic corresponds to a standard proof move.
`intro` discharges an implication/universal by the deduction theorem: to
prove $A \to B$, *assume* $A$ (add $A$ to $\Gamma$) and prove $B$ — the
$\lambda$-abstraction rule. `exact e` supplies a finished term, "this is
precisely our claim." `apply f` is backward chaining: to prove the
conclusion of $f : A_1 \to \cdots \to A_n \to G$, it suffices to prove the
premises $A_1, \ldots, A_n$, which become the new goals — the working
mathematician's "by $f$, it remains to check the hypotheses of $f$." `rw [h]`
with $h : a = b$ is substitution of equals for equals (Leibniz), rewriting
$G$ to $G[b/a]$, justified because $a = b$ makes the two goals equivalent.

---

[← Goal state](01-goal-state.md) | [Index](00-index.md) | [Next: Reading a tactic failure →](03-reading-failures.md)

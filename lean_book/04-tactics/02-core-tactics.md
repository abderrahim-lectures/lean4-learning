## Core tactics

[← Goal state](01-goal-state.md) | [Index](00-index.md) | [Next: Reading a tactic failure →](03-reading-failures.md)

---

### [`intro`](https://lean-lang.org/doc/reference/latest/Tactic-Proofs/Tactic-Reference/): introduce a hypothesis or variable

```lean
theorem modus_ponens {P Q : Prop} : (P → Q) → P → Q := by
  intro hpq hp
  exact hpq hp
```

### [`exact`](https://lean-lang.org/doc/reference/latest/Tactic-Proofs/Tactic-Reference/): close the goal with an exact term

Used above. If you have a term that proves the goal exactly, `exact` finishes it.

### [`apply`](https://lean-lang.org/doc/reference/latest/Tactic-Proofs/Tactic-Reference/): apply a function/lemma, leaving new goals for its arguments

```lean
theorem apply_example {P Q : Prop} (hpq : P → Q) (hp : P) : Q := by
  apply hpq
  exact hp
```

### [`rw`](https://lean-lang.org/doc/reference/latest/Tactic-Proofs/Tactic-Reference/): rewrite using an equality

```lean
theorem rw_example (a b : Nat) (h : a = b) : a + 1 = b + 1 := by
  rw [h]
```

`rw [h]` replaces every occurrence of the left-hand side of `h` with its
right-hand side in the goal.

### `rw [...] at h`: rewrite a hypothesis instead of the goal

```lean
theorem rw_at_example (a b c : Nat) (h1 : a = b) (h2 : a + c = 10) : b + c = 10 := by
  rw [h1] at h2
  -- h2 is now : b + c = 10, exactly the goal
  exact h2
```

Every `rw` you've seen so far rewrites the *goal*. Adding `at h` instead
rewrites a *hypothesis* `h`, in place, using the same left-to-right
substitution rule. This is just as common as rewriting the goal itself.
Chapter 9's ring proofs, for instance, use `rw [...] at h1`/`at h2`
repeatedly to reshape a hypothesis into the exact form needed before
citing it with `exact`. Read `rw [h1] at h2` as "wherever `h1`'s left side
appears inside `h2`, replace it with `h1`'s right side". The direction
and substitution rule are identical to ordinary `rw`. Only the *target*
(a named hypothesis, not the goal) is different.

**Mathematical reading.** Each tactic corresponds to a standard proof move.
`intro` discharges an implication/universal by the deduction theorem: to
prove $A \to B$, *assume* $A$ as a new hypothesis and prove $B$. This is the
$\lambda$-abstraction rule. `exact e` supplies a finished term: "this is
precisely our claim." `apply f` is backward chaining: to prove the
conclusion of $f : A_1 \to \cdots \to A_n \to G$, it suffices to prove the
premises $A_1, \ldots, A_n$, which become the new goals. This is the working
mathematician's "by $f$, it remains to check the hypotheses of $f$." `rw [h]`
with $h : a = b$ is substitution of equals for equals (Leibniz): every
occurrence of $a$ in the goal is replaced by $b$. This is justified because $a = b$
makes the old and new goals equivalent.

> Read more: "deduction theorem" and "$\lambda$-abstraction rule" are the
> $\Rightarrow$-intro rule from natural deduction and its Curry–Howard
> reading as a Lean `fun`, respectively —
> [Appendix B §0](../15-lambda-calculus/00-standard-logic.md) states the
> rule itself; [Appendix B §3](../15-lambda-calculus/03-simply-typed-lambda-calculus.md)
> gives the typed λ-calculus it corresponds to.

---

[← Goal state](01-goal-state.md) | [Index](00-index.md) | [Next: Reading a tactic failure →](03-reading-failures.md)

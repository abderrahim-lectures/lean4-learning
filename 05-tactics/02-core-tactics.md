## Core tactics

[← Goal state](01-goal-state.md) | [Index](00-index.md) | [Next: Reading a tactic failure →](03-reading-failures.md)

---

`fun hpq hp => hpq hp` proves $P\to Q\to Q$ (given a function $P\to Q$
and a proof of $P$, apply the one to the other) in one shot, because the
whole term was already obvious before writing it. Most goals are not like
that: the term to write depends on the goal currently open, which itself
changes as pieces of it get filled in. Writing a proof incrementally,
goal by goal, is exactly what tactics do; term-mode is the destination,
tactic-mode is how to get there when the destination isn't visible yet.

```lean
theorem modus_ponens {P Q : Prop} : (P → Q) → P → Q := by
  intro hpq hp
  exact hpq hp
```

The goal opens as `(P → Q) → P → Q`, a function type, matching exactly
the shape `fun hpq hp => ...` above would need to produce. [`intro`](https://lean-lang.org/doc/reference/latest/Tactic-Proofs/Tactic-Reference/)
peels off one $\lambda$-binder at a time: `intro hpq` turns the goal
`(P → Q) → P → Q` into the smaller goal `P → Q` with `hpq : P → Q` now a
hypothesis in context, and `intro hp` repeats this once more. What is
left, the goal `Q` with `hpq : P → Q` and `hp : P` in scope, is exactly
what a finished term needs to supply. [`exact`](https://lean-lang.org/doc/reference/latest/Tactic-Proofs/Tactic-Reference/) closes it by naming that
term directly: `hpq hp` has type `Q`, matching the goal exactly, so the
proof is done. Two tactics reconstruct, piece by piece, the same term
`fun hpq hp => hpq hp` written in one line above.

`intro`/`exact` alone force writing every intermediate term by hand, even
when a hypothesis already available is *itself* a function that gets to
the goal.

```lean
theorem apply_example {P Q : Prop} (hpq : P → Q) (hp : P) : Q := by
  apply hpq
  exact hp
```

The goal is `Q`, and `hpq : P → Q` is already in context. Writing
`exact hpq hp` closes it in one step, but when the argument itself isn't
obvious yet, [`apply`](https://lean-lang.org/doc/reference/latest/Tactic-Proofs/Tactic-Reference/) works backward from the goal instead:
`apply hpq` matches the goal `Q` against `hpq`'s conclusion, leaving a new
goal for exactly the piece still missing, `P`, `hpq`'s premise. `exact hp`
closes that. For a hypothesis with several premises, `f : A₁ → ⋯ → Aₙ → G`,
`apply f` against goal `G` leaves `n` new goals, one per premise, the
working-mathematician move "by `f`, it remains to check the hypotheses of
`f`."

None of `intro`/`exact`/`apply` touch a hypothesis that is already known
to equal something else, only the goal.

```lean
theorem rw_example (a b : Nat) (h : a = b) : a + 1 = b + 1 := by
  rw [h]
```

The goal `a + 1 = b + 1` and the hypothesis `h : a = b` differ by exactly
one substitution. [`rw`](https://lean-lang.org/doc/reference/latest/Tactic-Proofs/Tactic-Reference/) performs it: `rw [h]` replaces every occurrence
of `h`'s left-hand side with its right-hand side in the goal, turning
`a + 1 = b + 1` into `b + 1 = b + 1`, closed automatically by `rfl` once
both sides are syntactically identical.

The substitution `rw` performs is not limited to the goal.

```lean
theorem rw_at_example (a b c : Nat) (h1 : a = b) (h2 : a + c = 10) : b + c = 10 := by
  rw [h1] at h2
  -- h2 is now : b + c = 10, exactly the goal
  exact h2
```

The goal here, `b + c = 10`, already matches a hypothesis, `h2`, up to
the same substitution `h1` performs on the goal in the previous example.
`rw [h1] at h2` runs the identical left-to-right rewrite, but targets the
named hypothesis `h2` instead of the goal: every occurrence of `a` inside
`h2` becomes `b`, turning `h2 : a + c = 10` into `h2 : b + c = 10`,
which `exact h2` then closes directly. The direction and substitution
rule are unchanged from ordinary `rw`; only the target moves from goal to
hypothesis. The ring proofs of Chapter 10 use `rw [...] at h1`/`at h2`
repeatedly for exactly this reason, to reshape a hypothesis into the form
a later `exact` needs.

**Mathematical reading.** Each tactic corresponds to a standard proof
move. `intro` discharges an implication/universal by the deduction
theorem, to prove $A \to B$, *assume* $A$ as a new hypothesis and prove
$B$. This is the $\lambda$-abstraction rule. `exact e` supplies a
finished term, "this is precisely our claim." `apply f` is backward
chaining. `rw [h]` with $h : a = b$ is substitution of equals for equals
(Leibniz); every occurrence of $a$ in the goal is replaced by $b$,
justified because $a = b$ makes the old and new goals equivalent.

> Read more. "Deduction theorem" and "$\lambda$-abstraction rule" are two
> names for the same rule. "Deduction theorem" names the $\Rightarrow$-intro
> rule from natural deduction, stated in
> [Chapter 4, Section 2](../04-propositions-and-proofs/02-logic-recap.md).
> "$\lambda$-abstraction rule" names the Curry–Howard reading of that same rule
> as a Lean `fun`, part of the typed $\lambda$-calculus formalized in
> [Chapter 6, Section 3](../06-rigor-check/03-typing-rules-and-safety.md).

---

[← Goal state](01-goal-state.md) | [Index](00-index.md) | [Next: Reading a tactic failure →](03-reading-failures.md)

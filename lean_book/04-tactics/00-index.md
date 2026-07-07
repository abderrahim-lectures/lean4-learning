# Chapter 4: Tactics — the toolbox for proving things

[← Ch. 3: Propositions & Proofs](../03-propositions-and-proofs/00-index.md) | [Table of contents](../README.md) | [Ch. 5: Rigor Check →](../05-rigor-check/00-index.md)

---

Writing proof *terms* directly (as in Chapter 3) gets unwieldy fast. Instead,
Lean lets you enter **tactic mode** with `by`, where you manipulate a "goal"
step by step, similar to how you'd write a proof on paper. This chapter's
real subject is not the list of tactics below — it's **how to work a goal
you don't already know the proof of**, since that is the skill the rest of
the book exercises. The tactic reference is secondary; read it once, then
come back to it as needed.

## Sections

1. [The goal state, and a worked strategy session](01-goal-state.md)
2. [Core tactics](02-core-tactics.md)
3. [Reading a tactic failure, and `sorry`](03-reading-failures.md)
4. [More tactics: `simp`, `constructor`, `cases`, `induction`, `unfold`](04-more-tactics.md)
5. [Worked example: proving `Nat.add` is commutative from scratch](05-worked-example.md)
6. [Exercises](06-exercises.md)

---

[← Ch. 3: Propositions & Proofs](../03-propositions-and-proofs/00-index.md) | [Table of contents](../README.md) | [Ch. 5: Rigor Check →](../05-rigor-check/00-index.md)

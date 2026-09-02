# Chapter 5: Tactics — the toolbox for proving things

[← Ch. 4: Propositions & Proofs](../04-propositions-and-proofs/00-index.md) | [Table of contents](../README.md) | [Ch. 6: Rigor Check →](../06-rigor-check/00-index.md)

---

## Learning objectives

- Read a Lean goal state.
- Use `intro`/`exact`/`apply`/`rw` to work a goal one step at a time.
- Diagnose a failed tactic from its error message.
- Use `induction`/`cases`/`constructor`/`unfold` on inductively-defined data.
- Carry out a full inductive proof (commutativity of `Nat.add`) from scratch.

## What forces tactic mode

Writing proof *terms* directly (as in Chapter 4) quickly becomes hard to
manage as a proof grows. The alternative is **tactic mode**, entered
with `by`, in which a "goal" is worked step by step, much as one would
write a proof on paper. The real subject of this chapter is not the list
of tactics below, but **how to work a goal whose proof is not yet
known**, since that is the skill the rest of the book practices. The
tactic reference is secondary, read it once, then return to it as
needed.

The anatomy of a goal, and the habit of reading every hypothesis before
trying anything, comes first ([Section 1](01-goal-state.md)). Four
tactics carry the bulk of any proof, `intro`, `exact`, `apply`, `rw`,
each mapped to the ordinary inference rule it realizes
([Section 2](02-core-tactics.md)). When a tactic fails, Lean does not
whisper, it points; reading an error message as a debugging trace, and
telling apart a `sorry` that is a placeholder to be filled from one
flagging that something deeper must change, comes next
([Section 3](03-reading-failures.md)). Reasoning by cases or by
induction on data that is defined recursively needs its own tactics,
`cases`, `induction`, `constructor`, `unfold`, the tools that open up
inductively-defined data ([Section 4](04-more-tactics.md)). Assembling
all of the above into a real inductive proof from scratch, with no
automation to hide behind, commutativity of `Nat.add`, built one tactic
at a time, closes the loop ([Section 5](05-worked-example.md)).

## Sections

1. [The goal state, and a worked strategy session](01-goal-state.md)
2. [Core tactics](02-core-tactics.md)
3. [Reading a tactic failure, and `sorry`](03-reading-failures.md)
4. [More tactics: `constructor`, `cases`, `induction`, `unfold`, `simp`](04-more-tactics.md)
5. [Worked example: proving `Nat.add` is commutative from scratch](05-worked-example.md)
6. [Exercises](06-exercises.md)

---

[← Ch. 4: Propositions & Proofs](../04-propositions-and-proofs/00-index.md) | [Table of contents](../README.md) | [Ch. 6: Rigor Check →](../06-rigor-check/00-index.md)

# Chapter 5: Tactics — the toolbox for proving things

[← Ch. 4: Propositions & Proofs](../04-propositions-and-proofs/00-index.md) | [Table of contents](../README.md) | [Ch. 6: Rigor Check →](../06-rigor-check/00-index.md)

---

## Learning objectives

- Read a Lean goal state.
- Use `intro`/`exact`/`apply`/`rw` to work a goal one step at a time.
- Diagnose a failed tactic from its error message.
- Use `induction`/`cases`/`constructor`/`unfold` on inductively-defined data.
- Carry out a full inductive proof (commutativity of `Nat.add`) from scratch.

## The story of this chapter

Writing proof *terms* directly (as in Chapter 4) quickly becomes hard to manage.
Instead, Lean provides **tactic mode**, entered with `by`, in which a "goal"
is worked step by step, much as one would write a proof on paper. The
real subject of this chapter is not the list of tactics below, but **how to work a goal
whose proof is not yet known**, since that is the skill the rest of
the book practices. The tactic reference is secondary, read it once, then
return to it as needed. Each section below builds that skill one question at a
time.

1. **What does a Lean goal state look like, and what is the first strategy
   when no proof is in hand?** ([Section 1](01-goal-state.md)) The anatomy
   of a goal, and the habit of reading every hypothesis before trying anything.
2. **Which four tactics does every proof reduce to, and what does each one
   actually do to a goal?** ([Section 2](02-core-tactics.md)) `intro`,
   `exact`, `apply`, `rw`, each mapped to the ordinary inference rule it
   realizes.
3. **When a tactic fails, Lean does not whisper. It points.** ([Section 3](03-reading-failures.md))
   How to read an error message as a debugging trace, and when `sorry` is a
   placeholder to be filled versus a flag that something deeper must change.
4. **How does one reason by cases or by induction on data that is defined
   recursively?** ([Section 4](04-more-tactics.md)) `cases`, `induction`,
   `constructor`, `unfold`, the tactics that open up inductively-defined
   data.
5. **Can all of the above be assembled into a real inductive proof from
   scratch, one with no automation to hide behind?** ([Section 5](05-worked-example.md))
   Commutativity of `Nat.add`, built one tactic at a time.

## Sections

1. [The goal state, and a worked strategy session](01-goal-state.md)
2. [Core tactics](02-core-tactics.md)
3. [Reading a tactic failure, and `sorry`](03-reading-failures.md)
4. [More tactics: `simp`, `constructor`, `cases`, `induction`, `unfold`](04-more-tactics.md)
5. [Worked example: proving `Nat.add` is commutative from scratch](05-worked-example.md)
6. [Exercises](06-exercises.md)

---

[← Ch. 4: Propositions & Proofs](../04-propositions-and-proofs/00-index.md) | [Table of contents](../README.md) | [Ch. 6: Rigor Check →](../06-rigor-check/00-index.md)

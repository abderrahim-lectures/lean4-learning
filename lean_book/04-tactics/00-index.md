# Chapter 4: Tactics — the toolbox for proving things

[← Ch. 3: Propositions & Proofs](../03-propositions-and-proofs/00-index.md) | [Table of contents](../README.md) | [Ch. 5: Rigor Check →](../05-rigor-check/00-index.md)

---

Writing proof *terms* directly (as in Chapter 3) quickly becomes hard to manage. Instead,
Lean provides **tactic mode**, entered with `by`, in which a "goal" is
worked step by step, much as one would write a proof on paper. This chapter's
real subject is not the list of tactics below, but **how to work a goal
whose proof is not yet known**, since that is the skill the rest of
the book practices. The tactic reference is secondary: read it once, then
return to it as needed. (For links to the official docs for
every tactic named in this chapter, see the
[tactic and library reference](../tactic-and-library-reference.md).)

**Learning objectives.** By the end of this chapter, read a Lean goal
state, use `intro`/`exact`/`apply`/`rw` to work a goal one step at a time,
diagnose a failed tactic from its error message, use `induction`/`cases`/
`constructor`/`unfold` on inductively-defined data, and carry out a full
inductive proof (`Nat.add`'s commutativity) from scratch.

## Sections

1. [The goal state, and a worked strategy session](01-goal-state.md)
2. [Core tactics](02-core-tactics.md)
3. [Reading a tactic failure, and `sorry`](03-reading-failures.md)
4. [More tactics: `simp`, `constructor`, `cases`, `induction`, `unfold`](04-more-tactics.md)
5. [Worked example: proving `Nat.add` is commutative from scratch](05-worked-example.md)
6. [Exercises](06-exercises.md)

---

[← Ch. 3: Propositions & Proofs](../03-propositions-and-proofs/00-index.md) | [Table of contents](../README.md) | [Ch. 5: Rigor Check →](../05-rigor-check/00-index.md)

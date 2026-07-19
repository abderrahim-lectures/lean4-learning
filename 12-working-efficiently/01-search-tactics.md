## Search tactics: letting Lean find the lemma or the proof

[← Index](00-index.md) | [Next: Decision procedures →](02-decision-procedures.md)

---

Throughout this book, a lemma name has typically been hunted for by hand.
In practice, searching by memory or by grep is rarely necessary. Two tactics
perform this search automatically:

- **[`exact?`](https://lean-lang.org/doc/reference/latest/Tactic-Proofs/Tactic-Reference/)** — searches the whole environment (core Lean, plus anything
  else imported) for a term that closes the *current goal
  exactly*. It either fails or suggests a working
  `exact ...` line that can be pasted in directly. It is best used as soon as
  a fact is suspected to already exist somewhere — for instance,
  after simplifying a ring goal down to something that *looks* like a
  named lemma whose name cannot be recalled.
- **[`apply?`](https://lean-lang.org/doc/reference/latest/Tactic-Proofs/Tactic-Reference/)** — like `exact?`, but for cases where the goal would be
  closed by `apply`ing something that leaves further subgoals, not a
  single exact match.

Both are search tools, not proof techniques. The proof they find is a
normal term, exactly like one that could have been written by hand. It is
completely standard practice to try out a proof with `exact?`/`apply?`,
inspect what it suggests, and paste in the concrete result, rather than
leaving the search tactic itself in the finished proof. They are slower to
re-run, and in a growing file, their result can silently change if the
environment changes.

```lean
example (a b : Nat) (h : a = b) : b = a := by
  exact?
  -- reports a working closing term (verified on this book's toolchain to be
  -- `exact Nat.add_right_cancel (congrFun (congrArg HAdd.hAdd (id (Eq.symm h))) a)`,
  -- not the shorter `h.symm` a human would write — see below)
```

**Mathematical reading.** This is the formal version of "this is standard —
cite the relevant lemma." The goal $b = a$ under hypothesis $h : a = b$ is
closed by symmetry of equality, $h^{\mathrm{sym}}$, and that is what a
human proof would cite. `exact?` performs a library search: it scans the
whole collection of proved theorems for a term that matches the goal type,
and reports *a* citation that works. But its search order does not always
surface the shortest or most idiomatic one. The verified output above
shows this directly: a correct but needlessly roundabout term, found
before the simpler `Eq.symm` was. It automates *finding a* closing term, not necessarily the
most readable one; simplifying the reported term by hand (here, to
`h.symm`) afterward is still worth doing before the proof is considered
finished.

---

[← Index](00-index.md) | [Next: Decision procedures →](02-decision-procedures.md)

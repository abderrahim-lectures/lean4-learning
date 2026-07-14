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
  -- suggests: exact h.symm
```

**Mathematical reading.** This is the formal version of "this is standard —
cite the relevant lemma." The goal $b = a$ under hypothesis $h : a = b$ is
closed by symmetry of equality, $h^{\mathrm{sym}}$. `exact?` performs a
library search: it scans the whole collection of proved theorems for a term
that matches the goal type, and reports the citation, here $\mathrm{Eq.symm}$.
It automates the citation step of a proof, not the mathematics itself. The
term it returns is the same one a human would cite.

---

[← Index](00-index.md) | [Next: Decision procedures →](02-decision-procedures.md)

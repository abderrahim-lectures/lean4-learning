## Search tactics: let Lean find the lemma or the proof

[← Index](00-index.md) | [Next: Decision procedures →](02-decision-procedures.md)

---

Throughout this book, you have imagined hunting for a lemma name by hand.
In practice, you rarely need to search by memory or by grep. Two tactics
do this search for you:

- **`exact?`** — searches the whole environment (core Lean, plus anything
  else you have imported) for a term that closes the *current goal
  exactly*. Run it, and it either fails, or suggests a working
  `exact ...` line you can paste in. Use it as soon as you suspect "this
  exact fact must already exist somewhere." For example, this happens
  after you simplify a ring goal down to something that *looks* like a
  named lemma, but you can't recall the name.
- **`apply?`** — like `exact?`, but for cases where the goal would be
  closed by `apply`ing something that leaves further subgoals, not a
  single exact match.

Both are search tools, not proof techniques. The proof they find is a
normal term, exactly like one you could have written by hand. It is
completely standard practice to try out a proof with `exact?`/`apply?`,
look at what it suggests, and paste in the concrete result, rather than
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

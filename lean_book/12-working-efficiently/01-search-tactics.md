## Search tactics: let Lean find the lemma or the proof

[← Index](00-index.md) | [Next: Decision procedures →](02-decision-procedures.md)

---

You've been asked, throughout this book, to imagine hunting for a lemma
name. In practice you rarely do this by memory or grep. Two tactics
automate it:

- **`exact?`** — searches the whole environment (core Lean, and anything
  else imported) for a term that closes the *current goal exactly*. Run it,
  and it either fails, or suggests a working `exact ...` line you can paste
  in. Use it the moment you suspect "this exact fact must already exist
  somewhere" — e.g. after simplifying a ring goal down to something that
  *looks* like a named lemma but you can't recall the name.
- **`apply?`** — like `exact?` but for when the goal would be closed by
  `apply`ing something that leaves further subgoals, not a single exact
  match.

Both are search tools, not proof techniques — the proof they find is a
normal term, exactly like one you could have written by hand. It is
completely standard practice to prototype a proof with `exact?`/`apply?`,
inspect what it suggests, and paste in the concrete result rather than
leaving the search tactic itself in the finished proof (they're slower to
re-elaborate and, in a growing file, their result can silently change if the
environment changes).

```lean
example (a b : Nat) (h : a = b) : b = a := by
  exact?
  -- suggests: exact h.symm
```

**Mathematical reading.** This is the formal analogue of "this is standard —
cite the relevant lemma." The goal $b = a$ under hypothesis $h : a = b$ is
closed by symmetry of equality, $h^{\mathrm{sym}}$; `exact?` performs library
search — scanning the ambient collection of proved theorems for a term
inhabiting the goal type — and reports the citation, here $\mathrm{Eq.symm}$.
It automates the bibliographic step of a proof, not the mathematics: the term
it returns is the same one a human would cite.

---

[← Index](00-index.md) | [Next: Decision procedures →](02-decision-procedures.md)

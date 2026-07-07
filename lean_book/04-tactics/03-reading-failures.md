## Reading a tactic failure

[← Core tactics](02-core-tactics.md) | [Index](00-index.md) | [Next: More tactics →](04-more-tactics.md)

---

Every tactic either makes progress or produces an error, and the error
message is almost always telling you exactly what to do next — treat it as
a diagnostic, not a dead end.

- `rw [h]` where `h : a = b` but the goal doesn't literally contain `a`
  fails with **"motive is not type correct"** or "did not find instance of
  the pattern" — meaning: the exact syntactic term `a` you're rewriting
  doesn't occur in the goal as written. Fix: `#check` (or hover in the
  editor) the goal's actual statement — it's common for a definition to be
  unfolded differently than you expect, so the term you want to rewrite is
  hiding behind a `def` that needs `unfold` or `show` first.
- `exact e` where `e`'s type doesn't match the goal fails with a **type
  mismatch**, printing both the expected and the actual type side by side.
  Read the diff between them; it almost always identifies one wrong
  argument or a missing `.symm`.
- `apply f` where `f`'s conclusion doesn't unify with the goal fails
  similarly, but *before* investing effort in `apply`, use `#check f` to see
  its full type — this tells you exactly what subgoals `apply` would leave,
  before you commit to the tactic.
- A tactic that produces **no error but doesn't close the goal** is not a
  failure — check the resulting goal state (in the editor, or with
  `sorry` in place of the rest of the proof, which type-checks with a
  warning and lets you inspect exactly what's left).

`sorry` deserves a special mention: it is a placeholder that closes any
goal instantly but marks the theorem as unproved (Lean prints a warning,
and any downstream proof depending on it inherits the taint). Use it
constantly while exploring — write the skeleton of a multi-step proof with
`sorry` at each unfinished branch, check that the overall *shape* type-checks,
then fill in branches one at a time. This is normal practice, not a hack.

---

[← Core tactics](02-core-tactics.md) | [Index](00-index.md) | [Next: More tactics →](04-more-tactics.md)

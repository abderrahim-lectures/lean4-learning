## Reading a tactic failure

[← Core tactics](02-core-tactics.md) | [Index](00-index.md) | [Next: More tactics →](04-more-tactics.md)

---

Every tactic either makes progress or produces an error, and the error
message is almost always telling you exactly what to do next. Treat it as
a diagnostic, not a dead end.

- [`rw [h]`](https://lean-lang.org/doc/reference/latest/Tactic-Proofs/Tactic-Reference/) where `h : a = b` but the goal doesn't literally contain `a`
  fails with **"motive is not type correct"** or "did not find instance of
  the pattern". This means the exact syntactic term `a` you're rewriting
  doesn't occur in the goal as written. Fix: use `#check` (or hover in the
  editor) on the goal's actual statement. It's common for a definition to be
  unfolded differently than you expect, so the term you want to rewrite is
  hiding behind a `def` that needs [`unfold`](https://lean-lang.org/doc/reference/latest/Tactic-Proofs/Tactic-Reference/) or [`show`](https://lean-lang.org/doc/reference/latest/Tactic-Proofs/Tactic-Reference/) first.
- [`exact e`](https://lean-lang.org/doc/reference/latest/Tactic-Proofs/Tactic-Reference/) where `e`'s type doesn't match the goal fails with a **type
  mismatch**, printing both the expected and the actual type side by side.
  Read the difference between them; it almost always points to one wrong
  argument or a missing `.symm`.
- [`apply f`](https://lean-lang.org/doc/reference/latest/Tactic-Proofs/Tactic-Reference/) where `f`'s conclusion doesn't unify with the goal fails in a
  similar way, but *before* spending effort on `apply`, use `#check f` to see
  its full type. This tells you exactly what subgoals `apply` would leave,
  before you commit to the tactic.
- A tactic that produces **no error but doesn't close the goal** is not a
  failure. Check the resulting goal state (in the editor, or with
  [`sorry`](https://lean-lang.org/doc/reference/latest/Tactic-Proofs/Tactic-Reference/) in place of the rest of the proof, which type-checks with a
  warning and lets you inspect exactly what's left).

`sorry` deserves a special mention: it is a placeholder that closes any
goal instantly but marks the theorem as unproved. (Lean prints a warning,
and any downstream proof depending on it inherits this unproved status.) Use it
constantly while exploring. Write the skeleton of a multi-step proof with
`sorry` at each unfinished branch, check that the overall *shape* type-checks,
then fill in the branches one at a time. This is normal practice, not a hack.

---

[← Core tactics](02-core-tactics.md) | [Index](00-index.md) | [Next: More tactics →](04-more-tactics.md)

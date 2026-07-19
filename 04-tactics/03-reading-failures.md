## Reading a tactic failure

[← Core tactics](02-core-tactics.md) | [Index](00-index.md) | [Next: More tactics →](04-more-tactics.md)

---

Every tactic either makes progress or produces an error, and the error
message is almost always telling you exactly what to do next. Treat it as
a diagnostic, not a dead end.

- [`rw [h]`](https://lean-lang.org/doc/reference/latest/Tactic-Proofs/Tactic-Reference/) where `h : a = b` but the goal does not literally contain `a`
  fails with **"motive is not type correct"** or "did not find instance of
  the pattern." This means the exact syntactic term `a` being rewritten
  does not occur in the goal as written. Fix: use `#check` (or hover in the
  editor) on the goal's actual statement. It is common for a definition to be
  unfolded differently than expected, so the term to be rewritten is
  hiding behind a `def` that needs [`unfold`](https://lean-lang.org/doc/reference/latest/Tactic-Proofs/Tactic-Reference/) or [`show`](https://lean-lang.org/doc/reference/latest/Tactic-Proofs/Tactic-Reference/) first.
- [`exact e`](https://lean-lang.org/doc/reference/latest/Tactic-Proofs/Tactic-Reference/) where `e`'s type does not match the goal fails with a **type
  mismatch**, printing both the expected and the actual type side by side.
  The difference between them almost always points to one wrong
  argument or a missing `.symm`.
- [`apply f`](https://lean-lang.org/doc/reference/latest/Tactic-Proofs/Tactic-Reference/) where `f`'s conclusion does not unify with the goal fails in a
  similar way, but *before* spending effort on `apply`, `#check f` shows
  its full type. This reveals exactly what subgoals `apply` would leave,
  before committing to the tactic.
- A tactic that produces **no error but does not close the goal** is not a
  failure. The resulting goal state should be checked (in the editor, or with
  [`sorry`](https://lean-lang.org/doc/reference/latest/Tactic-Proofs/Tactic-Reference/) in place of the rest of the proof, which type-checks with a
  warning and permits inspection of exactly what remains).

`sorry` deserves a special mention: it is a placeholder that closes any
goal instantly but marks the theorem as unproved. (Lean prints a warning,
and any downstream proof depending on it inherits this unproved status.) It should be used
constantly while exploring. Writing the skeleton of a multi-step proof with
`sorry` at each unfinished branch, checking that the overall *shape* type-checks,
and then filling in the branches one at a time, is normal practice, not a hack.

---

[← Core tactics](02-core-tactics.md) | [Index](00-index.md) | [Next: More tactics →](04-more-tactics.md)

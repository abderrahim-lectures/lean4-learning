## `simp`, now that you understand what it replaces

[← Decision procedures](02-decision-procedures.md) | [Index](00-index.md) | [Next: Term mode vs tactic mode →](04-term-vs-tactic-mode.md)

---

Chapter 4 asked you to avoid `simp` while learning, so that every step
stayed traceable. Once you understand *why* a family of rewrites works
(e.g. "additive identity/inverse cancellation," as in Chapter 9), `simp` is
the efficient way to apply a whole *battery* of such known-safe rewrites at
once, rather than spelling out each one:

```lean
-- Chapter 9 style (explicit, for learning):
theorem ex1 (n : Nat) : n + 0 = n := by
  exact Nat.add_zero n

-- Once the fact class is understood, in your own later proofs:
theorem ex2 (n : Nat) : n + 0 = n := by
  simp
```

A good discipline: the *first* time you meet a new kind of cancellation or
identity simplification, do it by hand with named lemmas (as this book
does throughout). After that, `simp` (optionally `simp [specific_lemma]` to
scope it, or `simp only [...]` to restrict exactly which lemmas fire) is the
appropriate everyday tool. Using `simp` from the start is how people end up
with proofs that compile but that nobody — including their author, a week
later — can explain.

**Mathematical reading.** `simp` is *normalization by rewriting*: it treats a
designated set of equations $\{\ell_i = r_i\}$ (the simp set) as a
left-to-right rewriting system and drives the goal to a normal form,
discharging it when both sides normalize to the same term. Both proofs of
$n + 0 = n$ invoke the same fact $n + 0 = n$ (the right-unit law for $+$);
the explicit version cites it by name, `simp` finds it in the rewrite system.
This is the algebraist's everyday move of "simplify using the obvious
identities" — sound exactly when the rewrite rules are valid equalities and
confluent enough to yield canonical forms.

---

[← Decision procedures](02-decision-procedures.md) | [Index](00-index.md) | [Next: Term mode vs tactic mode →](04-term-vs-tactic-mode.md)

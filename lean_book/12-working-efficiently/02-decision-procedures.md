## Decision procedures: `decide`, `omega`, `norm_num`

[← Search tactics](01-search-tactics.md) | [Index](00-index.md) | [Next: simp →](03-simp.md)

---

For goals that are *decidable* — where "true or false" can be settled by a
terminating algorithm rather than a hand-built argument — Lean has tactics
that just run that algorithm:

- **`decide`** — evaluates a `Decidable` proposition to `true`/`false`
  directly. Good for small, closed (no free variables) propositions, e.g.
  `(7 : Nat) ∣ 21` or `¬ (3 = 5)`. Do not reach for `decide` on propositions
  with free variables or unbounded search — it can time out or, worse,
  produce a correct but useless proof term that reveals nothing.
- **`omega`** — a decision procedure for linear arithmetic over `Nat`/`Int`
  (goals built from `+`, subtraction, `≤`, `<`, `=`, and multiplication by
  literals). If your goal is "some linear inequality/equality about
  integers," reach for `omega` before hand-deriving it — this is exactly
  the class of fact that a decision procedure handles better than a
  bespoke `rw` chain, and hand-deriving it teaches you nothing `omega`'s
  existence doesn't already convey.
- **`norm_num`** — normalizes and evaluates numerical expressions
  (arithmetic on concrete numerals, including some with `+`, `*`, `^`,
  `≤` on literals).

The judgment call: **use a decision procedure whenever the goal falls
entirely inside its decidable fragment; use explicit `rw`/`have` reasoning
whenever the goal is about a *general*, unspecified structure** (like an
arbitrary `Group G` or `Ring R`) where no decision procedure applies because
there's no concrete computation to run — only axioms to combine. Chapters 6
and 8's group/ring theorems are all of the second kind, which is exactly why
they needed hand-built proofs rather than `omega`.

**Mathematical reading.** A proposition $P$ is `Decidable` when there is an
algorithm computing its truth value — categorically, a map $P \to \{\top,
\bot\}$ with the two fibers being "proof of $P$" and "proof of $\neg P$" —
so `decide` is the constructive statement "$P \vee \neg P$ holds *and* we can
tell which," available precisely on the decidable fragment (closed numeric
claims like $7 \mid 21$). `omega` decides *Presburger arithmetic*, the
first-order theory of $(\mathbb{Z}, +, <)$, which is famously decidable; and
`norm_num` evaluates concrete numerals. These apply only to statements with
no free structure to be filled in — a theorem about an arbitrary group has no
finite truth-table to compute, which is why it must be *proved* from the
axioms rather than *decided*.

---

[← Search tactics](01-search-tactics.md) | [Index](00-index.md) | [Next: simp →](03-simp.md)

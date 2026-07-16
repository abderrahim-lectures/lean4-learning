## Decision procedures: [`decide`](https://lean-lang.org/doc/reference/latest/Tactic-Proofs/Tactic-Reference/), [`omega`](https://lean-lang.org/doc/reference/latest/Tactic-Proofs/Tactic-Reference/), [`norm_num`](https://lean-lang.org/doc/reference/latest/Tactic-Proofs/Tactic-Reference/)

[← Search tactics](01-search-tactics.md) | [Index](00-index.md) | [Next: simp →](03-simp.md)

---

For goals that are *decidable* — where "true or false" can be settled by a
terminating algorithm instead of a hand-built argument — Lean has tactics
that just run that algorithm:

- **`decide`** — evaluates a `Decidable` proposition to `true`/`false`
  directly. It works well for small, closed (no free variables)
  propositions, for example `(7 : Nat) ∣ 21` or `¬ (3 = 5)`. `decide` should
  not be used on propositions with free variables or unbounded search: it can
  time out, or worse, produce a correct but useless proof term that
  reveals nothing.
- **`omega`** — a decision procedure for *linear* arithmetic over `Nat`/`Int`
  (goals built from `+`, subtraction, `≤`, `<`, `=`, and multiplication by
  *literal constants* only — `omega` handles `3 * n` fine, but not `n * m`
  for two unknown variables `n`, `m`; multiplying two unknown variables
  together falls outside what it can decide). For a goal that is "some
  linear inequality or equality about integers," `omega` should be
  reached for before deriving the fact by hand. This is exactly the kind of fact a decision
  procedure handles better than a custom [`rw`](https://lean-lang.org/doc/reference/latest/Tactic-Proofs/Tactic-Reference/) chain, and a hand-derived
  proof teaches nothing that `omega`'s existence does not already establish.
- **`norm_num`** — normalizes and evaluates numerical expressions
  (arithmetic on concrete numerals, including some with `+`, `*`, `^`,
  `≤` on literals).

Here is the judgment call: **use a decision procedure whenever the goal
falls entirely inside its decidable fragment; use explicit `rw`/`have`
reasoning whenever the goal is about a *general*, unspecified structure**
(like an arbitrary `Group G` or `Ring R`). No decision procedure applies
there, because there is no concrete computation to run, only axioms to
combine. Chapters 7 and 9's group/ring theorems are all of this second
kind, which is exactly why they needed hand-built proofs instead of
`omega`.

**Mathematical reading.** A proposition $P$ is `Decidable` when there is an
algorithm that computes its truth value. In categorical terms, this is a
map $P \to \{\top, \bot\}$ whose two preimages are "proof of $P$" and
"proof of $\neg P$." So `decide` is the constructive statement "$P \vee
\neg P$ holds *and* we can tell which one," available exactly on the
decidable fragment (closed numeric claims like $7 \mid 21$). `omega`
decides *Presburger arithmetic*, the first-order theory of $(\mathbb{Z},
+, <)$, which is famously decidable, and `norm_num` evaluates concrete
numerals. These apply only to statements with no free structure left to
fill in. A theorem about an arbitrary group has no finite truth table to
compute, and thus must be *proved* from the axioms instead of
*decided*.

> Read more: the Lean/Mathlib documentation for `decide`, `omega`, and
> `norm_num` (searchable in the Mathlib docs or via `#help tactic omega`
> inside a Lean file) covers each tactic's exact decidable fragment and
> performance in more depth than this book needs.

---

[← Search tactics](01-search-tactics.md) | [Index](00-index.md) | [Next: simp →](03-simp.md)

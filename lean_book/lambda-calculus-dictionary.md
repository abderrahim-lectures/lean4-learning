# λ-calculus / type theory to Lean dictionary

[Table of contents](README.md)

---

A direct dictionary connecting the formal λ-calculus/type-theory notation
used in a few "Mathematical reading" boxes throughout this book back to
the Lean syntax it corresponds to. This page is a lookup table, not
something to read start to finish — [Chapter 1 §4](01-basics/04-terminology.md)
and [§5](01-basics/05-pi-sigma-and-coc.md), [Chapter 3
§2](03-propositions-and-proofs/02-logic-recap.md), and [Chapter 5
§3](05-rigor-check/03-typing-rules-and-safety.md) are where each row is
actually built up and explained.

| λ-calculus / type theory | Lean syntax | Where in this book |
| --- | --- | --- |
| variable $x$ | `x` | Chapter 1 |
| abstraction $\lambda x.\, t$ | `fun x => t` | Chapter 1 |
| application $t_1\, t_2$ | `t1 t2` | Chapter 1 |
| α-conversion | (silent, automatic) | — |
| β-reduction $(\lambda x.t)s \to t[x:=s]$ | `rfl`, `#eval` reduction | Chapter 1 §4, Chapter 5 §4 (definitional equality) |
| type judgment $\Gamma \vdash t : \tau$ | `#check t` | Chapter 1 |
| simple function type $\tau_1 \to \tau_2$ | `τ1 → τ2` | Chapter 1, Chapter 5 §3 |
| universe hierarchy $\mathtt{Type}\,i$ | `Type`, `Type 1`, ... | Chapter 5 §2–§3 |
| Π-type $\prod_{x:A} B(x)$ | `(x : A) → B x`, `∀ x : A, B x` | Chapter 1 §3, §5, Chapter 3 |
| Σ-type $\sum_{x:A} B(x)$ | `structure` (extractable); `∃ x, P x` is a *restricted* cousin (no witness-extraction) rather than literally Σ | Chapter 2, Chapter 1 §5 |
| proof-irrelevant universe | `Prop` | Chapter 3, Chapter 1 §5 |
| inductive data (beyond bare CoC) | `inductive`, `structure` | Chapters 1, 2, 11 |
| Curry–Howard: propositions-as-types | `Prop`/proof terms | Chapter 3 |
| progress + preservation | Lean's kernel type-checker | Chapter 5 §3 |
| Church numerals (encoded data) | `Nat` (but built via `inductive`, not encoded) | Chapter 1 §4, Chapter 13 (aside) |
| Church booleans / if-then-else via application | `Bool`, `if`/`match` (but native, not encoded) | Chapter 13 (aside) |

Two related facts, explained where their own dictionary rows live rather
than repeated here: tactics ([Chapter 1 §4](01-basics/04-terminology.md))
add nothing to the underlying calculus — they are a user interface for
building the same terms step by step — and elaboration/unification
([Chapter 1 §4](01-basics/04-terminology.md)) is type inference for this
calculus, a well-understood algorithm, not magic.

---

[Table of contents](README.md)

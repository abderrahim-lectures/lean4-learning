## From λ-calculus to Lean, term by term

[← Dependent types and the calculus of constructions](04-dependent-types-coc.md) | [Index](00-index.md) | [Next: Exercises →](06-exercises.md)

---

A direct dictionary, collecting the correspondences scattered through the
previous four sections into one table.

| λ-calculus / type theory | Lean syntax | Where in this book |
| --- | --- | --- |
| variable $x$ | `x` | Chapter 1 |
| abstraction $\lambda x.\, t$ | `fun x => t` | Chapter 1 |
| application $t_1\, t_2$ | `t1 t2` | Chapter 1 |
| α-conversion | (silent, automatic) | — |
| β-reduction $(\lambda x.t)s \to t[x:=s]$ | `rfl`, `#eval` reduction | Chapter 5 (definitional equality) |
| type judgment $\Gamma \vdash t : \tau$ | `#check t` | Chapter 1 |
| simple function type $\tau_1 \to \tau_2$ | `τ1 → τ2` | Chapter 1 |
| universe hierarchy $\mathtt{Type}\,i$ | `Type`, `Type 1`, ... | Chapter 5 |
| Π-type $\prod_{x:A} B(x)$ | `(x : A) → B x`, `∀ x : A, B x` | Chapter 1, Chapter 3 |
| Σ-type $\sum_{x:A} B(x)$ | `∃ x : A, P x`; also `structure` | Chapter 2, Chapter 3 |
| proof-irrelevant universe | `Prop` | Chapter 3 |
| inductive data (beyond bare CoC) | `inductive`, `structure` | Chapters 1, 2, 11 |
| Curry–Howard: propositions-as-types | `Prop`/proof terms | Chapter 3 |
| progress + preservation | Lean's kernel type-checker | Chapter 5 |
| Church numerals (encoded data) | `Nat` (but built via `inductive`, not encoded) | Chapter 1 |
| Church booleans / if-then-else via application | `Bool`, `if`/`match` (but native, not encoded) | Chapter 1 |

### Two points worth dwelling on

**Tactics don't add anything to the calculus.** Chapter 4's entire tactic
vocabulary (`intro`, `exact`, `rw`, `induction`, ...) is a *user interface*
for constructing CIC terms incrementally, with the current goal state
showing you the type of the "hole" still to be filled. Every finished
tactic proof elaborates to an ordinary term you *could* have written by
hand (as Chapter 3 did, before tactics were introduced) — tactics exist
purely because writing large CIC terms directly is unpleasant, not because
they access any extra expressive power. You can see this directly: run
`#print` on any theorem proved with tactics, and Lean shows you the
literal λ-term/application-tree the tactic script built.

**Elaboration is type inference for CIC, not magic.** Chapter 1's
implicit-argument inference (`identity 5` inferring `α := Nat`) and every
subsequent "Lean figures it out from context" moment in this book is an
algorithm — **unification** — solving equations between CIC terms with
metavariable placeholders, guided by the typing rules from the previous
two sections. It is a well-understood, terminating (for the fragment Lean
actually uses) procedure, not an oracle; when it fails, the resulting
error message (Chapter 4, "reading a tactic failure") is telling you
specifically which unification equation it couldn't solve.

## Next

Continue to [Exercises](06-exercises.md).

---

[← Dependent types and the calculus of constructions](04-dependent-types-coc.md) | [Index](00-index.md) | [Next: Exercises →](06-exercises.md)

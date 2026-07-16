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
| Σ-type $\sum_{x:A} B(x)$ | `structure` (extractable); `∃ x, P x` is a *restricted* cousin (no witness-extraction) rather than literally Σ | Chapter 2, Appendix B §4 |
| proof-irrelevant universe | `Prop` | Chapter 3 |
| inductive data (beyond bare CoC) | `inductive`, `structure` | Chapters 1, 2, 11 |
| Curry–Howard: propositions-as-types | `Prop`/proof terms | Chapter 3 |
| progress + preservation | Lean's kernel type-checker | Chapter 5 |
| Church numerals (encoded data) | `Nat` (but built via `inductive`, not encoded) | Chapter 1 |
| Church booleans / if-then-else via application | `Bool`, `if`/`match` (but native, not encoded) | Chapter 1 |

### Two points worth dwelling on

**Tactics add nothing to the calculus.** Chapter 4's entire tactic
vocabulary ([`intro`](https://lean-lang.org/doc/reference/latest/Tactic-Proofs/Tactic-Reference/), [`exact`](https://lean-lang.org/doc/reference/latest/Tactic-Proofs/Tactic-Reference/), [`rw`](https://lean-lang.org/doc/reference/latest/Tactic-Proofs/Tactic-Reference/), [`induction`](https://lean-lang.org/doc/reference/latest/Tactic-Proofs/Tactic-Reference/), ...) is a *user interface*
for building CIC terms step by step, with the current goal state
showing the type of the "hole" still to be filled. Every finished
tactic proof elaborates to an ordinary term that *could* have been written by
hand (as Chapter 3 did, before tactics were introduced). Tactics exist
purely because writing large CIC terms directly is unwieldy, not because
they give access to any extra expressive power. This is visible directly:
running `#print` on any theorem proved with tactics shows the
literal λ-term/application-tree the tactic script built.

**Elaboration is type inference for CIC, not magic.** Chapter 1's
implicit-argument inference (`identity 5` inferring `α := Nat`) and every
later "Lean figures it out from context" moment in this book is an
algorithm called **unification**. It solves equations between CIC terms
with metavariables (placeholders for not-yet-known terms), guided by the
typing rules from the previous two sections. It is a well-understood,
terminating (for the fragment Lean actually uses) procedure, not an
oracle. When it fails, the resulting error message (Chapter 4, "reading a
tactic failure") states specifically which unification equation could
not be solved.

## Next

Continue to [Exercises](06-exercises.md).

---

### References

- *Theorem Proving in Lean 4*, ["Type Classes"](https://leanprover.github.io/theorem_proving_in_lean4/type_classes.html) and the [Lean 4 documentation](https://lean-lang.org/doc/reference/latest/) generally — for elaboration and unification as actually implemented, beyond what this appendix's simplified rules cover.
- Frank Pfenning, ["Lecture Notes on Elaboration"](https://www.cs.cmu.edu/~fp/courses/15814-f21/lectures/11-elab.pdf), 15-814 Types and Programming Languages (Carnegie Mellon), and Ulf Norell, *[Towards a Practical Programming Language Based on Dependent Type Theory](https://www.cse.chalmers.se/~ulfn/papers/thesis.pdf)*, PhD thesis, Chalmers, 2007, Ch. 3 — standard treatments of elaboration/unification for dependently typed languages, the general algorithm this section's dictionary points at.
- Gérard Huet, "Résolution d'équations dans des langages d'ordre 1, 2, ..., ω," PhD thesis, Université Paris VII, 1976 — the original source for higher-order unification, the underlying problem Lean's elaborator solves.

---

[← Dependent types and the calculus of constructions](04-dependent-types-coc.md) | [Index](00-index.md) | [Next: Exercises →](06-exercises.md)

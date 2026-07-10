# Appendix B: The λ-calculus underneath Lean

[← Appendix A: Solutions](../14-appendix-solutions/00-index.md) | [Table of contents](../README.md)

---

Every `fun x => ...`, every `∀`, every tactic proof you've written in this
book compiles down to a term in a single, small formal system: the
**λ-calculus**, extended with dependent types (the **calculus of
constructions**, or CoC) and then further extended with `inductive` types
and a proof-irrelevant `Prop` (the **calculus of inductive constructions**,
CIC — the specific type theory Lean is actually built on; CoC is its
core, dependent-types-only fragment). This appendix makes that system
explicit — the untyped core first, then the typed and dependent
refinements — so that "elaboration," "reduction," "definitional equality"
(Chapter 5) and "the `Path` family is a $\Pi$-type" (Chapter 1) are
statements about a calculus you can hold in your head in its entirety, not
black-box compiler behavior.

This material is independent of the main chapters and can be read any
time after Chapter 5 (Rigor check); it's placed last because it's
foundational *underneath* everything else rather than a next step *after*
it.

## Sections

0. [A recap of standard logic and logical calculus](00-standard-logic.md)
1. [Untyped λ-calculus: terms and reduction](01-untyped-lambda-calculus.md)
2. [Encoding data: Church numerals and booleans](02-church-encodings.md)
3. [The simply typed λ-calculus](03-simply-typed-lambda-calculus.md)
4. [Dependent types and the calculus of constructions](04-dependent-types-coc.md)
5. [From λ-calculus to Lean, term by term](05-lambda-to-lean.md)
6. [Exercises](06-exercises.md)

Readers with no prior exposure to formal logic (natural deduction, truth
tables, $\vdash$ vs. $\models$) should start at §0 — it recaps standard
logic on its own terms, with no Lean or type theory involved, before §§1–4
build the type-theoretic side that Chapter 3 identifies it with. Readers
already comfortable with propositional/first-order logic can skip directly
to §1.

---

[← Appendix A: Solutions](../14-appendix-solutions/00-index.md) | [Table of contents](../README.md)

# Appendix B: The λ-calculus underneath Lean

[← Appendix A: Solutions](../14-appendix-solutions/00-index.md) | [Table of contents](../README.md)

---

Every `fun x => ...`, every `∀`, every tactic proof written in this
book compiles down to a term in one small formal system: the
**λ-calculus**. This system is extended with dependent types (the
**calculus of constructions**, or CoC) and then further extended with
`inductive` types and a proof-irrelevant `Prop` (the **calculus of
inductive constructions**, CIC — the actual type theory Lean is built on;
CoC is its core, dependent-types-only part). This appendix spells out
that system in full: the untyped core first, then the typed and dependent
parts added on top. The goal is that "elaboration," "reduction,"
"definitional equality" (Chapter 5), and "the `Path` family is a
$\Pi$-type" (Chapter 1) become statements about a calculus that can be
held in mind completely, rather than black-box compiler behavior.

This material is independent of the main chapters and may be read at any
time after Chapter 5 (Rigor check). It is placed last because it is the
foundation *underneath* everything else, not a next step *after* it.

## Sections

0. [A recap of standard logic and logical calculus](00-standard-logic.md)
1. [Untyped λ-calculus: terms and reduction](01-untyped-lambda-calculus.md)
2. [Encoding data: Church numerals and booleans](02-church-encodings.md)
3. [The simply typed λ-calculus](03-simply-typed-lambda-calculus.md)
4. [Dependent types and the calculus of constructions](04-dependent-types-coc.md)
5. [From λ-calculus to Lean, term by term](05-lambda-to-lean.md)
6. [Exercises](06-exercises.md)

A reader with no prior exposure to formal logic (natural deduction, truth
tables, $\vdash$ vs. $\models$) should start at §0, which recaps standard
logic on its own terms, with no Lean or type theory involved, before
§§1–4 build the type-theoretic side that Chapter 3 connects it to. A
reader already comfortable with propositional/first-order logic may skip
directly to §1.

---

[← Appendix A: Solutions](../14-appendix-solutions/00-index.md) | [Table of contents](../README.md)

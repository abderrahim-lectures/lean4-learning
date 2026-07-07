# Appendix B: The λ-calculus underneath Lean

[← Appendix A: Solutions](../14-appendix-solutions/00-index.md) | [Table of contents](../README.md)

---

Every `fun x => ...`, every `∀`, every tactic proof you've written in this
book compiles down to a term in a single, small formal system: the
**λ-calculus**, extended with dependent types (making it the **calculus of
constructions**, the specific type theory Lean is built on). This appendix
makes that system explicit — the untyped core first, then the typed and
dependent refinements — so that "elaboration," "reduction," "definitional
equality" (Chapter 5) and "the `Path` family is a $\Pi$-type" (Chapter 1)
are statements about a calculus you can hold in your head in its entirety,
not black-box compiler behavior.

This material is independent of the main chapters and can be read any
time after Chapter 5 (Rigor check); it's placed last because it's
foundational *underneath* everything else rather than a next step *after*
it.

## Sections

1. [Untyped λ-calculus: terms and reduction](01-untyped-lambda-calculus.md)
2. [Encoding data: Church numerals and booleans](02-church-encodings.md)
3. [The simply typed λ-calculus](03-simply-typed-lambda-calculus.md)
4. [Dependent types and the calculus of constructions](04-dependent-types-coc.md)
5. [From λ-calculus to Lean, term by term](05-lambda-to-lean.md)
6. [Exercises](06-exercises.md)

---

[← Appendix A: Solutions](../14-appendix-solutions/00-index.md) | [Table of contents](../README.md)

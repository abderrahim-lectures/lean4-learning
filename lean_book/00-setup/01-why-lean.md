## Why Lean?

[Index](00-index.md) | [Next: Installing the toolchain →](02-installing-toolchain.md)

---

In 1879, Alfred Kempe published a proof of the four-color theorem, the
claim that any map can be colored with four colors so that no two
adjacent regions share a color. The proof was accepted, cited, and
taught for eleven years. In 1890, Percy Heawood found a specific
configuration of eleven regions for which Kempe's central technique
silently broke down. That technique built two chains of alternating
colors and relied on them staying disjoint. In Heawood's
eleven-region configuration the two chains could interfere with each
other instead, and Kempe's argument gave no way to detect that this had
happened. No reader who checked Kempe's proof over those eleven years
was careless. A single unhandled case, invisible unless a
reader constructed exactly the right counterexample by hand, survived
peer review, publication, and a decade of citation ([Heawood1890]).

A proof checker exists to make this specific failure mode structurally
impossible. Lean 4 is a programming language with a built-in interactive
theorem prover, created by Leonardo de Moura and, for the version this
book uses, reimplemented in Lean itself together with Sebastian Ullrich
([DeMouraUllrich2021]); de Moura now leads the Lean Focused Research
Organization, the nonprofit that maintains the language. The Lean
community, organized as the Lean Prover Community and gathered on the
[Lean Zulip chat](https://leanprover.zulipchat.com/), builds and
maintains Mathlib, the shared library of formalized mathematics this
book builds every structure from scratch instead of importing. Mathematical definitions and statements are expressed as
code, and every proof is a term whose type must match the statement
exactly, checked by a small, fixed kernel. There is no step at which a
silently-unhandled case can pass review, because there is no step at
which the attention of a human reader is the only thing standing between a
gap and an accepted proof. A proof is correct if and only if it
type-checks, and it either type-checks or it does not, regardless of
how many regions the missing case would have involved.

Lean has since moved well past classroom-scale checking. In September 2026,
Anthropic published the first complete, kernel-checked proof of Fermat's
Last Theorem, roughly 13.5 million lines of Lean and 29,511 theorems,
built on the Imperial College FLT project led by Kevin Buzzard and on
Mathlib ([AnthropicFLT2026]). The same month, Tristan Buckmaster and
Levent Alpöge posted Lean-formalized proofs of finite-time blowup for
the incompressible porous medium, Boussinesq, and incompressible Euler
equations, close relatives of Navier–Stokes. Terence Tao called the
work "a remarkable achievement" and saw no obvious obstacle to the same
method eventually reaching Navier–Stokes itself, though the Millennium
Problem remains open ([BuckmasterAlpoge2026]). Alongside individual
results, the Tau Ceti project builds a Lean library of AI-authored,
human-reviewed mathematics downstream of Mathlib, aimed at giving later
projects a reusable foundation instead of starting each one from
scratch ([TauCeti2026]). A first course reaches none of these results
directly. The same kernel that checked the FLT proof checks the
exercises below, and the skills this book teaches, reading a goal
state, building a proof term by term, are the same skills those
projects use at scale.

This book uses abstract algebra (groups, rings) and a bit of category-flavored
material (path algebras of quivers) as running examples. These topics are
rich enough to be interesting, but simple enough to build from scratch.

### Sources, quoted

Formal definitions and citations for this section, gathered here for
reference (full entry in the [Bibliography](../bibliography.md)):

- **The Kempe/Heawood gap.** [Heawood1890] identifies the specific
  eleven-region configuration for which Kempe's 1879 argument fails,
  eleven years after publication.
- **Lean 4 itself.** [DeMouraUllrich2021] is the system description,
  led by Leonardo de Moura, who created Lean.
- **Fermat's Last Theorem.** [AnthropicFLT2026] is the Anthropic report
  on the complete Lean formalization.
- **Navier-Stokes-adjacent blowup results.** [BuckmasterAlpoge2026] is
  the Buckmaster/Alpöge statement and preprints.
- **Tau Ceti.** [TauCeti2026] is the project repository.

[Heawood1890]: ../bibliography.md#heawood1890
[DeMouraUllrich2021]: ../bibliography.md#demourullrich2021
[AnthropicFLT2026]: ../bibliography.md#anthropicflt2026
[BuckmasterAlpoge2026]: ../bibliography.md#buckmasteralpoge2026
[TauCeti2026]: ../bibliography.md#tauceti2026

---

[Index](00-index.md) | [Next: Installing the toolchain →](02-installing-toolchain.md)

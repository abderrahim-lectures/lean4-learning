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
theorem prover. Mathematical definitions and statements are expressed as
code, and every proof is a term whose type must match the statement
exactly, checked by a small, fixed kernel. There is no step at which a
silently-unhandled case can pass review, because there is no step at
which the attention of a human reader is the only thing standing between a
gap and an accepted proof. A proof is correct if and only if it
type-checks, and it either type-checks or it does not, regardless of
how many regions the missing case would have involved.

This book uses abstract algebra (groups, rings) and a bit of category-flavored
material (path algebras of quivers) as running examples. These topics are
rich enough to be interesting, but simple enough to build from scratch.

### Sources, quoted

Formal definitions and citations for this section, gathered here for
reference (full entry in the [Bibliography](../bibliography.md)):

- **The Kempe/Heawood gap.** [Heawood1890] identifies the specific
  eleven-region configuration for which Kempe's 1879 argument fails,
  eleven years after publication.

[Heawood1890]: ../bibliography.md#heawood1890

---

[Index](00-index.md) | [Next: Installing the toolchain →](02-installing-toolchain.md)

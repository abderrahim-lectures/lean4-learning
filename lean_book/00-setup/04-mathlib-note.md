## A note on Mathlib

[← Editor](03-editor.md) | [Index](00-index.md) | [Table of contents](../README.md) | [Ch. 1: Basics →](../01-basics/00-index.md)

---

This book builds groups, rings, and path algebras **from scratch**,
deliberately, without importing Mathlib (the community math library of Lean).
This is slower, but better for learning, since every definition and every proof
obligation is made explicit. Chapter 14 points toward Mathlib for readers
ready to use the "real" library instead of reinventing it.

Starting in Chapter 7, most worked examples are followed by a small,
clearly labeled "Mathlib equivalent" box, showing the same statement
written against the actual `Group`/`Ring`/`Module` API of Mathlib. This does not
replace the from-scratch approach; the hand-built version remains the main
teaching path, and the Mathlib box is only a preview. Holding both versions
in mind at once, the definition just derived, and the shape the same idea
takes in the library used later, builds a sharper understanding of both
than either alone would.

**Key points.** Lean 4 plus `lake`, an editor with the Lean extension, and
a pinned toolchain (matching `lean_project/lean-toolchain`) are all that
is needed to follow along. This book is Mathlib-free by design through
the from-scratch constructions of Chapter 12; Mathlib appears only in the
"Mathlib equivalent" boxes from Chapter 7 onward, and in full starting
Chapter 14.

**Three design choices, and why each one is forced.**

Here is the concrete cost of importing Mathlib from page one. The real
`Group` of Mathlib is not one `structure` with the group axioms listed in it;
it is the bottom of a chain, `Group extends DivInvMonoid`, which
`extends Monoid`, which `extends Semigroup` and `MulOneClass`, three
layers deep, before a single group axiom is visible in the source the
reader is looking at
(`Mathlib/Algebra/Group/Defs.lean`, pinned toolchain). A learner who
writes `example (G : Type) [Group G] (a : G) : a * a⁻¹ = 1 :=
mul_inv_cancel a` gets a correct proof without ever having read where
`mul_inv_cancel` is proved, or which of those three layers actually
states it. `lean_project`
already has Mathlib installed as a dependency; that is what powers the
"Mathlib equivalent" boxes from Chapter 7 onward. Importing it everywhere
from page one, rather than building `Group`/`Ring` from scratch first,
would be strictly less work. It would also defeat the point. The goal is
not merely to *use* a group in Lean, but to see exactly what a group *is*
to Lean: every field, every proof obligation, in one `structure`, with
nothing hidden behind the typeclass hierarchy of someone else. A library saves
effort by hiding that machinery, and the purpose of this book is for the
reader to see it on a first encounter, not have it hidden.

`elan` pins one exact Lean version per project via `lean-toolchain`.
Without that pin, on a machine with several Lean projects at once, a
later toolchain update to one project could silently change how the code
of another project elaborates, or stop it compiling at all. Pinning
`lean_project/lean-toolchain` to `leanprover/lean4:v4.33.1` is what keeps
every code block in this book reproducible regardless of what else is
installed system-wide.

Finally, if this book is Mathlib-free by design through Chapter 12, why
does Chapter 7 onward show Mathlib code at all? Because "built from
scratch" and "never shown the real library" are different design
choices, and this book only commits to the first. Every hand-built
definition from Chapter 7 onward is paired with a labeled preview of its
Mathlib counterpart, so that the transition to Mathlib in Chapter 14 is a
recognition of material already seen, not a cold start.

## Next

Continue to [Chapter 1: First steps](../01-basics/00-index.md).

---

[← Editor](03-editor.md) | [Index](00-index.md) | [Table of contents](../README.md) | [Ch. 1: Basics →](../01-basics/00-index.md)

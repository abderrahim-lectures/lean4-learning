## A note on Mathlib

[← Editor](03-editor.md) | [Index](00-index.md)

---

This book builds groups, rings, and path algebras **from scratch**,
deliberately, without importing Mathlib (Lean's community math library).
This is slower, but better for learning: every definition and every proof
obligation is made explicit. Chapter 13 points toward Mathlib for readers
ready to use the "real" library instead of reinventing it.

Starting in Chapter 6, most worked examples are followed by a small,
clearly labeled "Mathlib equivalent" box, showing the same statement
written against Mathlib's actual `Group`/`Ring`/`Module` API. This does not
replace the from-scratch approach; the hand-built version remains the main
teaching path, and the Mathlib box is only a preview. Holding both versions
in mind at once — the definition just derived, and the shape the same idea
takes in the library used later — builds a sharper understanding of both
than either alone would.

**Key points.** Lean 4 plus `lake`, an editor with the Lean extension, and
a pinned toolchain (matching `lean_project/lean-toolchain`) are all that
is needed to follow along. This book is Mathlib-free by design through
Chapter 11's from-scratch constructions; Mathlib appears only in the
"Mathlib equivalent" boxes from Chapter 6 onward, and in full starting
Chapter 13.

**Socratic questions.**

1. *`lean_project` already has Mathlib installed as a dependency (it is
   what powers the "Mathlib equivalent" boxes from Chapter 6 onward) —
   so why not just import it everywhere from page one, instead of
   building `Group`/`Ring` from scratch first?* Because the point of this
   book is not merely to *use* a group in Lean, but to see exactly what a
   group *is* to Lean: every field, every proof obligation, with nothing
   hidden behind someone else's typeclass hierarchy. A library saves
   effort by hiding that machinery, and this book's purpose is for the
   reader to see it on a first encounter, not have it hidden.
2. *`elan` pins one exact Lean version per project via `lean-toolchain`.
   What would go wrong without that pin, on a machine with several Lean
   projects at once?* A later toolchain update to one project could
   silently change how another project's code elaborates or even fails
   to compile — the entire point of `lean_project/lean-toolchain` reading
   `leanprover/lean4:v4.31.0` is that every code block in this book stays
   reproducible regardless of what else is installed system-wide.
3. *If this book is Mathlib-free by design through Chapter 11, why does
   Chapter 6 onward show Mathlib code at all?* Because "built from
   scratch" and "never shown the real library" are different design
   choices, and this book only commits to the first. Every hand-built
   definition from Chapter 6 onward is paired with a labeled preview of
   its Mathlib counterpart, so that the transition to Mathlib in
   Chapter 13 is a recognition of material already seen, not a cold
   start.

## Next

Continue to [Chapter 1: First steps](../01-basics/00-index.md).

---

[← Editor](03-editor.md) | [Index](00-index.md) | [Table of contents](../README.md) | [Ch. 1: Basics →](../01-basics/00-index.md)

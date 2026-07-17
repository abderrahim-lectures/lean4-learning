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

## Next

Continue to [Chapter 1: First steps](../01-basics/00-index.md).

---

[← Editor](03-editor.md) | [Index](00-index.md) | [Table of contents](../README.md) | [Ch. 1: Basics →](../01-basics/00-index.md)

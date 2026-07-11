## A note on Mathlib

[← Editor](03-editor.md) | [Index](00-index.md)

---

This book deliberately builds groups, rings, and path algebras **from
scratch**, without importing Mathlib (Lean's giant community math library).
This is slower but much better for learning: you'll see every definition and
every proof obligation explicitly. Chapter 13 points you toward Mathlib once
you're ready to use the "real" library instead of reinventing it.

Starting in Chapter 6, most worked examples are followed by a small,
clearly labeled "Mathlib equivalent" box showing the same statement written
against Mathlib's actual `Group`/`Ring`/`Module` API. This doesn't undo the
from-scratch approach — the hand-built version stays the primary teaching
path, and the Mathlib box is a deliberate peek ahead. Holding both versions
in mind at once (the definition you just derived, and the shape the same
idea takes in the library you'll eventually use) builds a sharper
understanding of both than either one alone would.

## Next

Continue to [Chapter 1: First steps](../01-basics/00-index.md).

---

[← Editor](03-editor.md) | [Index](00-index.md) | [Table of contents](../README.md) | [Ch. 1: Basics →](../01-basics/00-index.md)

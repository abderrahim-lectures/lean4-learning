## Solutions

[← Suggested next projects](03-next-projects.md) | [Index](00-index.md)

---

**Socratic questions, looking back and forward.**

1. *Every group, ring, module, and path algebra in this book was built by
   hand, field by field. Having now seen Mathlib's `class`-based versions
   in §2, was the from-scratch work wasted effort, now that a library
   does it automatically?* No — Mathlib automates exactly the parts that
   are safe to automate *once the underlying data is already understood*.
   Nothing in §2 replaces knowing what a `Group` axiom actually demands;
   it only removes the bookkeeping of re-deriving that knowledge every
   time a new carrier type shows up.
2. *Of the five projects sketched in §3, which one sounds least
   comfortable to attempt right now — and is that discomfort a reason to
   avoid it, or a reason to pick it?* This book has no answer to give
   here; noticing which gap feels least settled is itself the most
   useful outcome of reaching this page, and that gap is usually exactly
   where a project pays off most.
3. *This book verified every Lean snippet against a real toolchain rather
   than merely describing what should happen. Now that the training
   wheels of a guided worked example are gone, what is the equivalent
   habit to carry forward alone?* Trying the cheap thing first, reading
   why it failed, and checking the goal state after every step rather
   than only at the end — the same loop Chapter 4 introduced, now
   without a book supplying the next line.

Full worked solutions to every chapter's exercises are in the
[Appendix](../14-appendix-solutions/00-index.md).

---

[← Suggested next projects](03-next-projects.md) | [Index](00-index.md) | [Table of contents](../README.md) | [Appendix: Solutions →](../14-appendix-solutions/00-index.md)

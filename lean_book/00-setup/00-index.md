# Chapter 0: Setting up Lean 4

[Table of contents](../README.md) | [Ch. 1: Basics →](../01-basics/00-index.md)

---

## Learning objectives

- Understand why this book chooses Lean over other proof assistants.
- Install the Lean 4 toolchain and configure a working editor.
- Understand why this book builds everything from scratch instead of importing Mathlib from the start.

## What forces the setup

Before any theorem is stated, three questions need settling, each forcing
the next. Why trust a proof to Lean specifically, rather than to pen and
paper or to a different proof assistant? Given the answer, how does a
reader actually get Lean running? And once it runs, why does this book
build every structure by hand rather than importing an existing library
that already has them? [Section 1](01-why-lean.md) answers the first
question by fixing what "verified" means for the rest of the book: a
proof is correct exactly when it type-checks against the kernel of Lean.
[Section 2](02-installing-toolchain.md) and [Section 3](03-editor.md)
answer the second, mechanically: install elan, pin a toolchain, add an
editor that shows the goal state. [Section 4](04-mathlib-note.md)
answers the third: building `Group`/`Ring` from scratch exposes every
field and proof obligation Mathlib would otherwise hide behind its
typeclass hierarchy, which is the entire point of a first encounter.

## Sections

1. [Why Lean?](01-why-lean.md)
2. [Installing the toolchain](02-installing-toolchain.md)
3. [Editor](03-editor.md)
4. [A note on Mathlib](04-mathlib-note.md)

---

[Table of contents](../README.md) | [Ch. 1: Basics →](../01-basics/00-index.md)

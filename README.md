# lean4-learning

[Notice](NOTICE.md) | [Reproducing this book](REPRODUCING.md)

## Summary

This repository contains **Lean for Working Algebraists**, an introduction
to the Lean 4 proof assistant for readers with a background in abstract
algebra and basic category theory (objects, morphisms, composition,
functors), and no prior exposure to Lean, formal logic, or programming.
The book develops Lean 4 syntax and tactics from first principles, then
uses them to formalize groups, rings, modules, and quiver path algebras,
building every definition from scratch rather than relying on Mathlib.
Starting in Chapter 6, each worked example is followed by a "Mathlib
equivalent" showing the same construction phrased against Mathlib's real
API, so the from-scratch material and the library a reader will use
afterward are both covered.

**Learning objectives.** By the end of this book, read and write basic
Lean 4 terms, types, and function definitions, including implicit
arguments and dependent types; construct and interpret proofs using
Lean's tactic language, and diagnose a failing tactic from the goal
state; state and prove properties of groups, rings, and modules as Lean
structures built from first principles; represent a quiver as a Lean
structure and construct its path algebra; search Lean's tactic and lemma
library efficiently, and choose between term-mode and tactic-mode proofs;
and translate a from-scratch algebraic construction into its Mathlib
equivalent.

## Contents

- [lean_book/](lean_book/) — the book itself. See
  [lean_book/README.md](lean_book/README.md) for the full table of
  contents.
- [lean_project/](lean_project/) — a companion Lean 4 project (toolchain
  `v4.31.0`) containing every code block from the book, ported into one
  module per chapter and verified to compile with `lake build` (see
  [lean_project/README.md](lean_project/README.md) for setup). This
  caught and fixed several real bugs in the book's original code — see
  the git history for specifics.

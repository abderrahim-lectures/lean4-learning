# Chapter 0: Setting up Lean 4

## Why Lean?

Lean 4 is both a programming language and an interactive theorem prover. You
write mathematical definitions and statements as code, and Lean checks your
proofs the way a compiler checks types — if it type-checks, the proof is
correct (assuming you trust Lean's small trusted kernel).

This book uses abstract algebra (groups, rings) and a bit of category-flavored
material (path algebras of quivers) as running examples, because they are
rich enough to be interesting but simple enough to build from scratch.

## Installing the toolchain

Lean is managed by **elan**, a version manager (like `rustup` for Rust).

1. Install elan: follow the instructions at the official Lean installation
   guide (search "leanprover elan install" or use your package manager).
   On Windows, the recommended path is via VS Code's *Lean 4* extension,
   which offers to install elan for you.
2. Verify installation:

   ```sh
   elan --version
   lake --version
   ```

3. This repository ships a companion project, `../lean_project`, already
   configured with:

   ```text
   lean-toolchain: leanprover/lean4:v4.31.0
   ```

   When you run `lake build` inside `lean_project`, elan will automatically
   download and use exactly that toolchain version.

## Editor

Install the **Lean 4** extension for VS Code. It gives you:

- Inline goal state (the "Lean infoview") as you write proofs.
- Jump-to-definition for anything in core Lean or Mathlib.
- Red squiggles for errors, exactly like a normal language server.

## A note on Mathlib

This book deliberately builds groups, rings, and path algebras **from
scratch**, without importing Mathlib (Lean's giant community math library).
This is slower but much better for learning: you'll see every definition and
every proof obligation explicitly. Chapter 10 points you toward Mathlib once
you're ready to use the "real" library instead of reinventing it.

## Next

Continue to [Chapter 1: First steps](01-basics.md).

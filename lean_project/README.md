# lean_project

A Lean 4 project scaffold (toolchain `v4.31.0`).

[![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://codespaces.new/abderrahim-lectures/lean4-learning)

Opening a Codespace installs the pinned toolchain and runs `lake build`
automatically (see `.devcontainer/devcontainer.json` at the repository
root); the first build downloads Mathlib's build cache and can take
several minutes.

## Setup

1. Install [elan](https://github.com/leanprover/elan) if not already installed.
2. From this directory, run:

   ```sh
   lake build
   lake exe lean_project
   ```

The toolchain version is pinned in `lean-toolchain` and will be fetched automatically by elan/lake on first build.

## Mathlib

This project also depends on Mathlib (pinned to the `v4.31.0` tag, matching
the toolchain). The from-scratch book code (`Ch06Groups.lean`, ...,
`Ch11PathAlgebras.lean`) never uses it; the matching `*Mathlib.lean` files
(`Ch06GroupsMathlib.lean`, ...) are Chapters 6-11's "Mathlib equivalent"
boxes ported and compiled for real. The first `lake build` after adding
Mathlib downloads its build cache and can take several minutes — later
builds are fast.

There are two separate library targets, built by `lake build` together
but never imported from one file:

- **`LeanProject`** (root `LeanProject.lean`) — the from-scratch book code,
  Chapters 1–11. `Main.lean`/`lake exe lean_project` only use this one.
- **`LeanProjectMathlib`** (root `LeanProjectMathlib.lean`) — the six
  `Ch0*Mathlib.lean` files, plus `Ch13CapstoneMathlib.lean` (Chapter 13's
  "Two theorems for free" capstone: `Field (ZMod 3)` and Lagrange's
  theorem applied to a real subgroup of `Equiv.Perm (Fin 3)`).

They're kept apart on purpose: the from-scratch chapters define their own
top-level `Group`, `CommGroup`, `Ring`, `Module`, `Submodule`, `LinearMap`,
and `Quiver` — names Mathlib also uses at the top level — so one file
cannot import both without a name clash. To build (or read the output of)
just one side, run `lake build LeanProject` or `lake build
LeanProjectMathlib`.

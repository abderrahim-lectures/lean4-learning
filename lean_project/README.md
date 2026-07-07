# lean_project

A Lean 4 project scaffold (toolchain `v4.31.0`).

## Setup

1. Install [elan](https://github.com/leanprover/elan) if not already installed.
2. From this directory, run:

   ```sh
   lake build
   lake exe lean_project
   ```

The toolchain version is pinned in `lean-toolchain` and will be fetched automatically by elan/lake on first build.

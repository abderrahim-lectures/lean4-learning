## Installing the toolchain

[← Why Lean?](01-why-lean.md) | [Index](00-index.md) | [Next: Editor →](03-editor.md)

---

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

---

[← Why Lean?](01-why-lean.md) | [Index](00-index.md) | [Next: Editor →](03-editor.md)

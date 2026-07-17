## Installing the toolchain

[← Why Lean?](01-why-lean.md) | [Index](00-index.md) | [Next: Editor →](03-editor.md)

---

Lean is managed by **elan**, a **version manager**. This is a small tool
that installs and switches between different versions of Lean itself, so
each project can pin the exact version it needs. (Readers familiar with
`uv`'s Python-version management (`uv python install`) will recognize
elan as playing the same role for Lean.)

1. Install elan: follow the instructions at the official Lean installation
   guide (search "leanprover elan install" or use a package manager).
   On Windows, Linux, and macOS alike, the recommended path is via VS
   Code's *Lean 4* extension, which offers to install elan automatically
   through a platform-specific setup script for whichever OS it detects.
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

   Running `lake build` inside `lean_project` causes elan to automatically
   download and use exactly that toolchain version.

---

[← Why Lean?](01-why-lean.md) | [Index](00-index.md) | [Next: Editor →](03-editor.md)

# NEXT AGENT TODO LIST

## IMMEDIATE PRIORITIES

### 1. Complete Phase-1 Reviews (4 remaining)
Run these as Task tool subagents with focused prompts. Use the same pattern that worked for completed reviews:

**A. lean-code (north-mini-code-free)**
- Slice: Ch 1-4, 12 (26 files: 01-basics, 02-functions-and-structures, 04-tactics, 12-working-efficiently, tactic-and-library-reference.md)
- Skill: adversarial-maths-reviewer
- Key focus: Lean fundamentals, tactics, efficiency chapter; check `rfl` overuse, `simp` shortcuts, Ch12 `exact?` example verification

**B. math-theorems (nemotron-3-ultra-free)**
- Slice: Ch 3-7 (30 files: propositions, rigor-check, groups, group-theorems)
- Skill: adversarial-maths-reviewer
- Key focus: Theorem proofs, boundary cases (trivial group, zero ring), regression from removed learning objectives

**C. math-algebra (laguna-s-2.1-free)**
- Slice: Ch 8-11 (30 files: rings, ring-theorems, modules, path-algebras)
- Skill: adversarial-maths-reviewer
- Key focus: Algebraic structures, 2x2 matrices, module constructions, quiver path algebra

### 2. Fix CRITICAL Issues from Completed Reviews
- **Version reconciliation**: Update all v4.33.0 → v4.32.2 in docs, OR add disclaimer "docs target v4.33.0; companion project uses v4.32.2"
- **Solutions appendix**: Move Ch1 Ex4 (Path.append) to Ch11 file; expand `rfl` justifications; add Ch12 solutions
- **Ch0/13 narratives**: Add explicit cognitive progression markers (Bloom verbs)

### 3. Run Phase-2 & Phase-3
- Phase-2: Cross-critique (each model reviews others' reports)
- Phase-3: Adjudication (nemotron synthesizes FINAL-REVIEW.md)

---

## COMMANDS TO RUN

```bash
# Check current branch
git branch

# View completed reviews
cat reviews/2026-08-02/ling-3.0-flash-free-root-notice.md
cat reviews/2026-08-02/deepseek-v4-flash-free-solutions.md
cat reviews/2026-08-02/mimo-v2.5-free-prose-setup.md

# Build PDF after fixes
cd lean_book_latex && xelatex lean-for-working-algebraists.tex

# Build Lean project
cd lean_project && lake build
```

---

## FILES TO NOT MODIFY
- `lean_project/lean-toolchain` — keep v4.32.2 (actual working version)
- `lean_project/lakefile.toml` — keep v4.32.2
- `lean_book/build/build_latex.py` — v1.5.0 logic is correct

---

## BRANCH PROTECTION
**Do not commit to main.** Stay on `docs/v1.5.0-lean-update-and-reviews`.
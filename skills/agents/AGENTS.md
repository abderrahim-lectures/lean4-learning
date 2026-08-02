# Review Agents Registry

This directory defines the agents used for the adversarial review
workflow. Each agent maps a **skill** (from `../<skill-name>/SKILL.md`)
to a **free-tier model** and a **book slice**. Agents are instantiated
by `run_free_review.sh` and the individual scripts in this directory.

## Agent assignments

| Agent | Skill | Free Model | Book Slice | Output File |
|---|---|---|---|---|
| `maths-theorems` | `adversarial-maths-reviewer` | `nemotron-3-ultra-free` | Ch 3–7: propositions, rigor, groups, group theorems | `nemotron-3-ultra-free-math-theorems.md` |
| `maths-algebra` | `adversarial-maths-reviewer` | `laguna-s-2.1-free` | Ch 8–11: rings, ring theorems, modules, path algebras | `laguna-s-2.1-free-math-algebra.md` |
| `lean-code` | `adversarial-maths-reviewer` | `north-mini-code-free` | Ch 1–4, 12: Lean fundamentals, tactics, efficiency | `north-mini-code-free-lean-code.md` |
| `solutions` | `adversarial-maths-reviewer` | `deepseek-v4-flash-free` | Appendix 14: exercise solutions | `deepseek-v4-flash-free-solutions.md` |
| `root-notice` | `adversarial-book-reviewer` | `ling-3.0-flash-free` | Root: README, NOTICE, CONTRIBUTING, REPRODUCING | `ling-3.0-flash-free-root-notice.md` |
| `prose-setup` | `adversarial-book-reviewer` | `mimo-v2.5-free` | Ch 0, 13, reference pages | `mimo-v2.5-free-prose-setup.md` |

## Specialized reviewer agents (standalone)

| Agent | Skill | Free Model | Scope | Output File |
|---|---|---|---|---|
| `lean-audit` | `lean-code-auditor` | `north-mini-code-free` | All Lean code blocks in book + project | `lean-audit-report.md` |
| `typesetting` | `latex-typesetting-reviewer` | `mimo-v2.5-free` | `lean_book_latex/` PDF output | `typesetting-review.md` |
| `proof-search` | `proof-search-analyst` | `nemotron-3-ultra-free` | Ch 7, 9 search narratives | `proof-search-review.md` |
| `notation` | `notation-consistency-reviewer` | `mimo-v2.5-free` | All chapters: symbol consistency | `notation-review.md` |
| `category-theory` | `category-theory-accuracy-reviewer` | `laguna-s-2.1-free` | Ch 1, 3, 6, 8, 11 categorical claims | `category-theory-review.md` |

## Adjudicator

| Agent | Role | Free Model | Scope | Output File |
|---|---|---|---|---|
| `adjudicator` | Moderator (all skills combined) | `nemotron-3-ultra-free` | All Phase-1 reports + critiques | `FINAL-REVIEW.md` |

## Orchestration

All Phase-1 agents run in parallel via `run_free_review.sh`.
Specialized reviewers run as standalone scripts after Phase 1.
The adjudicator runs last, synthesizing all reports.

## Free model notes

- `nemotron-3-ultra-free` — strongest free model; use for complex reasoning
  (theorems, adjudication, moderation).
- `laguna-s-2.1-free` — strong reasoning; use for algebraic content and
  category-theory claims.
- `mimo-v2.5-free` — fast, broad pattern matching; use for prose,
  notation consistency, and typesetting scanning.
- `north-mini-code-free` — code-specialized; use for Lean code auditing.
- `deepseek-v4-flash-free` — logic-oriented; use for exercise solutions.
- `ling-3.0-flash-free` — fast lightweight; use for root notice files.

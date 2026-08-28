# Review Agents Registry

This directory documents the agents used for the adversarial review
workflow. Each agent maps a **skill** (from `../<skill-name>/SKILL.md`)
to a **free-tier model** and a **book slice**.

Since the agent conversion, the agents themselves live in
`.opencode/agent/*.md` as opencode agents and are dispatched by the
primary `review-lean-book` agent. The table below records the mapping
from registry name to `.opencode/agent/` file, model, and slice.

## Agent assignments

| Agent | Skill | Free Model | Book Slice | Output File |
|---|---|---|---|---|
| `maths-theorems` | `adversarial-maths-reviewer` | `nemotron-3-ultra-free` | Ch 3–7: propositions, rigor, groups, group theorems | `p1-reviews/maths-theorems.md` |
| `maths-algebra` | `adversarial-maths-reviewer` | `laguna-s-2.1-free` | Ch 8–11: rings, ring theorems, modules, path algebras | `p1-reviews/maths-algebra.md` |
| `lean-code` | `adversarial-maths-reviewer` | `north-mini-code-free` | Ch 1–4, 12: Lean fundamentals, tactics, efficiency | `p1-reviews/lean-code.md` |
| `solutions` | `adversarial-maths-reviewer` | `deepseek-v4-flash-free` | Appendix 14: exercise solutions | `p1-reviews/solutions.md` |
| `root-notice` | `adversarial-book-reviewer` | `ling-3.0-flash-free` | Root: README, NOTICE, CONTRIBUTING, REPRODUCING | `p1-reviews/root-notice.md` |
| `prose-setup` | `adversarial-book-reviewer` | `mimo-v2.5-free` | Ch 0, 13, reference pages | `p1-reviews/prose-setup.md` |

## Specialized reviewer agents (standalone)

| Agent | Skill | Free Model | Scope | Output File |
|---|---|---|---|---|
| `lean-audit` | `lean-code-auditor` | `north-mini-code-free` | All Lean code blocks in book + project | `specialized/lean-audit.md` |
| `typesetting` | `latex-typesetting-reviewer` | `mimo-v2.5-free` | `lean_book_latex/` PDF output | `specialized/typesetting.md` |
| `proof-search` | `proof-search-analyst` | `nemotron-3-ultra-free` | Ch 7, 9 search narratives | `specialized/proof-search.md` |
| `notation` | `notation-consistency-reviewer` | `mimo-v2.5-free` | All chapters: symbol consistency | `specialized/notation.md` |
| `category-theory` | `category-theory-accuracy-reviewer` | `laguna-s-2.1-free` | Ch 1, 3, 6, 8, 11 categorical claims | `specialized/category-theory.md` |

## Phase 2 cross-critique agents

Each model attacks the other models' Phase-1 reports. Subagent files
`critique-<model>.md` in `.opencode/agent/`, each excluding its own
Phase-1 report from the peer list:

| Agent | Free Model | Excludes |
|---|---|---|
| `critique-nemotron` | `nemotron-3-ultra-free` | `p1-reviews/maths-theorems.md` |
| `critique-laguna` | `laguna-s-2.1-free` | `p1-reviews/maths-algebra.md` |
| `critique-north` | `north-mini-code-free` | `p1-reviews/lean-code.md` |
| `critique-deepseek` | `deepseek-v4-flash-free` | `p1-reviews/solutions.md` |
| `critique-ling` | `ling-3.0-flash-free` | `p1-reviews/root-notice.md` |
| `critique-mimo` | `mimo-v2.5-free` | `p1-reviews/prose-setup.md` |

## Adjudicator

| Agent | Role | Free Model | Scope | Output File |
|---|---|---|---|---|
| `adjudicator` | Moderator (all skills combined) | `nemotron-3-ultra-free` | All Phase-1 reports + critiques | `p3-adjudication/FINAL-REVIEW.md` |

## Claude Code final reviewer (last step)

| Agent | Role | Model | Scope | Output File |
|---|---|---|---|---|
| `claude-final-reviewer` | Closing verification reviewer (tie-breaker, not an opencode subagent) | Claude Code CLI (`claude -p`) | All Phase-1 reports + critiques + `FINAL-REVIEW.md` + the underlying book text | `p3-adjudication/REVIEW-FINAL-CLAUDE.md` |

Runs headlessly in Phase 4 of the pipeline via the `claude` CLI, loading
its skill from `.claude/skills/claude-final-reviewer/SKILL.md`. It
re-verifies every finding at its cited `file:line`, adds an independent
regression and blind-spot sweep, and emits a detailed
`REVIEW-FINAL-CLAUDE.md`.

## Orchestration

The primary agent `review-lean-book` (in `.opencode/agent/`) orchestrates
the whole pipeline: it owns run folders (`reviews/<DATE>/run-<HHMMSS>/`),
resumability (reuses the newest run folder and skips reviewers whose report
is already on disk), and dispatches every subagent sequentially — never in
parallel. Phase 1 (6 slice reviews), specialized reviewers, Phase 2 (6
cross-critiques), Phase 3 (nemotron adjudication), then Phase 4 (Claude
Code final review via the `claude` CLI). Invoke it in the opencode TUI by
selecting the `review-lean-book` agent.

The old shell driver `run_free_review.sh` is retained for reference but is
superseded by the agent-based pipeline.

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

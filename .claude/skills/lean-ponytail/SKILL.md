---
name: lean-ponytail
version: "1.1.0"
description: >
  Minimalist Lean formalization and writing style. Decides: term-mode over
  tactic-mode, one tactic over a block, extract shared lemma over repeat,
  deletion over addition. Wires the full formalization pipeline: freshness
  gate, strategy chain, probe-first, ponytail, explicit-proofs, registry
  logging. Also enforces writing rules: derive from problem, cite at first
  use, plain prose. Use on any Lean task or math writing task.
  Trigger on: "ponytail", "lean ponytail", "lazy proof", "minimal proof",
  "yagni lean", "lean minimal", "simplest proof", "shortest proof".
argument-hint: "[lite|full|ultra]"
license: MIT
---

> **Start here first.** Load `second-brain/SKILL.md` if this session hasn't already — it routes the request to the capacity that owns it.

# Lean Ponytail — minimal code, minimal prose

You are a lazy senior developer on a Lean 4 codebase. Lazy means efficient,
not careless. The best proof is the shortest one the reader can follow. The
best prose is the shortest one that carries the argument.

## Before you write anything — the mandatory gates

Every formalization session passes these gates in order. No skipping.

### Gate 0: freshness check

Run `third-party-freshness` before touching any Lean file. Vendored
submodules (`vendor/lean-beam`, `vendor/tauceti`, `vendor/con-leche`),
the `.lake` symlink, and the pinned toolchain drift silently. A stale
submodule means a build that passes locally but fails on CI, or a lemma
that exists in the vendored copy but not in the version CI sees.

```bash
bash .claude/skills/third-party-freshness/scripts/check-freshness.sh
```

If the report flags a mismatch, fix it or log it before proceeding.
Do not formalize against a stale submodule.

### Gate 1: search before writing (owned by `lean-probe-first`)

Before any proof text, search every location where a lemma might live:

| Location | What to search | Tool |
|---|---|---|
| `lean/Research/` | This repo's own library | `grep -rn "theorem\|lemma" lean/Research/` |
| `.lake/packages/` | Mathlib, Std, Init | Loogle (`curl -s https://loogle.lean-lang.org/json`) or `#loogle` |
| `vendor/tauceti/` | TauCeti's downstream library | `grep -rn "theorem\|lemma" vendor/tauceti/` |
| `vendor/con-leche/` | Verified checker output | `grep -rn "theorem\|lemma" vendor/con-leche/` |

A hit ends the task — cite the existing declaration. Do not re-prove
what already exists.

### Gate 2: observe the real goal

Never reason about the goal from memory. Get the elaborator's actual
goal state via `lean-beam`:

```bash
LB=vendor/lean-beam/scripts/lean-beam
$LB --root lean sync <file>
$LB --root lean goals before <file> 1 <line> <col>
```

The gap between the goal you imagined and the goal the elaborator reports
is where guessed proofs die.

### Gate 3: speculate before committing

Test the candidate tactic against the real goal without touching the file:

```bash
$LB --root lean run-at <file> 1 <line> <col> --text 'rw [foo]; exact baz'
```

Only a tactic that a probe has accepted passes to the next gate.

## The formalization strategy chain

When starting a new formalization target, the full chain runs:

```
formalization-strategy  →  lean-probe-first  →  lean-ponytail  →  lean-proof-strategies  →  lean4-explicit-proofs
      (macro)              (pre-generation)      (minimal code)       (tactic selection)        (allowed forms)
```

| Layer | Skill | Question |
|---|---|---|
| Macro | `formalization-strategy` | Is this the right target? When is it done? |
| Freshness | `third-party-freshness` | Are submodules current? |
| Registry | `formal-math-ecosystem` | Where should this result live? |
| Pre-generation | `lean-probe-first` | Have I earned the right to write? |
| **Minimal code** | **this skill** | **Can I write less?** |
| Tactic | `lean-proof-strategies` | Which strategy for this goal shape? |
| Allowed forms | `lean4-explicit-proofs` | Is this proof form permitted? |
| Style | `plain-prose-repair` | Is the prose plain enough? |

### Where should this result live?

Before formalizing, check whether the result belongs here or downstream:

- **This repo** (`lean/Research/`): research-scoped lemmas, project-specific
  results, anything still tied to a paper under active development.
- **TauCeti** (`vendor/tauceti/`): generalized lemmas that have outgrown
  their research scope — corner formulas, syzygy-witness machinery. Submit
  via `tauceti-contribution` once the lemma is general and peer-reviewed.
- **Palomar registry**: finished, generalizable results registered for
  independent verification. Check via `palomar-registry` before declaring
  a result "done."
- **leanprover/hex**: computational falsification batteries (`#eval`/`decide`
  cores) that verify by computation, not proof.

## The ladder — minimal code

Stop at the first rung that holds. This ladder runs AFTER the gates above
have cleared, and AFTER you understand the goal.

1. **Is there a term-mode proof?** `⟨h, h'⟩` for `And`, `⟨rfl⟩` for
   equality, `by exact foo` as last resort. Term-mode is lazier than
   tactic-mode: it names exactly what to check and nothing more.

2. **Can one tactic close it?** `rw [h]`, `exact h`, `apply X`,
   `constructor`. One tactic, one line. A block that starts with
   `simp [h1, h2]` and ends with `exact foo` is usually
   `simp [h1, h2, foo]`.

3. **Can two tactics close it?** Keep it to two lines. If you need
   three or more, consider whether a named intermediate step (`have`)
   makes the proof shorter *and* more readable.

4. **Can subgoals share a pattern?** Extract a local `lemma` or
   `theorem` with a clear name, prove it once, apply it in all
   places. Don't repeat a tactic block across two proofs.

5. **Only then: the minimum tactic block that works.** Each line does
   one thing. Name the hard step; mechanical steps (`simp`, `omega`,
   `decide`) need no comment.

## Rules

### Lean Formalization

- **Term-mode over tactic-mode.** `⟨h, h'⟩` over `constructor <;> exact h`.
  `by exact foo` over a tactic block that ends with `exact foo`.

- **One tactic per line.** No `simp [h1] <;> rwa [h2]` chains unless
  the compound is the only correct expression.

- **Name the hard step.** Creative steps get a `--` comment explaining
  why they exist. Mechanical steps need no comment.

- **Deletion over addition.** If a `have`, a tactic line, or a `lemma`
  doesn't earn its place by making the proof shorter or more readable,
  cut it.

- **Lean proof ≠ proof text.** The Lean source is ground truth. Never
  let prose claim a theorem is proved when Lean has `sorry`.

- **Import the minimum.** Don't `import Mathlib.Tactic.All`. Import
  the specific files your proof uses.

### Mathematical Writing

- **Derive, don't announce.** Problem → Definition → Example → Theorem.

- **Cite at first use.** `[Author Year, p.XX]` inline at first use of
  any non-original notion. Sources box at chapter end is recap.

- **Plain prose.** No antithesis drumbeat, no dictionary words, no
  cross-domain metaphors. Run `tools/scripts/check-plain-prose.sh`.

- **No "clearly"/"obviously".** Replace with the actual argument or
  a citation.

- **Comparison blocks: cite the code.** File and line number. The prose
  matches what the Lean source actually does.

### Logging — after every formalization

After completing a formalization, log it in the right place:

| What happened | Where to log | Skill |
|---|---|---|
| A lemma was proved | `ledger/` entry + issue comment | `research-ledger`, `github-tracker` |
| A sorry was closed | Issue comment with proof summary | `github-tracker` |
| A new dead end | `ledger/dead-ends.md` + issue label `dead-end` | `research-ledger`, `github-tracker` |
| A computation falsified a conjecture | Issue label `counterexampled`, close | `github-tracker` |
| A result is ready for downstream | `tauceti-contribution` or `palomar-registry` | `formal-math-ecosystem` |
| A gate was skipped and it cost a cycle | `ledger/lessons-learned/` | `lifelong-learning` |

Write bodies with `--body-file`, never inline `--body` (backtick-eating
shell substitution). Every status change is a commit in `ledger/`.

## Intensity

| Level | What change |
|-------|------------|
| **lite** | Build what's asked, but name the lazier alternative in one line. |
| **full** | Full gate chain enforced. Term-mode first, one tactic per line, cite at first use, plain prose, log after. Default. |
| **ultra** | YAGNI extremist. Challenge the task itself: "Does this theorem need to exist?" Ship the minimum, question everything else. |

## When NOT to be lazy

- **User explicitly asks for detail.** The ladder defers.
- **Proof correctness.** Every step traceable. Bare `simp` closing a
  non-trivial goal is a bug. (Enforced by `lean4-explicit-proofs`.)
- **Citation completeness.** Every non-original claim cited. No
  "well-known" exceptions.
- **The problem motivating a definition.** The derivation chain is
  the pedagogy. Skipping it is a second bug.
- **Logging.** Every proved lemma, every closed sorry, every dead end
  gets logged. A proof without a ledger entry is unfinished.

## Output

Lean source first. Then at most three short lines: what was skipped,
when to add it.

Pattern: `[proof] → skipped: [X], add when [Y].`

## Meta

v1.1.0 (2026-09-12). Wired the full formalization pipeline: freshness
gate (Gate 0), submodule search paths (lean/Research, .lake, vendor/*),
registry skills (formal-math-ecosystem, palomar-registry,
tauceti-contribution), GitHub logging (github-tracker, research-ledger).
Non-duplication check run against `formalization-strategy` (macro chain),
`lean-probe-first` (gates 1-3), `lean4-explicit-proofs` (tactic policy),
`third-party-freshness` (freshness gate), `formal-math-ecosystem`
(registry), `github-tracker`/`research-ledger` (logging). This skill
owns the "write less" decision, the writing style rules, and the pipeline
wiring that connects the other skills into a single session flow.
Audited by `skill-improver`. Next audit due: after first real use
producing a gated result, or ~15 iterations. Receipts:
`review/_meta/skill-audit.log`.

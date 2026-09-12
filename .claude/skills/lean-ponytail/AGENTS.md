# Lean Ponytail — lazy senior dev mode for Lean 4

Minimalist Lean formalization and writing style. Adapted from
ponytail (DietrichGebert/ponytail). Wires the full formalization
pipeline.

## Before writing — mandatory gates (in order)

1. **Freshness**: run `third-party-freshness` — submodules drift silently.
2. **Search**: grep `lean/Research/`, Loogle, `vendor/tauceti/`,
   `vendor/con-leche/`. A hit ends the task.
3. **Observe**: get real goal state via `lean-beam`. Never guess.
4. **Speculate**: test candidate tactic via `lean-beam run-at`. No
   blind writes.

## The ladder — minimal code

After gates clear, stop at the first rung:

1. **Term-mode proof?** `⟨h, h'⟩`, `by exact foo`. One step.
2. **One tactic?** `rw [h]`, `exact h`, `apply X`. One line.
3. **Two tactics?** Two lines. Name intermediates.
4. **Shared pattern?** Extract named `lemma`, prove once, apply everywhere.
5. **Only then:** minimum tactic block. One tactic per line.

## Strategy chain

```
formalization-strategy → lean-probe-first → lean-ponytail → lean-proof-strategies → lean4-explicit-proofs
     (macro)             (pre-generation)     (minimal code)      (tactic selection)       (allowed forms)
```

## Where should results live?

- `lean/Research/`: research-scoped, tied to active paper.
- TauCeti (`vendor/tauceti/`): generalized, peer-reviewed.
- Palomar registry: finished, independent verification.
- leanprover/hex: computational falsification batteries.

## Writing rules

- Derive from problem, don't announce.
- Cite at first use: `[Author Year, p.XX]` inline.
- Plain prose: no antithesis drumbeat, no dictionary words.
- No "clearly"/"obviously" — say the argument or cite the lemma.
- Deletion over addition.

## Logging — after every formalization

- Lemma proved → `ledger/` + issue comment (`research-ledger`, `github-tracker`).
- Sorry closed → issue comment with proof summary.
- Dead end → `ledger/dead-ends.md` + label `dead-end`.
- Ready for downstream → `tauceti-contribution` or `palomar-registry`.
- Gate skipped and it cost a cycle → `ledger/lessons-learned/`.

## When NOT to be lazy

- User asks for detail → ladder defers.
- Proof correctness → every step traceable.
- Citation completeness → every non-original claim cited.
- Derivation chain → problem before definition.
- Logging → every result gets a ledger entry.

Shortest correct proof wins. Every result gets logged.

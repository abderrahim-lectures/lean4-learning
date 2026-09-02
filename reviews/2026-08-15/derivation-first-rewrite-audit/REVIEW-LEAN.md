# REVIEW-LEAN.md — derivation-first-rewrite

## 1. Summary

I ran `lake build` fresh in `lean_project/` on toolchain `leanprover/lean4:v4.32.2`
(matches `lean_project/lean-toolchain`, and Mathlib is pinned to `rev =
"v4.32.2"` in `lakefile.toml`). It finished with **`Build completed
successfully (8681 jobs).`** and zero errors. I read the `#check`/`#eval`/
`dbg_trace` output Lean itself printed during that build (not the book's
claimed output) and cross-checked two of the book's `dbg_trace` claims
(`double`, `toList`) against it — both match verbatim. I confirmed the two
lemmas this rewrite adds (`nat_add_zero`, `nat_zero_mul`) are present,
byte-identical, in `lean_project/LeanProject/Ch15AppendixSolutions.lean`,
and compiled as part of the same successful build (their `#eval`/proof
output appears in the log). I grepped every fenced Lean code block in
`lean_book/` (not just prose mentions) for `sorry`/`admit`/`axiom`/`unsafe`
and found none, and confirmed `lean_project/LeanProject/*.lean` has none
either. I diffed `derivation-first-rewrite` against `master`
(`git merge-base` = `master` HEAD, `0593f0c`) across all 54 changed `.md`
files and the one changed `.lean` file, extracting every fenced code block
on both sides, to confirm the prose-only rewrite left Lean/Python code
blocks untouched except for the two documented new lemmas.

## 2. Recommendation

**Accept.**

## 3. Compile failures

None. `lake build` completed with 8681/8681 jobs, no errors, no warnings
beyond the intentional `Try this:` suggestion at
`lean_project/LeanProject/Ch13WorkingEfficiently.lean:16:2` (an
`apply?`/similar tactic-suggestion info message, not an error).

## 4. Faithfulness gaps

None found in the scope checked. Specifically verified:

- `dbg_trace` output for `double` (Ch. 2,
  `lean_book/02-terminology-and-coc/02-pi-sigma-and-coc.md:355-362`) matches
  the compiler's actual printed trace character-for-character:
  `double: succ case, ih=0, adding 2` through `ih=8, adding 2`.
- `dbg_trace` output for `toList` (Ch. 15 appendix,
  `lean_book/15-appendix-solutions/01-chapter-1.md:40-49`) matches the
  compiler's actual printed trace: three `toList: cons, prepending one
  element, recursing on the rest` lines followed by `toList: nil, base
  case, returning []`.
- The two new lemmas' prose descriptions match their Lean statements:
  - `nat_add_zero (n : Nat) : n + 0 = n := rfl` — prose
    (`lean_book/15-appendix-solutions/04-chapter-4.md:64-74`) correctly
    explains why `rfl` suffices here (recursion is on the second argument)
    and why the mirror-image `0 + n = n` would not close by `rfl`. Matches
    the statement exactly, no weakened hypothesis.
  - `nat_zero_mul (n : Nat) : 0 * n = 0 := by induction n with | zero =>
    rfl | succ k ih => rw [Nat.mul_succ, ih]`
    (`lean_book/15-appendix-solutions/05-chapter-5.md:57-62`) — prose
    (lines 64-71) correctly walks the base case and the `Nat.mul_succ`
    rewrite step used in the inductive case; matches the tactic proof.

## 5. Proof shortcuts

None found. `grep -rniE '\bsorry\b|\badmit\b|\baxiom\b|\bunsafe\b'` across
`lean_book/**/*.md` and `lean_project/LeanProject/*.lean` returns matches
only in prose (e.g. "group axiom", explanations of what `sorry` is/does as
a tactic concept, changelog entries describing past `sorry` removals). A
second pass parsed every fenced ` ```lean ` / ` ```lean4 ` block in the book
and searched only inside code fences — zero matches. `lean_project/*.lean`
has zero matches anywhere, code or comments.

`rfl` usage was spot-checked at the two new-lemma sites above and confirms
each holds definitionally (recursion-on-first-argument base case), not
misapplied.

## 6. Verification log

```
$ cd lean_project && lake build
...
ℹ [16/384] Replayed LeanProject.Ch15AppendixSolutions
info: LeanProject/Ch15AppendixSolutions.lean:47:0: toList: cons, prepending one element, recursing on the rest
toList: cons, prepending one element, recursing on the rest
toList: cons, prepending one element, recursing on the rest
toList: nil, base case, returning []
info: LeanProject/Ch15AppendixSolutions.lean:47:0: [7, 7, 7]
...
Build completed successfully (8681 jobs).
```

- Toolchain: `lean_project/lean-toolchain` = `leanprover/lean4:v4.32.2`.
- `lakefile.toml`: Mathlib `rev = "v4.32.2"` (matches toolchain tag).
- `lake-manifest.json`: dependency revs present and pinned (batteries,
  aesop, proofwidgets, etc.), consistent with the build succeeding.
- `nat_add_zero` / `nat_zero_mul`: present in both
  `lean_book/15-appendix-solutions/04-chapter-4.md` /
  `05-chapter-5.md` and `lean_project/LeanProject/Ch15AppendixSolutions.lean`
  — confirmed via `git diff 0593f0c derivation-first-rewrite --
  lean_project/LeanProject/Ch15AppendixSolutions.lean`, which shows only
  these two additions (+10 lines, purely additive, no other change to the
  file), and both compiled cleanly as part of the full build above.
- `sorry`/`admit`/`axiom`/`unsafe` search: zero hits inside Lean code
  fences in `lean_book/`; zero hits anywhere in `lean_project/LeanProject/
  *.lean`. All prose hits are conceptual references (group/ring "axiom",
  `sorry` as a documented tactic) or changelog history, not live code.
- Prose-only-rewrite check: `git merge-base derivation-first-rewrite master`
  = `0593f0c` (= `master` HEAD, this branch is 2 commits ahead). Diffed all
  54 changed `.md` files' fenced `lean`/`lean4`/`python`/unlabeled code
  blocks, base vs. head: only `04-chapter-4.md` and `05-chapter-5.md` gained
  a block (the two new lemmas); every other changed file's code blocks are
  byte-identical to `0593f0c`. The only changed `.lean` file in
  `lean_project/` is `Ch15AppendixSolutions.lean`, purely additive as
  above. `lean_book/changelog/v2.0.0.md` is a new file (no base version to
  diff), reporting on this rewrite itself — expected.
- Book-vs-project porting for Chapters 1-12: spot-checked; most `lean_book`
  blocks appear verbatim inside the corresponding `lean_project/LeanProject/
  Ch*.lean` file. A small number of trivial illustrative one-liners (e.g.
  `#check 3` in `01-basics/01-everything-has-a-type.md` appearing as
  `#check (3 : Nat)` in `Ch01Basics.lean`) carry minor, pre-existing,
  semantically-equivalent syntax adaptations (explicit type ascriptions)
  that predate this rewrite — confirmed by the `git diff` above showing
  `lean_project/` was untouched by this branch except for the two new
  lemmas. This is not a rewrite-introduced faithfulness gap.
```

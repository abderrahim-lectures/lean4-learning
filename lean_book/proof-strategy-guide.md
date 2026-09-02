# Proof strategy guide: when a goal looks like X, start with Y

[Table of contents](README.md)

---

A decision table connecting the shape of the goal or hypothesis you are
staring at to the tactic or approach most likely to make progress first,
before any deeper reasoning. This page is a starting point, not a
substitute for the chapters where each tactic is actually built up
([Chapter 5](05-tactics/00-index.md) for the core tactics,
[Chapter 13](13-working-efficiently/00-index.md) for working faster). Use
it the way a heat map is used: read the shape of your current goal, find
its row, and try the listed move first. If that move fails, the
[reading a tactic failure](05-tactics/03-reading-failures.md) section
explains what the error message is telling you to do instead. The
[tactic and library reference](tactic-and-library-reference.md) holds the
full per-tactic index; this page holds only the goal-shape-to-tactic
mapping.

Each trigger column names what you see; each move column names the first
thing to try, in the order listed. Where a move is useful only once a
fact has already been established, the trigger says so.

## By the shape of the goal

The rewrite names below (`add_comm`, `mul_assoc`, `mul_add`) follow the
conventions the book actually uses: for the hand-built `Group`/`Ring`/
`Module` of Chapters 7-11, rewrite with the *field* name of the structure
in hand (`Grp.assoc`, `Grp.inv_left`, `Rg.mul_assoc`, `Rg.left_distrib`,
`Rg.addGrp.comm`); the plain `add_comm`-style names apply to the Mathlib
`Int.`-prefixed lemmas the book reaches for in its own code and its
Mathlib boxes (`Int.add_comm`, `Int.mul_assoc`). Match the name to the
structure you are actually working with, and `#check` the name if you
are unsure.

| When the goal is ... | Try ... first | The idea, in one line |
| --- | --- | --- |
| literally the same term on both sides, `a = a`, or an obvious computation like `2 + 3 = 5` | `rfl` | Eat the definitional equality directly; nothing to prove |
| `n + 0 = n`, `x * 1 = x`, a perhaps-unobvious equality that is still definitional | `rfl`, then `simp` | These close by reduction when the recursion is on the right argument (see [Chapter 1](01-basics/01-everything-has-a-type.md), [Chapter 6, Section 4](06-rigor-check/04-defeq-vs-propeq.md)) |
| an equality you have as a hypothesis, goal `P` and hypothesis `h : P` | `exact h` | No work; it is already in hand |
| goal `P` after `intro`, with `h : P` and a function whose result is `P` | `exact`, `apply` | Supply the value explicitly, or let `apply` turn its conclusion into subgoals |
| `a + b = b + a`, `a * b = b * a` (a commutativity fact) | `rw [add_comm]`, `rw [mul_comm]`, then re-close by `rfl` or `simp` | Rewrite with the commutativity law; the simplifier or a direct rewrite closes the rest |
| `a * b * c = a * (b * c)` (an associativity fact) | `rw [mul_assoc]`, then `rfl` or `simp` | Rewrite with associativity; the structure axiom of the ring does the work |
| a distributivity identity, `a * (b + c) = a * b + a * c` | `rw [mul_add]`, then `rfl` | The ring axiom `mul_add` handles it directly |
| a non-commutative-ring identity | `noncomm_ring`, or hand-`rw [mul_add]` / `rw [add_mul]` per step | `noncomm_ring` is a Mathlib decision tactic (see Ch. 9 Mathlib box); by hand, rewrite with `mul_add` or `add_mul` one step at a time |
| `f (def x) = ...` where `def` is a definition you control | `unfold def`, `simp [def]` | Unfold the definition to expose the structure; `simp [def]` unfolds and simplifies in one move |
| `F x = F y` where `F` is a function on a hand-built `structure` (`Perm3`, `Mat2`) | `apply` the `.ext` lemma you write for that structure, or prove per-field | Extensionality is *not* an automatic tactic here; the book supplies `Perm3.ext`/`Mat2.ext` by hand (`funext`/`simp only [mk.injEq]`), because a plain `structure` has no generated `@[ext]` (see Ch. 7 permutations, Ch. 9 Matrices) |
| two `structure`/`sigma` values equal | `apply` the `.ext` lemma of the structure, else `cases` the two, else prove per-field with `⟨_, _⟩` | Break the bundle apart into its data, then reassemble; reach for the hand-written `.ext` before a bare `ext` that will not fire on these structures |
| `P ∧ Q` (a conjunction to prove) | `constructor`, then `exact`/`rw` for each half; or `⟨hp, hq⟩` | Split it into two goals, prove each separately |
| a disjunction `P ∨ Q` where one side is literally already a hypothesis | `left`, `right`, then `exact` | Pick the side that is already established and close it |
| `∃ x, P x` (an existential to prove) | `use witness`, then prove `P witness`; `refine ⟨w, proof⟩` | Supply a witness value, then prove the property of it |
| `x = y` with `h : y = z` (a chain, or a transitivity step) | `rw [h]`, then `rfl` | Rewrite along the known equality until both sides are definitionally equal |
| `a = b` where a hypothesis is `h : a = c` or of the form `g a = g b` | `rw [← h]`, `apply congrArg g`, `congr` | Rewrite the reverse direction, or argue both sides under the same function |
| `f a = f b` (function applied to two points) | `apply congrArg f`, `congr` | Reduce to proving `a = b` |
| `a + b = b + a` where `b` is an abstract unknown | `rw [add_comm]` then `rfl` | Rewrite with the commutativity law; the `rfl` closes the resulting definitional equality |
| a goal with `g (f x) = g (f y)` and `∀ a, f a = ...` | `rw [h]` repeatedly, then `rfl` | Rewrite inner occurrences until both sides match exactly |

## By the shape of a hypothesis

| When you hold ... | Try ... first | The idea |
| --- | --- | --- |
| `h : P ∧ Q` (a conjunction to use) | `cases h with \| conj hp hq => ...` | Split it into its two proofs; `hp`/`hq` are each usable afterward |
| `h : P ∨ Q` (a disjunction to case on) | `cases h with \| inl hp => ... \| inr hq => ...` | Branch; each branch takes one side, the other is dead |
| `h : ∃ x, P x` (an existential to use) | `cases h with \| intro x hx => ...` | Extract the witness and its proof into the context |
| `h : f x = f y` and you want `x = y` (injectivity) | `rw [mk.injEq]` on `h` for a hand-built structure, or `cases` the equality and match constructors | Extraction is not automatic; the book tool of choice is `mk.injEq` (see `Mat2.mk.injEq` in Ch. 9), else prove injectivity directly by `cases` |
| `h : a + b = b + c` and the goal mentions `b` | `rw [add_comm]` on `h`, then simplify both sides | Regroup the terms until the middle cancels, the "regroup, then cancel" pattern of [Chapter 8, Theorem 3](08-group-theorems/04-theorem-3.md) |
| a goal needing a fact you have named, `h : P` with goal `P` | `exact h` | Completion; it is exactly satisfied |
| a general fact `h : ∀ x, P x` and goal `P a` | `exact h a` | Instantiate the universal at `a` |
| `h : a = b` and goal contains `b` | `rw [h]`, or `rw [← h]` if it contains `a` | Rewrite the known equality in the direction it collapses the goal |
| `h : n + 0 = n` (a lemma over `Nat`) | `exact h` | Already in hand; `Nat.add` recurses on the second argument, so `n + 0 = n` is `rfl` when you need to prove it yourself |
| `0 + m = m` (the mirror-image case) | `induction m` | Not definitional; prove by induction on the first argument (see [Chapter 5](05-tactics/02-core-tactics.md)) |
| `h : a * b = c * b` and goal needs `a = c` (cancellation in a monoid) | regroup with `assoc` to isolate `b` and `b⁻¹`, then cancel | Same regroup-then-cancel pattern; the inverse pair adjacent to `b` collapses, leaving `a = c` |

## By the shape of a definition

| When you are defining ... | Try ... first | The idea |
| --- | --- | --- |
| a `def` with a tall body | `def name ... :=` then fill the right-hand side straight | Computation, no proof; Lean checks it is well-typed |
| a `structure` with proof fields | `structure X where ... : Prop` then fill each field, proving the `Prop` ones | Bundle data; each `Prop` field is a subgoal to discharge |
| a `instance` of a `structure` | `instance : X where ...` fill per field; use `by decide` for finite ones | Provide each field; finite cases (`Fin n`, `Bool`) close every axiom by `decide` |
| a `theorem`/`lemma` | `theorem name : P := by ...` | Tactic-mode builds the proof step by step |
| a recursive `def` over `Nat` or an inductive type | `def f : ... | c` base => ... `| c' step => ... f ...` (equation style) | Pattern-match one equation per constructor; structural recursion is accepted automatically, no `termination_by` needed (see Ch. 1 `Vec.toList`, Ch. 12 `Path.length`) |
| a function by pattern matching on a `structure` | `| struct1 => ...` per constructor | One equation per constructor |
| a proof by induction on `Nat` | `induction n with | zero => base | succ k ih => step` | Prove base and step; `ih` is the induction hypothesis |

## By the shape of the algebraic structure

| When your goal is a fact about ... | Try ... first | The name to `#check` / the tactic |
| --- | --- | --- |
| a group `Grp : Group G`, goal `x * x⁻¹ = 1` | `exact Grp.inv_right x` | Project the axiom `inv_right` out of the bundle |
| a group, `a * b = a * c` implies `b = c` | regroup with `Grp.assoc`/`← Grp.assoc` until `a` sits next to `a⁻¹`, then `rw [Grp.inv_left]` and cancel | The "regroup, then cancel" pattern of [Chapter 8, Section 2](08-group-theorems/04-theorem-3.md): rewrite with `assoc` until an inverse pair is adjacent, then `inv_left`/`inv_right` collapses it |
| the identity of a monoid being unique, `e' = Grp.id` from `h : ∀ a, Grp.op e' a = a` | find a common third expression both sides relate to: `have step1 : Grp.op e' Grp.id = Grp.id := h Grp.id`, `have step2 : Grp.op e' Grp.id = e' := Grp.id_right e'`, then `rw [← step2]`, `exact step1` | The "two things equal to a common third are equal" move of [Chapter 8, Theorem 1](08-group-theorems/02-theorem-1.md); resist an opaque `rw`-chain shortcut, the lesson is the third expression |
| a ring, `(-1) * a = -a` or `0 * a = 0` | `rw [neg_one_mul]`, `rw [mul_zero]` | Absorbing/sign laws; `rw` the named lemma (see [Chapter 10](10-ring-theorems/00-index.md)) |
| a module scalar `r • (m + m')` | `rw [smul_add]` | The scalar-action distributivity axiom |
| a linear map commuting with `+` | `rw [f.map_add]`, `exact f.map_smul r m` | Project the homomorphism-preservation fields |
| a submodule membership `m ∈ sub` | apply the closure lemma, or `show` the predicate | Unfold the membership predicate and apply the closure proof |
| a direct sum, componentwise equality | `congr 1` then prove each summand | Split the bundled equality into one fact per summand (see [Chapter 11, Section 6](11-modules/06-direct-sums.md)) |
| a path `Path.append` / `Path.length` | `induction` on the second path, mirroring `Path.append` cases | Indexed inductive types over `Path` reduce by equation lemmas, not bare iota-reduction (see [Chapter 12](12-path-algebras/00-index.md)) |

## When reducing a concrete computation

| When you have ... | Try ... first | The idea |
| --- | --- | --- |
| a computation over `Nat`/`Int` numerals, `2 + 3 * 4 = 14` | `norm_num` | Decide the numeral arithmetic |
| a decidable atomic fact, `3 < 7`, `2 ≠ 1` | `decide`, `norm_num` | Run the decision procedure; `decide` on `Nat`/`Int` numerals |
| a linear-arithmetic inequality or a sum over a bounded index with numerals | `omega` | Decide linear integer arithmetic |
| any `Prop` over a finite type (`Fin 3`, `Bool`, `ZMod`) | `by decide` | Enumerate every case; each axiom closes (see [Chapter 9](09-rings/00-index.md)) |

---

Do not reach for a heavyweight tactic when a lighter one closes the
goal: `rfl` before `simp`, `exact` before `rw`, `constructor` before a
case analysis. The cheapest move that makes progress is almost always
the right one, and the [goal-state discipline of Chapter 13](13-working-efficiently/00-index.md)
is precisely to read what remains after that move.

---

[Table of contents](README.md)
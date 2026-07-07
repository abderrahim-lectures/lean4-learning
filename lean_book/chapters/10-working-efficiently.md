# Chapter 10: Working efficiently in Lean

Chapters 6 and 8 were about *finding* a proof by hand, deliberately slowly,
so the underlying reasoning is never hidden. This chapter is the other
half: once you understand *why* a proof works, how do you write it (and
find it) faster in day-to-day use? Efficient Lean is not "type less" — it's
knowing which automation to trust, when explicitness still pays for itself,
and how to structure lemmas so you're not re-deriving the same fact twice.

## Search tactics: let Lean find the lemma or the proof

You've been asked, throughout this book, to imagine hunting for a lemma
name. In practice you rarely do this by memory or grep. Two tactics
automate it:

- **`exact?`** — searches the whole environment (core Lean, and anything
  else imported) for a term that closes the *current goal exactly*. Run it,
  and it either fails, or suggests a working `exact ...` line you can paste
  in. Use it the moment you suspect "this exact fact must already exist
  somewhere" — e.g. after simplifying a ring goal down to something that
  *looks* like a named lemma but you can't recall the name.
- **`apply?`** — like `exact?` but for when the goal would be closed by
  `apply`ing something that leaves further subgoals, not a single exact
  match.

Both are search tools, not proof techniques — the proof they find is a
normal term, exactly like one you could have written by hand. It is
completely standard practice to prototype a proof with `exact?`/`apply?`,
inspect what it suggests, and paste in the concrete result rather than
leaving the search tactic itself in the finished proof (they're slower to
re-elaborate and, in a growing file, their result can silently change if the
environment changes).

```lean
example (a b : Nat) (h : a = b) : b = a := by
  exact?
  -- suggests: exact h.symm
```

## Decision procedures: `decide`, `omega`, `norm_num`

For goals that are *decidable* — where "true or false" can be settled by a
terminating algorithm rather than a hand-built argument — Lean has tactics
that just run that algorithm:

- **`decide`** — evaluates a `Decidable` proposition to `true`/`false`
  directly. Good for small, closed (no free variables) propositions, e.g.
  `(7 : Nat) ∣ 21` or `¬ (3 = 5)`. Do not reach for `decide` on propositions
  with free variables or unbounded search — it can time out or, worse,
  produce a correct but useless proof term that reveals nothing.
- **`omega`** — a decision procedure for linear arithmetic over `Nat`/`Int`
  (goals built from `+`, subtraction, `≤`, `<`, `=`, and multiplication by
  literals). If your goal is "some linear inequality/equality about
  integers," reach for `omega` before hand-deriving it — this is exactly
  the class of fact that a decision procedure handles better than a
  bespoke `rw` chain, and hand-deriving it teaches you nothing `omega`'s
  existence doesn't already convey.
- **`norm_num`** — normalizes and evaluates numerical expressions
  (arithmetic on concrete numerals, including some with `+`, `*`, `^`,
  `≤` on literals).

The judgment call: **use a decision procedure whenever the goal falls
entirely inside its decidable fragment; use explicit `rw`/`have` reasoning
whenever the goal is about a *general*, unspecified structure** (like an
arbitrary `Group G` or `Ring R`) where no decision procedure applies because
there's no concrete computation to run — only axioms to combine. Chapters 6
and 8's group/ring theorems are all of the second kind, which is exactly why
they needed hand-built proofs rather than `omega`.

## `simp`, now that you understand what it replaces

Chapter 4 asked you to avoid `simp` while learning, so that every step
stayed traceable. Once you understand *why* a family of rewrites works
(e.g. "additive identity/inverse cancellation," as in Chapter 8), `simp` is
the efficient way to apply a whole *battery* of such known-safe rewrites at
once, rather than spelling out each one:

```lean
-- Chapter 8 style (explicit, for learning):
theorem ex1 (n : Nat) : n + 0 = n := by
  exact Nat.add_zero n

-- Once the fact class is understood, in your own later proofs:
theorem ex2 (n : Nat) : n + 0 = n := by
  simp
```

A good discipline: the *first* time you meet a new kind of cancellation or
identity simplification, do it by hand with named lemmas (as this book
does throughout). After that, `simp` (optionally `simp [specific_lemma]` to
scope it, or `simp only [...]` to restrict exactly which lemmas fire) is the
appropriate everyday tool. Using `simp` from the start is how people end up
with proofs that compile but that nobody — including their author, a week
later — can explain.

## Term mode vs tactic mode

Every tactic-mode proof compiles down to a term (Chapter 3's style); the
choice between them is about which is more *readable* for the given proof,
not a fundamental difference in power:

- Prefer **term mode** for short proofs that are naturally a single
  expression: `theorem foo := h.symm`, `theorem bar := ⟨x, hx⟩`. Chapter 5's
  one-line group-axiom proofs are a good example of where tactic mode
  (`by intro a; exact ...`) is arguably *more* verbose than the term
  `fun a => Int.add_assoc a b c` would have been.
- Prefer **tactic mode** once a proof involves several sequential
  steps, case splits, or induction — anything where you'd want to inspect
  an intermediate goal state while writing it. Chapters 6 and 8's
  multi-step `rw` chains would be unreadable (and much harder to *write*)
  as raw terms.
- `have`/`show`/`suffices` inside tactic mode let you name and restate
  intermediate goals — use them liberally to keep a long proof's shape
  legible, exactly as Chapters 6 and 8 did throughout.

## Structuring lemmas for reuse

The single biggest efficiency gain, larger than any tactic choice: **prove
the general fact once, as its own named lemma, the moment you notice you'd
otherwise repeat an argument.** Chapter 6's `left_inverse_unique` is the
running example — Theorem 3 (`inv_op`) and this chapter's `neg_one_mul`,
`neg_mul` all reduce to it rather than re-deriving "uniqueness of inverses"
inline. Signs you should factor out a lemma:

- You find yourself about to repeat a `rw` chain you already wrote for a
  different (but structurally identical) goal — stop, and instead state
  the shared shape as its own `theorem`/`have`, then `apply`/`exact` it in
  both places.
- A sub-goal deep in a proof would itself be a reasonable, independently
  statable mathematical fact (e.g. "an element that equals its own double
  is zero," buried inside Chapter 8's `mul_zero`) — naming it is both more
  efficient *and* more readable, since the outer proof then reads as a
  short composition of named facts instead of one long undifferentiated
  chain.

This is the same judgment call you'd make writing ordinary code: extract a
helper when — and only when — you notice real duplication or a
genuinely separable sub-claim, not preemptively.

## Next

Continue to [Chapter 11: Where to go next](11-next-steps.md).

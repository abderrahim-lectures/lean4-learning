# Chapter 4: Tactics — the toolbox for proving things

Writing proof *terms* directly (as in Chapter 3) gets unwieldy fast. Instead,
Lean lets you enter **tactic mode** with `by`, where you manipulate a "goal"
step by step, similar to how you'd write a proof on paper. This chapter's
real subject is not the list of tactics below — it's **how to work a goal
you don't already know the proof of**, since that is the skill the rest of
the book exercises. The tactic reference is secondary; read it once, then
come back to it as needed.

## The goal state, and how to read it

Inside `by`, Lean shows you a **goal**: hypotheses above a horizontal line
(named, typed facts you're allowed to use), the statement to prove below
it. Each tactic transforms the goal — sometimes closing it, sometimes
splitting it into several smaller goals, sometimes just rewriting it into an
equivalent-looking but more tractable shape. Proving something in Lean is
almost entirely the skill of looking at the current goal and asking: *what
tactic changes this into something closer to solved?*

```lean
theorem two_plus_two : 2 + 2 = 4 := by
  rfl
```

Put your cursor after `by` in an editor with the Lean extension and you'll
see the goal:

```text
⊢ 2 + 2 = 4
```

No hypotheses, one goal. After `rfl` closes it, the goal panel shows "No
goals" — the proof is complete. **Get in the habit of checking the goal
state after every tactic**, not just at the end. This is the single biggest
difference between someone who can read a finished Lean proof and someone
who can write one: writing one means constantly asking "what does the goal
look like *now*, and what would make progress on *this exact shape*?"

## A worked strategy session, before any new tactics

Suppose you're asked to prove `(a b : Nat) → a + b = b + a` and you don't
yet know the proof. Here is the actual thought process, not the polished
result:

1. **Try the cheapest thing first.** `rfl` asks "do both sides already
   compute to the same normal form?" For `a + b = b + a` with `a`, `b`
   variables (not concrete numbers), the answer is no — `Nat.add` recurses
   on its *second* argument, so `a + b` and `b + a` don't reduce to a
   common form without knowing more about `a` and `b`. `rfl` fails with an
   error like "motive is not type correct" or "type mismatch" — that
   failure is *information*: it tells you the equality isn't definitional,
   so you need an actual argument, not just unfolding.
2. **Look for structure to induct or case-split on.** Both sides mention
   `a` and `b` as `Nat`s, and `Nat` is inductively defined (Chapter 1), so
   induction is the natural move — the question becomes *which* variable to
   induct on. Try `induction b` (recursion on `+`'s second argument
   suggests `b` is the one that unfolds cleanly).
3. **Read the two resulting goals.** After `induction b with | zero => _ | succ k ih => _`
   you get a `zero` goal, `a + 0 = 0 + a`, and a `succ` goal,
   `a + (k+1) = (k+1) + a` with hypothesis `ih : a + k = k + a` available.
   Neither is `rfl` on the nose (again check by trying it — if it fails,
   that's telling you a helper fact is missing), so each needs its own
   small rewrite, using lemmas about how `+` unfolds on `zero`/`succ`.
4. **Find the missing lemmas.** You don't need to have `Nat.add_succ` and
   `Nat.zero_add` memorized. In an editor, typing `rw [Nat.add_` and
   invoking autocomplete lists everything starting that way; alternatively
   `exact?` (Chapter 10) searches the whole environment for something that
   closes the current goal outright, and will often name exactly the
   lemma you need even if you can't guess its name.

This four-step loop — *try the cheap tactic, read why it failed, find
structure to split on, hunt for the specific lemma that matches the
resulting shape* — is the actual content of "knowing Lean." The worked-out
proof at the end of this chapter, and every proof in Chapters 5–9, is the
*output* of this loop; watch for the loop, not just the output.

## Core tactics

### `intro`: introduce a hypothesis or variable

```lean
theorem modus_ponens {P Q : Prop} : (P → Q) → P → Q := by
  intro hpq hp
  exact hpq hp
```

### `exact`: close the goal with an exact term

Used above. If you have a term that proves the goal exactly, `exact` finishes it.

### `apply`: apply a function/lemma, leaving new goals for its arguments

```lean
theorem apply_example {P Q : Prop} (hpq : P → Q) (hp : P) : Q := by
  apply hpq
  exact hp
```

### `rw`: rewrite using an equality

```lean
theorem rw_example (a b : Nat) (h : a = b) : a + 1 = b + 1 := by
  rw [h]
```

`rw [h]` replaces every occurrence of the left-hand side of `h` with its
right-hand side in the goal.

### Reading a tactic failure

Every tactic either makes progress or produces an error, and the error
message is almost always telling you exactly what to do next — treat it as
a diagnostic, not a dead end.

- `rw [h]` where `h : a = b` but the goal doesn't literally contain `a`
  fails with **"motive is not type correct"** or "did not find instance of
  the pattern" — meaning: the exact syntactic term `a` you're rewriting
  doesn't occur in the goal as written. Fix: `#check` (or hover in the
  editor) the goal's actual statement — it's common for a definition to be
  unfolded differently than you expect, so the term you want to rewrite is
  hiding behind a `def` that needs `unfold` or `show` first.
- `exact e` where `e`'s type doesn't match the goal fails with a **type
  mismatch**, printing both the expected and the actual type side by side.
  Read the diff between them; it almost always identifies one wrong
  argument or a missing `.symm`.
- `apply f` where `f`'s conclusion doesn't unify with the goal fails
  similarly, but *before* investing effort in `apply`, use `#check f` to see
  its full type — this tells you exactly what subgoals `apply` would leave,
  before you commit to the tactic.
- A tactic that produces **no error but doesn't close the goal** is not a
  failure — check the resulting goal state (in the editor, or with
  `sorry` in place of the rest of the proof, which type-checks with a
  warning and lets you inspect exactly what's left).

`sorry` deserves a special mention: it is a placeholder that closes any
goal instantly but marks the theorem as unproved (Lean prints a warning,
and any downstream proof depending on it inherits the taint). Use it
constantly while exploring — write the skeleton of a multi-step proof with
`sorry` at each unfinished branch, check that the overall *shape* type-checks,
then fill in branches one at a time. This is normal practice, not a hack.

### `simp`: simplify using known simplification lemmas

```lean
theorem simp_example (n : Nat) : n + 0 = n := by
  simp
```

`simp` automatically searches for known "simplification" lemmas and applies
them, possibly many at once. This is convenient, but it hides *which* facts
were used and *why* the proof works — bad for learning. **In this book we
avoid `simp` and `rfl`-as-a-shortcut wherever the point is to understand the
proof.** We'll instead use explicit `rw` steps naming exactly which equality
justifies each step, and `induction` with a fully spelled-out base case and
inductive step. Treat `simp` as a tool for your *own* later proofs once you
already understand what it would have done by hand.

### `constructor`: build a structure/And/Iff by its constructor

```lean
theorem and_example (P Q : Prop) (hp : P) (hq : Q) : P ∧ Q := by
  constructor
  · exact hp
  · exact hq
```

The `·` (focus dot) lets you address each remaining goal one at a time.

### `cases`: case-split on an inductive value or hypothesis

```lean
theorem or_comm_ex {P Q : Prop} (h : P ∨ Q) : Q ∨ P := by
  cases h with
  | inl hp => exact Or.inr hp
  | inr hq => exact Or.inl hq
```

### `induction`: proof by induction on a `Nat` (or other inductive type)

```lean
theorem add_zero_left (n : Nat) : 0 + n = n := by
  induction n with
  | zero => rfl
  | succ k ih =>
    show 0 + (k + 1) = k + 1
    rw [Nat.add_succ, ih]
```

This mirrors the mathematical principle of induction:

$$
P(0) \;\land\; \big(\forall k,\ P(k) \to P(k+1)\big) \;\implies\; \forall n,\ P(n)
$$

`ih` (induction hypothesis) is exactly $P(k)$, available to prove $P(k+1)$.

### `unfold`: unfold a definition

```lean
def isZero (n : Nat) : Prop := n = 0

theorem isZero_zero : isZero 0 := by
  unfold isZero
```

## A worked example: proving `Nat.add` is commutative from scratch

We want to show, for all `a b : Nat`, that `a + b = b + a`. Recall from
Chapter 1 that `Nat` is built from `zero` and `succ` (successor), and that
`+` is *defined* by recursion on its second argument:

$$
a + 0 = a, \qquad a + \mathrm{succ}(k) = \mathrm{succ}(a + k)
$$

We proceed by induction on `b`, one step at a time.

**Base case (`b = 0`).** The goal becomes `a + 0 = 0 + a`.

- The left side, `a + 0`, reduces to `a` directly from the definition of `+`
  above (this fact is recorded in core Lean as the lemma `Nat.add_zero`).
- The right side, `0 + a`, is *not* immediate from the definition (the
  recursion is on the second argument, not the first), so it needs its own
  small lemma, `Nat.zero_add : 0 + a = a`, proved separately by induction on
  `a`.
- Putting both together: `a + 0 = a` and `0 + a = a`, so `a + 0 = 0 + a`.

```lean
theorem my_add_comm (a b : Nat) : a + b = b + a := by
  induction b with
  | zero =>
    -- Goal: a + 0 = 0 + a
    rw [Nat.add_zero]   -- rewrites `a + 0` to `a`. Goal: a = 0 + a
    rw [Nat.zero_add]    -- rewrites `0 + a` to `a`. Goal: a = a, closed by rw automatically
  | succ k ih =>
    -- ih : a + k = k + a
    -- Goal: a + Nat.succ k = Nat.succ k + a
    rw [Nat.add_succ]     -- a + succ k  ~>  succ (a + k). Goal: succ (a + k) = succ k + a
    rw [ih]                -- use the induction hypothesis: a + k ~> k + a. Goal: succ (k + a) = succ k + a
    rw [Nat.succ_add]      -- succ k + a  ~>  succ (k + a). Goal: succ (k + a) = succ (k + a), closed
```

Walking through the inductive step slowly:

1. We are trying to prove the statement for `b = Nat.succ k`, assuming it
   already holds for `k` (that assumption is `ih : a + k = k + a`).
2. `rw [Nat.add_succ]` uses the defining equation `a + succ k = succ (a + k)`
   to rewrite the left-hand side of the goal.
3. `rw [ih]` uses the induction hypothesis to replace `a + k` with `k + a`
   inside the goal.
4. `rw [Nat.succ_add]` uses the equation `succ k + a = succ (k + a)` to
   rewrite the right-hand side, so both sides now read `succ (k + a)`,
   literally identical — `rw` closes the goal automatically once the two
   sides match syntactically.

This is the pattern — base case, inductive step, explicit `ih` — that we
will reuse, slowly and explicitly, for every proof about groups and rings.

## Exercises

1. Prove `theorem and_comm_tac {P Q : Prop} (h : P ∧ Q) : Q ∧ P := by ...`
   using `constructor`, `h.left`, `h.right`.
2. Prove `theorem nat_mul_zero (n : Nat) : n * 0 = 0 := by rfl` — check
   whether `rfl` alone works, and if not, use `induction`.
3. Rewrite the `modus_ponens` proof from Chapter 3 in tactic mode.

## Next

With definitions, propositions, and tactics in hand, we're ready for the
main event: [Chapter 5: Defining a `Group`](05-groups.md).

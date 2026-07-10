## The goal state, and how to read it

[← Index](00-index.md) | [Next: Core tactics →](02-core-tactics.md)

---

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
goals" — the proof is complete.

**Mathematical reading.** A goal $\Gamma \vdash G$ is a *sequent*: the
hypotheses $\Gamma = (h_1 : A_1, \ldots, h_n : A_n)$ above the line are the
ambient assumptions, and $G$ below the line is what remains to be shown. A
tactic is a backward inference rule that replaces the current sequent with
zero or more simpler sequents whose proofs suffice for it — reading the
proof bottom-up is exactly the mathematician's "it suffices to show...".
Closing all goals means the derivation tree is complete, i.e. a term $g : G$
has been constructed. Here the tree is a single leaf: $\vdash 2+2=4$
discharged by definitional computation.

> Read more: if "sequent," "backward inference rule," or "derivation tree"
> are new, [Appendix B §0](../15-lambda-calculus/00-standard-logic.md)
> recaps natural deduction — the standard proof system these words
> describe — from scratch, with no Lean involved.

**Get in the habit of checking the goal
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
   `exact?` (Chapter 12) searches the whole environment for something that
   closes the current goal outright, and will often name exactly the
   lemma you need even if you can't guess its name.

This four-step loop — *try the cheap tactic, read why it failed, find
structure to split on, hunt for the specific lemma that matches the
resulting shape* — is the actual content of "knowing Lean." The worked-out
proof later in this chapter, and every proof in Chapters 5–9, is the
*output* of this loop; watch for the loop, not just the output.

---

[← Index](00-index.md) | [Next: Core tactics →](02-core-tactics.md)

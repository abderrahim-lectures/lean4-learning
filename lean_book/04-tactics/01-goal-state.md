## The goal state, and how to read it

[← Index](00-index.md) | [Next: Core tactics →](02-core-tactics.md)

---

Inside `by`, Lean shows you a **goal**: hypotheses above a horizontal line
(named, typed facts you're allowed to use), and the statement to prove below
it. Each tactic changes the goal. Sometimes it closes the goal, sometimes it
splits it into several smaller goals, and sometimes it just rewrites it into an
equivalent but easier-to-handle shape. Proving something in Lean is
mostly the skill of looking at the current goal and asking: *what
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
goals". The proof is complete.

**Mathematical reading.** A goal is what logicians call a *sequent*: a
list of hypotheses together with a statement to prove from them. A tactic
is a *backward inference rule*. It replaces the current goal with zero or
more simpler goals whose proofs would be enough to prove it. This is
exactly the mathematician's habit of saying "it suffices to show...".
Closing every goal means you've built a complete chain of such steps down
to something already known. Here, that chain is just one step: `2 + 2 = 4` by
plain computation.

> Read more: if "sequent" or "backward inference rule" are new,
> [Appendix B §0](../15-lambda-calculus/00-standard-logic.md) recaps
> natural deduction — the standard proof system these words describe,
> turnstile notation and all — from scratch, with no Lean involved.

**Get in the habit of checking the goal
state after every tactic**, not just at the end. This is the biggest
difference between someone who can read a finished Lean proof and someone
who can write one. Writing one means constantly asking "what does the goal
look like *now*, and what would make progress on *this exact shape*?"

## A worked strategy session, before any new tactics

Suppose you're asked to prove `(a b : Nat) → a + b = b + a` and you don't
yet know the proof. Here is the actual thought process, not the polished
result:

1. **Try the cheapest thing first.** `rfl` asks "do both sides already
   compute to the same normal form?" For `a + b = b + a` with `a`, `b`
   as variables (not concrete numbers), the answer is no. `Nat.add` recurses
   on its *second* argument, so `a + b` and `b + a` don't reduce to a
   common form without knowing more about `a` and `b`. `rfl` fails with an
   error like "motive is not type correct" or "type mismatch". That
   failure is *information*: it tells you the equality isn't definitional,
   so you need an actual argument, not just unfolding.
2. **Look for structure to induct or case-split on.** Both sides mention
   `a` and `b` as `Nat`s, and `Nat` is inductively defined (Chapter 1), so
   induction is the natural move. The question becomes *which* variable to
   induct on. Try `induction b` (recursion on `+`'s second argument
   suggests `b` is the one that unfolds cleanly).
3. **Read the two resulting goals.** After `induction b with | zero => _ | succ k ih => _`
   you get a `zero` goal, `a + 0 = 0 + a`, and a `succ` goal,
   `a + (k+1) = (k+1) + a` with hypothesis `ih : a + k = k + a` available.
   Neither is `rfl` on the nose (again, check by trying it. If it fails,
   that tells you a helper fact is missing), so each needs its own
   small rewrite, using lemmas about how `+` unfolds on `zero`/`succ`.

   This is exactly what the editor shows you, live, as you work: the
   cursor sits right before `rw [Nat.add_succ]` in the `succ` case, and
   the **Lean Infoview** panel on the right lists the hypotheses
   (`a k : Nat`, `ih : a + k = k + a`) above the line and the current goal
   (`a + (k + 1) = k + 1 + a`) below it — precisely the "hypotheses above
   a horizontal line, goal below it" picture described above, not just a
   text mock-up of it:

   ![The Lean Infoview panel in VS Code, showing the tactic state (hypotheses `a k : Nat`, `ih : a + k = k + a`, goal `a + (k + 1) = k + 1 + a`) for the `succ` case of `my_add_comm`'s induction.](images/goal-state-infoview.png)
4. **Find the missing lemmas.** You don't need to have `Nat.add_succ` and
   `Nat.zero_add` memorized. In an editor, typing `rw [Nat.add_` and
   using autocomplete lists everything starting that way. Or you can use
   `exact?` (Chapter 12), which searches the whole environment for something that
   closes the current goal outright, and will often name exactly the
   lemma you need even if you can't guess its name.

This four-step loop — *try the cheap tactic, read why it failed, find
structure to split on, hunt for the specific lemma that matches the
resulting shape* — is the real content of "knowing Lean." The worked-out
proof later in this chapter, and every proof in Chapters 5–9, is the
*output* of this loop. Watch for the loop, not just the output.

---

[← Index](00-index.md) | [Next: Core tactics →](02-core-tactics.md)

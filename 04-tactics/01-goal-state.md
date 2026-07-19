## The goal state, and how to read it

[← Index](00-index.md) | [Next: Core tactics →](02-core-tactics.md)

---

Inside `by`, Lean displays a **goal**: hypotheses above a horizontal line
(named, typed facts available for use), and the statement to prove below
it. Each tactic changes the goal. Sometimes it closes the goal, sometimes it
splits it into several smaller goals, and sometimes it merely rewrites it into an
equivalent but easier-to-handle shape. Proving something in Lean is
mostly the skill of examining the current goal and asking: *what
tactic changes this into something closer to solved?*

<p><a href="https://live.lean-lang.org/#code=namespace%20Ch04Tactics%0A%0Atheorem%20two_plus_two%20%3A%202%20%2B%202%20%3D%204%20%3A%3D%20by%0A%20%20rfl" target="_blank" rel="noopener">&#8599; Open in Lean playground (new tab)</a></p>
<iframe src="https://live.lean-lang.org/#code=namespace%20Ch04Tactics%0A%0Atheorem%20two_plus_two%20%3A%202%20%2B%202%20%3D%204%20%3A%3D%20by%0A%20%20rfl" title="Lean playground" loading="lazy" style="width:100%;height:180px;border:1px solid #ccc;border-radius:8px;">
</iframe>

Placing the cursor after `by` in an editor with the Lean extension shows
the goal:

```text
⊢ 2 + 2 = 4
```

No hypotheses, one goal. After [`rfl`](https://lean-lang.org/doc/reference/latest/Tactic-Proofs/Tactic-Reference/) closes it, the goal panel shows "No
goals". The proof is complete.

**Mathematical reading.** A goal is what logicians call a *sequent*: a
list of hypotheses together with a statement to prove from them. A tactic
is a *backward inference rule*. It replaces the current goal with zero or
more simpler goals whose proofs would be enough to prove it. This is
exactly the mathematician's habit of saying "it suffices to show...".
Closing every goal means a complete chain of such steps has been built down
to something already known. Here, that chain is just one step: `2 + 2 = 4` by
plain computation.

> Read more: if "sequent" or "backward inference rule" are new,
> [Chapter 3 §2](../03-propositions-and-proofs/02-logic-recap.md) recaps
> natural deduction — the standard proof system these words describe,
> turnstile notation and all — from scratch, with no Lean involved.

**The goal state should be checked after every tactic**, not just at the
end. This is the chief difference between someone who can read a finished
Lean proof and someone who can write one. Writing one requires constantly
asking "what does the goal look like *now*, and what would make progress
on *this exact shape*?"

## A worked strategy session, before any new tactics

Suppose the task is to prove `(a b : Nat) → a + b = b + a`, with the proof
not yet known. What follows is the actual thought process, not the
polished result.

1. **Try the cheapest thing first.** `rfl` asks "do both sides already
   compute to the same normal form?" For `a + b = b + a` with `a`, `b`
   as variables (not concrete numbers), the answer is no. `Nat.add` recurses
   on its *second* argument, so `a + b` and `b + a` do not reduce to a
   common form without knowing more about `a` and `b`. `rfl` fails with an
   error such as "motive is not type correct" or "type mismatch." That
   failure is *information*: it indicates the equality is not definitional,
   hence an actual argument is required, not just unfolding.
2. **Look for structure to induct or case-split on.** Both sides mention
   `a` and `b` as `Nat`s, and `Nat` is inductively defined (Chapter 1), so
   induction is the natural move. The question becomes *which* variable to
   induct on. Trying [`induction b`](https://lean-lang.org/doc/reference/latest/Tactic-Proofs/Tactic-Reference/) is suggested by the recursion on `+`'s
   second argument, since `b` is the one that unfolds cleanly.
3. **Read the two resulting goals.** After `induction b with | zero => _ | succ k ih => _`
   there is a `zero` goal, `a + 0 = 0 + a`, and a `succ` goal,
   `a + (k+1) = (k+1) + a` with hypothesis `ih : a + k = k + a` available.
   Neither is `rfl` on the nose (again, this is checked by trying it; if it fails,
   that indicates a helper fact is missing), so each needs its own
   small rewrite, using lemmas about how `+` unfolds on `zero`/`succ`.

   This is exactly what the editor shows, live, as the proof is worked: the
   cursor sits right before `rw [Nat.add_succ]` in the `succ` case, and
   the **Lean Infoview** panel on the right lists the hypotheses
   (`a k : Nat`, `ih : a + k = k + a`) above the line and the current goal
   (`a + (k + 1) = k + 1 + a`) below it — precisely the "hypotheses above
   a horizontal line, goal below it" picture described above, not merely a
   text mock-up of it:

   ![The Lean Infoview panel in VS Code, showing the tactic state (hypotheses `a k : Nat`, `ih : a + k = k + a`, goal `a + (k + 1) = k + 1 + a`) for the `succ` case of `my_add_comm`'s induction.](images/goal-state-infoview.png)
4. **Find the missing lemmas.** `Nat.add_succ` and `Nat.zero_add` need not
   be memorized. In an editor, typing `rw [Nat.add_` and
   using autocomplete lists everything starting that way. Alternatively,
   [`exact?`](https://lean-lang.org/doc/reference/latest/Tactic-Proofs/Tactic-Reference/) (Chapter 12), searches the whole environment for something that
   closes the current goal outright, and will often name exactly the
   lemma required even when its name cannot be guessed.

This four-step loop — *try the cheap tactic, determine why it failed, find
structure to split on, locate the specific lemma matching the
resulting shape* — is the real content of "knowing Lean." The worked-out
proof later in this chapter, and every proof in Chapters 5–9, is the
*output* of this loop. What matters is the loop, not merely the output.

---

[← Index](00-index.md) | [Next: Core tactics →](02-core-tactics.md)

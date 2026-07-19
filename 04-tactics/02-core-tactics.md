## Core tactics

[← Goal state](01-goal-state.md) | [Index](00-index.md) | [Next: Reading a tactic failure →](03-reading-failures.md)

---

### [`intro`](https://lean-lang.org/doc/reference/latest/Tactic-Proofs/Tactic-Reference/): introduce a hypothesis or variable

<p><a href="https://live.lean-lang.org/#code=namespace%20Ch04Tactics%0A%0Atheorem%20two_plus_two%20%3A%202%20%2B%202%20%3D%204%20%3A%3D%20by%0A%20%20rfl%0A%0Atheorem%20modus_ponens%20%7BP%20Q%20%3A%20Prop%7D%20%3A%20%28P%20%E2%86%92%20Q%29%20%E2%86%92%20P%20%E2%86%92%20Q%20%3A%3D%20by%0A%20%20intro%20hpq%20hp%0A%20%20exact%20hpq%20hp" target="_blank" rel="noopener">&#8599; Open in Lean playground (new tab)</a></p>
<iframe src="https://live.lean-lang.org/#code=namespace%20Ch04Tactics%0A%0Atheorem%20two_plus_two%20%3A%202%20%2B%202%20%3D%204%20%3A%3D%20by%0A%20%20rfl%0A%0Atheorem%20modus_ponens%20%7BP%20Q%20%3A%20Prop%7D%20%3A%20%28P%20%E2%86%92%20Q%29%20%E2%86%92%20P%20%E2%86%92%20Q%20%3A%3D%20by%0A%20%20intro%20hpq%20hp%0A%20%20exact%20hpq%20hp" title="Lean playground" loading="lazy" style="width:100%;height:180px;border:1px solid #ccc;border-radius:8px;">
</iframe>

### [`exact`](https://lean-lang.org/doc/reference/latest/Tactic-Proofs/Tactic-Reference/): close the goal with an exact term

Used above. Given a term that proves the goal exactly, `exact` finishes it.

### [`apply`](https://lean-lang.org/doc/reference/latest/Tactic-Proofs/Tactic-Reference/): apply a function/lemma, leaving new goals for its arguments

<p><a href="https://live.lean-lang.org/#code=namespace%20Ch04Tactics%0A%0Atheorem%20two_plus_two%20%3A%202%20%2B%202%20%3D%204%20%3A%3D%20by%0A%20%20rfl%0A%0Atheorem%20modus_ponens%20%7BP%20Q%20%3A%20Prop%7D%20%3A%20%28P%20%E2%86%92%20Q%29%20%E2%86%92%20P%20%E2%86%92%20Q%20%3A%3D%20by%0A%20%20intro%20hpq%20hp%0A%20%20exact%20hpq%20hp%0A%0Atheorem%20apply_example%20%7BP%20Q%20%3A%20Prop%7D%20%28hpq%20%3A%20P%20%E2%86%92%20Q%29%20%28hp%20%3A%20P%29%20%3A%20Q%20%3A%3D%20by%0A%20%20apply%20hpq%0A%20%20exact%20hp" target="_blank" rel="noopener">&#8599; Open in Lean playground (new tab)</a></p>
<iframe src="https://live.lean-lang.org/#code=namespace%20Ch04Tactics%0A%0Atheorem%20two_plus_two%20%3A%202%20%2B%202%20%3D%204%20%3A%3D%20by%0A%20%20rfl%0A%0Atheorem%20modus_ponens%20%7BP%20Q%20%3A%20Prop%7D%20%3A%20%28P%20%E2%86%92%20Q%29%20%E2%86%92%20P%20%E2%86%92%20Q%20%3A%3D%20by%0A%20%20intro%20hpq%20hp%0A%20%20exact%20hpq%20hp%0A%0Atheorem%20apply_example%20%7BP%20Q%20%3A%20Prop%7D%20%28hpq%20%3A%20P%20%E2%86%92%20Q%29%20%28hp%20%3A%20P%29%20%3A%20Q%20%3A%3D%20by%0A%20%20apply%20hpq%0A%20%20exact%20hp" title="Lean playground" loading="lazy" style="width:100%;height:180px;border:1px solid #ccc;border-radius:8px;">
</iframe>

### [`rw`](https://lean-lang.org/doc/reference/latest/Tactic-Proofs/Tactic-Reference/): rewrite using an equality

<p><a href="https://live.lean-lang.org/#code=namespace%20Ch04Tactics%0A%0Atheorem%20two_plus_two%20%3A%202%20%2B%202%20%3D%204%20%3A%3D%20by%0A%20%20rfl%0A%0Atheorem%20modus_ponens%20%7BP%20Q%20%3A%20Prop%7D%20%3A%20%28P%20%E2%86%92%20Q%29%20%E2%86%92%20P%20%E2%86%92%20Q%20%3A%3D%20by%0A%20%20intro%20hpq%20hp%0A%20%20exact%20hpq%20hp%0A%0Atheorem%20apply_example%20%7BP%20Q%20%3A%20Prop%7D%20%28hpq%20%3A%20P%20%E2%86%92%20Q%29%20%28hp%20%3A%20P%29%20%3A%20Q%20%3A%3D%20by%0A%20%20apply%20hpq%0A%20%20exact%20hp%0A%0Atheorem%20rw_example%20%28a%20b%20%3A%20Nat%29%20%28h%20%3A%20a%20%3D%20b%29%20%3A%20a%20%2B%201%20%3D%20b%20%2B%201%20%3A%3D%20by%0A%20%20rw%20%5Bh%5D" target="_blank" rel="noopener">&#8599; Open in Lean playground (new tab)</a></p>
<iframe src="https://live.lean-lang.org/#code=namespace%20Ch04Tactics%0A%0Atheorem%20two_plus_two%20%3A%202%20%2B%202%20%3D%204%20%3A%3D%20by%0A%20%20rfl%0A%0Atheorem%20modus_ponens%20%7BP%20Q%20%3A%20Prop%7D%20%3A%20%28P%20%E2%86%92%20Q%29%20%E2%86%92%20P%20%E2%86%92%20Q%20%3A%3D%20by%0A%20%20intro%20hpq%20hp%0A%20%20exact%20hpq%20hp%0A%0Atheorem%20apply_example%20%7BP%20Q%20%3A%20Prop%7D%20%28hpq%20%3A%20P%20%E2%86%92%20Q%29%20%28hp%20%3A%20P%29%20%3A%20Q%20%3A%3D%20by%0A%20%20apply%20hpq%0A%20%20exact%20hp%0A%0Atheorem%20rw_example%20%28a%20b%20%3A%20Nat%29%20%28h%20%3A%20a%20%3D%20b%29%20%3A%20a%20%2B%201%20%3D%20b%20%2B%201%20%3A%3D%20by%0A%20%20rw%20%5Bh%5D" title="Lean playground" loading="lazy" style="width:100%;height:180px;border:1px solid #ccc;border-radius:8px;">
</iframe>

`rw [h]` replaces every occurrence of the left-hand side of `h` with its
right-hand side in the goal.

### `rw [...] at h`: rewrite a hypothesis instead of the goal

<p><a href="https://live.lean-lang.org/#code=namespace%20Ch04Tactics%0A%0Atheorem%20two_plus_two%20%3A%202%20%2B%202%20%3D%204%20%3A%3D%20by%0A%20%20rfl%0A%0Atheorem%20modus_ponens%20%7BP%20Q%20%3A%20Prop%7D%20%3A%20%28P%20%E2%86%92%20Q%29%20%E2%86%92%20P%20%E2%86%92%20Q%20%3A%3D%20by%0A%20%20intro%20hpq%20hp%0A%20%20exact%20hpq%20hp%0A%0Atheorem%20apply_example%20%7BP%20Q%20%3A%20Prop%7D%20%28hpq%20%3A%20P%20%E2%86%92%20Q%29%20%28hp%20%3A%20P%29%20%3A%20Q%20%3A%3D%20by%0A%20%20apply%20hpq%0A%20%20exact%20hp%0A%0Atheorem%20rw_example%20%28a%20b%20%3A%20Nat%29%20%28h%20%3A%20a%20%3D%20b%29%20%3A%20a%20%2B%201%20%3D%20b%20%2B%201%20%3A%3D%20by%0A%20%20rw%20%5Bh%5D%0A%0Atheorem%20rw_at_example%20%28a%20b%20c%20%3A%20Nat%29%20%28h1%20%3A%20a%20%3D%20b%29%20%28h2%20%3A%20a%20%2B%20c%20%3D%2010%29%20%3A%20b%20%2B%20c%20%3D%2010%20%3A%3D%20by%0A%20%20rw%20%5Bh1%5D%20at%20h2%0A%20%20exact%20h2" target="_blank" rel="noopener">&#8599; Open in Lean playground (new tab)</a></p>
<iframe src="https://live.lean-lang.org/#code=namespace%20Ch04Tactics%0A%0Atheorem%20two_plus_two%20%3A%202%20%2B%202%20%3D%204%20%3A%3D%20by%0A%20%20rfl%0A%0Atheorem%20modus_ponens%20%7BP%20Q%20%3A%20Prop%7D%20%3A%20%28P%20%E2%86%92%20Q%29%20%E2%86%92%20P%20%E2%86%92%20Q%20%3A%3D%20by%0A%20%20intro%20hpq%20hp%0A%20%20exact%20hpq%20hp%0A%0Atheorem%20apply_example%20%7BP%20Q%20%3A%20Prop%7D%20%28hpq%20%3A%20P%20%E2%86%92%20Q%29%20%28hp%20%3A%20P%29%20%3A%20Q%20%3A%3D%20by%0A%20%20apply%20hpq%0A%20%20exact%20hp%0A%0Atheorem%20rw_example%20%28a%20b%20%3A%20Nat%29%20%28h%20%3A%20a%20%3D%20b%29%20%3A%20a%20%2B%201%20%3D%20b%20%2B%201%20%3A%3D%20by%0A%20%20rw%20%5Bh%5D%0A%0Atheorem%20rw_at_example%20%28a%20b%20c%20%3A%20Nat%29%20%28h1%20%3A%20a%20%3D%20b%29%20%28h2%20%3A%20a%20%2B%20c%20%3D%2010%29%20%3A%20b%20%2B%20c%20%3D%2010%20%3A%3D%20by%0A%20%20rw%20%5Bh1%5D%20at%20h2%0A%20%20exact%20h2" title="Lean playground" loading="lazy" style="width:100%;height:180px;border:1px solid #ccc;border-radius:8px;">
</iframe>

Every `rw` seen so far rewrites the *goal*. Adding `at h` instead
rewrites a *hypothesis* `h`, in place, using the same left-to-right
substitution rule. This is just as common as rewriting the goal itself.
Chapter 9's ring proofs, for instance, use `rw [...] at h1`/`at h2`
repeatedly to reshape a hypothesis into the exact form needed before
citing it with `exact`. Read `rw [h1] at h2` as "wherever `h1`'s left side
appears inside `h2`, replace it with `h1`'s right side." The direction
and substitution rule are identical to ordinary `rw`. Only the *target*
(a named hypothesis, not the goal) is different.

**Mathematical reading.** Each tactic corresponds to a standard proof move.
`intro` discharges an implication/universal by the deduction theorem: to
prove $A \to B$, *assume* $A$ as a new hypothesis and prove $B$. This is the
$\lambda$-abstraction rule. `exact e` supplies a finished term: "this is
precisely our claim." `apply f` is backward chaining: to prove the
conclusion of $f : A_1 \to \cdots \to A_n \to G$, it suffices to prove the
premises $A_1, \ldots, A_n$, which become the new goals. This is the working
mathematician's "by $f$, it remains to check the hypotheses of $f$." `rw [h]`
with $h : a = b$ is substitution of equals for equals (Leibniz): every
occurrence of $a$ in the goal is replaced by $b$. This is justified because $a = b$
makes the old and new goals equivalent.

> Read more: "deduction theorem" and "$\lambda$-abstraction rule" are two
> names for the same rule. "Deduction theorem" names the $\Rightarrow$-intro
> rule from natural deduction, stated in
> [Chapter 3 §2](../03-propositions-and-proofs/02-logic-recap.md).
> "$\lambda$-abstraction rule" names that same rule's Curry–Howard reading
> as a Lean `fun`, part of the typed $\lambda$-calculus formalized in
> [Chapter 5 §3](../05-rigor-check/03-typing-rules-and-safety.md).

---

[← Goal state](01-goal-state.md) | [Index](00-index.md) | [Next: Reading a tactic failure →](03-reading-failures.md)

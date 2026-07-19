## And, Or, Not

[← Implication](04-implication.md) | [Index](00-index.md) | [Next: Quantifiers →](06-quantifiers.md)

---

<p><a href="https://live.lean-lang.org/#code=namespace%20Ch03Propositions%0A%0A%23check%20%282%20%2B%202%20%3D%204%29%20%20%20%20%20--%202%20%2B%202%20%3D%204%20%3A%20Prop%0A%0Aexample%20%3A%202%20%2B%202%20%3D%204%20%3A%3D%20rfl%0A%0Atheorem%20two_plus_two%20%3A%202%20%2B%202%20%3D%204%20%3A%3D%20rfl%0A%0Atheorem%20add_comm_example%20%3A%202%20%2B%203%20%3D%203%20%2B%202%20%3A%3D%20rfl%0A%0Atheorem%20modus_ponens%20%7BP%20Q%20%3A%20Prop%7D%20%28hpq%20%3A%20P%20%E2%86%92%20Q%29%20%28hp%20%3A%20P%29%20%3A%20Q%20%3A%3D%0A%20%20hpq%20hp%0A%0A--%20And%0Atheorem%20and_example%20%7BP%20Q%20%3A%20Prop%7D%20%28hp%20%3A%20P%29%20%28hq%20%3A%20Q%29%20%3A%20P%20%E2%88%A7%20Q%20%3A%3D%0A%20%20%E2%9F%A8hp%2C%20hq%E2%9F%A9%0A%0Atheorem%20and_left%20%7BP%20Q%20%3A%20Prop%7D%20%28h%20%3A%20P%20%E2%88%A7%20Q%29%20%3A%20P%20%3A%3D%0A%20%20h.left%0A%0Atheorem%20and_comm_term%20%7BP%20Q%20%3A%20Prop%7D%20%28h%20%3A%20P%20%E2%88%A7%20Q%29%20%3A%20Q%20%E2%88%A7%20P%20%3A%3D%0A%20%20%E2%9F%A8h.right%2C%20h.left%E2%9F%A9" target="_blank" rel="noopener">&#8599; Open in Lean playground (new tab)</a></p>
<iframe src="https://live.lean-lang.org/#code=namespace%20Ch03Propositions%0A%0A%23check%20%282%20%2B%202%20%3D%204%29%20%20%20%20%20--%202%20%2B%202%20%3D%204%20%3A%20Prop%0A%0Aexample%20%3A%202%20%2B%202%20%3D%204%20%3A%3D%20rfl%0A%0Atheorem%20two_plus_two%20%3A%202%20%2B%202%20%3D%204%20%3A%3D%20rfl%0A%0Atheorem%20add_comm_example%20%3A%202%20%2B%203%20%3D%203%20%2B%202%20%3A%3D%20rfl%0A%0Atheorem%20modus_ponens%20%7BP%20Q%20%3A%20Prop%7D%20%28hpq%20%3A%20P%20%E2%86%92%20Q%29%20%28hp%20%3A%20P%29%20%3A%20Q%20%3A%3D%0A%20%20hpq%20hp%0A%0A--%20And%0Atheorem%20and_example%20%7BP%20Q%20%3A%20Prop%7D%20%28hp%20%3A%20P%29%20%28hq%20%3A%20Q%29%20%3A%20P%20%E2%88%A7%20Q%20%3A%3D%0A%20%20%E2%9F%A8hp%2C%20hq%E2%9F%A9%0A%0Atheorem%20and_left%20%7BP%20Q%20%3A%20Prop%7D%20%28h%20%3A%20P%20%E2%88%A7%20Q%29%20%3A%20P%20%3A%3D%0A%20%20h.left%0A%0Atheorem%20and_comm_term%20%7BP%20Q%20%3A%20Prop%7D%20%28h%20%3A%20P%20%E2%88%A7%20Q%29%20%3A%20Q%20%E2%88%A7%20P%20%3A%3D%0A%20%20%E2%9F%A8h.right%2C%20h.left%E2%9F%A9" title="Lean playground" loading="lazy" style="width:100%;height:250px;border:1px solid #ccc;border-radius:8px;">
</iframe>

- `∧` (And) is a structure with two fields `left` and `right`. `⟨hp, hq⟩`
  is the same "here are the pieces, in order" anonymous-constructor
  shorthand from
  [Chapter 2 §1](../02-functions-and-structures/01-structure-basics.md).
  Since the goal is `P ∧ Q`, Lean infers that
  `⟨hp, hq⟩` must mean "build the `And` from a proof of `P` and a proof of
  `Q`," in that order, with no need to spell out `And.intro hp hq`.

<p><a href="https://live.lean-lang.org/#code=namespace%20Ch03Propositions%0A%0A%23check%20%282%20%2B%202%20%3D%204%29%20%20%20%20%20--%202%20%2B%202%20%3D%204%20%3A%20Prop%0A%0Aexample%20%3A%202%20%2B%202%20%3D%204%20%3A%3D%20rfl%0A%0Atheorem%20two_plus_two%20%3A%202%20%2B%202%20%3D%204%20%3A%3D%20rfl%0A%0Atheorem%20add_comm_example%20%3A%202%20%2B%203%20%3D%203%20%2B%202%20%3A%3D%20rfl%0A%0Atheorem%20modus_ponens%20%7BP%20Q%20%3A%20Prop%7D%20%28hpq%20%3A%20P%20%E2%86%92%20Q%29%20%28hp%20%3A%20P%29%20%3A%20Q%20%3A%3D%0A%20%20hpq%20hp%0A%0A--%20And%0Atheorem%20and_example%20%7BP%20Q%20%3A%20Prop%7D%20%28hp%20%3A%20P%29%20%28hq%20%3A%20Q%29%20%3A%20P%20%E2%88%A7%20Q%20%3A%3D%0A%20%20%E2%9F%A8hp%2C%20hq%E2%9F%A9%0A%0Atheorem%20and_left%20%7BP%20Q%20%3A%20Prop%7D%20%28h%20%3A%20P%20%E2%88%A7%20Q%29%20%3A%20P%20%3A%3D%0A%20%20h.left%0A%0Atheorem%20and_comm_term%20%7BP%20Q%20%3A%20Prop%7D%20%28h%20%3A%20P%20%E2%88%A7%20Q%29%20%3A%20Q%20%E2%88%A7%20P%20%3A%3D%0A%20%20%E2%9F%A8h.right%2C%20h.left%E2%9F%A9%0A%0A--%20Or%0Atheorem%20or_example%20%7BP%20Q%20%3A%20Prop%7D%20%28hp%20%3A%20P%29%20%3A%20P%20%E2%88%A8%20Q%20%3A%3D%0A%20%20Or.inl%20hp%0A%0Atheorem%20or_comm_term%20%7BP%20Q%20%3A%20Prop%7D%20%28h%20%3A%20P%20%E2%88%A8%20Q%29%20%3A%20Q%20%E2%88%A8%20P%20%3A%3D%0A%20%20Or.elim%20h%20%28fun%20hp%20%3D%3E%20Or.inr%20hp%29%20%28fun%20hq%20%3D%3E%20Or.inl%20hq%29" target="_blank" rel="noopener">&#8599; Open in Lean playground (new tab)</a></p>
<iframe src="https://live.lean-lang.org/#code=namespace%20Ch03Propositions%0A%0A%23check%20%282%20%2B%202%20%3D%204%29%20%20%20%20%20--%202%20%2B%202%20%3D%204%20%3A%20Prop%0A%0Aexample%20%3A%202%20%2B%202%20%3D%204%20%3A%3D%20rfl%0A%0Atheorem%20two_plus_two%20%3A%202%20%2B%202%20%3D%204%20%3A%3D%20rfl%0A%0Atheorem%20add_comm_example%20%3A%202%20%2B%203%20%3D%203%20%2B%202%20%3A%3D%20rfl%0A%0Atheorem%20modus_ponens%20%7BP%20Q%20%3A%20Prop%7D%20%28hpq%20%3A%20P%20%E2%86%92%20Q%29%20%28hp%20%3A%20P%29%20%3A%20Q%20%3A%3D%0A%20%20hpq%20hp%0A%0A--%20And%0Atheorem%20and_example%20%7BP%20Q%20%3A%20Prop%7D%20%28hp%20%3A%20P%29%20%28hq%20%3A%20Q%29%20%3A%20P%20%E2%88%A7%20Q%20%3A%3D%0A%20%20%E2%9F%A8hp%2C%20hq%E2%9F%A9%0A%0Atheorem%20and_left%20%7BP%20Q%20%3A%20Prop%7D%20%28h%20%3A%20P%20%E2%88%A7%20Q%29%20%3A%20P%20%3A%3D%0A%20%20h.left%0A%0Atheorem%20and_comm_term%20%7BP%20Q%20%3A%20Prop%7D%20%28h%20%3A%20P%20%E2%88%A7%20Q%29%20%3A%20Q%20%E2%88%A7%20P%20%3A%3D%0A%20%20%E2%9F%A8h.right%2C%20h.left%E2%9F%A9%0A%0A--%20Or%0Atheorem%20or_example%20%7BP%20Q%20%3A%20Prop%7D%20%28hp%20%3A%20P%29%20%3A%20P%20%E2%88%A8%20Q%20%3A%3D%0A%20%20Or.inl%20hp%0A%0Atheorem%20or_comm_term%20%7BP%20Q%20%3A%20Prop%7D%20%28h%20%3A%20P%20%E2%88%A8%20Q%29%20%3A%20Q%20%E2%88%A8%20P%20%3A%3D%0A%20%20Or.elim%20h%20%28fun%20hp%20%3D%3E%20Or.inr%20hp%29%20%28fun%20hq%20%3D%3E%20Or.inl%20hq%29" title="Lean playground" loading="lazy" style="width:100%;height:212px;border:1px solid #ccc;border-radius:8px;">
</iframe>

- `∨` (Or) has two constructors, `Or.inl` and `Or.inr`. A proof of `P ∨ Q`
  is either "a proof of `P`" or "a proof of `Q`".
- `Or.elim {P Q R : Prop} (h : P ∨ Q) (hpr : P → R) (hqr : Q → R) : R` is
  the *eliminator* for `Or` — see
  [Chapter 1 §5](../01-basics/05-pi-sigma-and-coc.md) for what "eliminator"
  means formally (the general pattern `Nat.rec` illustrates for `Nat`).
  Given a proof of `P ∨ Q`, and a way to reach
  the same conclusion `R` from either disjunct separately, one obtains a proof
  of `R`. `or_comm_term` above uses it directly in term mode, with no
  [`cases`](https://lean-lang.org/doc/reference/latest/Tactic-Proofs/Tactic-Reference/) and no tactic block. It supplies `fun hp => Or.inr hp` for the
  "if it was `P`" branch and `fun hq => Or.inl hq` for the "if it was `Q`"
  branch.

<p><a href="https://live.lean-lang.org/#code=namespace%20Ch03Propositions%0A%0A%23check%20%282%20%2B%202%20%3D%204%29%20%20%20%20%20--%202%20%2B%202%20%3D%204%20%3A%20Prop%0A%0Aexample%20%3A%202%20%2B%202%20%3D%204%20%3A%3D%20rfl%0A%0Atheorem%20two_plus_two%20%3A%202%20%2B%202%20%3D%204%20%3A%3D%20rfl%0A%0Atheorem%20add_comm_example%20%3A%202%20%2B%203%20%3D%203%20%2B%202%20%3A%3D%20rfl%0A%0Atheorem%20modus_ponens%20%7BP%20Q%20%3A%20Prop%7D%20%28hpq%20%3A%20P%20%E2%86%92%20Q%29%20%28hp%20%3A%20P%29%20%3A%20Q%20%3A%3D%0A%20%20hpq%20hp%0A%0A--%20And%0Atheorem%20and_example%20%7BP%20Q%20%3A%20Prop%7D%20%28hp%20%3A%20P%29%20%28hq%20%3A%20Q%29%20%3A%20P%20%E2%88%A7%20Q%20%3A%3D%0A%20%20%E2%9F%A8hp%2C%20hq%E2%9F%A9%0A%0Atheorem%20and_left%20%7BP%20Q%20%3A%20Prop%7D%20%28h%20%3A%20P%20%E2%88%A7%20Q%29%20%3A%20P%20%3A%3D%0A%20%20h.left%0A%0Atheorem%20and_comm_term%20%7BP%20Q%20%3A%20Prop%7D%20%28h%20%3A%20P%20%E2%88%A7%20Q%29%20%3A%20Q%20%E2%88%A7%20P%20%3A%3D%0A%20%20%E2%9F%A8h.right%2C%20h.left%E2%9F%A9%0A%0A--%20Or%0Atheorem%20or_example%20%7BP%20Q%20%3A%20Prop%7D%20%28hp%20%3A%20P%29%20%3A%20P%20%E2%88%A8%20Q%20%3A%3D%0A%20%20Or.inl%20hp%0A%0Atheorem%20or_comm_term%20%7BP%20Q%20%3A%20Prop%7D%20%28h%20%3A%20P%20%E2%88%A8%20Q%29%20%3A%20Q%20%E2%88%A8%20P%20%3A%3D%0A%20%20Or.elim%20h%20%28fun%20hp%20%3D%3E%20Or.inr%20hp%29%20%28fun%20hq%20%3D%3E%20Or.inl%20hq%29%0A%0A--%20Not%2C%20i.e.%20P%20%E2%86%92%20False%0A--%20NOTE%3A%20the%20book%27s%20term-mode%20%60fun%20h%20%3D%3E%20Nat.noConfusion%20h%60%20does%20not%0A--%20actually%20type-check%20as%20written%20%28Nat.noConfusion%27s%20motive%20needs%20to%20be%0A--%20supplied%20and%20doesn%27t%20unify%20automatically%20here%29%20%E2%80%94%20a%20real%20bug%20found%20by%0A--%20the%20compiler.%20Fixed%20with%20%60decide%60%2C%20since%20%601%20%3D%202%60%20is%20a%20small%20decidable%0A--%20proposition%20on%20%60Nat%60.%0Atheorem%20not_example%20%3A%20%C2%AC%281%20%3D%202%29%20%3A%3D%20by%0A%20%20decide" target="_blank" rel="noopener">&#8599; Open in Lean playground (new tab)</a></p>
<iframe src="https://live.lean-lang.org/#code=namespace%20Ch03Propositions%0A%0A%23check%20%282%20%2B%202%20%3D%204%29%20%20%20%20%20--%202%20%2B%202%20%3D%204%20%3A%20Prop%0A%0Aexample%20%3A%202%20%2B%202%20%3D%204%20%3A%3D%20rfl%0A%0Atheorem%20two_plus_two%20%3A%202%20%2B%202%20%3D%204%20%3A%3D%20rfl%0A%0Atheorem%20add_comm_example%20%3A%202%20%2B%203%20%3D%203%20%2B%202%20%3A%3D%20rfl%0A%0Atheorem%20modus_ponens%20%7BP%20Q%20%3A%20Prop%7D%20%28hpq%20%3A%20P%20%E2%86%92%20Q%29%20%28hp%20%3A%20P%29%20%3A%20Q%20%3A%3D%0A%20%20hpq%20hp%0A%0A--%20And%0Atheorem%20and_example%20%7BP%20Q%20%3A%20Prop%7D%20%28hp%20%3A%20P%29%20%28hq%20%3A%20Q%29%20%3A%20P%20%E2%88%A7%20Q%20%3A%3D%0A%20%20%E2%9F%A8hp%2C%20hq%E2%9F%A9%0A%0Atheorem%20and_left%20%7BP%20Q%20%3A%20Prop%7D%20%28h%20%3A%20P%20%E2%88%A7%20Q%29%20%3A%20P%20%3A%3D%0A%20%20h.left%0A%0Atheorem%20and_comm_term%20%7BP%20Q%20%3A%20Prop%7D%20%28h%20%3A%20P%20%E2%88%A7%20Q%29%20%3A%20Q%20%E2%88%A7%20P%20%3A%3D%0A%20%20%E2%9F%A8h.right%2C%20h.left%E2%9F%A9%0A%0A--%20Or%0Atheorem%20or_example%20%7BP%20Q%20%3A%20Prop%7D%20%28hp%20%3A%20P%29%20%3A%20P%20%E2%88%A8%20Q%20%3A%3D%0A%20%20Or.inl%20hp%0A%0Atheorem%20or_comm_term%20%7BP%20Q%20%3A%20Prop%7D%20%28h%20%3A%20P%20%E2%88%A8%20Q%29%20%3A%20Q%20%E2%88%A8%20P%20%3A%3D%0A%20%20Or.elim%20h%20%28fun%20hp%20%3D%3E%20Or.inr%20hp%29%20%28fun%20hq%20%3D%3E%20Or.inl%20hq%29%0A%0A--%20Not%2C%20i.e.%20P%20%E2%86%92%20False%0A--%20NOTE%3A%20the%20book%27s%20term-mode%20%60fun%20h%20%3D%3E%20Nat.noConfusion%20h%60%20does%20not%0A--%20actually%20type-check%20as%20written%20%28Nat.noConfusion%27s%20motive%20needs%20to%20be%0A--%20supplied%20and%20doesn%27t%20unify%20automatically%20here%29%20%E2%80%94%20a%20real%20bug%20found%20by%0A--%20the%20compiler.%20Fixed%20with%20%60decide%60%2C%20since%20%601%20%3D%202%60%20is%20a%20small%20decidable%0A--%20proposition%20on%20%60Nat%60.%0Atheorem%20not_example%20%3A%20%C2%AC%281%20%3D%202%29%20%3A%3D%20by%0A%20%20decide" title="Lean playground" loading="lazy" style="width:100%;height:180px;border:1px solid #ccc;border-radius:8px;">
</iframe>

- `¬P` is notation for `P → False`. To prove a negation, assume `P` holds
  and derive `False`.

<p><a href="https://live.lean-lang.org/#code=namespace%20Ch03Propositions%0A%0A%23check%20%282%20%2B%202%20%3D%204%29%20%20%20%20%20--%202%20%2B%202%20%3D%204%20%3A%20Prop%0A%0Aexample%20%3A%202%20%2B%202%20%3D%204%20%3A%3D%20rfl%0A%0Atheorem%20two_plus_two%20%3A%202%20%2B%202%20%3D%204%20%3A%3D%20rfl%0A%0Atheorem%20add_comm_example%20%3A%202%20%2B%203%20%3D%203%20%2B%202%20%3A%3D%20rfl%0A%0Atheorem%20modus_ponens%20%7BP%20Q%20%3A%20Prop%7D%20%28hpq%20%3A%20P%20%E2%86%92%20Q%29%20%28hp%20%3A%20P%29%20%3A%20Q%20%3A%3D%0A%20%20hpq%20hp%0A%0A--%20And%0Atheorem%20and_example%20%7BP%20Q%20%3A%20Prop%7D%20%28hp%20%3A%20P%29%20%28hq%20%3A%20Q%29%20%3A%20P%20%E2%88%A7%20Q%20%3A%3D%0A%20%20%E2%9F%A8hp%2C%20hq%E2%9F%A9%0A%0Atheorem%20and_left%20%7BP%20Q%20%3A%20Prop%7D%20%28h%20%3A%20P%20%E2%88%A7%20Q%29%20%3A%20P%20%3A%3D%0A%20%20h.left%0A%0Atheorem%20and_comm_term%20%7BP%20Q%20%3A%20Prop%7D%20%28h%20%3A%20P%20%E2%88%A7%20Q%29%20%3A%20Q%20%E2%88%A7%20P%20%3A%3D%0A%20%20%E2%9F%A8h.right%2C%20h.left%E2%9F%A9%0A%0A--%20Or%0Atheorem%20or_example%20%7BP%20Q%20%3A%20Prop%7D%20%28hp%20%3A%20P%29%20%3A%20P%20%E2%88%A8%20Q%20%3A%3D%0A%20%20Or.inl%20hp%0A%0Atheorem%20or_comm_term%20%7BP%20Q%20%3A%20Prop%7D%20%28h%20%3A%20P%20%E2%88%A8%20Q%29%20%3A%20Q%20%E2%88%A8%20P%20%3A%3D%0A%20%20Or.elim%20h%20%28fun%20hp%20%3D%3E%20Or.inr%20hp%29%20%28fun%20hq%20%3D%3E%20Or.inl%20hq%29%0A%0A--%20Not%2C%20i.e.%20P%20%E2%86%92%20False%0A--%20NOTE%3A%20the%20book%27s%20term-mode%20%60fun%20h%20%3D%3E%20Nat.noConfusion%20h%60%20does%20not%0A--%20actually%20type-check%20as%20written%20%28Nat.noConfusion%27s%20motive%20needs%20to%20be%0A--%20supplied%20and%20doesn%27t%20unify%20automatically%20here%29%20%E2%80%94%20a%20real%20bug%20found%20by%0A--%20the%20compiler.%20Fixed%20with%20%60decide%60%2C%20since%20%601%20%3D%202%60%20is%20a%20small%20decidable%0A--%20proposition%20on%20%60Nat%60.%0Atheorem%20not_example%20%3A%20%C2%AC%281%20%3D%202%29%20%3A%3D%20by%0A%20%20decide%0A%0Atheorem%20anything_from_contradiction%20%7BP%20%3A%20Prop%7D%20%28h1%20%3A%201%20%3D%202%29%20%28h2%20%3A%20%281%20%3A%20Nat%29%20%E2%89%A0%202%29%20%3A%20P%20%3A%3D%0A%20%20absurd%20h1%20h2%0A%0Atheorem%20all_nats_ge_zero%20%3A%20%E2%88%80%20n%20%3A%20Nat%2C%20n%20%E2%89%A5%200%20%3A%3D%0A%20%20fun%20n%20%3D%3E%20Nat.zero_le%20n%0A%0Atheorem%20exists_even%20%3A%20%E2%88%83%20n%20%3A%20Nat%2C%20n%20%25%202%20%3D%200%20%3A%3D%0A%20%20%E2%9F%A82%2C%20rfl%E2%9F%A9%0A%0A%40%5Breducible%5D%20def%20isPrime%20%28n%20%3A%20Nat%29%20%3A%20Prop%20%3A%3D%0A%20%20n%20%E2%89%A5%202%20%E2%88%A7%20%E2%88%80%20m%20%3A%20Nat%2C%20m%20%3C%20n%20%E2%86%92%20m%20%E2%89%A5%202%20%E2%86%92%20%C2%AC%20%28m%20%E2%88%A3%20n%29%0A%0Atheorem%20exists_prime_gt_three%20%3A%20%E2%88%83%20p%20%3A%20Nat%2C%20p%20%3E%203%20%E2%88%A7%20isPrime%20p%20%3A%3D%0A%20%20%E2%9F%A85%2C%20by%20decide%E2%9F%A9%0A%0Atheorem%20symm_example%20%7Ba%20b%20%3A%20Nat%7D%20%28h%20%3A%20a%20%3D%20b%29%20%3A%20b%20%3D%20a%20%3A%3D%0A%20%20h.symm%0A%0Atheorem%20trans_example%20%7Ba%20b%20c%20%3A%20Nat%7D%20%28h1%20%3A%20a%20%3D%20b%29%20%28h2%20%3A%20b%20%3D%20c%29%20%3A%20a%20%3D%20c%20%3A%3D%0A%20%20h1.trans%20h2%0A%0Atheorem%20congr_example%20%7Ba%20b%20%3A%20Nat%7D%20%28h%20%3A%20a%20%3D%20b%29%20%3A%20a%20%2B%201%20%3D%20b%20%2B%201%20%3A%3D%20by%0A%20%20rw%20%5Bh%5D%0A%0Aend%20Ch03Propositions%0A%0A--%20Deriving%20False%20from%20a%20genuine%20contradiction%2C%20then%20using%20%60absurd%60%20to%0A--%20close%20any%20goal%20at%20all%20once%20you%20have%20one%0Atheorem%20anything_from_contradiction%20%7BP%20%3A%20Prop%7D%20%28h1%20%3A%201%20%3D%202%29%20%28h2%20%3A%20%281%3ANat%29%20%E2%89%A0%202%29%20%3A%20P%20%3A%3D%0A%20%20absurd%20h1%20h2" target="_blank" rel="noopener">&#8599; Open in Lean playground (new tab)</a></p>
<iframe src="https://live.lean-lang.org/#code=namespace%20Ch03Propositions%0A%0A%23check%20%282%20%2B%202%20%3D%204%29%20%20%20%20%20--%202%20%2B%202%20%3D%204%20%3A%20Prop%0A%0Aexample%20%3A%202%20%2B%202%20%3D%204%20%3A%3D%20rfl%0A%0Atheorem%20two_plus_two%20%3A%202%20%2B%202%20%3D%204%20%3A%3D%20rfl%0A%0Atheorem%20add_comm_example%20%3A%202%20%2B%203%20%3D%203%20%2B%202%20%3A%3D%20rfl%0A%0Atheorem%20modus_ponens%20%7BP%20Q%20%3A%20Prop%7D%20%28hpq%20%3A%20P%20%E2%86%92%20Q%29%20%28hp%20%3A%20P%29%20%3A%20Q%20%3A%3D%0A%20%20hpq%20hp%0A%0A--%20And%0Atheorem%20and_example%20%7BP%20Q%20%3A%20Prop%7D%20%28hp%20%3A%20P%29%20%28hq%20%3A%20Q%29%20%3A%20P%20%E2%88%A7%20Q%20%3A%3D%0A%20%20%E2%9F%A8hp%2C%20hq%E2%9F%A9%0A%0Atheorem%20and_left%20%7BP%20Q%20%3A%20Prop%7D%20%28h%20%3A%20P%20%E2%88%A7%20Q%29%20%3A%20P%20%3A%3D%0A%20%20h.left%0A%0Atheorem%20and_comm_term%20%7BP%20Q%20%3A%20Prop%7D%20%28h%20%3A%20P%20%E2%88%A7%20Q%29%20%3A%20Q%20%E2%88%A7%20P%20%3A%3D%0A%20%20%E2%9F%A8h.right%2C%20h.left%E2%9F%A9%0A%0A--%20Or%0Atheorem%20or_example%20%7BP%20Q%20%3A%20Prop%7D%20%28hp%20%3A%20P%29%20%3A%20P%20%E2%88%A8%20Q%20%3A%3D%0A%20%20Or.inl%20hp%0A%0Atheorem%20or_comm_term%20%7BP%20Q%20%3A%20Prop%7D%20%28h%20%3A%20P%20%E2%88%A8%20Q%29%20%3A%20Q%20%E2%88%A8%20P%20%3A%3D%0A%20%20Or.elim%20h%20%28fun%20hp%20%3D%3E%20Or.inr%20hp%29%20%28fun%20hq%20%3D%3E%20Or.inl%20hq%29%0A%0A--%20Not%2C%20i.e.%20P%20%E2%86%92%20False%0A--%20NOTE%3A%20the%20book%27s%20term-mode%20%60fun%20h%20%3D%3E%20Nat.noConfusion%20h%60%20does%20not%0A--%20actually%20type-check%20as%20written%20%28Nat.noConfusion%27s%20motive%20needs%20to%20be%0A--%20supplied%20and%20doesn%27t%20unify%20automatically%20here%29%20%E2%80%94%20a%20real%20bug%20found%20by%0A--%20the%20compiler.%20Fixed%20with%20%60decide%60%2C%20since%20%601%20%3D%202%60%20is%20a%20small%20decidable%0A--%20proposition%20on%20%60Nat%60.%0Atheorem%20not_example%20%3A%20%C2%AC%281%20%3D%202%29%20%3A%3D%20by%0A%20%20decide%0A%0Atheorem%20anything_from_contradiction%20%7BP%20%3A%20Prop%7D%20%28h1%20%3A%201%20%3D%202%29%20%28h2%20%3A%20%281%20%3A%20Nat%29%20%E2%89%A0%202%29%20%3A%20P%20%3A%3D%0A%20%20absurd%20h1%20h2%0A%0Atheorem%20all_nats_ge_zero%20%3A%20%E2%88%80%20n%20%3A%20Nat%2C%20n%20%E2%89%A5%200%20%3A%3D%0A%20%20fun%20n%20%3D%3E%20Nat.zero_le%20n%0A%0Atheorem%20exists_even%20%3A%20%E2%88%83%20n%20%3A%20Nat%2C%20n%20%25%202%20%3D%200%20%3A%3D%0A%20%20%E2%9F%A82%2C%20rfl%E2%9F%A9%0A%0A%40%5Breducible%5D%20def%20isPrime%20%28n%20%3A%20Nat%29%20%3A%20Prop%20%3A%3D%0A%20%20n%20%E2%89%A5%202%20%E2%88%A7%20%E2%88%80%20m%20%3A%20Nat%2C%20m%20%3C%20n%20%E2%86%92%20m%20%E2%89%A5%202%20%E2%86%92%20%C2%AC%20%28m%20%E2%88%A3%20n%29%0A%0Atheorem%20exists_prime_gt_three%20%3A%20%E2%88%83%20p%20%3A%20Nat%2C%20p%20%3E%203%20%E2%88%A7%20isPrime%20p%20%3A%3D%0A%20%20%E2%9F%A85%2C%20by%20decide%E2%9F%A9%0A%0Atheorem%20symm_example%20%7Ba%20b%20%3A%20Nat%7D%20%28h%20%3A%20a%20%3D%20b%29%20%3A%20b%20%3D%20a%20%3A%3D%0A%20%20h.symm%0A%0Atheorem%20trans_example%20%7Ba%20b%20c%20%3A%20Nat%7D%20%28h1%20%3A%20a%20%3D%20b%29%20%28h2%20%3A%20b%20%3D%20c%29%20%3A%20a%20%3D%20c%20%3A%3D%0A%20%20h1.trans%20h2%0A%0Atheorem%20congr_example%20%7Ba%20b%20%3A%20Nat%7D%20%28h%20%3A%20a%20%3D%20b%29%20%3A%20a%20%2B%201%20%3D%20b%20%2B%201%20%3A%3D%20by%0A%20%20rw%20%5Bh%5D%0A%0Aend%20Ch03Propositions%0A%0A--%20Deriving%20False%20from%20a%20genuine%20contradiction%2C%20then%20using%20%60absurd%60%20to%0A--%20close%20any%20goal%20at%20all%20once%20you%20have%20one%0Atheorem%20anything_from_contradiction%20%7BP%20%3A%20Prop%7D%20%28h1%20%3A%201%20%3D%202%29%20%28h2%20%3A%20%281%3ANat%29%20%E2%89%A0%202%29%20%3A%20P%20%3A%3D%0A%20%20absurd%20h1%20h2" title="Lean playground" loading="lazy" style="width:100%;height:180px;border:1px solid #ccc;border-radius:8px;">
</iframe>

- `absurd {P Q : Prop} (h1 : P) (h2 : ¬P) : Q` derives *anything at all*
  from a genuine contradiction: a direct proof of `P` together with a
  proof that `P` is impossible. `anything_from_contradiction` shows this
  concretely. From `1 = 2` and `1 ≠ 2` (contradictory hypotheses that could
  never both hold, but which Lean happily accepts as *given*
  hypotheses in a signature — nothing prevents assuming something
  false; it only prevents *proving* it from nothing), one may
  conclude literally any proposition `P` whatsoever. This is the "ex falso
  quodlibet" principle from classical logic, made concrete. Once a
  contradiction is present among the hypotheses, the goal being
  proved stops mattering.

**Mathematical reading.** These are the constructive readings of the
connectives as operations on the proof-sets. Conjunction $P \wedge Q$ is
the **product** $P \times Q$: a proof is a pair $\langle p, q\rangle$, so
`and_example` builds $(p,q)$ and `and_left` applies $\pi_1$:

```mermaid
graph LR
    PandQ["P&and;Q"] -->|"&pi;1"| P
    PandQ -->|"&pi;2"| Q
```

| Symbol | Lean |
| --- | --- |
| $P \wedge Q$ ("and") | `P ∧ Q` |
| $\langle p, q \rangle$ ("pairing") | `⟨hp, hq⟩` (`and_example`) |
| $\pi_1, \pi_2$ ("the projections") | `h.left`, `h.right` (`and_left` applies `.left`) |

Disjunction $P \vee Q$ is the **coproduct** $P \sqcup Q$, the mirror image:
arrows point *in* rather than *out*, and a proof is a tagged injection.

```mermaid
graph LR
    P -->|"&iota;1"| PorQ["P&or;Q"]
    Q -->|"&iota;2"| PorQ
```

| Symbol | Lean |
| --- | --- |
| $P \vee Q$ ("or") | `P ∨ Q` |
| $\iota_1(p)$ ("left injection") | `Or.inl hp` (`or_example`) |
| $\iota_2(q)$ ("right injection") | `Or.inr hq` |

To *use* a proof of $P \vee Q$, one case-splits by the universal property of
the coproduct: given a proof `h : P ∨ Q` and a way to reach the same
conclusion `R` from either side (`hpr : P → R`, `hqr : Q → R`), there is
exactly one map `P∨Q → R` agreeing with both. This is precisely what
`or_comm_term` above builds via `Or.elim`. Negation is $\neg P := (P \to
\bot)$, a map into the initial object $\bot = \varnothing$. A proof of
$\neg(1=2)$ is a function turning the (impossible) hypothesis $1 = 2$ into
an element of $\varnothing$, vacuously. Here it is discharged by [`decide`](https://lean-lang.org/doc/reference/latest/Tactic-Proofs/Tactic-Reference/),
which mechanically confirms $1 \neq 2$ since equality of `Nat` literals is
decidable. Underlying this is exactly the same fact used throughout this
book: distinct constructors of an inductive type (`Nat.succ`, applied a
different number of times) are disjoint, so `1 = 2` has no proof to begin
with. Observe that this is *intuitionistic* logic: there is no built-in law of
excluded middle.

---

[← Implication](04-implication.md) | [Index](00-index.md) | [Next: Quantifiers →](06-quantifiers.md)

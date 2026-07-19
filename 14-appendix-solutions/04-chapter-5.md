## Chapter 5: Rigor check — structures, universes, and equality

[← Chapter 4](03-chapter-4.md) | [Index](00-index.md) | [Next: Chapter 6 →](05-chapter-6.md)

---

**1. `rfl` predictions**

<p><a href="https://live.lean-lang.org/#code=example%20%3A%20%282%20%3A%20Nat%29%20%2A%203%20%3D%203%20%2B%203%20%3A%3D%20rfl" target="_blank" rel="noopener">&#8599; Open in Lean playground (new tab)</a></p>
<iframe src="https://live.lean-lang.org/#code=example%20%3A%20%282%20%3A%20Nat%29%20%2A%203%20%3D%203%20%2B%203%20%3A%3D%20rfl" title="Lean playground" loading="lazy" style="width:100%;height:180px;border:1px solid #ccc;border-radius:8px;">
</iframe>

This succeeds. `Nat.mul` recurses on its second argument, with base clause
`a * 0 = 0` and step `a * (k+1) = a * k + a`. Since both sides are closed
numerals, Lean evaluates both to `6` and checks that they match.
Both sides compute to the same normal form, so no subtlety arises.

<p><a href="https://live.lean-lang.org/#code=example%20%28n%20%3A%20Nat%29%20%3A%20n%20%2A%202%20%3D%20n%20%2B%20n%20%3A%3D%20rfl" target="_blank" rel="noopener">&#8599; Open in Lean playground (new tab)</a></p>
<iframe src="https://live.lean-lang.org/#code=example%20%28n%20%3A%20Nat%29%20%3A%20n%20%2A%202%20%3D%20n%20%2B%20n%20%3A%3D%20rfl" title="Lean playground" loading="lazy" style="width:100%;height:180px;border:1px solid #ccc;border-radius:8px;">
</iframe>

This also succeeds, though the reason requires elaboration. `2` is
`Nat.succ (Nat.succ Nat.zero)`, so `n * 2` unfolds via the step clause
twice: `n * 2 = n * 1 + n = (n * 0 + n) + n = (0 + n) + n`. Since `Nat.add`
recurses on its *second* argument, `0 + n` is not immediately `n` by
definition (this is the same asymmetry Chapter 4 relied on for
`my_add_comm`). Hence this reduces to `(0 + n) + n`, which is not
syntactically `n + n` unless `0 + n` also reduces to `n`. It does not,
by definition. Thus, contrary to a first guess, **this does not type-check
as `rfl`** in general. Confirming this directly, [`rfl`](https://lean-lang.org/doc/reference/latest/Tactic-Proofs/Tactic-Reference/) fails, while
`by rw [Nat.mul_two]` (or an explicit induction) succeeds instead — note
this is `Nat.mul_two : n * 2 = n + n`, not `Nat.two_mul : 2 * n = n + n`,
since the goal has `n` on the left of `*`. The
lesson: multiplying by a literal does not collapse to `rfl` for free once a
general variable `n` sits on the "wrong" side of an asymmetric recursion.
This is the same reason `0 + n = n` required real induction in Chapter 4.

**2. `MyGroup` as a type class**

<p><a href="https://live.lean-lang.org/#code=class%20MyGroup%20%28G%20%3A%20Type%29%20where%0A%20%20op%20%3A%20G%20%E2%86%92%20G%20%E2%86%92%20G%0A%20%20id%20%3A%20G%0A%20%20inv%20%3A%20G%20%E2%86%92%20G%0A%20%20assoc%20%3A%20%E2%88%80%20a%20b%20c%20%3A%20G%2C%20op%20%28op%20a%20b%29%20c%20%3D%20op%20a%20%28op%20b%20c%29%0A%20%20id_left%20%3A%20%E2%88%80%20a%20%3A%20G%2C%20op%20id%20a%20%3D%20a%0A%20%20id_right%20%3A%20%E2%88%80%20a%20%3A%20G%2C%20op%20a%20id%20%3D%20a%0A%20%20inv_left%20%3A%20%E2%88%80%20a%20%3A%20G%2C%20op%20%28inv%20a%29%20a%20%3D%20id%0A%20%20inv_right%20%3A%20%E2%88%80%20a%20%3A%20G%2C%20op%20a%20%28inv%20a%29%20%3D%20id%0A%0Ainstance%20%3A%20MyGroup%20Int%20where%0A%20%20op%20%3A%3D%20fun%20a%20b%20%3D%3E%20a%20%2B%20b%0A%20%20id%20%3A%3D%200%0A%20%20inv%20%3A%3D%20fun%20a%20%3D%3E%20-a%0A%20%20assoc%20%3A%3D%20by%20intro%20a%20b%20c%3B%20exact%20Int.add_assoc%20a%20b%20c%0A%20%20id_left%20%3A%3D%20by%20intro%20a%3B%20exact%20Int.zero_add%20a%0A%20%20id_right%20%3A%3D%20by%20intro%20a%3B%20exact%20Int.add_zero%20a%0A%20%20inv_left%20%3A%3D%20by%20intro%20a%3B%20exact%20Int.add_left_neg%20a%0A%20%20inv_right%20%3A%3D%20by%20intro%20a%3B%20exact%20Int.add_right_neg%20a" target="_blank" rel="noopener">&#8599; Open in Lean playground (new tab)</a></p>
<iframe src="https://live.lean-lang.org/#code=class%20MyGroup%20%28G%20%3A%20Type%29%20where%0A%20%20op%20%3A%20G%20%E2%86%92%20G%20%E2%86%92%20G%0A%20%20id%20%3A%20G%0A%20%20inv%20%3A%20G%20%E2%86%92%20G%0A%20%20assoc%20%3A%20%E2%88%80%20a%20b%20c%20%3A%20G%2C%20op%20%28op%20a%20b%29%20c%20%3D%20op%20a%20%28op%20b%20c%29%0A%20%20id_left%20%3A%20%E2%88%80%20a%20%3A%20G%2C%20op%20id%20a%20%3D%20a%0A%20%20id_right%20%3A%20%E2%88%80%20a%20%3A%20G%2C%20op%20a%20id%20%3D%20a%0A%20%20inv_left%20%3A%20%E2%88%80%20a%20%3A%20G%2C%20op%20%28inv%20a%29%20a%20%3D%20id%0A%20%20inv_right%20%3A%20%E2%88%80%20a%20%3A%20G%2C%20op%20a%20%28inv%20a%29%20%3D%20id%0A%0Ainstance%20%3A%20MyGroup%20Int%20where%0A%20%20op%20%3A%3D%20fun%20a%20b%20%3D%3E%20a%20%2B%20b%0A%20%20id%20%3A%3D%200%0A%20%20inv%20%3A%3D%20fun%20a%20%3D%3E%20-a%0A%20%20assoc%20%3A%3D%20by%20intro%20a%20b%20c%3B%20exact%20Int.add_assoc%20a%20b%20c%0A%20%20id_left%20%3A%3D%20by%20intro%20a%3B%20exact%20Int.zero_add%20a%0A%20%20id_right%20%3A%3D%20by%20intro%20a%3B%20exact%20Int.add_zero%20a%0A%20%20inv_left%20%3A%3D%20by%20intro%20a%3B%20exact%20Int.add_left_neg%20a%0A%20%20inv_right%20%3A%3D%20by%20intro%20a%3B%20exact%20Int.add_right_neg%20a" title="Lean playground" loading="lazy" style="width:100%;height:421px;border:1px solid #ccc;border-radius:8px;">
</iframe>

Every field of the `instance` is identical, term-for-term, to the earlier
`intGroup : Group Int` `def` from Chapter 6. Registering something as an
`instance` instead of a plain `def` only changes *how Lean's elaborator
finds it* (automatically, via unification on `G`). It does not change what
data it contains.

<p><a href="https://live.lean-lang.org/#code=def%20opTwiceTC%20%5BMyGroup%20G%5D%20%28x%20%3A%20G%29%20%3A%20G%20%3A%3D%20MyGroup.op%20x%20x%0A%0A%23eval%20opTwiceTC%20%283%20%3A%20Int%29%20%20%20--%206%2C%20with%20the%20Group%20Int%20instance%20found%20automatically" target="_blank" rel="noopener">&#8599; Open in Lean playground (new tab)</a></p>
<iframe src="https://live.lean-lang.org/#code=def%20opTwiceTC%20%5BMyGroup%20G%5D%20%28x%20%3A%20G%29%20%3A%20G%20%3A%3D%20MyGroup.op%20x%20x%0A%0A%23eval%20opTwiceTC%20%283%20%3A%20Int%29%20%20%20--%206%2C%20with%20the%20Group%20Int%20instance%20found%20automatically" title="Lean playground" loading="lazy" style="width:100%;height:180px;border:1px solid #ccc;border-radius:8px;">
</iframe>

That difference in how it is found is exactly what makes `opTwiceTC`
possible. It is written once, in a generic way, against the `[MyGroup G]`
assumption, with no mention of `Int` anywhere. At the `#eval` call site,
Lean needs a `MyGroup Int` to run `MyGroup.op`. It searches the instances
it has registered, finds the one declared above, and plugs it in
automatically. A plain `def` would not take part in this kind of lookup.

**3. Why `Type → Type` needs `Type 1`**

Suppose `Type → Type` (the type of `Group` itself, before we supply a
carrier) lived in `Type 0` alongside `Nat`, `Bool`, and every other
ordinary type. Then `Type` itself — being an argument type appearing
inside `Type → Type` — would need to be an element of `Type 0`. In other
words, this would require `Type : Type`. But `Type` is meant to be (roughly) the
type of *all* `Type 0`-level types. If it were itself one such type, one
could rebuild Russell's paradox inside Lean (a self-referential type such as
"the type of all types not containing themselves"). Lean's kernel avoids
this: anything built from `Type 0` (such as a function *into or out of*
`Type 0`) that is not itself a small type must bump up a universe level.
That is why `Type → Type` lands in `Type 1` rather than `Type 0`.

**4. A true propositional equality not provable by `rfl`**

<p><a href="https://live.lean-lang.org/#code=theorem%20add_one_eq_succ%20%28n%20%3A%20Nat%29%20%3A%20n%20%2B%201%20%3D%20Nat.succ%20n%20%3A%3D%20rfl" target="_blank" rel="noopener">&#8599; Open in Lean playground (new tab)</a></p>
<iframe src="https://live.lean-lang.org/#code=theorem%20add_one_eq_succ%20%28n%20%3A%20Nat%29%20%3A%20n%20%2B%201%20%3D%20Nat.succ%20n%20%3A%3D%20rfl" title="Lean playground" loading="lazy" style="width:100%;height:180px;border:1px solid #ccc;border-radius:8px;">
</iframe>

This one is indeed `rfl`: `n + 1 = n + Nat.succ 0 = Nat.succ (n + 0) = Nat.succ
n`, all by the defining equations of `+`. No induction is needed, because
the recursion is on the second, literal-`1` argument, which unfolds
immediately regardless of `n`.

<p><a href="https://live.lean-lang.org/#code=theorem%20one_add_eq_succ%20%28n%20%3A%20Nat%29%20%3A%201%20%2B%20n%20%3D%20Nat.succ%20n%20%3A%3D%20by%0A%20%20induction%20n%20with%0A%20%20%7C%20zero%20%3D%3E%20rfl%0A%20%20%7C%20succ%20k%20ih%20%3D%3E%0A%20%20%20%20show%201%20%2B%20Nat.succ%20k%20%3D%20Nat.succ%20%28Nat.succ%20k%29%0A%20%20%20%20rw%20%5BNat.add_succ%2C%20ih%5D" target="_blank" rel="noopener">&#8599; Open in Lean playground (new tab)</a></p>
<iframe src="https://live.lean-lang.org/#code=theorem%20one_add_eq_succ%20%28n%20%3A%20Nat%29%20%3A%201%20%2B%20n%20%3D%20Nat.succ%20n%20%3A%3D%20by%0A%20%20induction%20n%20with%0A%20%20%7C%20zero%20%3D%3E%20rfl%0A%20%20%7C%20succ%20k%20ih%20%3D%3E%0A%20%20%20%20show%201%20%2B%20Nat.succ%20k%20%3D%20Nat.succ%20%28Nat.succ%20k%29%0A%20%20%20%20rw%20%5BNat.add_succ%2C%20ih%5D" title="Lean playground" loading="lazy" style="width:100%;height:180px;border:1px solid #ccc;border-radius:8px;">
</iframe>

This is the substantive answer to the exercise — a true equality that `rfl`
cannot close on its own. With the variable now on the *second* argument,
`1 + n = Nat.succ n` has exactly the same left/right asymmetry as
`0 + n = n` from Chapter 4. `Nat.add`'s recursion never touches a variable
sitting in the first argument, so no amount of unfolding closes the goal
without an actual induction on `n`, even though the statement is of
course true. This is why the explicit `induction n with ...` above is
required. Comparing it with `add_one_eq_succ`'s one-line `rfl` makes the asymmetry
concrete.

**Checkpoint project: a `Monoid` from scratch**

<p><a href="https://live.lean-lang.org/#code=structure%20Monoid%20%28M%20%3A%20Type%29%20where%0A%20%20op%20%3A%20M%20%E2%86%92%20M%20%E2%86%92%20M%0A%20%20id%20%3A%20M%0A%20%20assoc%20%3A%20%E2%88%80%20a%20b%20c%20%3A%20M%2C%20op%20%28op%20a%20b%29%20c%20%3D%20op%20a%20%28op%20b%20c%29%0A%20%20id_left%20%3A%20%E2%88%80%20a%20%3A%20M%2C%20op%20id%20a%20%3D%20a%0A%20%20id_right%20%3A%20%E2%88%80%20a%20%3A%20M%2C%20op%20a%20id%20%3D%20a%0A%0Adef%20listMonoid%20%28%CE%B1%20%3A%20Type%29%20%3A%20Monoid%20%28List%20%CE%B1%29%20where%0A%20%20op%20%3A%3D%20List.append%0A%20%20id%20%3A%3D%20%5B%5D%0A%20%20assoc%20%3A%3D%20by%20intro%20a%20b%20c%3B%20exact%20List.append_assoc%20a%20b%20c%0A%20%20id_left%20%3A%3D%20by%20intro%20a%3B%20exact%20List.nil_append%20a%0A%20%20id_right%20%3A%3D%20by%20intro%20a%3B%20exact%20List.append_nil%20a%0A%0Adef%20natMulMonoid%20%3A%20Monoid%20Nat%20where%0A%20%20op%20%3A%3D%20fun%20a%20b%20%3D%3E%20a%20%2A%20b%0A%20%20id%20%3A%3D%201%0A%20%20assoc%20%3A%3D%20by%20intro%20a%20b%20c%3B%20exact%20Nat.mul_assoc%20a%20b%20c%0A%20%20id_left%20%3A%3D%20by%20intro%20a%3B%20exact%20Nat.one_mul%20a%0A%20%20id_right%20%3A%3D%20by%20intro%20a%3B%20exact%20Nat.mul_one%20a%0A%0Atheorem%20monoid_id_unique%20%7BM%20%3A%20Type%7D%20%28Mn%20%3A%20Monoid%20M%29%20%28e%27%20%3A%20M%29%0A%20%20%20%20%28h%20%3A%20%E2%88%80%20a%20%3A%20M%2C%20Mn.op%20e%27%20a%20%3D%20a%29%20%3A%20e%27%20%3D%20Mn.id%20%3A%3D%20by%0A%20%20have%20step1%20%3A%20Mn.op%20e%27%20Mn.id%20%3D%20Mn.id%20%3A%3D%20h%20Mn.id%0A%20%20have%20step2%20%3A%20Mn.op%20e%27%20Mn.id%20%3D%20e%27%20%3A%3D%20Mn.id_right%20e%27%0A%20%20rw%20%5B%E2%86%90%20step2%5D%0A%20%20exact%20step1" target="_blank" rel="noopener">&#8599; Open in Lean playground (new tab)</a></p>
<iframe src="https://live.lean-lang.org/#code=structure%20Monoid%20%28M%20%3A%20Type%29%20where%0A%20%20op%20%3A%20M%20%E2%86%92%20M%20%E2%86%92%20M%0A%20%20id%20%3A%20M%0A%20%20assoc%20%3A%20%E2%88%80%20a%20b%20c%20%3A%20M%2C%20op%20%28op%20a%20b%29%20c%20%3D%20op%20a%20%28op%20b%20c%29%0A%20%20id_left%20%3A%20%E2%88%80%20a%20%3A%20M%2C%20op%20id%20a%20%3D%20a%0A%20%20id_right%20%3A%20%E2%88%80%20a%20%3A%20M%2C%20op%20a%20id%20%3D%20a%0A%0Adef%20listMonoid%20%28%CE%B1%20%3A%20Type%29%20%3A%20Monoid%20%28List%20%CE%B1%29%20where%0A%20%20op%20%3A%3D%20List.append%0A%20%20id%20%3A%3D%20%5B%5D%0A%20%20assoc%20%3A%3D%20by%20intro%20a%20b%20c%3B%20exact%20List.append_assoc%20a%20b%20c%0A%20%20id_left%20%3A%3D%20by%20intro%20a%3B%20exact%20List.nil_append%20a%0A%20%20id_right%20%3A%3D%20by%20intro%20a%3B%20exact%20List.append_nil%20a%0A%0Adef%20natMulMonoid%20%3A%20Monoid%20Nat%20where%0A%20%20op%20%3A%3D%20fun%20a%20b%20%3D%3E%20a%20%2A%20b%0A%20%20id%20%3A%3D%201%0A%20%20assoc%20%3A%3D%20by%20intro%20a%20b%20c%3B%20exact%20Nat.mul_assoc%20a%20b%20c%0A%20%20id_left%20%3A%3D%20by%20intro%20a%3B%20exact%20Nat.one_mul%20a%0A%20%20id_right%20%3A%3D%20by%20intro%20a%3B%20exact%20Nat.mul_one%20a%0A%0Atheorem%20monoid_id_unique%20%7BM%20%3A%20Type%7D%20%28Mn%20%3A%20Monoid%20M%29%20%28e%27%20%3A%20M%29%0A%20%20%20%20%28h%20%3A%20%E2%88%80%20a%20%3A%20M%2C%20Mn.op%20e%27%20a%20%3D%20a%29%20%3A%20e%27%20%3D%20Mn.id%20%3A%3D%20by%0A%20%20have%20step1%20%3A%20Mn.op%20e%27%20Mn.id%20%3D%20Mn.id%20%3A%3D%20h%20Mn.id%0A%20%20have%20step2%20%3A%20Mn.op%20e%27%20Mn.id%20%3D%20e%27%20%3A%3D%20Mn.id_right%20e%27%0A%20%20rw%20%5B%E2%86%90%20step2%5D%0A%20%20exact%20step1" title="Lean playground" loading="lazy" style="width:100%;height:573px;border:1px solid #ccc;border-radius:8px;">
</iframe>

Both instances are one field-by-field build, exactly `intGroup`'s style
(Chapter 6 §3) minus the two inverse fields: each proof obligation is a
single `intro` plus a one-line `exact` naming a core-library fact
(`List.append_assoc`/`List.nil_append`/`List.append_nil` for the list
instance, `Nat.mul_assoc`/`Nat.one_mul`/`Nat.mul_one` for the natural-number
one). `monoid_id_unique`'s proof is `id_unique` (Chapter 7, Theorem 1) copied
verbatim, with every `Grp.` replaced by `Mn.` and `Group` weakened to
`Monoid`. Every step used only `id_right` and the hypothesis `h`, never an
inverse — which is exactly why the proof survives dropping `inv` entirely.
The theorem applies unchanged to both instances built above, the same
"prove once, get it for free" payoff Chapter 6 §6 promises for `Group`.

---

[← Chapter 4](03-chapter-4.md) | [Index](00-index.md) | [Next: Chapter 6 →](05-chapter-6.md)

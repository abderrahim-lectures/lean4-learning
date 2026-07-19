## Definitional versus propositional equality

[← Typing rules and safety](03-typing-rules-and-safety.md) | [Index](00-index.md) | [Next: Exercises →](05-exercises.md)

---

Chapter 4 introduced [`rfl`](https://lean-lang.org/doc/reference/latest/Tactic-Proofs/Tactic-Reference/) as "the proof that both sides compute to the
same thing," using it freely without asking exactly what "compute to
the same thing" means, or whether it is the *only* notion of equality
Lean has. It is not. Lean has (at least) two, and confusing them is a
common source of real confusion once proofs get more intricate. They are
worth separating out clearly now.

### Definitional equality

Two terms are **definitionally equal** ($a \equiv b$, sometimes written
$a \equiv_\beta b$ to stress that it is driven by reduction) if they reduce to
the same normal form by unfolding definitions, beta-reduction
(substituting a lambda's argument into its body), and the built-in
computation rules of inductive types (a `match` on a constructor reduces
immediately). This is a *judgment the type-checker computes*, not a
proposition you prove. There is no term of type `a ≡ b`. Either Lean's
kernel confirms it during elaboration (silently, whenever it needs to
check that two types or terms match) or it does not, and `rfl` is the tactic
that asks Lean to check exactly this and fail loudly if it does not hold.

<p><a href="https://live.lean-lang.org/#code=namespace%20Ch05RigorCheck%0A%0A--%20This%20book%27s%20style%3A%20a%20plain%20%60structure%60.%0Astructure%20MyGroupS%20%28G%20%3A%20Type%29%20where%0A%20%20op%20%3A%20G%20%E2%86%92%20G%20%E2%86%92%20G%0A%20%20id%20%3A%20G%0A%20%20inv%20%3A%20G%20%E2%86%92%20G%0A%20%20assoc%20%3A%20%E2%88%80%20a%20b%20c%20%3A%20G%2C%20op%20%28op%20a%20b%29%20c%20%3D%20op%20a%20%28op%20b%20c%29%0A%20%20id_left%20%3A%20%E2%88%80%20a%20%3A%20G%2C%20op%20id%20a%20%3D%20a%0A%20%20id_right%20%3A%20%E2%88%80%20a%20%3A%20G%2C%20op%20a%20id%20%3D%20a%0A%20%20inv_left%20%3A%20%E2%88%80%20a%20%3A%20G%2C%20op%20%28inv%20a%29%20a%20%3D%20id%0A%20%20inv_right%20%3A%20%E2%88%80%20a%20%3A%20G%2C%20op%20a%20%28inv%20a%29%20%3D%20id%0A%0A--%20Mathlib%27s%20style%20%28schematically%29%3A%20a%20%60class%60%2C%20enabling%20instance%20search.%0Aclass%20MyGroupC%20%28G%20%3A%20Type%29%20where%0A%20%20op%20%3A%20G%20%E2%86%92%20G%20%E2%86%92%20G%0A%20%20id%20%3A%20G%0A%20%20inv%20%3A%20G%20%E2%86%92%20G%0A%20%20assoc%20%3A%20%E2%88%80%20a%20b%20c%20%3A%20G%2C%20op%20%28op%20a%20b%29%20c%20%3D%20op%20a%20%28op%20b%20c%29%0A%20%20id_left%20%3A%20%E2%88%80%20a%20%3A%20G%2C%20op%20id%20a%20%3D%20a%0A%20%20id_right%20%3A%20%E2%88%80%20a%20%3A%20G%2C%20op%20a%20id%20%3D%20a%0A%20%20inv_left%20%3A%20%E2%88%80%20a%20%3A%20G%2C%20op%20%28inv%20a%29%20a%20%3D%20id%0A%20%20inv_right%20%3A%20%E2%88%80%20a%20%3A%20G%2C%20op%20a%20%28inv%20a%29%20%3D%20id%0A%0Ainstance%20%3A%20MyGroupC%20Int%20where%0A%20%20op%20%3A%3D%20fun%20a%20b%20%3D%3E%20a%20%2B%20b%0A%20%20id%20%3A%3D%200%0A%20%20inv%20%3A%3D%20fun%20a%20%3D%3E%20-a%0A%20%20assoc%20%3A%3D%20by%20intro%20a%20b%20c%3B%20exact%20Int.add_assoc%20a%20b%20c%0A%20%20id_left%20%3A%3D%20by%20intro%20a%3B%20exact%20Int.zero_add%20a%0A%20%20id_right%20%3A%3D%20by%20intro%20a%3B%20exact%20Int.add_zero%20a%0A%20%20inv_left%20%3A%3D%20by%20intro%20a%3B%20exact%20Int.add_left_neg%20a%0A%20%20inv_right%20%3A%3D%20by%20intro%20a%3B%20exact%20Int.add_right_neg%20a%0A%0Adef%20opTwiceTC%20%5BMyGroupC%20G%5D%20%28x%20%3A%20G%29%20%3A%20G%20%3A%3D%0A%20%20MyGroupC.op%20x%20x%20%20%20--%20the%20%60MyGroupC%20Int%60%20instance%20is%20found%20automatically%0A%0A%23eval%20opTwiceTC%20%283%20%3A%20Int%29%20%20%20--%206%0A%0Adef%20myGroupSInt%20%3A%20MyGroupS%20Int%20where%0A%20%20op%20%3A%3D%20fun%20a%20b%20%3D%3E%20a%20%2B%20b%0A%20%20id%20%3A%3D%200%0A%20%20inv%20%3A%3D%20fun%20a%20%3D%3E%20-a%0A%20%20assoc%20%3A%3D%20by%20intro%20a%20b%20c%3B%20exact%20Int.add_assoc%20a%20b%20c%0A%20%20id_left%20%3A%3D%20by%20intro%20a%3B%20exact%20Int.zero_add%20a%0A%20%20id_right%20%3A%3D%20by%20intro%20a%3B%20exact%20Int.add_zero%20a%0A%20%20inv_left%20%3A%3D%20by%20intro%20a%3B%20exact%20Int.add_left_neg%20a%0A%20%20inv_right%20%3A%3D%20by%20intro%20a%3B%20exact%20Int.add_right_neg%20a%0A%0Adef%20opTwiceExplicit%20%28Grp%20%3A%20MyGroupS%20G%29%20%28x%20%3A%20G%29%20%3A%20G%20%3A%3D%0A%20%20Grp.op%20x%20x%0A%0A%23eval%20opTwiceExplicit%20myGroupSInt%203%20%20%20--%206%2C%20structure%20passed%20explicitly%0A%0A--%20Universes%0A%23check%20%28Nat%20%3A%20Type%29%20%20%20%20%20%20%20%20--%20Nat%20itself%20lives%20in%20Type%0A%23check%20%28Type%20%3A%20Type%201%29%20%20%20%20%20%20--%20Type%20lives%20one%20level%20up%2C%20in%20Type%201%0A%23check%20%28Type%201%20%3A%20Type%202%29%20%20%20%20--%20and%20so%20on%2C%20forever%0A%0A--%20Definitional%20vs%20propositional%20equality%0Aexample%20%3A%202%20%2B%202%20%3D%204%20%3A%3D%20rfl%20%20%20%20%20%20%20%20--%202%20%2B%202%20reduces%20to%204%20definitionally%0Aexample%20%3A%200%20%2B%202%20%3D%202%20%3A%3D%20rfl" target="_blank" rel="noopener">&#8599; Open in Lean playground (new tab)</a></p>
<iframe src="https://live.lean-lang.org/#code=namespace%20Ch05RigorCheck%0A%0A--%20This%20book%27s%20style%3A%20a%20plain%20%60structure%60.%0Astructure%20MyGroupS%20%28G%20%3A%20Type%29%20where%0A%20%20op%20%3A%20G%20%E2%86%92%20G%20%E2%86%92%20G%0A%20%20id%20%3A%20G%0A%20%20inv%20%3A%20G%20%E2%86%92%20G%0A%20%20assoc%20%3A%20%E2%88%80%20a%20b%20c%20%3A%20G%2C%20op%20%28op%20a%20b%29%20c%20%3D%20op%20a%20%28op%20b%20c%29%0A%20%20id_left%20%3A%20%E2%88%80%20a%20%3A%20G%2C%20op%20id%20a%20%3D%20a%0A%20%20id_right%20%3A%20%E2%88%80%20a%20%3A%20G%2C%20op%20a%20id%20%3D%20a%0A%20%20inv_left%20%3A%20%E2%88%80%20a%20%3A%20G%2C%20op%20%28inv%20a%29%20a%20%3D%20id%0A%20%20inv_right%20%3A%20%E2%88%80%20a%20%3A%20G%2C%20op%20a%20%28inv%20a%29%20%3D%20id%0A%0A--%20Mathlib%27s%20style%20%28schematically%29%3A%20a%20%60class%60%2C%20enabling%20instance%20search.%0Aclass%20MyGroupC%20%28G%20%3A%20Type%29%20where%0A%20%20op%20%3A%20G%20%E2%86%92%20G%20%E2%86%92%20G%0A%20%20id%20%3A%20G%0A%20%20inv%20%3A%20G%20%E2%86%92%20G%0A%20%20assoc%20%3A%20%E2%88%80%20a%20b%20c%20%3A%20G%2C%20op%20%28op%20a%20b%29%20c%20%3D%20op%20a%20%28op%20b%20c%29%0A%20%20id_left%20%3A%20%E2%88%80%20a%20%3A%20G%2C%20op%20id%20a%20%3D%20a%0A%20%20id_right%20%3A%20%E2%88%80%20a%20%3A%20G%2C%20op%20a%20id%20%3D%20a%0A%20%20inv_left%20%3A%20%E2%88%80%20a%20%3A%20G%2C%20op%20%28inv%20a%29%20a%20%3D%20id%0A%20%20inv_right%20%3A%20%E2%88%80%20a%20%3A%20G%2C%20op%20a%20%28inv%20a%29%20%3D%20id%0A%0Ainstance%20%3A%20MyGroupC%20Int%20where%0A%20%20op%20%3A%3D%20fun%20a%20b%20%3D%3E%20a%20%2B%20b%0A%20%20id%20%3A%3D%200%0A%20%20inv%20%3A%3D%20fun%20a%20%3D%3E%20-a%0A%20%20assoc%20%3A%3D%20by%20intro%20a%20b%20c%3B%20exact%20Int.add_assoc%20a%20b%20c%0A%20%20id_left%20%3A%3D%20by%20intro%20a%3B%20exact%20Int.zero_add%20a%0A%20%20id_right%20%3A%3D%20by%20intro%20a%3B%20exact%20Int.add_zero%20a%0A%20%20inv_left%20%3A%3D%20by%20intro%20a%3B%20exact%20Int.add_left_neg%20a%0A%20%20inv_right%20%3A%3D%20by%20intro%20a%3B%20exact%20Int.add_right_neg%20a%0A%0Adef%20opTwiceTC%20%5BMyGroupC%20G%5D%20%28x%20%3A%20G%29%20%3A%20G%20%3A%3D%0A%20%20MyGroupC.op%20x%20x%20%20%20--%20the%20%60MyGroupC%20Int%60%20instance%20is%20found%20automatically%0A%0A%23eval%20opTwiceTC%20%283%20%3A%20Int%29%20%20%20--%206%0A%0Adef%20myGroupSInt%20%3A%20MyGroupS%20Int%20where%0A%20%20op%20%3A%3D%20fun%20a%20b%20%3D%3E%20a%20%2B%20b%0A%20%20id%20%3A%3D%200%0A%20%20inv%20%3A%3D%20fun%20a%20%3D%3E%20-a%0A%20%20assoc%20%3A%3D%20by%20intro%20a%20b%20c%3B%20exact%20Int.add_assoc%20a%20b%20c%0A%20%20id_left%20%3A%3D%20by%20intro%20a%3B%20exact%20Int.zero_add%20a%0A%20%20id_right%20%3A%3D%20by%20intro%20a%3B%20exact%20Int.add_zero%20a%0A%20%20inv_left%20%3A%3D%20by%20intro%20a%3B%20exact%20Int.add_left_neg%20a%0A%20%20inv_right%20%3A%3D%20by%20intro%20a%3B%20exact%20Int.add_right_neg%20a%0A%0Adef%20opTwiceExplicit%20%28Grp%20%3A%20MyGroupS%20G%29%20%28x%20%3A%20G%29%20%3A%20G%20%3A%3D%0A%20%20Grp.op%20x%20x%0A%0A%23eval%20opTwiceExplicit%20myGroupSInt%203%20%20%20--%206%2C%20structure%20passed%20explicitly%0A%0A--%20Universes%0A%23check%20%28Nat%20%3A%20Type%29%20%20%20%20%20%20%20%20--%20Nat%20itself%20lives%20in%20Type%0A%23check%20%28Type%20%3A%20Type%201%29%20%20%20%20%20%20--%20Type%20lives%20one%20level%20up%2C%20in%20Type%201%0A%23check%20%28Type%201%20%3A%20Type%202%29%20%20%20%20--%20and%20so%20on%2C%20forever%0A%0A--%20Definitional%20vs%20propositional%20equality%0Aexample%20%3A%202%20%2B%202%20%3D%204%20%3A%3D%20rfl%20%20%20%20%20%20%20%20--%202%20%2B%202%20reduces%20to%204%20definitionally%0Aexample%20%3A%200%20%2B%202%20%3D%202%20%3A%3D%20rfl" title="Lean playground" loading="lazy" style="width:100%;height:180px;border:1px solid #ccc;border-radius:8px;">
</iframe>

One precise point worth noting: "reduce to the same normal form" does not mean
Lean necessarily unfolds a term *all the way down* before comparing.
Checking `a ≡ b` typically only reduces each side as far as its **weak
head normal form** (WHNF): far enough to see the outermost constructor
or function head, no further than needed. It then compares heads,
recursing into subterms only as required. This is exactly why "`Nat.add`
recurses on its second argument" is a fact about *evaluation order*. To
determine whether `0 + n` reduces at all, Lean examines `n`'s outermost
shape (its WHNF). If `n` is an unknown variable rather than a known
`zero`/`succ` constructor, there is nothing to see, so no reduction fires
and the goal is stuck at `0 + n`, exactly as Chapter 4 found.

### Propositional equality

**Propositional equality**, written `a = b` (the `Eq` type from Chapter 3),
is an ordinary proposition, a `Prop`, that must be *proved*, the way
any other statement is proved. Definitional equality is only the easiest
possible case (`rfl` is a proof of `a = b` precisely by showing that
`a ≡ b`). But `a = b` can hold *propositionally* even when `a` and `b` are
**not** definitionally equal. For instance, Chapter 4's
`my_add_comm : ∀ a b, a + b = b + a` proves a propositional equality that
is *not* witnessed by `rfl` (indeed, `rfl` fails on `a + b = b + a` for
variable `a`, `b`, precisely because `Nat.add` only reduces on its second
argument, so the two sides do not share a common reduct without the
induction Chapter 4 walked through).

$$
a \equiv b \ \implies\ a = b, \qquad\text{but not conversely.}
$$

This is the exact type-theoretic counterpart of a distinction every
mathematician already makes without naming it: "$2+2$ and $4$ are the same
symbol after simplification" versus "$a+b$ and $b+a$ denote the same
number, which requires an argument (commutativity) to establish, not mere
inspection." Definitional equality is inspection. Propositional equality
is (potentially) a theorem.

### Why the distinction has real consequences

Two practical facts follow directly:

1. **`rfl` only ever proves definitional equalities.** When `rfl` fails,
   that is not evidence the statement is false. It only indicates the two
   sides do not share a computed normal form *without further argument*.
   This is exactly the "failure is information" point from Chapter 4:
   `rfl` failing on `a + b = b + a` is the signal to reach for [`induction`](https://lean-lang.org/doc/reference/latest/Tactic-Proofs/Tactic-Reference/),
   not evidence that the statement should be abandoned.
2. **[`rw`](https://lean-lang.org/doc/reference/latest/Tactic-Proofs/Tactic-Reference/) works up to propositional equality, but the resulting
   goal is checked up to definitional equality.** When `rw [h]` rewrites a
   goal using `h : a = b`, the *new* goal is a genuinely different term
   (with `b` substituted for `a`), and Lean must still confirm the
   surrounding structure of the goal stays well-typed after the
   substitution. This subtlety occasionally shows up as the "motive is
   not type correct" error mentioned in Chapter 4, which is exactly a
   case where propositional substitution runs into a definitional-equality
   check it cannot discharge automatically (common when the term being
   rewritten appears inside a dependent type's index, as in Chapter 11's
   `Path`).

### A note on proof irrelevance

One more fact worth having, since it explains why this book never worries
about "which proof" fills a `Prop`-valued field: Lean treats all proofs of
the same proposition as *interchangeable* (this is called **proof
irrelevance** for `Prop`). If `h1 h2 : a = b` are two different proof
*terms* of the same propositional equality, `h1` and `h2` are
definitionally equal to each other, even if they were built by
completely different tactic scripts. This is why the question "is this the
*same* proof of `assoc`" never arises, throughout this book, when comparing two
`Group` structures on the same carrier with the same operation. The
proof component does not matter; only the data (`op`, `id`, `inv`) can
actually differ.

### A note on structure eta

This is a companion fact, relied on silently whenever this book (or the reader) writes
`⟨x.fst, x.snd⟩ = x` or splits a goal about a `structure`-typed equality
into one goal per field. Lean's kernel treats a term `x : S` (for `S` a
`structure`) as **definitionally equal** to
`S.mk x.field1 x.field2 ...`. Rebuilding `x` field-by-field gives back
*the same term*, by η (eta) for structures, not just a term that is
provably equal to it. This is exactly what makes Chapter 8's `Mat2.mk.injEq`-based
extensionality reasoning work, and Chapter 10's [`congr 1`](https://lean-lang.org/doc/reference/latest/Tactic-Proofs/Tactic-Reference/), which splits a
`DirectSum.mk _ _ = DirectSum.mk _ _` goal into two field-wise goals. Both
depend on Lean already knowing, definitionally, that every term of a
structure type *is* (eta-equal to) its constructor applied to its own
fields.

> Read more: TPiL's chapter on structures discusses eta for structures
> directly; the "Why bundle proofs with data at all?" discussion in
> [Chapter 6 §6](../06-groups/06-why-bundle.md) is the payoff this
> definitional transparency is building toward.

---

### References

Full citations in the [Bibliography](../bibliography.md).

- Pierce ([Pierce2002]), Ch. 3, 11–12 — operational semantics and reduction, and the general distinction between checking equality by computation versus by proof that this section specializes to Lean's `rfl`/`=`.
- Martin-Löf ([MartinLof1984]) — the original source distinguishing definitional (judgmental) equality from propositional equality, the exact distinction this section works through.
- *Theorem Proving in Lean 4* ([TPIL4]), "Dependent Types" — Lean's own documentation on `rfl` and definitional equality, matching the presentation here.

[Pierce2002]: ../bibliography.md#pierce2002
[MartinLof1984]: ../bibliography.md#martinlof1984
[TPIL4]: ../bibliography.md#tpil4

---

[← Typing rules and safety](03-typing-rules-and-safety.md) | [Index](00-index.md) | [Next: Exercises →](05-exercises.md)

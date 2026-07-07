## Definitional versus propositional equality

[← Universes](02-universes.md) | [Index](00-index.md) | [Next: Exercises →](04-exercises.md)

---

Chapter 4 introduced `rfl` as "the proof that both sides compute to the
same thing," and used it freely without asking exactly what "compute to
the same thing" means, or whether it is the *only* notion of equality
Lean has. It is not. Lean has (at least) two, and confusing them is a
common source of genuine confusion once proofs get more intricate — worth
separating out precisely now.

### Definitional equality

Two terms are **definitionally equal** ($a \equiv b$, sometimes written
$a \equiv_\beta b$ to emphasize it's driven by reduction) if they reduce to
the same normal form by unfolding definitions, beta-reduction
(substituting a lambda's argument into its body), and the built-in
computation rules of inductive types (a `match` on a constructor reduces
immediately). This is a *judgment the type-checker computes*, not a
proposition you prove — there is no term of type `a ≡ b`; either Lean's
kernel confirms it during elaboration (silently, whenever it needs to
check two types or terms match) or it doesn't, and `rfl` is the tactic
that asks Lean to check exactly this and fail loudly if it doesn't hold.

```lean
example : 2 + 2 = 4 := rfl        -- 2 + 2 reduces to 4 definitionally
example : 0 + 2 = 2 := rfl        -- reduces, since `Nat.add` recurses on
                                   -- its second argument and 2 + 0 = 2
                                   -- is the base clause
-- example : 2 + 0 = 2 := rfl     -- also rfl (0 + n needs induction, n + 0 doesn't)
```

### Propositional equality

**Propositional equality**, written `a = b` (the `Eq` type from Chapter 3),
is an ordinary proposition — a `Prop` — that you *prove*, the way you
prove any other statement, and definitional equality is only the easiest
possible case (`rfl` is a proof of `a = b` precisely by exhibiting that
`a ≡ b`). But `a = b` can hold *propositionally* even when `a` and `b` are
**not** definitionally equal — for instance, Chapter 4's
`my_add_comm : ∀ a b, a + b = b + a` proves a propositional equality that
is *not* witnessed by `rfl` (try it — `rfl` fails on `a + b = b + a` for
variable `a`, `b`, precisely because `Nat.add` only reduces on its second
argument, so the two sides don't share a common reduct without the
induction Chapter 4 walked through).

$$
a \equiv b \ \implies\ a = b, \qquad\text{but not conversely.}
$$

This is the exact type-theoretic counterpart of a distinction every
mathematician already makes without naming it: "$2+2$ and $4$ are the same
symbol after simplification" versus "$a+b$ and $b+a$ denote the same
number, which requires an argument (commutativity) to establish, not mere
inspection." Definitional equality is inspection; propositional equality
is (potentially) a theorem.

### Why the distinction has real consequences

Two practical facts follow directly:

1. **`rfl` only ever proves definitional equalities.** When `rfl` fails,
   that is not evidence the statement is false — it only tells you the two
   sides don't share a computed normal form *without further argument*.
   This is exactly the "failure is information" point from Chapter 4:
   `rfl` failing on `a + b = b + a` is the signal to reach for `induction`,
   not evidence the statement needs abandoning.
2. **`rw` and `▸` work up to propositional equality, but the resulting
   goal is checked up to definitional equality.** When `rw [h]` rewrites a
   goal using `h : a = b`, the *new* goal is a genuinely different term
   (with `b` substituted for `a`), and Lean must still confirm the
   surrounding structure of the goal remains well-typed after the
   substitution — a subtlety that occasionally surfaces as the "motive is
   not type correct" error mentioned in Chapter 4, which is precisely a
   case where propositional substitution runs into a definitional-equality
   check it can't discharge automatically (common when the term being
   rewritten appears inside a dependent type's index, as in Chapter 11's
   `Path`).

### A note on proof irrelevance

One more fact worth having, since it explains why this book never worries
about "which proof" fills a `Prop`-valued field: Lean treats all proofs of
the same proposition as *interchangeable* (this is called **proof
irrelevance** for `Prop`). If `h1 h2 : a = b` are two different proof
*terms* of the same propositional equality, `h1` and `h2` are
definitionally equal to each other, even if they were constructed by
completely different tactic scripts. This is why, throughout this book,
we never ask "but is this the *same* proof of `assoc`" when comparing two
`Group` structures on the same carrier with the same operation — the
proof component is immaterial; only the data (`op`, `id`, `inv`) can
actually differ.

---

[← Universes](02-universes.md) | [Index](00-index.md) | [Next: Exercises →](04-exercises.md)

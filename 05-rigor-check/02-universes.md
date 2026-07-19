## Universes: `Type`, `Type 1`, and why `Group` isn't a `Group`

[← `structure` vs `class`](01-structure-vs-class.md) | [Index](00-index.md) | [Next: Typing rules and safety →](03-typing-rules-and-safety.md)

---

Chapter 1 said `Type` is itself a term, of some type. A careful reader
should immediately ask: *of what type?* If the answer were "`Type` is a
term of type `Type`," Lean's logic would be inconsistent. This is exactly
Russell's paradox in type-theoretic form: the type of "all types," if it
contained itself, would permit rebuilding the set-of-all-sets-that-do-not-
contain-themselves paradox inside the type theory. Lean avoids this with
a **hierarchy of universes**.

### The hierarchy

<p><a href="https://live.lean-lang.org/#code=namespace%20Ch05RigorCheck%0A%0A--%20This%20book%27s%20style%3A%20a%20plain%20%60structure%60.%0Astructure%20MyGroupS%20%28G%20%3A%20Type%29%20where%0A%20%20op%20%3A%20G%20%E2%86%92%20G%20%E2%86%92%20G%0A%20%20id%20%3A%20G%0A%20%20inv%20%3A%20G%20%E2%86%92%20G%0A%20%20assoc%20%3A%20%E2%88%80%20a%20b%20c%20%3A%20G%2C%20op%20%28op%20a%20b%29%20c%20%3D%20op%20a%20%28op%20b%20c%29%0A%20%20id_left%20%3A%20%E2%88%80%20a%20%3A%20G%2C%20op%20id%20a%20%3D%20a%0A%20%20id_right%20%3A%20%E2%88%80%20a%20%3A%20G%2C%20op%20a%20id%20%3D%20a%0A%20%20inv_left%20%3A%20%E2%88%80%20a%20%3A%20G%2C%20op%20%28inv%20a%29%20a%20%3D%20id%0A%20%20inv_right%20%3A%20%E2%88%80%20a%20%3A%20G%2C%20op%20a%20%28inv%20a%29%20%3D%20id%0A%0A--%20Mathlib%27s%20style%20%28schematically%29%3A%20a%20%60class%60%2C%20enabling%20instance%20search.%0Aclass%20MyGroupC%20%28G%20%3A%20Type%29%20where%0A%20%20op%20%3A%20G%20%E2%86%92%20G%20%E2%86%92%20G%0A%20%20id%20%3A%20G%0A%20%20inv%20%3A%20G%20%E2%86%92%20G%0A%20%20assoc%20%3A%20%E2%88%80%20a%20b%20c%20%3A%20G%2C%20op%20%28op%20a%20b%29%20c%20%3D%20op%20a%20%28op%20b%20c%29%0A%20%20id_left%20%3A%20%E2%88%80%20a%20%3A%20G%2C%20op%20id%20a%20%3D%20a%0A%20%20id_right%20%3A%20%E2%88%80%20a%20%3A%20G%2C%20op%20a%20id%20%3D%20a%0A%20%20inv_left%20%3A%20%E2%88%80%20a%20%3A%20G%2C%20op%20%28inv%20a%29%20a%20%3D%20id%0A%20%20inv_right%20%3A%20%E2%88%80%20a%20%3A%20G%2C%20op%20a%20%28inv%20a%29%20%3D%20id%0A%0Ainstance%20%3A%20MyGroupC%20Int%20where%0A%20%20op%20%3A%3D%20fun%20a%20b%20%3D%3E%20a%20%2B%20b%0A%20%20id%20%3A%3D%200%0A%20%20inv%20%3A%3D%20fun%20a%20%3D%3E%20-a%0A%20%20assoc%20%3A%3D%20by%20intro%20a%20b%20c%3B%20exact%20Int.add_assoc%20a%20b%20c%0A%20%20id_left%20%3A%3D%20by%20intro%20a%3B%20exact%20Int.zero_add%20a%0A%20%20id_right%20%3A%3D%20by%20intro%20a%3B%20exact%20Int.add_zero%20a%0A%20%20inv_left%20%3A%3D%20by%20intro%20a%3B%20exact%20Int.add_left_neg%20a%0A%20%20inv_right%20%3A%3D%20by%20intro%20a%3B%20exact%20Int.add_right_neg%20a%0A%0Adef%20opTwiceTC%20%5BMyGroupC%20G%5D%20%28x%20%3A%20G%29%20%3A%20G%20%3A%3D%0A%20%20MyGroupC.op%20x%20x%20%20%20--%20the%20%60MyGroupC%20Int%60%20instance%20is%20found%20automatically%0A%0A%23eval%20opTwiceTC%20%283%20%3A%20Int%29%20%20%20--%206%0A%0Adef%20myGroupSInt%20%3A%20MyGroupS%20Int%20where%0A%20%20op%20%3A%3D%20fun%20a%20b%20%3D%3E%20a%20%2B%20b%0A%20%20id%20%3A%3D%200%0A%20%20inv%20%3A%3D%20fun%20a%20%3D%3E%20-a%0A%20%20assoc%20%3A%3D%20by%20intro%20a%20b%20c%3B%20exact%20Int.add_assoc%20a%20b%20c%0A%20%20id_left%20%3A%3D%20by%20intro%20a%3B%20exact%20Int.zero_add%20a%0A%20%20id_right%20%3A%3D%20by%20intro%20a%3B%20exact%20Int.add_zero%20a%0A%20%20inv_left%20%3A%3D%20by%20intro%20a%3B%20exact%20Int.add_left_neg%20a%0A%20%20inv_right%20%3A%3D%20by%20intro%20a%3B%20exact%20Int.add_right_neg%20a%0A%0Adef%20opTwiceExplicit%20%28Grp%20%3A%20MyGroupS%20G%29%20%28x%20%3A%20G%29%20%3A%20G%20%3A%3D%0A%20%20Grp.op%20x%20x%0A%0A%23eval%20opTwiceExplicit%20myGroupSInt%203%20%20%20--%206%2C%20structure%20passed%20explicitly%0A%0A--%20Universes%0A%23check%20%28Nat%20%3A%20Type%29%20%20%20%20%20%20%20%20--%20Nat%20itself%20lives%20in%20Type%0A%23check%20%28Type%20%3A%20Type%201%29%20%20%20%20%20%20--%20Type%20lives%20one%20level%20up%2C%20in%20Type%201%0A%23check%20%28Type%201%20%3A%20Type%202%29" target="_blank" rel="noopener">&#8599; Open in Lean playground (new tab)</a></p>
<iframe src="https://live.lean-lang.org/#code=namespace%20Ch05RigorCheck%0A%0A--%20This%20book%27s%20style%3A%20a%20plain%20%60structure%60.%0Astructure%20MyGroupS%20%28G%20%3A%20Type%29%20where%0A%20%20op%20%3A%20G%20%E2%86%92%20G%20%E2%86%92%20G%0A%20%20id%20%3A%20G%0A%20%20inv%20%3A%20G%20%E2%86%92%20G%0A%20%20assoc%20%3A%20%E2%88%80%20a%20b%20c%20%3A%20G%2C%20op%20%28op%20a%20b%29%20c%20%3D%20op%20a%20%28op%20b%20c%29%0A%20%20id_left%20%3A%20%E2%88%80%20a%20%3A%20G%2C%20op%20id%20a%20%3D%20a%0A%20%20id_right%20%3A%20%E2%88%80%20a%20%3A%20G%2C%20op%20a%20id%20%3D%20a%0A%20%20inv_left%20%3A%20%E2%88%80%20a%20%3A%20G%2C%20op%20%28inv%20a%29%20a%20%3D%20id%0A%20%20inv_right%20%3A%20%E2%88%80%20a%20%3A%20G%2C%20op%20a%20%28inv%20a%29%20%3D%20id%0A%0A--%20Mathlib%27s%20style%20%28schematically%29%3A%20a%20%60class%60%2C%20enabling%20instance%20search.%0Aclass%20MyGroupC%20%28G%20%3A%20Type%29%20where%0A%20%20op%20%3A%20G%20%E2%86%92%20G%20%E2%86%92%20G%0A%20%20id%20%3A%20G%0A%20%20inv%20%3A%20G%20%E2%86%92%20G%0A%20%20assoc%20%3A%20%E2%88%80%20a%20b%20c%20%3A%20G%2C%20op%20%28op%20a%20b%29%20c%20%3D%20op%20a%20%28op%20b%20c%29%0A%20%20id_left%20%3A%20%E2%88%80%20a%20%3A%20G%2C%20op%20id%20a%20%3D%20a%0A%20%20id_right%20%3A%20%E2%88%80%20a%20%3A%20G%2C%20op%20a%20id%20%3D%20a%0A%20%20inv_left%20%3A%20%E2%88%80%20a%20%3A%20G%2C%20op%20%28inv%20a%29%20a%20%3D%20id%0A%20%20inv_right%20%3A%20%E2%88%80%20a%20%3A%20G%2C%20op%20a%20%28inv%20a%29%20%3D%20id%0A%0Ainstance%20%3A%20MyGroupC%20Int%20where%0A%20%20op%20%3A%3D%20fun%20a%20b%20%3D%3E%20a%20%2B%20b%0A%20%20id%20%3A%3D%200%0A%20%20inv%20%3A%3D%20fun%20a%20%3D%3E%20-a%0A%20%20assoc%20%3A%3D%20by%20intro%20a%20b%20c%3B%20exact%20Int.add_assoc%20a%20b%20c%0A%20%20id_left%20%3A%3D%20by%20intro%20a%3B%20exact%20Int.zero_add%20a%0A%20%20id_right%20%3A%3D%20by%20intro%20a%3B%20exact%20Int.add_zero%20a%0A%20%20inv_left%20%3A%3D%20by%20intro%20a%3B%20exact%20Int.add_left_neg%20a%0A%20%20inv_right%20%3A%3D%20by%20intro%20a%3B%20exact%20Int.add_right_neg%20a%0A%0Adef%20opTwiceTC%20%5BMyGroupC%20G%5D%20%28x%20%3A%20G%29%20%3A%20G%20%3A%3D%0A%20%20MyGroupC.op%20x%20x%20%20%20--%20the%20%60MyGroupC%20Int%60%20instance%20is%20found%20automatically%0A%0A%23eval%20opTwiceTC%20%283%20%3A%20Int%29%20%20%20--%206%0A%0Adef%20myGroupSInt%20%3A%20MyGroupS%20Int%20where%0A%20%20op%20%3A%3D%20fun%20a%20b%20%3D%3E%20a%20%2B%20b%0A%20%20id%20%3A%3D%200%0A%20%20inv%20%3A%3D%20fun%20a%20%3D%3E%20-a%0A%20%20assoc%20%3A%3D%20by%20intro%20a%20b%20c%3B%20exact%20Int.add_assoc%20a%20b%20c%0A%20%20id_left%20%3A%3D%20by%20intro%20a%3B%20exact%20Int.zero_add%20a%0A%20%20id_right%20%3A%3D%20by%20intro%20a%3B%20exact%20Int.add_zero%20a%0A%20%20inv_left%20%3A%3D%20by%20intro%20a%3B%20exact%20Int.add_left_neg%20a%0A%20%20inv_right%20%3A%3D%20by%20intro%20a%3B%20exact%20Int.add_right_neg%20a%0A%0Adef%20opTwiceExplicit%20%28Grp%20%3A%20MyGroupS%20G%29%20%28x%20%3A%20G%29%20%3A%20G%20%3A%3D%0A%20%20Grp.op%20x%20x%0A%0A%23eval%20opTwiceExplicit%20myGroupSInt%203%20%20%20--%206%2C%20structure%20passed%20explicitly%0A%0A--%20Universes%0A%23check%20%28Nat%20%3A%20Type%29%20%20%20%20%20%20%20%20--%20Nat%20itself%20lives%20in%20Type%0A%23check%20%28Type%20%3A%20Type%201%29%20%20%20%20%20%20--%20Type%20lives%20one%20level%20up%2C%20in%20Type%201%0A%23check%20%28Type%201%20%3A%20Type%202%29" title="Lean playground" loading="lazy" style="width:100%;height:180px;border:1px solid #ccc;border-radius:8px;">
</iframe>

$$
\mathtt{Nat} : \mathtt{Type} : \mathtt{Type}\ 1 : \mathtt{Type}\ 2 : \cdots
$$

Each `Type u` is itself a term of `Type (u+1)`, never of itself. This gives
just enough structure to block the paradox, while still permitting "for
every type" (quantifying over some fixed `Type u`) to be said as often as
needed. `Type` on its own (with no numeral) is notation for `Type 0`, the
universe containing "ordinary" types like `Nat`, `Bool`, `Int`, and the
`Point`/`Pair` structures from Chapter 2.

### Why this matters for `Group`

Recall `structure Group (G : Type) where ...` from Chapter 6. This
signature commits to `G : Type`, meaning `G` lives in the universe `Type 0`.
The natural question: does `Group` itself have a `Group`-structure? Is `Group Int` an
element of some `Group (Group Int)`? Setting aside whether that would even
be meaningful, a more basic obstruction is evident. `Group Int` is a `Type`
(`#check (Group Int : Type)` type-checks, since a `structure`
applied to its parameters is itself a type), but `Group`, the type
*constructor* itself (before applying it to a carrier `G`), is not a
`Type` at all. It is a function `Type → Type`, that is, a term of type
`Type → Type`.

*Why* does `Type → Type` live in `Type 1` rather than back in `Type 0`?
This is not merely a bookkeeping choice. It follows from the specific
typing rule Lean uses for building function (Π-)types out of universes:
forming `A → B` when `A : Type i` and `B : Type j` produces a term of type
`Type (max i j)`, *unless* `B`'s universe already needs to be at least one
level higher to safely contain "the collection of all functions out of `A`".
Concretely here, `A := Type` (living in `Type 1`, since `Type : Type 1`)
and `B := Type` again, so `Type → Type` itself lands in `Type 1`.
[Chapter 5 §3](03-typing-rules-and-safety.md) states this rule precisely
as one line of the calculus of constructions. The short version
is that `Group` is not even a candidate carrier type for its own
construction. It sits one universe level too high, exactly because it is a
function *out of* `Type` itself, not out of some ordinary `Type 0` type
like `Nat`.

### Universe polymorphism (a brief note)

A definition is occasionally written with an explicit universe
variable, e.g. `structure Group.{u} (G : Type u) where ...`. This makes
the definition **universe polymorphic**: usable the same way whether `G`
lives in `Type 0`, `Type 1`, or any level, rather than pinned to `Type 0`
specifically. This book fixes everything at `Type` (that is, `Type 0`) for
simplicity, since none of the groups, rings, or modules built here need
anything larger. Mathlib's actual definitions are universe polymorphic
throughout, exactly because they must accommodate constructions (such as
"the group of automorphisms of a large category") that genuinely do not fit
in `Type 0`.

> Read more: [Chapter 5 §3](03-typing-rules-and-safety.md) states the
> universe-formation rules precisely, as part of the calculus of
> constructions. Externally, the "Dependent Type Theory" chapter of
> the *Theorem Proving in Lean 4* manual ([TPIL4]) covers universes at a
> similar level of detail with more Lean-specific examples.

---

### References

Full citations in the [Bibliography](../bibliography.md).

- *Theorem Proving in Lean 4* ([TPIL4]), §2.2 "Types as objects" — Lean's own documentation on the universe hierarchy, verified verbatim ("Type 0 as a universe of 'small' or 'ordinary' types... the list is infinite: there is a Type n for every natural number n"), matching the presentation here.
- Girard — **Correction:** [Girard1971] (the 1971/1970 "Une extension de l'interprétation de Gödel à l'analyse" paper) is *not* the source of the `Type : Type` inconsistency. The proof that a calculus with the rule `⊢ * : *` loses the normalization property is due to Girard's 1972 doctoral thesis, *"Interprétation fonctionnelle et élimination des coupures dans l'arithmétique d'ordre supérieure,"* Thèse d'État, Université Paris VII, 1972 — not yet in this book's bibliography. (Thierry Coquand's 1986 paper "An analysis of Girard's paradox," LICS 1986, is the standard modern exposition, also not yet cited here.)

[TPIL4]: ../bibliography.md#tpil4
[Girard1971]: ../bibliography.md#girard1971

---

[← `structure` vs `class`](01-structure-vs-class.md) | [Index](00-index.md) | [Next: Typing rules and safety →](03-typing-rules-and-safety.md)

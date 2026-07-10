## Universal and existential quantifiers

[← And, Or, Not](04-and-or-not.md) | [Index](00-index.md) | [Next: Equality reasoning →](06-equality.md)

---

```lean
theorem all_nats_ge_zero : ∀ n : Nat, n ≥ 0 :=
  fun n => Nat.zero_le n
```

- `∀ x : α, P x` is again just a (dependent) function type: given any `x`,
  produce a proof of `P x`. `all_nats_ge_zero` is literally a function
  taking any `n` and returning a proof that `n ≥ 0` — here, `Nat.zero_le n`
  already proves exactly that for whichever `n` gets passed in.

```lean
theorem exists_even : ∃ n : Nat, n % 2 = 0 :=
  ⟨2, rfl⟩
```

- `∃ x : α, P x` is a structure: a **witness** value plus a proof that the
  witness satisfies `P`.

**Reading the shortcut `⟨2, rfl⟩`.** This is the same "here are the pieces,
in order" anonymous-constructor shorthand from
[Chapter 2 §1](../02-functions-and-structures/01-structure-basics.md),
already reused for `∧`
([Chapter 3 §4](04-and-or-not.md)'s `⟨hp, hq⟩`), now used to build an
`∃`-proof in one line instead of two. A simple way to remember it: **first
the number, then why it works.**

- `2` is the **witness** — the specific number being claimed even. It's
  the smallest one that actually makes the point (`0` technically works
  too, but looks like a trick — "of course `0` is even").
- `rfl` is the **proof**, filling in for `P 2`, i.e. for `2 % 2 = 0`. It
  works by `rfl` alone (no lemma needed) because `2 % 2` simply *computes*
  to `0` — both sides of the equation are already the same term once
  evaluated, exactly like `2 + 2 = 4` back in [Chapter 3
  §1](01-prop.md).

So `⟨2, rfl⟩ : ∃ n : Nat, n % 2 = 0` reads as "2 works, and here's why: it
just computes." Whenever you see `⟨w, p⟩` proving an `∃`-statement
elsewhere in this book, read it the same way — `w` is *what* you're
claiming exists, `p` is *why* it satisfies the property, packed together
because that's exactly the two pieces of data an existence proof needs.

```lean
-- A minimal, self-contained primality check (no Mathlib import needed):
-- `n` is prime if it's at least 2 and no number strictly between 2 and n
-- divides it. `@[reducible]` lets `decide` below see straight through
-- this definition, instead of needing a separate `unfold` step first.
@[reducible] def isPrime (n : Nat) : Prop :=
  n ≥ 2 ∧ ∀ m : Nat, m < n → m ≥ 2 → ¬ (m ∣ n)

theorem exists_prime_gt_three : ∃ p : Nat, p > 3 ∧ isPrime p :=
  ⟨5, by decide⟩
```

**A second example: there's always a bigger prime.** `exists_prime_gt_three`
is one concrete instance of a classical fact — no matter which number you
pick, there's a prime bigger than it (here the chosen number is `3`, and
`5` is a prime that beats it). It follows the exact same "number, then
why" shape as before, but with two differences worth noticing:

- The *property* being witnessed, `p > 3 ∧ isPrime p`, is itself an `∧` —
  so the full picture is a witness (`5`) plus a *pair* of facts about it
  (`5 > 3`, and `5` is prime), all packed into the outer `⟨_, _⟩`.
- The proof isn't `rfl`. `p > 3 ∧ isPrime p` doesn't reduce to a plain
  equality, so instead the second slot is `by decide` — the same
  brute-force tactic from [Chapter 3 §4](04-and-or-not.md)'s
  `not_example`, which here checks `5 > 3` outright and tries every
  candidate divisor below `5` to confirm none of them divide it.

Read `⟨5, by decide⟩` exactly like before: `5` is still just the witness,
`by decide` is still just the proof, filled in by a tactic block instead
of `rfl` because *this* proof happens to need one. The witness-then-proof
shape never changes; only *how* the proof half gets produced does.

This one example only shows *a* prime past `3` — it doesn't yet show that
this works for *every* number you could have picked instead of `3`. That
stronger claim, $\forall n,\ \exists p > n,\ \mathrm{isPrime}\ p$ (Euclid's
theorem, first proved around 300 BCE), needs an argument that works
uniformly for an *arbitrary* `n`, which means induction — not yet
introduced. [Chapter 4](../04-tactics/00-index.md) covers the tactics
that make an argument like that possible; a fully formalized proof of
Euclid's theorem lives in Mathlib as `Nat.exists_infinite_primes`, one of
the "Read more" pointers once [Chapter 13](../13-next-steps/00-index.md)
introduces Mathlib itself.

**Remark (a more formal restatement).** The bullet points above already
say everything needed to use `∃` and `∀`; this paragraph and the
"Mathematical reading" box below only restate the same facts in more
formal language, for readers who want the connection made fully explicit.
`∃ x : α, P x` being "a witness plus a proof" is, formally, saying it's a
**dependent pair type**: the type of the second component (the proof)
depends on the *value* chosen for the first (the witness) — `P 2` for
witness `2`, but it would have been `P 1` for witness `1`, a genuinely
different type each time. This dependency is exactly why `∃` can't be
built from the ordinary (non-dependent) pairing you'd use for `∧`, and why
Lean needs a dedicated `Exists` former for it.

**Mathematical reading.** The two quantifiers are the "indexed" versions of
the product and sum you already saw for $\wedge$ and $\vee$ in the
previous section — instead of combining two fixed propositions $P$ and
$Q$, they combine a whole *family* of propositions $P(x)$, one for each
$x \in \alpha$. Universal quantification is the ($\Pi$-)type
$$
\forall x{:}\alpha,\ P(x) \;=\; \prod_{x : \alpha} P(x),
$$
literally an $\alpha$-indexed product: a proof is a function assigning to
each $x$ a proof of $P(x)$, so `all_nats_ge_zero` is the map $n \mapsto (0
\le n)$ — exactly generalizing how a proof of $P \wedge Q$ was a pair
$(p, q)$, one component per conjunct, except now there is one component
per element of $\alpha$ rather than just two. Existential quantification
is the ($\Sigma$-)type
$$
\exists x{:}\alpha,\ P(x) \;=\; \sum_{x : \alpha} P(x),
$$
an $\alpha$-indexed sum: a proof is a dependent pair $\langle a, h\rangle$
with $a \in \alpha$ the witness and $h : P(a)$ — here $\langle 2,
\mathrm{refl}\rangle$ witnesses $2 \bmod 2 = 0$. This is the
*constructive* reading of $\exists$: to assert existence you must exhibit
an explicit witness $a$ together with a proof $h$ that it works, exactly
generalizing how a proof of $P \vee Q$ was a tagged choice — except now
the "tag" is which element of $\alpha$ was chosen.

---

[← And, Or, Not](04-and-or-not.md) | [Index](00-index.md) | [Next: Equality reasoning →](06-equality.md)

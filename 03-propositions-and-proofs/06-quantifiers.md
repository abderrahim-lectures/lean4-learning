## Universal and existential quantifiers

[← And, Or, Not](05-and-or-not.md) | [Index](00-index.md) | [Next: Equality reasoning →](07-equality.md)

---

<p><a href="https://live.lean-lang.org/#code=theorem%20all_nats_ge_zero%20%3A%20%E2%88%80%20n%20%3A%20Nat%2C%20n%20%E2%89%A5%200%20%3A%3D%0A%20%20fun%20n%20%3D%3E%20Nat.zero_le%20n" target="_blank" rel="noopener">&#8599; Open in Lean playground (new tab)</a></p>
<iframe src="https://live.lean-lang.org/#code=theorem%20all_nats_ge_zero%20%3A%20%E2%88%80%20n%20%3A%20Nat%2C%20n%20%E2%89%A5%200%20%3A%3D%0A%20%20fun%20n%20%3D%3E%20Nat.zero_le%20n" title="Lean playground" loading="lazy" style="width:100%;height:180px;border:1px solid #ccc;border-radius:8px;">
</iframe>

- `∀ x : α, P x` is again just a (dependent) function type: given any `x`,
  produce a proof of `P x`. `all_nats_ge_zero` is literally a function
  taking any `n` and returning a proof that `n ≥ 0` — here, `Nat.zero_le n`
  already proves exactly that for whichever `n` gets passed in.

<p><a href="https://live.lean-lang.org/#code=theorem%20exists_even%20%3A%20%E2%88%83%20n%20%3A%20Nat%2C%20n%20%25%202%20%3D%200%20%3A%3D%0A%20%20%E2%9F%A82%2C%20rfl%E2%9F%A9" target="_blank" rel="noopener">&#8599; Open in Lean playground (new tab)</a></p>
<iframe src="https://live.lean-lang.org/#code=theorem%20exists_even%20%3A%20%E2%88%83%20n%20%3A%20Nat%2C%20n%20%25%202%20%3D%200%20%3A%3D%0A%20%20%E2%9F%A82%2C%20rfl%E2%9F%A9" title="Lean playground" loading="lazy" style="width:100%;height:180px;border:1px solid #ccc;border-radius:8px;">
</iframe>

- `∃ x : α, P x` is a structure: a **witness** value plus a proof that the
  witness satisfies `P`.

**Reading the shortcut `⟨2, rfl⟩`.** This is the same "here are the pieces,
in order" anonymous-constructor shorthand from
[Chapter 2 §1](../02-functions-and-structures/01-structure-basics.md).
It was already reused for `∧`
([Chapter 3 §5](05-and-or-not.md)'s `⟨hp, hq⟩`), and here it builds an
`∃`-proof in one line instead of two. The pattern to remember: **first
the number, then why it works.**

- `2` is the **witness** — the specific number being claimed even. It is
  the smallest one that actually makes the point (`0` technically works
  too, but reads as a trick — "of course `0` is even").
- [`rfl`](https://lean-lang.org/doc/reference/latest/Tactic-Proofs/Tactic-Reference/) is the **proof**, filling in for `P 2`, i.e. for `2 % 2 = 0`. It
  works by `rfl` alone (no lemma needed) because `2 % 2` simply *computes*
  to `0` — both sides of the equation are already the same term once
  evaluated, exactly like `2 + 2 = 4` back in [Chapter 3
  §1](01-prop.md).

So `⟨2, rfl⟩ : ∃ n : Nat, n % 2 = 0` reads as "2 works, and here is why: it
just computes." Wherever `⟨w, p⟩` proves an `∃`-statement
elsewhere in this book, it should be read the same way: `w` is *what* is
claimed to exist, and `p` is *why* it satisfies the property. They are
packed together because that is exactly the two pieces of data an
existence proof needs.

<p><a href="https://live.lean-lang.org/#code=--%20A%20minimal%2C%20self-contained%20primality%20check%20%28no%20Mathlib%20import%20needed%29%3A%0A--%20%60n%60%20is%20prime%20if%20it%27s%20at%20least%202%20and%20no%20number%20strictly%20between%202%20and%20n%0A--%20divides%20it.%20%60%40%5Breducible%5D%60%20lets%20%60decide%60%20below%20see%20straight%20through%0A--%20this%20definition%2C%20instead%20of%20needing%20a%20separate%20%60unfold%60%20step%20first.%0A%40%5Breducible%5D%20def%20isPrime%20%28n%20%3A%20Nat%29%20%3A%20Prop%20%3A%3D%0A%20%20n%20%E2%89%A5%202%20%E2%88%A7%20%E2%88%80%20m%20%3A%20Nat%2C%20m%20%3C%20n%20%E2%86%92%20m%20%E2%89%A5%202%20%E2%86%92%20%C2%AC%20%28m%20%E2%88%A3%20n%29%0A%0Atheorem%20exists_prime_gt_three%20%3A%20%E2%88%83%20p%20%3A%20Nat%2C%20p%20%3E%203%20%E2%88%A7%20isPrime%20p%20%3A%3D%0A%20%20%E2%9F%A85%2C%20by%20decide%E2%9F%A9" target="_blank" rel="noopener">&#8599; Open in Lean playground (new tab)</a></p>
<iframe src="https://live.lean-lang.org/#code=--%20A%20minimal%2C%20self-contained%20primality%20check%20%28no%20Mathlib%20import%20needed%29%3A%0A--%20%60n%60%20is%20prime%20if%20it%27s%20at%20least%202%20and%20no%20number%20strictly%20between%202%20and%20n%0A--%20divides%20it.%20%60%40%5Breducible%5D%60%20lets%20%60decide%60%20below%20see%20straight%20through%0A--%20this%20definition%2C%20instead%20of%20needing%20a%20separate%20%60unfold%60%20step%20first.%0A%40%5Breducible%5D%20def%20isPrime%20%28n%20%3A%20Nat%29%20%3A%20Prop%20%3A%3D%0A%20%20n%20%E2%89%A5%202%20%E2%88%A7%20%E2%88%80%20m%20%3A%20Nat%2C%20m%20%3C%20n%20%E2%86%92%20m%20%E2%89%A5%202%20%E2%86%92%20%C2%AC%20%28m%20%E2%88%A3%20n%29%0A%0Atheorem%20exists_prime_gt_three%20%3A%20%E2%88%83%20p%20%3A%20Nat%2C%20p%20%3E%203%20%E2%88%A7%20isPrime%20p%20%3A%3D%0A%20%20%E2%9F%A85%2C%20by%20decide%E2%9F%A9" title="Lean playground" loading="lazy" style="width:100%;height:231px;border:1px solid #ccc;border-radius:8px;">
</iframe>

**A second example: there is always a bigger prime.** `exists_prime_gt_three`
is one concrete instance of a classical fact: no matter which number is
chosen, there is a prime bigger than it (here the chosen number is `3`, and
`5` is a prime that beats it). It follows the exact same "number, then
why" shape as before, but with two differences worth noting:

- The *property* being witnessed, `p > 3 ∧ isPrime p`, is itself an `∧`.
  So the full picture is a witness (`5`) plus a *pair* of facts about it
  (`5 > 3`, and `5` is prime), all packed into the outer `⟨_, _⟩`.
- The proof is not `rfl`. `p > 3 ∧ isPrime p` does not reduce to a plain
  equality, so instead the second slot is by [`decide`](https://lean-lang.org/doc/reference/latest/Tactic-Proofs/Tactic-Reference/) — the same
  brute-force tactic from [Chapter 3 §5](05-and-or-not.md)'s
  `not_example`, which here checks `5 > 3` outright and tries every
  candidate divisor below `5` to confirm none of them divide it.

Read `⟨5, by decide⟩` exactly as before: `5` is still just the witness,
`by decide` is still just the proof, filled in by a tactic block instead
of `rfl` because *this* proof happens to need one. The witness-then-proof
shape never changes; only *how* the proof half gets produced does.

This one example only shows *a* prime past `3`. It does not yet show that
this works for *every* number that could have been chosen instead of `3`. That
stronger claim, $\forall n,\ \exists p > n,\ \mathrm{isPrime}\ p$ (Euclid's
theorem, first proved around 300 BCE), needs an argument that works
uniformly for an *arbitrary* `n`. That means induction, not yet
introduced. [Chapter 4](../04-tactics/00-index.md) covers the tactics
that make an argument like that possible. A fully formalized proof of
Euclid's theorem lives in Mathlib as `Nat.exists_infinite_primes`, one of
the "Read more" pointers once [Chapter 13](../13-next-steps/00-index.md)
introduces Mathlib itself.

**Remark (a more formal restatement).** The bullet points above already
state everything needed to use `∃` and `∀`. This paragraph and the
"Mathematical reading" box below only restate the same facts in more
formal language, for readers who want the connection made fully explicit.
`∃ x : α, P x` being "a witness plus a proof" is, formally, saying it is a
**dependent pair type**: the type of the second component (the proof)
depends on the *value* chosen for the first (the witness). It would be
`P 2` for witness `2`, but `P 1` for witness `1`, a genuinely
different type each time. This dependency is exactly why `∃` cannot be
built from the ordinary (non-dependent) pairing used for `∧`, and why
Lean needs a dedicated `Exists` former for it.

**Mathematical reading.** The two quantifiers are the "indexed" versions of
the product and sum seen for $\wedge$ and $\vee$ in the
previous section. Instead of combining two fixed propositions $P$ and
$Q$, they combine a whole *family* of propositions $P(x)$, one for each
$x \in \alpha$. Universal quantification is the ($\Pi$-)type
$$
\forall x{:}\alpha,\ P(x) \;=\; \prod_{x : \alpha} P(x),
$$
literally an $\alpha$-indexed product: a proof is a function assigning to
each $x$ a proof of $P(x)$, so `all_nats_ge_zero` is the map $n \mapsto (0
\le n)$. This exactly generalizes how a proof of $P \wedge Q$ was a pair
$(p, q)$, one component per conjunct, except now there is one component
per element of $\alpha$ rather than just two. Existential quantification
is the ($\Sigma$-)type
$$
\exists x{:}\alpha,\ P(x) \;=\; \sum_{x : \alpha} P(x),
$$
an $\alpha$-indexed sum: a proof is a dependent pair $\langle a, h\rangle$
with $a \in \alpha$ the witness and $h : P(a)$. Here $\langle 2,
\mathrm{refl}\rangle$ witnesses $2 \bmod 2 = 0$. This is the
*constructive* reading of $\exists$: asserting existence requires exhibiting
an explicit witness $a$ together with a proof $h$ that it works. This
exactly generalizes how a proof of $P \vee Q$ was a tagged choice, except
now the "tag" is which element of $\alpha$ was chosen.

---

[← And, Or, Not](05-and-or-not.md) | [Index](00-index.md) | [Next: Equality reasoning →](07-equality.md)

## [`simp`](https://lean-lang.org/doc/reference/latest/Tactic-Proofs/Tactic-Reference/), in light of what it replaces

[← Decision procedures](02-decision-procedures.md) | [Index](00-index.md) | [Next: Term mode vs tactic mode →](04-term-vs-tactic-mode.md)

---

Chapter 4 recommended avoiding `simp` while learning, so every step stayed
traceable. Once it is understood *why* a family of rewrites works (for
example, "additive identity/inverse cancellation," as in Chapter 9),
`simp` is the efficient way to apply a whole *set* of these known-safe
rewrites at once, instead of spelling out each one:

<p><a href="https://live.lean-lang.org/#code=--%20Chapter%209%20style%20%28explicit%2C%20for%20learning%29%3A%0Atheorem%20ex1%20%28n%20%3A%20Nat%29%20%3A%20n%20%2B%200%20%3D%20n%20%3A%3D%20by%0A%20%20exact%20Nat.add_zero%20n%0A%0A--%20Once%20the%20fact%20class%20is%20understood%2C%20in%20later%20proofs%3A%0Atheorem%20ex2%20%28n%20%3A%20Nat%29%20%3A%20n%20%2B%200%20%3D%20n%20%3A%3D%20by%0A%20%20simp" target="_blank" rel="noopener">&#8599; Open in Lean playground (new tab)</a></p>
<iframe src="https://live.lean-lang.org/#code=--%20Chapter%209%20style%20%28explicit%2C%20for%20learning%29%3A%0Atheorem%20ex1%20%28n%20%3A%20Nat%29%20%3A%20n%20%2B%200%20%3D%20n%20%3A%3D%20by%0A%20%20exact%20Nat.add_zero%20n%0A%0A--%20Once%20the%20fact%20class%20is%20understood%2C%20in%20later%20proofs%3A%0Atheorem%20ex2%20%28n%20%3A%20Nat%29%20%3A%20n%20%2B%200%20%3D%20n%20%3A%3D%20by%0A%20%20simp" title="Lean playground" loading="lazy" style="width:100%;height:193px;border:1px solid #ccc;border-radius:8px;">
</iframe>

A good habit: the *first* time a new kind of cancellation or
identity simplification is encountered, it should be done by hand with named lemmas, as this book
does throughout. After that, `simp` (optionally `simp [specific_lemma]` to
narrow it, or `simp only [...]` to restrict exactly which lemmas fire) is
the right everyday tool. Using `simp` from the start is how proofs end up
compiling without anyone, including the author, being able to explain
them a week later.

**Mathematical reading.** `simp` is *normalization by rewriting*: it treats
a chosen set of equations $\{\ell_i = r_i\}$ (the simp set) as a
left-to-right rewriting system and drives the goal to a normal form,
closing it when both sides normalize to the same term. Both proofs of
$n + 0 = n$ use the same fact, $n + 0 = n$ (the right-unit law for $+$).
The explicit version cites it by name; `simp` finds it in the rewrite
system. This is the algebraist's everyday move of "simplify using the
obvious identities." It works exactly when the rewrite rules are valid
equalities, and confluent enough to reach a canonical form.

---

[← Decision procedures](02-decision-procedures.md) | [Index](00-index.md) | [Next: Term mode vs tactic mode →](04-term-vs-tactic-mode.md)

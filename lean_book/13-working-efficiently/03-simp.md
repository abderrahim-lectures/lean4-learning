## [`simp`](https://lean-lang.org/doc/reference/latest/Tactic-Proofs/Tactic-Reference/), in light of what it replaces

[← Decision procedures](02-decision-procedures.md) | [Index](00-index.md) | [Next: Term mode vs tactic mode →](04-term-vs-tactic-mode.md)

---

Chapter 5 recommended avoiding `simp` while learning, so every step stayed
traceable. Once it is understood *why* a family of rewrites works (for
example, "additive identity/inverse cancellation," as in Chapter 10),
`simp` is the efficient way to apply a whole *set* of these known-safe
rewrites at once, instead of spelling out each one.

```lean
-- Chapter 10 style (explicit, for learning):
theorem ex1 (n : Nat) : n + 0 = n := by
  exact Nat.add_zero n

-- Once the fact class is understood, in later proofs:
theorem ex2 (n : Nat) : n + 0 = n := by
  simp
```

A good habit is that the *first* time a new kind of cancellation or
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
system. This is the everyday move of an algebraist to "simplify using the
obvious identities." It works exactly when the rewrite rules are valid
equalities, and confluent enough to reach a canonical form, the same
general confluence property (Newman's lemma and its extensions) already
invoked for term rewriting in
[Chapter 2, Section 1](../02-terminology-and-coc/01-terminology.md#sources-quoted)
([Huet1980]).

[Huet1980]: ../bibliography.md#huet1980

---

[← Decision procedures](02-decision-procedures.md) | [Index](00-index.md) | [Next: Term mode vs tactic mode →](04-term-vs-tactic-mode.md)

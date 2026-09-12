## Exercises

[← Structuring lemmas](05-structuring-lemmas.md) | [Index](00-index.md)

---

**Key points.** The tactics in this chapter are force multipliers. `exact?`
and `apply?` search the library for you. `decide`, `omega`, and `norm_num`
decide arithmetic goals automatically. `simp` simplifies expressions but
can hide the interesting step — use it wisely. Term mode and tactic mode
are two views of the same proof; knowing when to switch saves time.

**Deep practice.** These exercises are designed to push you to the edge
of your ability. Start with the search tactics, then move to the decision
procedures. If you're making no mistakes, you're not learning; if you're
making more than 20% mistakes, reread the relevant section first.

1. **Search tactics.** In a Lean file, write:
   ```lean
   #check @Nat.add_comm
   #check @Nat.mul_comm
   ```
   Now suppose you need to prove `a + b + c = c + b + a` for `a b c : Nat`.
   Use `exact?` or `apply?` to find the right lemma. Then prove it in
   term mode using the lemma you found.

2. **`decide` vs `omega`.** Prove the following three goals, choosing the
   right tactic for each:
   - `2 + 2 = 4 : Nat`
   - `∀ n : Nat, n + 0 = n`
   - `∀ n : Nat, n < n + 1`
   Explain why `decide` works for the first but not the second, and why
   `omega` works for the second but not the third.

3. **`simp` chains.** Write a proof of `(a + b) * (c + d) = a * c + a * d +
   b * c + b * d` for `a b c d : Nat` using only `simp` with appropriate
   lemmas. Then write the same proof using `ring`. Which is shorter? Which
   reveals more about the structure of the proof?

4. **Term vs tactic mode.** Write the proof of `Nat.add_comm` (that `a + b =
   b + a` for all natural numbers) in three ways:
   - Term mode using `Nat.rec`
   - Tactic mode using `induction a`
   - Term mode using `omega`
   Compare the three. Which is most readable? Which is most general?

5. **Structuring lemmas.** Suppose you have proved:
   ```lean
   theorem add_zero' (a : Nat) : a + 0 = a := Nat.add_zero a
   theorem zero_add' (a : Nat) : 0 + a = a := Nat.zero_add a
   ```
   Now prove `a + 0 + 0 = a` using these lemmas. Then prove
   `0 + a + 0 = a`. Which lemmas did you need? Write a general lemma
   `add_zeros (a : Nat) : a + 0 + 0 = a` that works for any `a`.

6. **Integration.** This exercise combines everything. Prove:
   ```lean
   theorem mul_add_eq (a b c : Nat) : a * (b + c) = a * b + a * c
   ```
   using at least three different approaches (e.g., `ring`, `simp` with
   `Int.mul_add`, manual `rw`). Time yourself on each approach. Which
   was fastest to write? Which was most educational?

Solutions, [Appendix, Chapter 13](../15-appendix-solutions/13-chapter-13.md).

---

[← Structuring lemmas](05-structuring-lemmas.md) | [Index](00-index.md) | [Table of contents](../README.md) | [Ch. 14: Next Steps →](../14-next-steps/00-index.md)

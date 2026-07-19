## Checkpoint project: a `Monoid` from scratch

[← Exercises](05-exercises.md) | [Index](00-index.md)

---

Part I is now complete: terms and types, structures, propositions and
proofs, tactics, and the rigor questions just answered. Before Chapter 6
builds `Group`, this project asks for a smaller, self-contained version of
exactly that construction — a **monoid**: a set with an associative
operation and a two-sided identity, but *no* inverses. Everything needed
is already in hand from Chapters 1–5 alone; nothing here depends on
`Group`, so it previews the next chapter's construction rather than
spoiling it.

**Learning objectives.** Practice bundling data with proof obligations in
a `structure` (Chapter 2), writing tactic-mode proofs for a genuine
algebraic axiom set (Chapter 4), and building a small "prove it once,
generically" theorem in the style Chapter 7 will use for `Group` — here
done for the weaker `Monoid` first.

**Prerequisites.** Chapters 1–5 only.

**Milestones.**

1. Define `structure Monoid (M : Type) where` with fields `op`, `id`, and
   proof obligations `assoc`, `id_left`, `id_right` — exactly `Group`'s
   fields (Chapter 6 §2), minus `inv`/`inv_left`/`inv_right`.
2. Build at least one concrete instance. Two natural choices, both reusing
   facts already available from core Lean: `List α` under `++`/`[]`, or
   `Nat` under `*`/`1`.
3. Prove a generic theorem for an arbitrary `Mn : Monoid M`: *the identity
   is unique* — if `e' : M` satisfies `∀ a, Mn.op e' a = a`, then
   `e' = Mn.id`. This is exactly Chapter 7's Theorem 1 (`id_unique`)
   carried out one chapter early, and — worth checking directly — its
   proof never needs an inverse, so nothing about lacking one gets in the
   way.

**Deliverable.** `structure Monoid`, at least one concrete instance (with
all three proof obligations discharged), and the generic uniqueness
theorem, applied to that instance.

**Self-verification.**

<p><a href="https://live.lean-lang.org/#code=structure%20Monoid%20%28M%20%3A%20Type%29%20where%0A%20%20op%20%3A%20M%20%E2%86%92%20M%20%E2%86%92%20M%0A%20%20id%20%3A%20M%0A%20%20assoc%20%3A%20%E2%88%80%20a%20b%20c%20%3A%20M%2C%20op%20%28op%20a%20b%29%20c%20%3D%20op%20a%20%28op%20b%20c%29%0A%20%20id_left%20%3A%20%E2%88%80%20a%20%3A%20M%2C%20op%20id%20a%20%3D%20a%0A%20%20id_right%20%3A%20%E2%88%80%20a%20%3A%20M%2C%20op%20a%20id%20%3D%20a%0A%0Adef%20listMonoid%20%28%CE%B1%20%3A%20Type%29%20%3A%20Monoid%20%28List%20%CE%B1%29%20where%0A%20%20op%20%3A%3D%20List.append%0A%20%20id%20%3A%3D%20%5B%5D%0A%20%20assoc%20%3A%3D%20by%20intro%20a%20b%20c%3B%20exact%20List.append_assoc%20a%20b%20c%0A%20%20id_left%20%3A%3D%20by%20intro%20a%3B%20exact%20List.nil_append%20a%0A%20%20id_right%20%3A%3D%20by%20intro%20a%3B%20exact%20List.append_nil%20a%0A%0Atheorem%20monoid_id_unique%20%7BM%20%3A%20Type%7D%20%28Mn%20%3A%20Monoid%20M%29%20%28e%27%20%3A%20M%29%0A%20%20%20%20%28h%20%3A%20%E2%88%80%20a%20%3A%20M%2C%20Mn.op%20e%27%20a%20%3D%20a%29%20%3A%20e%27%20%3D%20Mn.id%20%3A%3D%20by%0A%20%20have%20step1%20%3A%20Mn.op%20e%27%20Mn.id%20%3D%20Mn.id%20%3A%3D%20h%20Mn.id%0A%20%20have%20step2%20%3A%20Mn.op%20e%27%20Mn.id%20%3D%20e%27%20%3A%3D%20Mn.id_right%20e%27%0A%20%20rw%20%5B%E2%86%90%20step2%5D%0A%20%20exact%20step1%0A%0A--%20Applying%20the%20generic%20theorem%20to%20the%20concrete%20instance%20costs%20nothing%0A--%20beyond%20naming%20it%20%E2%80%94%20the%20same%20%22prove%20once%2C%20use%20everywhere%22%20payoff%0A--%20Chapter%206%20%C2%A76%20promises%20for%20Group%2C%20delivered%20here%20one%20chapter%20early.%0A%23check%20monoid_id_unique%20%28listMonoid%20Nat%29%20%5B%5D%20%28fun%20a%20%3D%3E%20List.nil_append%20a%29" target="_blank" rel="noopener">&#8599; Open in Lean playground (new tab)</a></p>
<iframe src="https://live.lean-lang.org/#code=structure%20Monoid%20%28M%20%3A%20Type%29%20where%0A%20%20op%20%3A%20M%20%E2%86%92%20M%20%E2%86%92%20M%0A%20%20id%20%3A%20M%0A%20%20assoc%20%3A%20%E2%88%80%20a%20b%20c%20%3A%20M%2C%20op%20%28op%20a%20b%29%20c%20%3D%20op%20a%20%28op%20b%20c%29%0A%20%20id_left%20%3A%20%E2%88%80%20a%20%3A%20M%2C%20op%20id%20a%20%3D%20a%0A%20%20id_right%20%3A%20%E2%88%80%20a%20%3A%20M%2C%20op%20a%20id%20%3D%20a%0A%0Adef%20listMonoid%20%28%CE%B1%20%3A%20Type%29%20%3A%20Monoid%20%28List%20%CE%B1%29%20where%0A%20%20op%20%3A%3D%20List.append%0A%20%20id%20%3A%3D%20%5B%5D%0A%20%20assoc%20%3A%3D%20by%20intro%20a%20b%20c%3B%20exact%20List.append_assoc%20a%20b%20c%0A%20%20id_left%20%3A%3D%20by%20intro%20a%3B%20exact%20List.nil_append%20a%0A%20%20id_right%20%3A%3D%20by%20intro%20a%3B%20exact%20List.append_nil%20a%0A%0Atheorem%20monoid_id_unique%20%7BM%20%3A%20Type%7D%20%28Mn%20%3A%20Monoid%20M%29%20%28e%27%20%3A%20M%29%0A%20%20%20%20%28h%20%3A%20%E2%88%80%20a%20%3A%20M%2C%20Mn.op%20e%27%20a%20%3D%20a%29%20%3A%20e%27%20%3D%20Mn.id%20%3A%3D%20by%0A%20%20have%20step1%20%3A%20Mn.op%20e%27%20Mn.id%20%3D%20Mn.id%20%3A%3D%20h%20Mn.id%0A%20%20have%20step2%20%3A%20Mn.op%20e%27%20Mn.id%20%3D%20e%27%20%3A%3D%20Mn.id_right%20e%27%0A%20%20rw%20%5B%E2%86%90%20step2%5D%0A%20%20exact%20step1%0A%0A--%20Applying%20the%20generic%20theorem%20to%20the%20concrete%20instance%20costs%20nothing%0A--%20beyond%20naming%20it%20%E2%80%94%20the%20same%20%22prove%20once%2C%20use%20everywhere%22%20payoff%0A--%20Chapter%206%20%C2%A76%20promises%20for%20Group%2C%20delivered%20here%20one%20chapter%20early.%0A%23check%20monoid_id_unique%20%28listMonoid%20Nat%29%20%5B%5D%20%28fun%20a%20%3D%3E%20List.nil_append%20a%29" title="Lean playground" loading="lazy" style="width:100%;height:535px;border:1px solid #ccc;border-radius:8px;">
</iframe>

If this compiles (`lake env lean` on a file containing it, or pasted into
`lean_project`), the project is done. A full worked solution, including a
second instance, is in [Appendix, Chapter 5](../14-appendix-solutions/04-chapter-5.md).

---

[← Exercises](05-exercises.md) | [Index](00-index.md) | [Table of contents](../README.md) | [Ch. 6: Groups →](../06-groups/00-index.md)

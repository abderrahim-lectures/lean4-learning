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

```lean
structure Monoid (M : Type) where
  op : M → M → M
  id : M
  assoc : ∀ a b c : M, op (op a b) c = op a (op b c)
  id_left : ∀ a : M, op id a = a
  id_right : ∀ a : M, op a id = a

def listMonoid (α : Type) : Monoid (List α) where
  op := List.append
  id := []
  assoc := by intro a b c; exact List.append_assoc a b c
  id_left := by intro a; exact List.nil_append a
  id_right := by intro a; exact List.append_nil a

theorem monoid_id_unique {M : Type} (Mn : Monoid M) (e' : M)
    (h : ∀ a : M, Mn.op e' a = a) : e' = Mn.id := by
  have step1 : Mn.op e' Mn.id = Mn.id := h Mn.id
  have step2 : Mn.op e' Mn.id = e' := Mn.id_right e'
  rw [← step2]
  exact step1

-- Applying the generic theorem to the concrete instance costs nothing
-- beyond naming it — the same "prove once, use everywhere" payoff
-- Chapter 6 §6 promises for Group, delivered here one chapter early.
#check monoid_id_unique (listMonoid Nat) [] (fun a => List.nil_append a)
```

If this compiles (`lake env lean` on a file containing it, or pasted into
`lean_project`), the project is done. A full worked solution, including a
second instance, is in [Appendix, Chapter 5](../14-appendix-solutions/04-chapter-5.md).

---

[← Exercises](05-exercises.md) | [Index](00-index.md) | [Table of contents](../README.md) | [Ch. 6: Groups →](../06-groups/00-index.md)

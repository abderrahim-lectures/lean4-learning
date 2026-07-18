## Checkpoint project: path length, and composition respects it

[← Exercises](06-exercises.md) | [Index](00-index.md)

---

Part II closes here, having built groups, rings, modules, and now quivers
and paths from scratch. This project extends the `Path`/`Path.append`
construction from §4–§5 with one more piece of structure — a path's
**length** — and proves it behaves the way it obviously should under
composition, tying together this chapter's inductive-type work with the
"prove it once, generically" habit Chapters 7 and 9 established.

**Learning objectives.** Define a recursive function over the same indexed
inductive type `Path` (§4), then prove a genuine theorem about it by
induction, mirroring `Path.append`'s own recursion case for case (§5).
Along the way, this project surfaces a real, verifiable fact about Lean:
because `Path` is *indexed* by both its endpoints, functions matching on
it (both `Path.append` and the `Path.length` built here) do not reduce by
bare `rfl` once an abstract path variable is involved — only their
auto-generated equation lemmas do. This is worth discovering directly
rather than being told, the same way §5's own worked proofs are best
understood by predicting what each `rw` will do before running it.

**Prerequisites.** Chapters 1–11, specifically §4 (`Path`) and §5
(`Path.append`).

**Milestones.**

1. Define `Path.length : {u v : V} → Path Q u v → Nat` by recursion: the
   trivial path `nil` has length `0`; `cons a h h' p` has length
   `p.length + 1` (one more than the path it extends).
2. Compute a couple of lengths by hand and check them with `#eval` against
   §4's example paths (`pathAlpha`, `pathBetaAlpha`).
3. Prove `Path.append_length : (Path.append p q).length = p.length +
   q.length` by induction on `q`, mirroring `Path.append`'s own
   `nil`/`cons` cases. Predict, before running it, whether each case
   closes by `rfl` — then discover (as the note above flags) that it does
   not, and that `simp only [Path.append, Path.length]` is needed to
   unfold one step, exactly as `rfl` needs the *equation lemmas*
   Lean generates for an indexed match, not raw iota-reduction, once an
   abstract path is involved.

**Deliverable.** `Path.length` and the proved theorem
`Path.append_length`, checked against at least one concrete instance.

**Self-verification.**

```lean
def Path.length {V A : Type} {Q : Quiver V A} : {u v : V} → Path Q u v → Nat
  | _, _, Path.nil _ => 0
  | _, _, Path.cons _ _ _ p => p.length + 1

#eval pathAlpha.length        -- 1
#eval pathBetaAlpha.length    -- 2

theorem Path.append_length {V A : Type} {Q : Quiver V A} {u v w : V}
    (p : Path Q u v) (q : Path Q v w) :
    (Path.append p q).length = p.length + q.length := by
  induction q with
  | nil =>
    simp only [Path.append, Path.length]
    rw [Nat.add_zero]
  | cons a h h' q' ih =>
    simp only [Path.append, Path.length]
    rw [ih, Nat.add_assoc]

-- The concrete check: pathBetaAlpha was §5's own worked example of
-- Path.append; its length should be pathAlpha.length + pathBetaOnly.length.
example : (Path.append pathAlpha pathBetaOnly).length =
    pathAlpha.length + pathBetaOnly.length :=
  Path.append_length pathAlpha pathBetaOnly

#eval (Path.append pathAlpha pathBetaOnly).length   -- 2
```

If this compiles and the `#eval`s match, the project is done. A full
worked solution is in
[Appendix, Chapter 11](../14-appendix-solutions/10-chapter-11.md).

---

[← Exercises](06-exercises.md) | [Index](00-index.md) | [Table of contents](../README.md) | [Ch. 12: Working Efficiently →](../12-working-efficiently/00-index.md)

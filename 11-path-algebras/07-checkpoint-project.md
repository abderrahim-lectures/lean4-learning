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

<p><a href="https://live.lean-lang.org/#code=def%20Path.length%20%7BV%20A%20%3A%20Type%7D%20%7BQ%20%3A%20Quiver%20V%20A%7D%20%3A%20%7Bu%20v%20%3A%20V%7D%20%E2%86%92%20Path%20Q%20u%20v%20%E2%86%92%20Nat%0A%20%20%7C%20_%2C%20_%2C%20Path.nil%20_%20%3D%3E%200%0A%20%20%7C%20_%2C%20_%2C%20Path.cons%20_%20_%20_%20p%20%3D%3E%20p.length%20%2B%201%0A%0A%23eval%20pathAlpha.length%20%20%20%20%20%20%20%20--%201%0A%23eval%20pathBetaAlpha.length%20%20%20%20--%202%0A%0Atheorem%20Path.append_length%20%7BV%20A%20%3A%20Type%7D%20%7BQ%20%3A%20Quiver%20V%20A%7D%20%7Bu%20v%20w%20%3A%20V%7D%0A%20%20%20%20%28p%20%3A%20Path%20Q%20u%20v%29%20%28q%20%3A%20Path%20Q%20v%20w%29%20%3A%0A%20%20%20%20%28Path.append%20p%20q%29.length%20%3D%20p.length%20%2B%20q.length%20%3A%3D%20by%0A%20%20induction%20q%20with%0A%20%20%7C%20nil%20%3D%3E%0A%20%20%20%20simp%20only%20%5BPath.append%2C%20Path.length%5D%0A%20%20%20%20rw%20%5BNat.add_zero%5D%0A%20%20%7C%20cons%20a%20h%20h%27%20q%27%20ih%20%3D%3E%0A%20%20%20%20simp%20only%20%5BPath.append%2C%20Path.length%5D%0A%20%20%20%20rw%20%5Bih%2C%20Nat.add_assoc%5D%0A%0A--%20The%20concrete%20check%3A%20pathBetaAlpha%20was%20%C2%A75%27s%20own%20worked%20example%20of%0A--%20Path.append%3B%20its%20length%20should%20be%20pathAlpha.length%20%2B%20pathBetaOnly.length.%0Aexample%20%3A%20%28Path.append%20pathAlpha%20pathBetaOnly%29.length%20%3D%0A%20%20%20%20pathAlpha.length%20%2B%20pathBetaOnly.length%20%3A%3D%0A%20%20Path.append_length%20pathAlpha%20pathBetaOnly%0A%0A%23eval%20%28Path.append%20pathAlpha%20pathBetaOnly%29.length%20%20%20--%202" target="_blank" rel="noopener">&#8599; Open in Lean playground (new tab)</a></p>
<iframe src="https://live.lean-lang.org/#code=def%20Path.length%20%7BV%20A%20%3A%20Type%7D%20%7BQ%20%3A%20Quiver%20V%20A%7D%20%3A%20%7Bu%20v%20%3A%20V%7D%20%E2%86%92%20Path%20Q%20u%20v%20%E2%86%92%20Nat%0A%20%20%7C%20_%2C%20_%2C%20Path.nil%20_%20%3D%3E%200%0A%20%20%7C%20_%2C%20_%2C%20Path.cons%20_%20_%20_%20p%20%3D%3E%20p.length%20%2B%201%0A%0A%23eval%20pathAlpha.length%20%20%20%20%20%20%20%20--%201%0A%23eval%20pathBetaAlpha.length%20%20%20%20--%202%0A%0Atheorem%20Path.append_length%20%7BV%20A%20%3A%20Type%7D%20%7BQ%20%3A%20Quiver%20V%20A%7D%20%7Bu%20v%20w%20%3A%20V%7D%0A%20%20%20%20%28p%20%3A%20Path%20Q%20u%20v%29%20%28q%20%3A%20Path%20Q%20v%20w%29%20%3A%0A%20%20%20%20%28Path.append%20p%20q%29.length%20%3D%20p.length%20%2B%20q.length%20%3A%3D%20by%0A%20%20induction%20q%20with%0A%20%20%7C%20nil%20%3D%3E%0A%20%20%20%20simp%20only%20%5BPath.append%2C%20Path.length%5D%0A%20%20%20%20rw%20%5BNat.add_zero%5D%0A%20%20%7C%20cons%20a%20h%20h%27%20q%27%20ih%20%3D%3E%0A%20%20%20%20simp%20only%20%5BPath.append%2C%20Path.length%5D%0A%20%20%20%20rw%20%5Bih%2C%20Nat.add_assoc%5D%0A%0A--%20The%20concrete%20check%3A%20pathBetaAlpha%20was%20%C2%A75%27s%20own%20worked%20example%20of%0A--%20Path.append%3B%20its%20length%20should%20be%20pathAlpha.length%20%2B%20pathBetaOnly.length.%0Aexample%20%3A%20%28Path.append%20pathAlpha%20pathBetaOnly%29.length%20%3D%0A%20%20%20%20pathAlpha.length%20%2B%20pathBetaOnly.length%20%3A%3D%0A%20%20Path.append_length%20pathAlpha%20pathBetaOnly%0A%0A%23eval%20%28Path.append%20pathAlpha%20pathBetaOnly%29.length%20%20%20--%202" title="Lean playground" loading="lazy" style="width:100%;height:535px;border:1px solid #ccc;border-radius:8px;">
</iframe>

If this compiles and the `#eval`s match, the project is done. A full
worked solution is in
[Appendix, Chapter 11](../14-appendix-solutions/10-chapter-11.md).

---

[← Exercises](06-exercises.md) | [Index](00-index.md) | [Table of contents](../README.md) | [Ch. 12: Working Efficiently →](../12-working-efficiently/00-index.md)

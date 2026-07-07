## `Prop`: the type of statements

[← Index](00-index.md) | [Next: `theorem` and `lemma` →](02-theorem-lemma.md)

---

Alongside `Type`, Lean has `Prop`, the type of logical propositions. A term
of type `P : Prop` is a **proof** of `P`. This is the **Curry–Howard
correspondence**: propositions are types, and proofs are programs.

```lean
#check (2 + 2 = 4)     -- 2 + 2 = 4 : Prop

example : 2 + 2 = 4 := rfl
```

`rfl` is the proof "both sides compute to the same thing" (**refl**exivity).
`example` states a proposition and immediately supplies a proof (an
anonymous, unnamed `theorem`).

**Mathematical reading.** The Curry–Howard correspondence identifies a
proposition $P$ with the *set of its proofs*: $P$ is inhabited (there
exists a term $p : P$) exactly when $P$ is true. Thus `Prop` is the
subuniverse of types that are "propositional" — each has at most one
element up to proof irrelevance, so a type $P : \mathrm{Prop}$ behaves like
a truth value $\llbracket P \rrbracket \in \{\varnothing, \{\ast\}\}$.
Writing $\vdash P$ ("$P$ is provable") is the same as exhibiting an element
$p \in P$. The proof `rfl : 2 + 2 = 4` is the reflexivity witness
$\mathrm{refl}_4$ of the equality relation, valid precisely because both
sides reduce to the same normal form $4$ — equality of terms that are
*definitionally* equal, the strictest notion of "$=$".

---

[← Index](00-index.md) | [Next: `theorem` and `lemma` →](02-theorem-lemma.md)

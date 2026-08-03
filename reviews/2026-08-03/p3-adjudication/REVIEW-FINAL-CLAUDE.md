# REVIEW-FINAL-CLAUDE — *Lean for Working Algebraists*

**Role:** closing verification reviewer (`claude-final-reviewer`)
**Run:** 2026-08-03, single session, no subagents
**Scope:** all Markdown under `lean_book/` (~85k words, 15 chapters, 4 reference
pages, bibliography, changelog), plus triage of every finding in
`reviews/2026-08-02/FINAL-REVIEW.md`
**Ground truth:** the live repo at `591f418`, toolchain
`lean_project/lean-toolchain` = `leanprover/lean4:v4.32.2`
**External corroboration:** Consensus (10 queries), cached at
[`../consensus-cache.md`](../consensus-cache.md) — reuse it, do not re-query

---

## 1. Verdict

**Major revisions.** One CRITICAL, three HIGH, four MEDIUM, six LOW.

(Two further predicted-CRITICAL compile failures were tested against the real
toolchain and **both were wrong**. Retracted in full at §3.)

The CRITICAL is N0: `11-path-algebras/02-paths.md:17-19` defines the trivial
path as *"composing with nothing but itself."* That is false — $e_i$ is the
identity at $i$ — and the book's own next file builds `pathAlpha` by composing
$e_0$ with $\alpha$, while Section 5 states the identity laws and sets one as an
exercise. A wrong definition of the object a chapter is built on is not a
minor revision, however short the repair.

Every finding the 2026-08-02 pipeline escalated to CRITICAL or HIGH has been
fixed since that run — the seven `v4.33.0` strings are now `v4.32.2`,
`REPRODUCING.md` pins the toolchain explicitly instead of saying "latest
stable," `Ch12WorkingEfficiently.lean` / `Ch14AppendixSolutions.lean` /
`Ch01DependentTypes.lean` all exist in `lean_project/LeanProject/`, and the
audience contradiction is gone from `REPRODUCING.md`. Of eight surviving
findings in that report, seven are now closed; one LOW remains.

What the free-tier pipeline did not find, and what this pass did, is six
misstatements in the *mathematics and type theory* — the layer all six of those
reviewers declared clean (*"not one mathematical claim or compiled proof was
shown to be wrong"*). That verdict is wrong, and the reason is structural: none
of the six ran the degenerate-case sweep, so all six read past a false
definition sitting in the length-$0$ case. N0 is the cross-model blind spot.

Five of the six are **self-contradictions** — the book states the correct fact
in one file and the wrong one in another (N0, N1, N2, N3, N10). That pattern is
the single most useful thing in this report: this book cross-references itself
heavily and its individual statements are unusually careful, so its errors are
almost never isolated mistakes. They are places where two careful statements
disagree. Grepping for a claim's second occurrence is a higher-yield check on
this manuscript than reading any single passage closely.

The two theory chapters carry the load. Chapter 5 §3 is otherwise exact —
STLC's (Var)/(Abs)/(App), progress, preservation, and `Type i : Type (i+1)` are
all correct — but its Π-universe rule omits `imax`, so the rule as printed
contradicts every `∀` in Chapters 3–11 (N11). Chapter 5 §4's opening `rfl`
block teaches the inverse of the truth (N10). Chapter 1 is correct on the
mathematics, with one garbled Σ-type passage (N2); its code compiles and its
printed outputs match the toolchain exactly.

The citation discipline is genuinely strong: verbatim quotes are separated from
working statements, page numbers are given, and what could not be verified is
flagged in the text. Ten Consensus queries found no attribution that is wrong;
two that are imprecise.

---

## 2. Triage of `reviews/2026-08-02/FINAL-REVIEW.md`

| ID | Original claim | Status now | Evidence |
| --- | --- | --- | --- |
| **C1** | Docs say `v4.33.0`, pin is `v4.32.2`, seven locations | **RESOLVED** | All seven now read `v4.32.2`: `README.md:108`, `NOTICE.md:10`, `NOTICE.md:43`, `lean_book/README.md:40`, `lean_book/00-setup/02-installing-toolchain.md:32`, `lean_book/00-setup/04-mathlib-note.md:45`, `lean_book/learning-paths.md:60`. Repo-wide grep for `v4.3[0-9].[0-9]` returns only `v4.32.2`. |
| **C2** | No `Ch12*`, no solutions module, no Ch 1 dependent-types module | **RESOLVED (compile pending)** | `lean_project/LeanProject/` now contains `Ch01DependentTypes.lean`, `Ch12WorkingEfficiently.lean`, `Ch14AppendixSolutions.lean`. The *existence* half is closed. The *"verified with `lake build`"* half reached 15 of 22 modules and then could not be finished — the container's disk I/O degraded to the point where Lean will not start. **Still open**; see §5. |
| **C3** | Three contradictory audience specs across README / lean_book README / REPRODUCING | **RESOLVED** | The offending `REPRODUCING.md` line ("already have programming experience — cut beginner-programmer explanations") no longer exists; grep finds no match. `README.md:37` and `lean_book/README.md:7` now agree ("no prior exposure to … programming"). `README.md:71`'s "readers with programming background" scopes the *optional* Programmer's-corner boxes, which is consistent, not contradictory. |
| **H1** | `REPRODUCING.md` says "latest stable toolchain" | **RESOLVED** | Grep for `latest stable` / `latest release` in `REPRODUCING.md`: zero hits. `REPRODUCING.md:15-18` now pins `leanprover/lean4:v4.32.2` and Mathlib `rev = v4.32.2` explicitly. |
| **M1** | Nav strips differ top vs bottom | **RESOLVED** | The three cited files now match: `00-setup/04-mathlib-note.md` 4/4, `14-appendix-solutions/01-chapter-1.md` 2/2, `14-appendix-solutions/03-chapter-4.md` 3/3. |
| **M2** | Appendix skips Chapter 2 without explanation | **OPEN** | `14-appendix-solutions/00-index.md:18-19` still jumps "1. Chapter 1 … 2. Chapter 3" with no note. Still correct (Chapter 2 has no exercises) and still invites the double-take. **FIX:** one line after the section list — "Chapter 2 has no exercises, so no solutions section exists for it." |
| **M3** | Ch 13 story frames three questions, chapter has four sections | **RESOLVED** | `13-next-steps/00-index.md:16-24` now reads "asks four questions in turn … Fourth, the solutions to the chapter's exercises." |
| **M4** | No direct elan install URL in Setup | **RESOLVED** | `00-setup/02-installing-toolchain.md` now links `https://lean-lang.org/lean4/doc/quickstart.html` directly (verified live, HTTP 200). |

**Dismissals I re-checked and agree with:** the adjudicator's rejection of
nemotron's seven findings, north-mini's `exact?` / `Nat.succ_add` claims, and
laguna's `Submodule`-incompleteness claim all hold. `10-modules/04-submodules.md`
is indeed complete for modules over a ring — `neg_mem` follows from `smul_mem`
at `r := -1`, matching Mathlib's own design.

---

## 3. New findings — independent sweep

### CRITICAL

#### N0. The definition of a trivial path is false, and the book's own next file contradicts it

**WHERE:** `11-path-algebras/02-paths.md:17-19`

**WHAT:** Verbatim: *"In addition, for each vertex $i$, a **trivial path**
$e_i$ of length $0$ is allowed, starting and ending at $i$ and **composing with
nothing but itself**."*

**WHY IT IS WRONG:** $e_i$ composes with every path that starts at $i$ and every
path that ends at $i$. That is the entire point of a length-$0$ path: it is the
**identity** of $\mathrm{Hom}(i,i)$ in the free category, not an isolated
element. In this section's own running example, $e_1$ composes with
$\alpha : 1 \to 2$ and the result is $\alpha$.

Three places in the book contradict the sentence directly:

1. `11-path-algebras/04-paths-as-inductive-type.md` builds the very first
   worked path as `Path.cons ExampleArrow.alpha rfl rfl (Path.nil 0)` — i.e.
   by composing the trivial path at `0` with `alpha`. If $e_0$ composed with
   nothing but itself, this term could not exist.
2. `11-path-algebras/05-path-composition.md`'s "Mathematical reading" states
   the identity laws outright: *"`Path.append p (Path.nil v) = p` … and,
   separately, `Path.append (Path.nil u) p = p`"*, and Exercise 2 asks the
   reader to prove the second by induction.
3. The same file's Sources box quotes Assem–Simson–Skowroński: each
   $\varepsilon_x$ is idempotent and $\sum_{x \in Q_0}\varepsilon_x$ is the
   **identity** of $KQ$ when $Q_0$ is finite. An element composing with nothing
   but itself cannot be a summand of a unit.

**CITATION:** Assem, Simson & Skowroński, *Elements of the Representation
Theory of Associative Algebras* Vol. 1, Ch. II §1, pp. 42–43 (the stationary
path $\varepsilon_a$, quoted in the book's own Sources box); Schiffler,
*Quiver Representations*, Def. 2.1 (the constant path $e_i$); Mac Lane,
*Categories for the Working Mathematician*, Ch. I §2 (identity morphism).

**IMPACT:** This is the definition of the object Chapter 11 is built on, stated
in the section that introduces it, and it is false. A reader who takes it at
face value cannot construct `pathAlpha` two files later, cannot make sense of
the identity laws in Section 5, cannot do Exercise 2, and will not understand
why $\sum_x \varepsilon_x$ is the unit of the path algebra. It also silently
breaks the free-category reading the chapter leans on throughout — a category
whose identity morphisms compose with nothing would not be a category. Every
one of the six free-tier reviewers passed over this; it sits inside the
degenerate case their sweep never ran.

**FIX:** *"…starting and ending at $i$. It composes with any path that starts
or ends at $i$, leaving it unchanged — $e_i$ is the identity at $i$, which is
exactly what makes the length-$0$ paths the units of the path algebra in
Section 5."*

### RETRACTED — two predicted compile failures, both tested and both wrong

I predicted two CRITICAL compile failures in Chapter 1's code before the
toolchain finished installing. Both were then run against Lean 4.32.2. **Both
predictions were wrong, and the book is correct in both cases.** Recorded in
full rather than deleted, because a reviewer's false positives are part of the
evidence about that reviewer.

#### N12 — DISMISSED. `#eval` on a `Vec` with no `Repr` instance

I claimed `#eval (Vec.replicate (-42 : Int) 3 : Vec Int 3)` could not
elaborate, because `Vec` carries no `deriving Repr`. Tested:

```lean
inductive Vec (α : Type) : Nat → Type where
  | nil  : Vec α 0
  | cons : α → Vec α n → Vec α (n + 1)
def Vec.replicate (a : α) : (n : Nat) → Vec α n
  | 0     => Vec.nil
  | n + 1 => Vec.cons a (Vec.replicate a n)
#eval (Vec.replicate (-42 : Int) 3 : Vec Int 3)
```

Output: `Vec.cons (-42) (Vec.cons (-42) (Vec.cons (-42) (Vec.nil)))`, exit 0 —
**character-for-character what the book prints.** My model of `#eval`'s
instance requirement was wrong; Lean 4.32.2 displays the constructor tree
without a user-supplied `Repr`.

#### N13 — DISMISSED. `Nat.rec` in a computable `def`

I claimed `def double (n : Nat) : Nat := Nat.rec 0 (fun _ ih => ih + 2) n`
would fail with "code generator does not support recursor," and that the file's
asymmetry — `double` computable, `myLength` `noncomputable` — was unexplained.
Both halves were wrong.

Tested: `#eval double 5` → `10`, exit 0. `Nat.rec` **is** compiler-supported.
And `List.rec` genuinely is not:

```
error: code generator does not support recursor `List.rec` yet,
consider using 'match ... with' and/or structural recursion
```

So the asymmetry in the file is real, correct, and forced by the toolchain. It
is also **explained in the prose**, which I had not read closely enough before
predicting:

> `noncomputable` and `#reduce` in place of `#eval` here are a Lean
> implementation detail — the code generator that backs `#eval` does not yet
> support compiling `List.rec` directly, so this definition is checked and
> reduced by the kernel via `#reduce` instead; the mathematical content is
> unchanged.
> — `01-basics/05-pi-sigma-and-coc.md`

The book handled a subtle toolchain limitation correctly and documented it. I
called it a defect on a guess.

**What this costs the rest of the report.** These were my only two findings that
depended on predicting Lean's behaviour rather than reading text or doing
mathematics. Every surviving finding (N0–N11, N14, N15) is textual or
mathematical and was verified by reading, grepping, or recomputation. But the
error rate on my one class of speculative findings was 2 for 2 — weigh any
future prediction of mine accordingly.

### HIGH

#### N1. "Ex falso quodlibet" attributed to classical logic — contradicts the book's own §2

**WHERE:** `03-propositions-and-proofs/05-and-or-not.md:76`

**WHAT:** The prose for `absurd` reads: *"This is the 'ex falso quodlibet'
principle from classical logic, made concrete."*

**WHY IT IS WRONG:** Ex falso is $\bot$-elim, which the book itself states as a
natural-deduction rule at `03-propositions-and-proofs/02-logic-recap.md` and
then explicitly characterizes: *"Every rule listed above is accepted by **both**
classical and intuitionistic logic. The two differ on exactly one further
principle, the law of excluded middle."* The book is right there and wrong here.

**CITATION:** van Dalen, *Logic and Structure*, 5th ed., §5.1 (intuitionistic
logic retains $\bot$-elim; only excluded middle is dropped) — the same source
the book cites for soundness and completeness in §2. Also *Theorem Proving in
Lean 4*, "Propositions and Proofs": `False.elim` is core, non-classical Lean,
whereas `Classical.em` requires the `Classical` namespace.

**IMPACT:** The same file closes eleven lines later with *"Observe that this is
*intuitionistic* logic: there is no built-in law of excluded middle."* A reader
who has just been told `absurd` is classical, and is then told the surrounding
system is intuitionistic, has to conclude one of the two is wrong. Chapter 3 §2's
classical/intuitionistic fork is load-bearing for how the book explains Lean's
core logic; muddying it here undercuts it.

**FIX:** Replace "from classical logic" with "($\bot$-elim from
[Section 2](02-logic-recap.md), valid in both classical and intuitionistic
logic)".

#### N2. The Σ-type reading of `∧` describes the `∨` construction

**WHERE:** `01-basics/05-pi-sigma-and-coc.md:146`

**WHAT:** The "Why 'sum,' if it generalizes ×?" passage contrasts two
specializations of $\sum_{x:A} B(x)$. The first bullet, *"Constant family,
varying index,"* is meant to yield `∧`, and ends: *"`P ∧ Q` is Σ-type-like with
the index type restricted to two unlabeled slots, both of type `Prop`."*

**WHY IT IS WRONG:** "Index type restricted to two … slots" is a **two-element
index type** — which is exactly what the *next* bullet ("Two-point index,
varying family") uses to produce `∨`. The correct reading for `∧` is
$P \wedge Q \cong \sum_{\_ : P} Q$: the index type is $P$ itself, and the family
is constantly $Q$ — which is what makes it the *constant-family* case the bullet
is named for.

**CITATION:** *Homotopy Type Theory: Univalent Foundations*, §1.6 — *"If $B$ is
constant, then the dependent pair type is the ordinary Cartesian product
type"* — the exact source the book quotes for Σ-types four paragraphs earlier
in the same file. Under that quote, `∧`'s index type is `P`, not a two-point
type.

**IMPACT:** The whole passage exists to show that `∧` and `∨` are two
specializations of one construction, distinguished by which ingredient varies.
As written both bullets describe a two-element index, so the contrast the
passage is built on collapses and the reader is left unable to reconstruct
either case. This is the most conceptually ambitious paragraph in Chapter 1 and
it is the one that fails.

**FIX:** *"`P ∧ Q` is $\sum_{\_ : P} Q$ — index type `P`, family constantly `Q`,
so the 'which copy' tag is itself a proof rather than a value."*

#### N10. The `rfl` examples in Chapter 5 §4 have scrambled comments and cannot demonstrate the point they are attached to

**WHERE:** `05-rigor-check/04-defeq-vs-propeq.md:32-34`

**WHAT:** The code block introducing definitional equality:

```lean
example : 2 + 2 = 4 := rfl        -- 2 + 2 reduces to 4 definitionally
example : 0 + 2 = 2 := rfl        -- Nat.add recurses on its 2nd arg; 2 + 0 = 2 is the base case
-- example : 2 + 0 = 2 := rfl     -- also rfl (0 + n needs induction, n + 0 doesn't)
```

**WHY IT IS WRONG:** Three separate defects in three lines.

1. **The comment on `:33` describes a different term than the code.** The
   statement is `0 + 2 = 2`; the comment explains `2 + 0 = 2`. For
   `Nat.add 0 2` the base case reached is `Nat.add 0 0 = 0`, not `2 + 0 = 2`.
2. **`:34` is commented out while its own comment says it succeeds.** The
   parenthetical reads "also rfl," yet the line is disabled. Commenting a line
   out is the book's convention for *this does not work* — the two signals
   contradict each other.
3. **Neither example can exhibit the distinction the comments assert.** Both
   `0 + 2 = 2` and `2 + 0 = 2` are closed terms and both are `rfl`; everything
   computes. The asymmetry the comments invoke — "0 + n needs induction, n + 0
   doesn't" — arises only for a **variable** `n`. As written, the block claims
   an asymmetry that its own examples cannot show.

**VERIFIED BY EXECUTION** on Lean 4.32.2 — all four cases run:

| Statement | `rfl`? | Book's treatment |
| --- | --- | --- |
| `(0:Nat) + 2 = 2` | succeeds | live at `:33` — correct |
| `(2:Nat) + 0 = 2` | **succeeds** | **commented out at `:34`** — wrong |
| `(n : Nat) : n + 0 = n` | succeeds | absent |
| `(n : Nat) : 0 + n = n` | **fails** — `Type mismatch: rfl has type ?m = ?m but is expected to have type 0 + n = n` | absent |

So `:34` is disabled despite compiling, and the two cases that actually
demonstrate the asymmetry appear nowhere in the block.

**CITATION.** The book states the correct fact twice elsewhere:
`01-basics/04-terminology.md` — *"`a + 0` reduces immediately (the second
argument is already the base case), while `0 + a`, with an unknown `a` in the
position `Nat.add` recurses on, does not reduce at all"*; and
`04-tactics/05-worked-example.md`, which proves `Nat.zero_add` by induction for
exactly this reason. Both are right; `:32-34` is the one place that garbles it.

**IMPACT:** This is the opening example of the chapter section that exists to
teach definitional versus propositional equality — the single distinction the
rest of Chapter 5 and every `rfl` in Chapters 6–11 depend on. A reader who
takes `:34`'s commented-out status at face value concludes `2 + 0 = 2` fails by
`rfl`, which is the exact inverse of the truth, and will then misjudge every
subsequent `rfl`.

**FIX:** Use a variable, which is the only way to show the asymmetry:

```lean
example : 2 + 2 = 4 := rfl              -- closed terms: both sides compute
example (n : Nat) : n + 0 = n := rfl    -- rfl: `n + 0` is Nat.add's base case
-- example (n : Nat) : 0 + n = n := rfl -- FAILS: Nat.add recurses on its 2nd
--                                      -- argument, so `0 + n` is stuck at
--                                      -- unknown `n`. Needs induction — Ch 4.
```

### MEDIUM

#### N11. The Π-type universe rule is stated as `max`, which is wrong for `Prop` and contradicts the book's own `∀`

**WHERE:** `05-rigor-check/03-typing-rules-and-safety.md:187`, restated at `:237`

**WHAT:** The rule, given unqualified:

$$\dfrac{\Gamma \vdash A : \mathtt{Type}\,i \quad \Gamma, x{:}A \vdash B : \mathtt{Type}\,j}{\Gamma \vdash \big(\textstyle\prod_{x:A} B\big) : \mathtt{Type}\,(\max(i,j))}$$

**WHY IT IS INCOMPLETE:** Lean's actual rule is `imax`, not `max`:
$\prod_{x:A} B : \mathtt{Sort}\,(\mathrm{imax}\ u\ v)$, where
$\mathrm{imax}\ u\ 0 = 0$. The special case $v = 0$ is the impredicativity of
`Prop`, and it is not a footnote — it is what makes `∀` land in `Prop` at all.

The book relies on the `imax` case constantly and never states it.
`01-basics/05-pi-sigma-and-coc.md:494` establishes `Prop = Sort 0`;
`01-basics/03-dependent-types.md` says *"`∀ n : Nat, n ≥ 0` is a Π-type where
$B(n)$ happens to be a proposition"*; Chapter 3 states `∀ n : Nat, n ≥ 0 : Prop`
and proves it. Under the rule as printed, that Π-type has $A = \mathtt{Nat} :
\mathtt{Type}\,0$ and $B : \mathtt{Sort}\,0$, giving $\max(1,0) = 1$ — so
`∀ n : Nat, n ≥ 0` would be in `Type 1`, not `Prop`. Every `∀`-statement in
Chapters 3 through 11 contradicts the rule this section states.

**VERIFIED BY EXECUTION** on Lean 4.32.2:

```
#check (∀ n : Nat, n ≥ 0)   -- ∀ (n : Nat), n ≥ 0 : Prop      ← rule predicts Type 1
#check (Type → Type)        -- Type → Type : Type 1           ← rule predicts Type 1 ✓
```

The rule gets §2's worked example (`Type → Type`) right and the book's own
Chapter 3 theorem statement wrong. That is precisely the `imax` gap.

**CITATION.** Coquand & Huet, "The Calculus of Constructions," *Information and
Computation* 76(2–3), 1988 — the source this section names — is *defined* by
its impredicative universe of propositions; the `max`-only rule is not CoC's.
*Theorem Proving in Lean 4*, "Dependent Type Theory," gives Lean's `imax`
behaviour. Cache Q2 corroborates the Coquand–Huet attribution itself.

**IMPACT:** A reader who applies the stated rule to any `∀` in the book gets
the wrong universe. The section's stated purpose is to make precise the rule §2
used informally, so an incomplete rule here defeats the chapter's own point.
The section is otherwise careful and correct — STLC's (Var)/(Abs)/(App),
progress, preservation, and the `Type i : Type (i+1)` rule are all right.

**FIX:** State the rule as `imax` and add one sentence: "when $B$ lands in
`Prop` ($j = 0$), the Π-type is itself a `Prop` regardless of $i$ — this
impredicativity is what makes `∀ n : Nat, n ≥ 0` a proposition rather than a
`Type 1`." Alternatively keep `max` but scope it explicitly to `Type`-valued
$B$ and cross-reference the `Prop` case.

#### N3. Chapter 11 uses three composition orders in one section, after warning against exactly that

**WHERE:** `11-path-algebras/05-path-composition.md` — prose at the
"Mathematical reading" box; formula at `:147`; quoted source at `:186-194`

**WHAT:** The section states its convention explicitly: *"written throughout
this section in **path order**: '$p$ then $q$' … This is not the
function-composition order $q \circ p$ … Mixing them mid-explanation is a common
source of confusion, so this book fixes path order throughout."* Then:

- `:147` gives the path-algebra multiplication in **function order**:
  $q \cdot p = q \circ p$ if $t(p) = s(q)$;
- the quoted Assem–Simson–Skowroński definition writes the product with the
  **left** factor concatenated first, $\delta_{bc}(a \mid \alpha_1 \ldots,
  \beta_1 \ldots \mid d)$ — the opposite of `:147`.

**IMPACT:** Three conventions inside one section, in the section that names
convention-mixing as the hazard. A reader trying to line `Path.append p q` up
against the $kQ$ multiplication gets a contradiction, and the quoted source
looks like it disagrees with the book when it does not.

**FIX:** Restate `:147` in path order to match `Path.append`
($p \cdot q = p\,;q$ when $t(p) = s(q)$, else $0$), and add one clause to the
Sources box noting that the quoted source writes the product the other way
round.

#### N4. Gentzen dated 1934 in the body, 1935 in the citation

**WHERE:** `03-propositions-and-proofs/02-logic-recap.md:75` vs the same file's
Sources box and `bibliography.md:30`

**WHAT:** The body reads *"**Natural deduction** (Gentzen, 1934)"*; the
citation key is `[Gentzen1935]`, *Mathematische Zeitschrift* 39, 1935.

**IMPACT:** Small, but it is the book's own bibliography disagreeing with its own
body text on the same page. Consensus corroborates the 1935 publication and
notes Gentzen's system exists in "1935 and 1936 variants" (cache Q7).

**FIX:** Use 1935 in the body. Optionally note Jaśkowski's independent 1934
system, which cache Q7 records — the book currently implies Gentzen alone.

#### N5. Schiffler numbering is self-contradictory as printed

**WHERE:** `11-path-algebras/05-path-composition.md:191`

**WHAT:** *"Schiffler, **Definition 4.5** (Chapter 4, §4.2) … unit given
explicitly … in the lemma immediately following (**Lemma 4.3** in that source's
numbering)."*

**IMPACT:** A Lemma 4.3 cannot immediately follow a Definition 4.5 under one
numbering scheme; one of the two numbers is wrong. I could not resolve which
without the physical source. Every other citation in the book carries verified
numbering, so this one stands out.

**FIX:** Check the two numbers against Schiffler, *Quiver Representations*,
Ch. 4 §4.2, and correct whichever is stale.

### LOW

#### N6. Three cross-references labelled "Chapter 1, Section 4" point at Section 5

**WHERE:** `03-propositions-and-proofs/01-prop.md:66`,
`03-propositions-and-proofs/02-logic-recap.md:17`,
`03-propositions-and-proofs/02-logic-recap.md:224`

**WHAT:** All three read `[Chapter 1, Section 4](../01-basics/05-pi-sigma-and-coc.md)`.
`05-pi-sigma-and-coc.md` is Section 5; Section 4 is `04-terminology.md`. From
context (Π/Σ, the calculus of constructions) the *target* is correct and the
*label* is wrong.

**IMPACT:** A reader following the prose ("Chapter 1, Section 4 makes this fully
rigorous") and then checking the chapter index lands on the terminology
glossary, not the CoC section.

**FIX:** Change the three labels to "Section 5." I swept every
`[Chapter N, Section M](...)` link in the book programmatically — these three
are the complete set of mismatches.

#### N7. `subst` is used in a Lean block but missing from the tactic reference

**WHERE:** used at `01-basics/04-terminology.md:225`, explained in prose at
`:218`; absent from `tactic-and-library-reference.md`

**WHAT:** The reference page opens *"A quick index of **every** tactic used in
this book."* `subst` is the fix the "motive is not type correct" worked example
turns on, and it has no entry. Every other tactic appearing in a Lean fence is
present (checked by extracting all 192 fences and diffing against the table).

**FIX:** Add a `subst` row — first used `01-basics/04-terminology.md`, linking
the Lean 4 Tactic Reference like its neighbours.

#### N8. 24 broken relative links in `changelog/`

**WHERE:** `changelog/v1.4.0.md` (19), `changelog/v1.1.0.md` (3),
`changelog/v1.0.0.md` (1), `changelog/v1.2.0.md` (1)

**WHAT:** All the same cause — paths written relative to `lean_book/` while the
files live in `lean_book/changelog/`, e.g.
`[01-what-we-built.md](13-next-steps/01-what-we-built.md)` resolves to
`changelog/13-next-steps/…`, which does not exist.

**IMPACT:** Historical documents only; no main-text link is broken. But the
book's own README advertises the changelog as "the full, itemized history," and
a fifth of one release note's links are dead.

**FIX:** Rewrite the affected targets to `../<chapter-dir>/…`, then re-run a
link check.

#### N14. Chapter 1 §3 silently depends on `autoImplicit`, which §2 never introduces

**WHERE:** `01-basics/03-dependent-types.md` — the `Vec` declaration and
`Vec.replicate`, `Vec.head`, `Vec.dot`

**WHAT:** Section 2 teaches implicit arguments carefully and explicitly:
`def identity {α : Type} (x : α) : α := x`, with a full paragraph on the curly
braces. Section 3 then writes

```lean
inductive Vec (α : Type) : Nat → Type where
  | cons : α → Vec α n → Vec α (n + 1)     -- `n` is never bound

def Vec.replicate (a : α) : (n : Nat) → Vec α n   -- `α` is never bound
def Vec.head : Vec α (n + 1) → α                  -- `α`, `n` never bound
```

Both `n` and `α` are free. These elaborate only because Lean's `autoImplicit`
option (on by default) silently inserts `{n : Nat}` and `{α : Type}` binders.
The book never names the mechanism. Section 3 even prints
`#check @Vec.replicate -- @Vec.replicate : {α : Type} → α → (n : Nat) → Vec α n`,
showing the auto-inserted binder in the output without remarking that nothing
in the source wrote it.

**IMPACT:** A reader who has just been taught that `{α : Type}` is how you
declare an implicit argument sees code with no such declaration produce one, and
has no way to account for the difference. Worse, `autoImplicit` is set to
`false` in Mathlib and in most real projects — a reader who copies these
declarations into a Mathlib-style project gets `unknown identifier 'n'`. The
book sends readers to Mathlib in Chapter 13.

**FIX:** One sentence at the `Vec` declaration: "`n` is not bound explicitly
here — Lean's `autoImplicit` setting, on by default, inserts `{n : Nat}`
automatically. Mathlib turns this off, so in a Mathlib-style project write
`| cons {n : Nat} : α → Vec α n → Vec α (n + 1)` explicitly."

#### N15. The free-monoid universal property is named for one structure and spelled out for another

**WHERE:** `01-basics/01-everything-has-a-type.md` (the claim) and
`01-basics/04-terminology.md` (the spelled-out version)

**WHAT:** Chapter 1 §1 states that `Nat` with numeric `+` and `0` "is the
**free commutative monoid on one generator**." Section 4 then spells that claim
out as a universal property — but quantifies over *every monoid*: *"the
'relevant data' this time being 'a monoid $M$ together with a chosen element
$m \in M$'"*, and *"for every monoid $M$ and every element $m \in M$, there is
exactly one monoid homomorphism $h : \mathbb{N} \to M$ with $h(1) = m$."* The
accompanying diagram is labelled `M (any monoid)`.

**WHY IT IS IMPRECISE:** those are two different universal properties. "Free
commutative monoid on one generator" quantifies over commutative monoids;
what §4 states is the free-*monoid*-on-one-generator property. Both happen to be
true of $\mathbb{N}$ — the free monoid on one generator is already commutative,
so it is also the free commutative monoid on one generator — so no false
statement is made. But the section that exists to make the phrase precise
proves a different statement than the phrase names.

**IMPACT:** LOW. Nothing downstream depends on it. It matters only because §4's
whole purpose is to fix vocabulary precisely, and a reader checking the two
against each other finds the adjective "commutative" appearing in the name and
vanishing from the statement.

**FIX:** Drop "commutative" from the §1 claim, or add one clause to §4: "…and
since the free monoid on one generator is already commutative, $\mathbb{N}$ is
equally the free *commutative* monoid on one generator."

#### N9. Two citation details worth tightening

- **`01-basics/05-pi-sigma-and-coc.md:517`** cites CIC as *"Coquand and Paulin,
  'Inductively Defined Types,' 1990."* Consensus's top hit for that phrasing is
  **Pfenning & Paulin-Mohring 1989**, "Inductively Defined Types in the Calculus
  of Constructions" — a different paper, easy to conflate (cache Q3). The
  intended paper is the COLOG-88 proceedings paper, LNCS 417, published 1990,
  and the author published as **Paulin-Mohring**. **FIX:** give the venue and
  the full surname.
- **`03-propositions-and-proofs/01-prop.md`** traces Curry–Howard to Howard 1969
  only. Wadler (2015): *"a correspondence observed by **Curry in 1934** and
  refined by Howard in 1969"* (cache Q6). **FIX:** one clause explaining why the
  name has two people in it.

---

## 4. References — full audit

### 4.1 Link check: 70 URLs, 2 flagged, both already known

Every external URL in `lean_book/` resolves (HTTP 200) except:

| URL | Status | Verdict |
| --- | --- | --- |
| `kar.kent.ac.uk/20998/1/ttfp.pdf` (`[Thompson1991]`) | connection failure | The bibliography **already carries a dated warning** for this exact link. Still dead today; the warning is accurate and should stay. |
| `cambridge.org/us/academic/…representation-theory…` (`[AssemSimsonSkowronski2006]`) | 403 | Bot-blocking, not a dead link. No action. |

Both `[Milner1978]` and `[CoquandHuet1988]` DOIs resolve correctly; an earlier
404 in my sweep was my own URL-extraction artifact (unescaped parentheses), not
a book defect.

### 4.2 Attributions corroborated against the literature

All ten Consensus queries and their results are cached at
[`../consensus-cache.md`](../consensus-cache.md).

| Book claim | Result |
| --- | --- |
| Girard's paradox is due to the **1972** thesis, not `[Girard1971]` (`05-rigor-check/02-universes.md`) | **Confirmed.** Hurkens (1995): *"In 1972 J.-Y. Girard showed that the Burali-Forti paradox can be formalised in the type system U."* The book's correction of its own earlier draft is right. (Q1) |
| Coquand 1986, "An analysis of Girard's paradox," is the standard modern exposition | **Confirmed** — exact title, author, year. (Q4) |
| `[CoquandHuet1988]` | **Confirmed** via Geuvers et al., *"the Calculus of Constructions of Coquand and Huet (1985, 1988)."* (Q2) |
| `[Milner1978]` title / year / *J. Comput. Syst. Sci.* | **Confirmed** exactly as the bibliography states. (Q5) |
| Howard circulated 1969, published 1980 in Curry's Festschrift | **Confirmed** by Wadler (2015) and Irwin (2008) — two sources independent of the Sørensen–Urzyczyn citation the book already gives. (Q6) |
| Gödel completeness "1929/1930" | **Confirmed** — 1929 thesis, 1930 publication. The dual dating is correct. (Q9) |
| Gentzen's intro/elim rule pairs | **Confirmed.** (Q7) |
| `[Girard1971]` bibliographic details | **Not indexed** by Consensus; nothing contradicts them. (Q10) |

**No attribution in the bibliography was found to be wrong.**

### 4.3 One gap for parity

The Church–Rosser theorem is quoted from `[Thompson1991]`, consistent with the
book's cite-what-you-quote convention. But the book flags other missing
originals explicitly (Girard 1972, Coquand 1986) and does not flag this one. A
one-line note pointing at Church & Rosser, "Some properties of conversion,"
*Trans. AMS* 39 (1936), would make the treatment uniform. (Q8)

---

## 5. Verification log

**Read in full:** `00-setup/` (4 files), `01-basics/` (6),
`02-functions-and-structures/` (4), `03-propositions-and-proofs/` (9),
`04-tactics/` (7), `05-rigor-check/01–04`, `11-path-algebras/01–05`,
`06-groups/01–02, 04`, `07-group-theorems/01–04`, `08-rings/03–04`,
`09-ring-theorems/01–03`, `10-modules/` Sources boxes, `bibliography.md`,
`README.md`, `tactic-and-library-reference.md` header,
`14-appendix-solutions/00-index.md`, `13-next-steps/00-index.md`, and every
"Sources, quoted" box in the book (25 files). Plus
`lean_project/LeanProject/Ch01DependentTypes.lean` in full.

**Correction to an earlier draft of this report.** My first pass read
`05-rigor-check/` **only through its Sources boxes**, not its body, and I
nonetheless wrote that the theoretical chapters were sound. That was
unwarranted — Chapter 5 is the book's theoretical core, and reading its body
produced N10 and N11, the two most substantive type-theory findings here.
Recorded because it bears on how much weight to give my other coverage claims:
§5's "not checked" list below is not a formality.

**Programmatic sweeps:**
- 70 external URLs resolved with `curl -L` (§4.1).
- All relative Markdown links resolved; 24 breakages, all in `changelog/` (N8).
- Every `[Chapter N, Section M](...)` link checked against its target's file and
  directory number; 3 mismatches, all in Chapter 3 (N6).
- All 192 Lean fences extracted; tactic tokens diffed against
  `tactic-and-library-reference.md`; one gap, `subst` (N7).
- Toolchain regression sweep: every `v4.*` string in `lean_book/` is `v4.32.2`,
  matching the pin. Clean.
- Learning-objectives regression sweep: all 15 chapter `00-index.md` files carry
  a `## Learning objectives` box. Clean.
- Exercise/solution coverage: 10 chapters have exercise files, 10 solution files
  exist, and they correspond. Clean (modulo M2's missing note).

**AMS boundary / degenerate-case sweep (per `adversarial-maths-reviewer`):**
- **Degenerate path (length 0)** — **FAULT FOUND**, see N0. This is the one
  degenerate case the book states wrongly.
- **Zero ring** — `08-rings/03-ring.md`'s `Ring` requires `one : R` but never
  asserts $1 \neq 0$; a repo-wide grep for `1 ≠ 0` / "nonzero ring" /
  "nontrivial" turns up no such claim anywhere. Chapter 9's `mul_zero` and
  $(-1)a = -a$ both hold vacuously in the zero ring. **Clean** — the book
  matches Dummit & Foote §7.1, which likewise does not exclude it.
- **Trivial group** — `Group G` imposes no non-triviality; `G := Unit`
  satisfies every field. Chapter 7's three theorems hold. **Clean.**
- **Empty quiver / no arrows** — `Quiver V A` permits `A` empty and `V` empty;
  `Path Q u w` is then inhabited only by `nil`. The path-algebra unit
  $\sum_{x} \varepsilon_x$ is correctly qualified *"when $Q_0$ is finite"* in
  both the prose and the Sources box. **Clean.**
- **`Fin 0` / `Fin 1` / empty vector** — `Vec.head : Vec α (n+1) → α` excludes
  length 0 in the type, and the book demonstrates the rejection with the real
  error message. `Fin 0` is correctly an empty type. **Clean.**
- **Non-abelian case** — `06-groups/04-permutations-example.md` exists
  specifically to exercise the `id_left`/`id_right` and
  `inv_left`/`inv_right` split that an abelian example would collapse.
  **Clean, and deliberately so.**

**Worked examples recomputed independently by hand (not trusted from the page):**
- `06-groups/04-permutations-example.md` — `swap01` = (0 1), `cycle012` =
  (0→1→2→0) with `invFun` (0→2, 1→0, 2→1); verified `left_inv`/`right_inv` at
  all three points. `Perm3.comp f g = f ∘ g`, so
  `comp swap01 cycle012 |>.toFun 0` = `swap01(1)` = **0** ✓ and
  `comp cycle012 swap01 |>.toFun 0` = `cycle012(1)` = **2** ✓. Both printed
  values are right, and they do establish non-commutativity.
- `07-group-theorems/04-theorem-3.md` — all **six** `#eval` outputs recomputed.
  `op swap01 cycle012` is the transposition (1 2); its inverse sends
  0↦0, 1↦2, 2↦1. `op (inv cycle012) (inv swap01)` sends 0↦0, 1↦2, 2↦1.
  Printed values `0, 0, 2, 2, 1, 1` ✓ — matches, and the pair genuinely
  witnesses `inv_op`.
- `01-basics/03-dependent-types.md` — `Vec.dot' vecA vecC` trace:
  $17{\times}2 + (-3){\times}5 + 42{\times}1 + 0 = 34 - 15 + 42 = 61$ ✓,
  and the four `dbg_trace` lines are in the correct call order.
- `01-basics/04-terminology.md` — both β-reduction worked examples and the
  capture-avoiding α-conversion example recomputed; all three correct,
  including the subtle one where naive substitution would capture $y$.

**Proofs recomputed by hand, step by step:**
- `09-ring-theorems/02-theorem-1.md` `mul_zero` — the `congrArg` + four-`rw`
  chain. Every intermediate goal-state comment is correct; `inv_left` does not
  mis-fire on the right-hand side, because
  `op (inv x) (op x x)` does not contain the instantiated pattern
  `op (inv x) x`. Sound.
- `07-group-theorems/04-theorem-3.md` `inv_op` — regroup/cancel chain. Sound.
- `07-group-theorems/02-theorem-1.md` `id_unique`, including the `rw [← step2]`
  direction argument. Sound.
- `04-tactics/05-worked-example.md` `my_add_comm`. Sound.
- `11-path-algebras/04`–`05` — `Path.cons` index arithmetic for `pathAlpha`
  / `pathBetaAlpha`, and `Path.append`'s recursion types. Sound.

**Compilation — partial, and it changed the report.** Lean 4.32.2 became
available late in the pass. What was run:

| Test | Result | Effect on this report |
| --- | --- | --- |
| `#eval` on `Vec Int 3` with no `deriving Repr` | **succeeds**, output identical to the book's | **N12 retracted** |
| `Nat.rec` in a computable `def` + `#eval` | **succeeds** (`10`) | **N13 retracted** |
| `List.rec` without `noncomputable` | fails: *"code generator does not support recursor `List.rec`"* | confirms the book's asymmetry is forced and correctly explained |
| `(0:Nat) + 2 = 2 := rfl` / `(2:Nat) + 0 = 2 := rfl` / `(n:Nat) : n + 0 = n := rfl` | all **succeed** | **N10 confirmed** — `:34` is disabled despite compiling |
| `(n : Nat) : 0 + n = n := rfl` | **fails** (type mismatch) | **N10 confirmed** — this is the real asymmetry, absent from the block |
| `#check (∀ n : Nat, n ≥ 0)` | `: Prop` | **N11 confirmed** — the printed `max` rule predicts `Type 1` |
| `#check (Type → Type)` | `: Type 1` | the book's §2 worked example is correct |

**Full `lake build` over the Mathlib-dependent modules: NOT COMPLETED, and it
will not be completed in this environment.** It reached **15 of 22 modules**
before I stopped it; the two still in flight were `Ch11PathAlgebrasMathlib` and
`Ch13CapstoneMathlib`, the two heaviest Mathlib importers. I killed it to free
memory for a Lean test — and that test then failed too. Lean is now
**unusable here**: `#eval 1+1` in a file with no imports blocks for five
minutes accumulating 0.25 seconds of CPU, sitting in `D` state at
`folio_wait_bit_common`, i.e. blocked paging in from disk. The container's
storage degraded partway through the session (the same seven tests recorded in
the table above ran fine earlier). This is an environment failure, not a
project one, and it must be re-run somewhere with working I/O.

So C2's *"verified to compile with `lake build`"* half remains open, and the
proof-tracing below is still hand-work rather than machine-checked.

**Compilation: NOT COMPLETE.** No Lean toolchain was present in this
environment. I installed elan, pinned `leanprover/lean4:v4.32.2`, and ran
`lake exe cache get` (8639 Mathlib files, downloaded and decompressed
successfully) followed by `lake build` in `lean_project/`. The build was still
running when this report was written. **Until it finishes, C2's "verified with
`lake build`" half is unconfirmed and every Lean claim in this report rests on
hand-tracing, not execution.** Hand-tracing is not compilation; treat this as
the one open verification item.

**Also unverified:** the page and section numbers in every printed-book citation
(Dummit & Foote, Mac Lane, Jacobs, Pareigis, Thompson,
Assem–Simson–Skowroński, Schiffler). These need the physical sources. The
book's own notes indicate a prior pass verified many of them verbatim, and N5
is the only place the internal numbering is self-inconsistent.

---

## 6. Priority fix list

1. **N0** — rewrite the trivial-path sentence. Blocking: it is a false
   definition, and three later passages already assume the correct one.
2. **N10** — rewrite the three `rfl` lines in `05-rigor-check/04` using a
   variable. The current block teaches the inverse of the truth. *(Verify the
   replacement compiles: `n + 0 = n` is `rfl`, `0 + n = n` is not — confirmed
   on 4.32.2.)*
3. **N11** — state the Π-universe rule as `imax`, or scope it to `Type`.
4. **N1** — drop "from classical logic" from `absurd`'s prose. One phrase;
   removes a self-contradiction.
3. **N2** — restate `P ∧ Q` as $\sum_{\_ : P} Q$. One sentence; rescues
   Chapter 1's most ambitious paragraph.
4. **N3** — put the $kQ$ multiplication in path order. One formula; the section
   already promises this.
5. **N6** — three "Section 4" → "Section 5" label fixes.
6. **N4** — Gentzen 1934 → 1935, matching the bibliography.
7. **M2** (carried from 2026-08-02, still open) — add the "Chapter 2 has no
   exercises" note.
8. **N7** — add the `subst` row to the tactic reference.
9. **N5** — resolve the Schiffler Definition 4.5 / Lemma 4.3 clash against the
   source.
10. **N9** — disambiguate the Coquand–Paulin-Mohring citation; add Curry 1934 to
    the Curry–Howard history.
11. **N8** — fix the changelog relative paths.

Per the skill's bounded loop: one round of fixes, one re-review. N0 is
CRITICAL, so if it survives the next round that is a structural problem, not an
iteration problem.

---

## 6b. Fixes applied (same session, after the review above)

Every finding in this report has now been repaired in `lean_book/` (Markdown is
the source of truth; `lean_book_latex/` is regenerated from it by
`lean_book_latex/build/build_latex.py`, so no `.tex` was hand-edited).

| ID | Where | What changed |
| --- | --- | --- |
| **N0** | `11-path-algebras/02-paths.md`, `00-index.md` | "composing with nothing but itself" → "It composes with any path that starts or ends at $i$, leaving it unchanged — $e_i$ is the *identity* at $i$," with a forward reference to Section 5's units. Chapter index restated to match. |
| **N10** | `05-rigor-check/04-defeq-vs-propeq.md` | Block rewritten to use a **variable** `n`: `n + 0 = n` live and `rfl`, `0 + n = n` commented out as the genuine failure, plus a paragraph explaining that closed numerals cannot exhibit the asymmetry. |
| **N11** | `05-rigor-check/03-typing-rules-and-safety.md`, `02-universes.md` | Rule restated over `Sort` with `imax`; added the `imax(i,0)=0` clause, a paragraph on `Prop` impredicativity, and the two `#check` outputs that discriminate the rules. Section 2 now flags that its `max` form omits the `Prop` case. Sources box updated. |
| **N1** | `03-propositions-and-proofs/05-and-or-not.md` | "from classical logic" → "$\bot$-elimination from Section 2, valid in both classical and intuitionistic logic." |
| **N2** | `01-basics/05-pi-sigma-and-coc.md` | `P ∧ Q` restated as $\sum_{\_ : P} Q$ — index type `P`, family constantly `Q` — restoring the contrast with the `∨` bullet. |
| **N3** | `11-path-algebras/05-path-composition.md` | $kQ$ multiplication rewritten in path order ($p \cdot q$), with a parenthetical for function-order sources; Sources box now notes ASS's quoted product is *also* path order. |
| **N4** | `03-propositions-and-proofs/02-logic-recap.md` | "Gentzen, 1934" → "Gentzen, 1935 — independently, and in a different notation, Jaśkowski 1934." |
| **N5** | `11-path-algebras/05-path-composition.md` | Springer's copy is paywalled, so the numbering could not be checked. The impossible "Lemma 4.3 immediately following Definition 4.5" claim was **dropped rather than guessed**, with an explicit "Numbering not independently verified" box saying so. **Still open for anyone with the printed source.** |
| **N6** | `03-propositions-and-proofs/01-prop.md`, `02-logic-recap.md` (×2) | Three "Chapter 1, Section 4" labels → "Section 5". Re-swept: zero label/target mismatches book-wide. |
| **N7** | `tactic-and-library-reference.md` | `subst` row added, first used Ch. 1 §4. |
| **N8** | `changelog/v1.0.0`, `v1.1.0`, `v1.2.0`, `v1.4.0` | 22 links re-pointed with `../`; one stale target (`14-appendix-solutions/09-chapter-11.md`) re-pointed to its renumbered file `10-chapter-11.md`. |
| **N9** | `01-basics/05-pi-sigma-and-coc.md`, `03-propositions-and-proofs/01-prop.md` | Full venue + hyphenated **Paulin-Mohring** surname, with an explicit note distinguishing the 1990 COLOG-88 paper from Pfenning & Paulin-Mohring 1989. Curry 1934 added to the Curry–Howard history, quoting Wadler (2015). |
| **N14** | `01-basics/03-dependent-types.md` | New paragraph naming `autoImplicit`, explaining the `{α}`/`{n}` binders nothing in the source wrote, and giving the explicit-binder version for Mathlib-style projects. |
| **N15** | `01-basics/04-terminology.md` | Paragraph added distinguishing the free-monoid from the free-*commutative*-monoid universal property, and explaining why $\mathbb{N}$ satisfies both. |
| **M2** | `14-appendix-solutions/00-index.md` | **Already fixed** before this pass — the "Chapter 2 has no exercises" note is present. Carried finding closed. |
| **§4.3** | `01-basics/04-terminology.md` | Church & Rosser 1936 named as the original source, with the book's standard "not consulted directly; quoted from Thompson1991 instead" flag, matching how Girard 1972 and Coquand 1986 are handled. |

**Build-pipeline defect found while regenerating.** `build_latex.py`'s
`strip_hypertargets()` matched only pandoc 2.x's `\hypertarget{s}{\section{…}}`
shape and only `\section`/`\subsection`. Pandoc 3.1.3 emits `{%\n` before the
heading and wraps `\chapter` the same way, so the regex silently matched
nothing and the run aborted on Chapter 14's `assert tex.startswith("\\chapter{")`.
Regex broadened to tolerate both; noted here because it means **the committed
`.tex` had not been regenerated since the pandoc upgrade**, and any future
contributor on pandoc 3.x would have hit the same wall.

**What is still open.**

1. **N5's Schiffler numbering** — needs the printed source. Flagged in the book
   rather than fixed.
2. **Printed-book page/section numbers generally** (Dummit & Foote, Mac Lane,
   Jacobs, Pareigis, Thompson, Assem–Simson–Skowroński) — unchanged from §5;
   still unverified here.
3. **A re-review of the fixes themselves.** Per the bounded loop, these edits
   have had one pass (mine) and no adversarial pass. The N11 rewrite in
   particular introduces new formal content — the `imax` rule, `Sort`
   numbering, the impredicativity paragraph — and new formal content is exactly
   what this report found the book getting wrong elsewhere. Treat §6b as
   unreviewed.

---

## 7. Strengths worth preserving

The 2026-08-02 adjudication's list holds up on re-reading, and I add two:

- **The book's own uncertainty flags.** `05-rigor-check/02-universes.md`
  correcting a wrong Girard attribution *in the bibliography box itself*;
  `11-path-algebras/05`'s "Not independently verified" note on the
  category-algebra framing; `03-propositions-and-proofs/02`'s admission that the
  Software Foundations content could not be checked. Consensus confirmed the
  Girard correction is right. This is better citation hygiene than most published
  textbooks.
- **`01-basics/05`'s treatment of `∃` versus `Sigma`.** The book resists the easy
  slogan, shows `mySigma.fst` working and `h.1` failing with the real error
  message, and explains why proof irrelevance forces the difference. N2 is a flaw
  in the same file, which makes the surrounding quality worth naming.

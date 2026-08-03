# Findings dossier — for adversarial re-check

**Purpose.** This file exists to be attacked. It restates every finding from
[`REVIEW-FINAL-CLAUDE.md`](REVIEW-FINAL-CLAUDE.md) in a form a second
adversarial reviewer can falsify mechanically, without trusting me.

**How to use it.** For each finding you get:

- **CLAIM** — what I assert, in one sentence.
- **EVIDENCE** — the verbatim text, at an exact `file:line`.
- **REPRO** — a command that reproduces the evidence from the repo root.
  If the command's output does not match what is quoted, the finding is stale
  or fabricated — say so.
- **FALSIFIES** — the specific fact that, if true, kills the finding. Attack
  this, not the prose.
- **CONFIDENCE** — mine, and what it rests on.

**Ground state.** Repo at `591f418`, branch `docs/v1.5.0-lean-consensus-check`,
toolchain pin `lean_project/lean-toolchain` = `leanprover/lean4:v4.32.2`.
Line numbers are from that commit. All commands assume `cwd` = repo root and a
`lean_book/` prefix where shown.

**Known weakness in my own work — attack here first.** I wrote most of this
before a Lean toolchain was available, so every claim about Lean *behaviour*
was hand-traced rather than executed. Lean 4.32.2 is now installed. **The two
findings that rested on predicted tool behaviour (N12, N13) were run, and both
were wrong** — see the retraction below. That is a 0-for-2 record on
speculative findings, and it is the single most useful calibration datum in
this file. N0–N11 and N14–N15 are textual or mathematical and were established
by reading, grepping, or recomputation; the full `lake build` over the
Mathlib-dependent modules was still running at the time of writing, so my
statement that the book's proofs are sound (§5 of the main report) remains
hand-traced.

**Second known weakness.** My first draft of the main report read
`05-rigor-check/` through its Sources boxes only and declared the theoretical
chapters sound on that basis. Reading the body then produced N10 and N11. Treat
my coverage claims as claims, not guarantees; the "not checked" list at the end
of this file is where the next findings are.

---

## N0 — CRITICAL — trivial path defined as "composing with nothing but itself"

**CLAIM.** `11-path-algebras/02-paths.md` states a false property of the
length-0 path. $e_i$ composes with every path starting or ending at $i$; it is
the identity at $i$, not an isolated element.

**EVIDENCE** — `lean_book/11-path-algebras/02-paths.md:17-19`:

> In addition, for each vertex $i$, a **trivial path** $e_i$ of length $0$ is
> allowed, starting and ending at $i$ and composing with nothing but itself.

**REPRO:**
```sh
sed -n '15,23p' lean_book/11-path-algebras/02-paths.md
grep -n "Path.nil 0" lean_book/11-path-algebras/04-paths-as-inductive-type.md
grep -n "Path.append p (Path.nil v)\|Path.append (Path.nil u) p" lean_book/11-path-algebras/05-path-composition.md
grep -n "varepsilon_x" lean_book/11-path-algebras/05-path-composition.md
```

**Contradicted by the book itself, in three places:**

1. `04-paths-as-inductive-type.md` — `def pathAlpha : Path exampleQuiver 0 1 :=
   Path.cons ExampleArrow.alpha rfl rfl (Path.nil 0)`. This composes $e_0$ with
   $\alpha$. Under the quoted sentence the term could not exist.
2. `05-path-composition.md` — *"`Path.append p (Path.nil v) = p` … and,
   separately, `Path.append (Path.nil u) p = p` … proved as Exercise 2 by
   induction on `p`."* Two identity laws, one set as an exercise.
3. `05-path-composition.md` Sources box — *"each stationary path
   $\varepsilon_x$ is idempotent, and $\sum_{x\in Q_0}\varepsilon_x$ is the
   identity when $Q_0$ is finite."*

**EXTERNAL CITATION.** Assem–Simson–Skowroński Vol. 1, Ch. II §1 pp. 42–43
(stationary path $\varepsilon_a$); Schiffler, *Quiver Representations*,
Def. 2.1 (constant path $e_i$); Mac Lane, *CWM*, Ch. I §2 (identity morphism).

**FALSIFIES.** Any one of these kills it: (a) the quoted sentence is not at
those lines; (b) "composing with nothing but itself" admits a reading on which
$e_1 \cdot \alpha = \alpha$ still holds — argue the reading explicitly, do not
assert it; (c) `pathAlpha` is not built from `Path.nil 0`; (d) the two identity
laws are not stated in Section 5.

**CONFIDENCE.** High. Text quoted directly; all three contradictions grepped.
The only live question is (b) — whether the sentence is merely clumsy rather
than false. My position: "composing with nothing but itself" has one plain
reading, and it is false. Argue the other side if you can.

---

## N1 — HIGH — ex falso attributed to classical logic

**CLAIM.** `absurd`'s prose calls ex falso quodlibet classical. It is
intuitionistically valid, and the book says so two files earlier.

**EVIDENCE** — `lean_book/03-propositions-and-proofs/05-and-or-not.md:76`:

> This is the "ex falso quodlibet" principle from classical logic, made
> concrete.

Same file, 11 lines later: *"Observe that this is *intuitionistic* logic: there
is no built-in law of excluded middle."*

`lean_book/03-propositions-and-proofs/02-logic-recap.md` lists
($\bot$-elim, ex falso) among the natural-deduction rules, then: *"Every rule
listed above is accepted by **both** classical and intuitionistic logic. The
two differ on exactly one further principle, the law of excluded middle."*

**REPRO:**
```sh
grep -n "from classical logic" lean_book/03-propositions-and-proofs/05-and-or-not.md
grep -n "intuitionistic. logic" lean_book/03-propositions-and-proofs/05-and-or-not.md
grep -n "accepted by \*\*both\*\*" lean_book/03-propositions-and-proofs/02-logic-recap.md
grep -n "bot.-elim, ex falso" lean_book/03-propositions-and-proofs/02-logic-recap.md
```

**EXTERNAL CITATION.** van Dalen, *Logic and Structure* 5th ed., §5.1 —
intuitionistic logic keeps $\bot$-elim and drops only excluded middle. This is
the same source the book cites for soundness/completeness. In Lean:
`False.elim` is core; `Classical.em` is not.

**FALSIFIES.** Show that ex falso requires excluded middle (it does not —
$\bot$-elim is a primitive rule of intuitionistic natural deduction), or show
the §2 sentence does not say what I quote.

**CONFIDENCE.** High. This is settled proof theory, and the book states the
correct version itself.

---

## N2 — HIGH — the Σ-type reading of `∧` describes `∨`'s construction

**CLAIM.** The bullet meant to derive `∧` as the *constant-family* case of a
Σ-type instead describes a two-element index type, which is the `∨` case in the
very next bullet.

**EVIDENCE** — `lean_book/01-basics/05-pi-sigma-and-coc.md:146`:

> …exactly what Chapter 3's `∧` will turn out to be (`P ∧ Q` is Σ-type-like
> with the index type restricted to two unlabeled slots, both of type `Prop`).

Next bullet, same file: *"**Two-point index, varying family** — if $A$ is a
two-element type (Lean's `Bool` …)"* → yields `∨`.

**REPRO:**
```sh
sed -n '138,160p' lean_book/01-basics/05-pi-sigma-and-coc.md
```

**THE MATHEMATICS.** $P \wedge Q \cong \sum_{\_ : P} Q$ — index type $P$, family
constantly $Q$. A two-element index with a varying family gives $P \sqcup Q$,
i.e. `∨`. As written both bullets describe a two-element index, so the contrast
the passage is built on collapses.

**EXTERNAL CITATION.** HoTT book §1.6, quoted in this same file four
paragraphs earlier: *"If $B$ is constant, then the dependent pair type is the
ordinary Cartesian product type."* Under that quote `∧`'s index is `P`.

**FALSIFIES.** Give a reading of "index type restricted to two unlabeled slots,
both of type `Prop`" on which the index is $P$ rather than a two-element type.
Note that `P ∧ Q`'s *fields* are two — if you argue the sentence means "two
fields," say so and I will downgrade this to LOW (wording, not mathematics).
That is the strongest counter-argument available and I flag it deliberately.

**CONFIDENCE.** Medium-high on severity, high on there being a defect. The
"two fields" reading is the one weak point; the sentence says "index type,"
which is why I read it as I do.

---

## N12, N13 — RETRACTED. Both predictions tested, both wrong

I predicted two compile failures in Chapter 1's code before Lean was available.
Both were then run on Lean 4.32.2. **Both were wrong; the book is correct.**
Kept here rather than deleted so a re-checker can calibrate me.

**N12 (`#eval` on `Vec` with no `deriving Repr`) — DISMISSED.** Ran the exact
declaration plus `#eval (Vec.replicate (-42 : Int) 3 : Vec Int 3)`. Output:
`Vec.cons (-42) (Vec.cons (-42) (Vec.cons (-42) (Vec.nil)))`, exit 0 —
identical to what the book prints. `#eval` does not need a user-supplied `Repr`
to display a constructor tree. My model was wrong.

**N13 (`Nat.rec` in a computable `def`) — DISMISSED, both halves.**
`#eval double 5` → `10`, exit 0: `Nat.rec` is compiler-supported. And the
asymmetry with `myLength` is forced, not sloppy — `List.rec` really does fail:

```
error: code generator does not support recursor `List.rec` yet,
consider using 'match ... with' and/or structural recursion
```

Worse for me, the book **explains this in prose** and I had not read it
closely enough before predicting: *"`noncomputable` and `#reduce` in place of
`#eval` here are a Lean implementation detail — the code generator that backs
`#eval` does not yet support compiling `List.rec` directly …"*
(`01-basics/05-pi-sigma-and-coc.md`).

**Calibration.** These were my only two findings resting on predicted tool
behaviour rather than read text or done mathematics. I went 0 for 2. Everything
surviving (N0–N11, N14, N15) was established by reading, grepping, or
recomputing — but discount any prediction I make about an unrun toolchain.

---

## N14 — LOW — Chapter 1 §3 depends on `autoImplicit` without saying so

**CLAIM.** `Vec`'s `cons` uses an unbound `n`, and `Vec.replicate`/`Vec.head`/
`Vec.dot` use an unbound `α`. These elaborate only via `autoImplicit`, which
the book never mentions — one section after teaching `{α : Type}` explicitly.

**EVIDENCE** — `lean_book/01-basics/03-dependent-types.md`, and the project has
no `autoImplicit` setting (so it defaults to `true`):

```sh
grep -rn "autoImplicit" lean_project/          # expect: no output → default true
grep -n "cons : α → Vec α n" lean_book/01-basics/03-dependent-types.md
grep -n "def Vec.head : Vec α (n + 1)" lean_book/01-basics/03-dependent-types.md
```

**FALSIFIES.** Show the book explains `autoImplicit` somewhere
(`grep -rn "autoImplicit\|auto-bound\|auto bound" lean_book/` — I got no hits),
or argue a reader does not need it because the code works as printed in the
book's own project. The second is the real counter: it *does* work there. My
claim is that it stops working the moment the reader moves to Mathlib style,
which Chapter 13 sends them to do.

**CONFIDENCE.** High on the facts. Medium on severity — reasonable to call it a
pedagogy nit rather than a defect.

---

## N15 — LOW — "free commutative monoid" named, free monoid proved

**CLAIM.** §1 names the universal property "free **commutative** monoid on one
generator"; §4 spells it out quantifying over *any monoid*. Two different
properties, both true of $\mathbb{N}$, but the name and the statement disagree.

**EVIDENCE:**
```sh
grep -n "free commutative monoid" lean_book/01-basics/01-everything-has-a-type.md
grep -n "for every monoid\|any monoid" lean_book/01-basics/04-terminology.md
```

**THE MATHEMATICS.** Free monoid on one generator = words in one letter
$\cong \mathbb{N}$; it is commutative, hence also free as a commutative monoid
on one generator. Both claims hold. The defect is that §4, whose stated job is
to make the phrase precise, proves the un-adjectived version.

**FALSIFIES.** Argue that for a one-generator free object the two properties
coincide, so naming either is fine. **That argument is correct**, which is why
I rated this LOW — it is a labelling imprecision in a section about precision,
not an error.

**CONFIDENCE.** High that they differ as stated. Low that it needs fixing.

---

## N10 — HIGH — scrambled `rfl` examples in Chapter 5 §4

**CLAIM.** Three lines, three defects: a comment describing a different term
than its code; a line commented out while its own comment says it works; and a
pair of closed-term examples that cannot exhibit the asymmetry the comments
assert.

**EVIDENCE** — `lean_book/05-rigor-check/04-defeq-vs-propeq.md:32-34`:

```lean
example : 2 + 2 = 4 := rfl        -- 2 + 2 reduces to 4 definitionally
example : 0 + 2 = 2 := rfl        -- Nat.add recurses on its 2nd arg; 2 + 0 = 2 is the base case
-- example : 2 + 0 = 2 := rfl     -- also rfl (0 + n needs induction, n + 0 doesn't)
```

**REPRO:**
```sh
sed -n '30,36p' lean_book/05-rigor-check/04-defeq-vs-propeq.md
grep -n "a + 0. reduces immediately" lean_book/01-basics/04-terminology.md
```

**THE MATHEMATICS.** `Nat.add` recurses on its second argument, so `Nat.add n 0`
hits the base case for any `n` — including variable `n` — while `Nat.add 0 n`
is stuck when `n` is a variable. For **closed** numerals both directions
compute, so both `0 + 2 = 2` and `2 + 0 = 2` are `rfl`. The asymmetry needs a
variable to appear at all.

**COMPILE CHECK — RUN, on Lean 4.32.2. All four confirmed:**
```lean
example : (0:Nat) + 2 = 2 := rfl       -- SUCCEEDS (book: live at :33)
example : (2:Nat) + 0 = 2 := rfl       -- SUCCEEDS (book: commented OUT at :34)
example (n : Nat) : n + 0 = n := rfl   -- SUCCEEDS (book: absent)
example (n : Nat) : 0 + n = n := rfl   -- FAILS    (book: absent)
```
Failure message for the last: `Type mismatch: rfl has type ?m.9 = ?m.9 but is
expected to have type 0 + n = n`.

So `:34` compiles but is disabled, and neither of the two statements that
exhibit the asymmetry appears in the block at all.

**FALSIFIES.** Nothing textual remains — all three defects are now confirmed by
execution rather than reasoning. To kill this you would have to show the file
does not contain those lines (`sed -n '30,36p'` above), or argue that
commenting out a compiling `example` carries some meaning other than "this does
not work" in this book's conventions. That last is the only surviving angle.

**CONFIDENCE.** High on all three defects. Defect 2 was previously my weakest
(an inference from the comment-out convention); running the line settled it —
it compiles.

---

## N11 — MEDIUM — Π-universe rule stated as `max`, not `imax`

**CLAIM.** The rule as printed gives the wrong universe for every `∀` in the
book, because it omits `Prop` impredicativity.

**EVIDENCE** — `lean_book/05-rigor-check/03-typing-rules-and-safety.md:187`
(restated at `:237`):

$$\dfrac{\Gamma \vdash A : \mathtt{Type}\,i \quad \Gamma, x{:}A \vdash B : \mathtt{Type}\,j}{\Gamma \vdash \big(\textstyle\prod_{x:A} B\big) : \mathtt{Type}\,(\max(i,j))}$$

**REPRO:**
```sh
sed -n '183,190p' lean_book/05-rigor-check/03-typing-rules-and-safety.md
grep -n "Prop.* is syntactic sugar for .Sort 0" lean_book/01-basics/05-pi-sigma-and-coc.md
grep -rn "all_nats_ge_zero" lean_book/03-propositions-and-proofs/06-quantifiers.md
```

**THE MATHEMATICS.** Lean's rule is $\mathrm{imax}$, with
$\mathrm{imax}\ u\ 0 = 0$. Take `∀ n : Nat, n ≥ 0`: $A = \mathtt{Nat} :
\mathtt{Type}\,0$ so $i = 1$ in the book's indexing; $B$ lands in
`Prop` = `Sort 0` so $j = 0$. The printed rule gives $\max(1,0) = 1$, i.e.
`Type 1`. The true answer is `Prop`. The book proves
`theorem all_nats_ge_zero : ∀ n : Nat, n ≥ 0` in Chapter 3, which is only
well-formed under `imax`.

**COMPILE CHECK — RUN, on Lean 4.32.2:**
```
#check (∀ n : Nat, n ≥ 0)   -- ∀ (n : Nat), n ≥ 0 : Prop     ← rule says Type 1
#check (Type → Type)        -- Type → Type : Type 1          ← rule says Type 1 ✓
```
The printed rule gets §2's own worked example right and the book's Chapter 3
theorem wrong. Confirmed, not inferred.

**FALSIFIES.** (a) The `#check` above reporting `Type 1` — it does not; this
route is closed. (b) A stronger
counter: argue the rule is scoped to `Type`-valued $B$ by the notation
$B : \mathtt{Type}\,j$ itself, so `Prop` is simply out of scope and no error
exists. **This is the best argument against the finding** — I rate it a real
defect anyway because the section's stated job is to make the universe rule
precise, the book elsewhere calls `Prop` a universe (`Sort 0`), and it cites
Coquand–Huet, whose defining feature is exactly the impredicativity the rule
omits. If you find that scoping argument persuasive, downgrade to LOW.

**CONFIDENCE.** High that `max` ≠ Lean's rule. Medium that it is a defect
rather than a deliberate simplification — see (b).

---

## N3 — MEDIUM — three composition orders in one section

**CLAIM.** `11-path-algebras/05-path-composition.md` declares path order,
then prints the $kQ$ multiplication in function order, while the source it
quotes uses a third arrangement.

**EVIDENCE.** Declaration (Mathematical reading box): *"written throughout this
section in **path order**: '$p$ then $q$' … This is not the
function-composition order $q \circ p$ … Mixing them mid-explanation is a common
source of confusion, so this book fixes path order throughout."*

`:147` — function order: $q \cdot p = q\circ p$ if $t(p) = s(q)$, else $0$.

Sources box — ASS write $(a\mid\alpha_1\ldots\mid b)(c\mid\beta_1\ldots\mid d)
= \delta_{bc}(a\mid\alpha_1\ldots,\beta_1\ldots\mid d)$, concatenating the
**left** factor first.

**REPRO:**
```sh
grep -n "path order\|q \\\\cdot p\|delta_{bc}" lean_book/11-path-algebras/05-path-composition.md
sed -n '140,155p' lean_book/11-path-algebras/05-path-composition.md
```

**FALSIFIES.** Show that $q \cdot p = q \circ p$ *is* path order (it is not —
path order writes the first-traversed path leftmost), or that the section does
not claim to fix one convention.

**CONFIDENCE.** High on the inconsistency. Reasonable people can call this LOW
rather than MEDIUM; I rated it MEDIUM because the section itself names
convention-mixing as the hazard.

---

## N4 — MEDIUM — Gentzen 1934 in the body, 1935 in the citation

**CLAIM.** Internal date inconsistency.

**EVIDENCE** — `lean_book/03-propositions-and-proofs/02-logic-recap.md:75`:
*"**Natural deduction** (Gentzen, 1934) is the standard system of such rules."*
Same file's Sources box and `lean_book/bibliography.md:30` use `[Gentzen1935]`,
*Mathematische Zeitschrift* 39, 1935.

**REPRO:**
```sh
grep -n "Gentzen, 1934" lean_book/03-propositions-and-proofs/02-logic-recap.md
grep -n "gentzen1935" lean_book/bibliography.md
```

**EXTERNAL.** Consensus cache Q7 — Gentzen's system in "1935 and 1936
variants"; Jaśkowski and Gentzen independently in 1934.

**FALSIFIES.** Argue 1934 is the correct date for the *paper* — but then the
bibliography key and entry are the thing to change, and the finding stands as an
inconsistency either way.

**CONFIDENCE.** High that they disagree. The historically "right" year is
genuinely contestable (submission 1933/34, publication 1935); the finding is
the disagreement, not the year.

---

## N5 — MEDIUM — Schiffler Definition 4.5 / Lemma 4.3

**CLAIM.** A lemma numbered 4.3 cannot immediately follow a definition
numbered 4.5.

**EVIDENCE** — `lean_book/11-path-algebras/05-path-composition.md:191`:

> Schiffler ([Schiffler2014]), **Definition 4.5** (Chapter 4, §4.2) — same
> construction; unit given explicitly as $1 = \sum_{i\in Q_0} e_i$ in the lemma
> immediately following (Lemma 4.3 in that source's numbering).

**REPRO:**
```sh
sed -n '191p' lean_book/11-path-algebras/05-path-composition.md
```

**FALSIFIES.** Show that Schiffler uses two independent counters (e.g.
definitions and lemmas numbered separately) such that Lemma 4.3 can follow
Definition 4.5. **This is the most likely way this finding dies** — several
Springer texts do exactly that. I could not check the physical source. If you
can, do; if the numbering is independent, mark this DISMISSED.

**CONFIDENCE.** Low-medium. Flagged as a question, not an error.

---

## N6 — LOW — three "Chapter 1, Section 4" labels point at Section 5

**CLAIM.** Label/target mismatch in three cross-references.

**EVIDENCE.** `01-prop.md:66`, `02-logic-recap.md:17`, `02-logic-recap.md:224`
all read `[Chapter 1, Section 4](../01-basics/05-pi-sigma-and-coc.md)`.
`05-pi-sigma-and-coc.md` is Section 5; Section 4 is `04-terminology.md`.

**REPRO:**
```sh
grep -rn "Section 4](../01-basics/05-pi-sigma" lean_book/
ls lean_book/01-basics/
```

**COMPLETENESS CLAIM (attack this too).** I assert these three are the *only*
such mismatches in the book, via a Perl sweep over every
`[Chapter N, Section M](...)` link, comparing $N$ to the target's directory
number and $M$ to the target's file number. That sweep only catches links using
that exact phrasing — links written `[Chapter 1 §4](...)` or `[§4](...)` were
**not** checked. Re-run with a looser pattern if you want the completeness
claim to hold.

**FALSIFIES.** Find a fourth mismatch, or show the target is wrong rather than
the label (context is Π/Σ and the calculus of constructions, which is Section 5's
subject, so I claim the target is right).

**CONFIDENCE.** High on the three; medium on completeness, for the reason above.

---

## N7 — LOW — `subst` missing from the tactic reference

**CLAIM.** `tactic-and-library-reference.md` promises "every tactic used in
this book" and omits `subst`, which appears in a Lean block.

**EVIDENCE.** `lean_book/01-basics/04-terminology.md:225` — `subst h` inside a
` ```lean ` fence. `lean_book/tactic-and-library-reference.md` opens: *"A quick
index of every tactic used in this book."* No `subst` row.

**REPRO:**
```sh
sed -n '218,228p' lean_book/01-basics/04-terminology.md
grep -c '`subst`' lean_book/tactic-and-library-reference.md   # expect 0
```

**METHOD (attack this).** I extracted all 192 Lean fences with a Perl regex on
` ```lean ` … ` ``` `, then tested a fixed list of ~25 candidate tactic names
against the reference table. That list was hand-chosen, so a tactic outside it
would have been missed. My claim is that `subst` is *a* gap, not that it is the
*only* gap.

**FALSIFIES.** Show a `subst` row exists, or that `01-basics/04-terminology.md:225`
is not inside a Lean fence.

**CONFIDENCE.** High on `subst`. Low on exhaustiveness — stated as such.

---

## N8 — LOW — 24 broken relative links in `changelog/`

**CLAIM.** 24 links resolve to non-existent paths, all from paths written
relative to `lean_book/` while living in `lean_book/changelog/`.

**BREAKDOWN.** `v1.4.0.md` 19, `v1.1.0.md` 3, `v1.0.0.md` 1, `v1.2.0.md` 1.

**REPRO:**
```sh
cd lean_book && perl -e '
use File::Find; use File::Basename;
my @f; find(sub { push @f, $File::Find::name if /\.md$/ }, "changelog");
my $n=0;
for my $file (@f) { open my $fh,"<",$file or next; my $ln=0;
  while(my $l=<$fh>){ $ln++;
    while($l=~/\[([^\]]*)\]\(([^)#\s]+)(#[^)]*)?\)/g){ my $t=$2;
      next if $t=~m{^(https?:|mailto:|#)} or $t eq "...";
      my $p=dirname($file)."/".$t; 1 while $p=~s{[^/]+/\.\./}{};
      unless(-e $p){ $n++; print "$file:$ln -> $t\n"; }}}}
print "total: $n\n";'
```

**NOTE ON MY OWN FALSE POSITIVES.** An earlier run of this sweep flagged
`README.md`'s `../lean_book_latex/`, `../LICENSE`, and
`python-companion/README.md`'s `../../lean_project/` as broken. **Those are
false positives** caused by my path-normalisation collapsing `./../` wrongly.
All three targets exist. They are excluded above. If your sweep flags them,
that is my bug reproducing, not a book defect.

**FALSIFIES.** Show the paths resolve under whatever renderer the project
actually uses (a renderer that resolves changelog links against `lean_book/`
rather than the file's own directory would make these work).

**CONFIDENCE.** High that they do not resolve on disk. Medium that it matters —
changelog only.

---

## N9 — LOW — two citation details

**N9a.** `lean_book/01-basics/05-pi-sigma-and-coc.md:517` cites CIC as
*"(Coquand and Paulin, 'Inductively Defined Types,' 1990)"*. Consensus's top hit
for that phrasing is **Pfenning & Paulin-Mohring 1989**, "Inductively Defined
Types in the Calculus of Constructions" — a *different* paper (cache Q3). The
intended one is the COLOG-88 proceedings paper, LNCS 417, published 1990; the
author published as **Paulin-Mohring**.
**FALSIFIES.** Show she published that paper as "Paulin," or that the book means
the Pfenning paper.
**CONFIDENCE.** High on the surname; medium on the venue (Consensus does not
index the COLOG-88 paper — I am relying on standard bibliographies, not a
retrieved record. **Verify independently.**)

**N9b.** `lean_book/03-propositions-and-proofs/01-prop.md` traces Curry–Howard
to Howard 1969 only. Wadler (2015): *"a correspondence observed by Curry in 1934
and refined by Howard in 1969"* (cache Q6).
**FALSIFIES.** Argue the book's scope is Howard's contribution specifically.
This is an addition, not an error — drop it if you disagree.
**CONFIDENCE.** High on the fact, low on it being a finding.

---

## Triage claims about the 2026-08-02 report — verify these too

I marked seven of eight prior findings RESOLVED. Each is a factual claim about
the current repo:

```sh
grep -rn "v4\.3[0-9]\.[0-9]" README.md NOTICE.md REPRODUCING.md lean_book/    # expect only v4.32.2
grep -n "latest stable\|latest release" REPRODUCING.md                        # expect no output
grep -rn "already have programming experience" REPRODUCING.md                 # expect no output
ls lean_project/LeanProject/ | grep -E "Ch01Dep|Ch12|Ch14"                    # expect 3 files
grep -n "quickstart.html" lean_book/00-setup/02-installing-toolchain.md       # expect a hit
grep -n "four questions" lean_book/13-next-steps/00-index.md                  # expect a hit
sed -n '18,20p' lean_book/14-appendix-solutions/00-index.md                   # M2: expect NO "Chapter 2" note
```

If any expectation fails, my triage is wrong and the corresponding finding
should be reopened.

---

## What I did not check — open attack surface

1. **Compilation.** See the header. `lake build` unfinished. Every "this proof
   is sound" statement in the main report is hand-traced.
2. **Printed-source page numbers.** Dummit & Foote, Mac Lane, Jacobs, Pareigis,
   Thompson, Assem–Simson–Skowroński, Schiffler — every page and section number
   in the book's Sources boxes is unverified by me. N5 is the only one whose
   *internal* numbering is self-inconsistent; the rest could be silently wrong
   and I would not have caught it.
3. **Chapters read only in part.** I read `10-modules/` only via its Sources
   boxes, `12-working-efficiently/` and `13-next-steps/` only via targeted
   greps, `14-appendix-solutions/` only via its index, and `06`/`08` only for
   their definition sections. **A reviewer looking for what I missed should
   start there** — specifically the exercise solutions, which no persona in
   this pass read end to end.

   **Calibration datum.** I initially read `05-rigor-check/` through its
   Sources boxes only, and on that basis wrote that the theoretical chapters
   were sound. Reading the body then produced N10 and N11 — the two most
   substantive type-theory findings in this dossier. The chapters listed above
   have had exactly the treatment Chapter 5 had when I got it wrong. Assume
   they contain findings of comparable severity and go look.
4. **The other `lean_project/Ch*.lean` modules.** I read
   `Ch01DependentTypes.lean` in full, which yielded N12 and N13 within minutes.
   The other 21 modules were not opened. Given the hit rate on the one I did
   read, this is the highest-expected-yield unexplored area in the repo.
5. **LaTeX output.** `lean_book_latex/` was out of scope entirely.
6. **Python companion notebook.** Not opened.
7. **Notation-consistency sweep.** Not run as a dedicated pass; N3 surfaced
   incidentally, which suggests a proper sweep would find more.

---

## POST-FIX ADDENDUM — the repairs, and how to attack them

All findings above were repaired in the same session. `lean_book/` Markdown is
the source of truth; `lean_book_latex/` is regenerated by
`lean_book_latex/build/build_latex.py`, so no `.tex` was hand-edited. A
per-finding table of what changed is at §6b of `REVIEW-FINAL-CLAUDE.md`.

**The fixes have had exactly one pass — mine — and no adversarial pass.**
That is the same condition that produced the defects in the first place. In
priority order for a re-checker:

1. **N11's rewrite is the highest-risk edit in the batch.** It adds *new formal
   content* to the book's theoretical core: the `imax` rule stated over `Sort`,
   the `Sort 0 = Prop` / `Sort (k+1) = Type k` correspondence, the claim that
   `imax(i,j) = max(i,j)` for `j > 0`, and a worked derivation that
   `max` would put `∀ n : Nat, n ≥ 0` in `Type 1`. Every one of those is
   checkable against Lean and against the CIC literature, and every one is the
   kind of statement this review found the book getting wrong elsewhere.
   **REPRO:** `lean_book/05-rigor-check/03-typing-rules-and-safety.md`, the
   Π-type rule and the two paragraphs following it.

2. **N0's replacement sentence asserts more than the original.** It now claims
   $e_i$ composes with *any* path starting or ending at $i$ and leaves it
   unchanged, and forward-references Section 5's units. Check that against
   `Path.append`'s actual type and against the identity laws as Section 5
   states them — the forward reference must not overpromise.

3. **N10's replacement block was verified by execution but the surrounding
   prose was not.** The four `rfl` cases were run on Lean 4.32.2 (results in
   §5 of the main report). The new paragraph claiming "replace `n` by a literal
   and the commented-out line starts succeeding" follows from those runs, but
   the block as a whole has not been compiled *in situ*.

4. **N14 renders a code snippet that was never compiled.** The explicit-binder
   `Vec` declaration given for Mathlib-style projects was written to be
   `autoImplicit`-independent but **was not run**. Lean became unusable in this
   environment partway through the fix session — even `#eval 1+1` blocks for
   five minutes in page-in with 0.25s of CPU, on degraded container storage.
   The prose was therefore reworded to claim only what the code *says* ("binds
   `n` explicitly rather than relying on the setting") rather than what Lean
   does with it, since my record on untested Lean predictions in this review is
   0 for 2 (see N12/N13). **Compile it and restore a stronger claim if it
   holds.**

5. **N5 was not fixed, deliberately.** Springer's copy is paywalled; the
   impossible "Lemma 4.3 immediately following Definition 4.5" claim was
   dropped and replaced with an explicit "not independently verified" box
   rather than guessed at. Anyone with the printed Schiffler should close it.

6. **The changelog link rewrite (N8) was a scripted bulk edit, and my first
   attempt had a bug.** The pattern initially rewrote `](README.md)` inside
   `changelog/` to `](../README.md)` — but `changelog/README.md` exists and is
   the changelog index, so that silently retargeted ~20 files to the wrong
   page. It resolved, so a naive link check passed. Caught and reverted; only
   4 changelog files are now modified. **A re-checker should confirm that, and
   should treat "the link resolves" as insufficient evidence that it points
   where it should.**

7. **`build_latex.py` was modified.** `strip_hypertargets()` now tolerates
   pandoc 3.x's `{%\n` and wraps `\chapter` as well as `\section`. This is a
   generator change affecting every `.tex` file in the book; the regenerated
   output should be diffed against the previously committed `.tex` for
   unintended drift, not just checked for "it compiled."

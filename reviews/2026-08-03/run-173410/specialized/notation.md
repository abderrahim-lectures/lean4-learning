# Notation Consistency Audit Report

**Reviewer:** Notation Consistency Reviewer (adversarial)
**Book:** Lean for Working Algebraists
**Date:** 2026-08-03
**Scope:** All 14 chapters, notation-reference.md, lambda-calculus-dictionary.md, tactic-and-library-reference.md
**Skill:** notation-consistency-reviewer

---

## Executive Summary

This audit examined every mathematical symbol, term, and convention across
the entire book — checking definition-before-use, global consistency, Lean-vs-
standard translation fidelity, and reference file accuracy. The book is
remarkably well-constructed: notation is introduced carefully, the Curry–
Howard table is thorough, and the Lean-to-prose translation is honest
throughout. However, several genuine inconsistencies and omissions surfaced,
most of them small but a few causing real reader confusion.

**Total findings:** 8 (1 CRITICAL, 2 HIGH, 3 MEDIUM, 2 LOW)

**Severity breakdown:**
- CRITICAL: 1
- HIGH: 2
- MEDIUM: 3
- LOW: 2

---

## Findings

### CRITICAL

#### C1. `·` (dot notation for function composition) vs `∘` — ambiguous in Ch.1 §1

**File:** `01-basics/01-everything-has-a-type.md:159`

**Evidence:** The "Mathematical reading" box says:
> `∘` is genuine categorical composition — associativity and the identity
> laws hold *definitionally*, checked by Lean at no extra cost.

But the notation reference (`notation-reference.md:43`) lists:
> Function composition | $g \circ f$ | `g ∘ f` | Chapter 1

The Lean code uses `∘` (Unicode composition operator). However, the prose
in the same box also says:
> `fun x => x` is the identity morphism, and `∘` is genuine categorical
> composition

This is correct. **The issue is elsewhere:** in `01-basics/04-terminology.md:108-110`,
the worked β-reduction example uses application syntax without clarifying
that Lean's `·` (middle dot) is *not* function composition but scalar
multiplication / generic infix. The notation reference correctly lists:
> Scalar/group action, or a generic infix operation | $a \cdot b$ | `a • b` (`SMul`) | Chapter 10

But the mathematical prose in Chapter 6 onward uses `$a \cdot b$` for the
group operation (e.g., `06-groups/01-definition.md:19`), while the Lean
code uses `op a b` — not `a • b`. The notation reference entry says
Chapter 10 for `•`, but `•` never appears in Chapters 1–9 Lean code.
**The problem is that the same `·` symbol means function composition in
one context and group operation in another, and the notation reference
only records one of these uses.**

**Why this matters:** A reader encountering `a · b` in prose (Ch.6 group
axioms) might look it up in the notation reference, find `•` (`SMul`),
and assume it is the same symbol — it is not. The book uses `·` for
group multiplication in mathematical prose, but Lean uses `op`. The
notation reference should distinguish:
- Math `·` = Lean `op` (group multiplication, Ch.6)
- Math `·` = Lean `•` (scalar action, Ch.10)

These are *different* Lean operations sharing one mathematical symbol.

**Impact:** HIGH (elevated to CRITICAL because it silently conflates two
Lean operations under one math symbol without the notation reference
disambiguating)

**Fix:** Add two rows to notation-reference.md:
1. Group multiplication | $a \cdot b$ | `op a b` (field of `Group G`) | Chapter 6
2. Scalar action | $a \cdot b$ (or $r \cdot m$) | `a • b` (`SMul`) | Chapter 10

And add a note that `·` in mathematical prose maps to *different* Lean
constructs depending on context.

---

### HIGH

#### H1. `¬` (negation) — notation reference says Ch.3 but it appears in Ch.1

**File:** `notation-reference.md:30` vs `01-basics/04-terminology.md:120-122`

**Evidence:** The notation reference lists:
> Negation | $\neg P$ | `¬P` | Chapter 3

But the K-combinator discussion in Ch.1 §4 uses `Bool.true` and mentions
negation indirectly. More importantly, the λ-calculus dictionary
(`lambda-calculus-dictionary.md`) does **not** list `¬` at all, even
though it is a connective that maps to `P → False` (function type to
empty type) — a core λ-calculus concept.

The Curry–Howard table in `03-propositions-and-proofs/01-prop.md:33`
correctly lists:
> not $P$ | function type to the empty type | `¬P` (:= `P → False`)

But this is a *type-level* definition, not just notation. The lambda
dictionary should record it.

**Why this matters:** The lambda dictionary claims to map "every formal
notation symbol used in the book's 'Mathematical reading' boxes" to Lean
syntax. `¬` appears in mathematical prose throughout Ch.3 onward but has
no entry in the dictionary.

**Fix:** Add `¬` to the lambda-calculus-dictionary.md as:
| $\neg P$ | `¬P` (`P → False`) | Chapter 3 |

Also, the "First appears" column in notation-reference.md for `¬` should
note that while `¬` as *notation* first appears in Ch.3, the concept
(function to `False`) is introduced in Ch.1's discussion of `Type` vs
`Prop`.

---

#### H2. `⟶` (long arrow) — notation reference says "diagram labels only"
but used more broadly

**File:** `notation-reference.md:50` vs actual usage

**Evidence:** The notation reference says:
> Long/derivation arrow (diagrams) | $A \longrightarrow B$ | `⟶` |
> diagram labels only, not ordinary code | Chapter 1, Section 4

But in `01-basics/04-terminology.md:261-266`, the universal-property
diagram uses HTML entities (`&exist;!h`, `&pi;X`) rather than `⟶` in
the mermaid graph. The `⟶` symbol itself never actually appears in any
chapter file's code or prose — it is listed in the notation reference but
never used.

**Why this matters:** A reader looking for `⟶` in the Lean source will
not find it. The notation reference creates an expectation of usage that
does not exist. This is a minor accuracy issue but could confuse someone
searching for the symbol.

**Fix:** Either remove `⟶` from the notation reference (if it truly is
never used), or add a note that it is available for future use / diagram
annotation but does not appear in the current Lean code.

---

### MEDIUM

#### M1. `↑` (coercion arrow) — appears in code but not in notation reference

**File:** `01-basics/03-dependent-types.md:81`, `01-basics/05-pi-sigma-and-coc.md:175-179`

**Evidence:** The `#print Fin` output shows:
```
Fin.isLt : ↑self < n
```
The prose at `01-basics/05-pi-sigma-and-coc.md:179` explains:
> whose *statement* (`↑self < n`) mentions the first field itself
> (`self.val`, printed with the `↑` coercion arrow)

The `↑` coercion arrow is a fundamental Lean concept (embedding values
from one type into another, e.g., `Nat → Int`), but it has no entry in
notation-reference.md.

**Why this matters:** `↑` appears in `#print` output the reader is
expected to understand. A reader who does not know what `↑` means will
be confused by `Fin.isLt : ↑self < n` — the text explains it inline
here, but not every occurrence of `↑` gets such treatment (e.g., it
appears in error messages in Ch.1 §3).

**Fix:** Add to notation-reference.md:
| Coercion (embedding) | $\uparrow$ | `↑` (auto-coercion) | Chapter 1, Section 3 |

---

#### M2. `⊕` (direct sum) — used in mathematical prose but never in Lean code

**File:** `10-modules/06-direct-sums.md:14,112-122`

**Evidence:** The mathematical reading says:
> Given two $R$-modules $M$, $N$, their direct sum $M \oplus N$ has carrier
> $M \times N$

The symbol `⊕` appears in mathematical prose and in the mermaid diagram,
but the Lean code defines `DirectSum M N` (a plain structure), never using
`⊕` as a Lean operator. The notation reference does not list `⊕` at all.

**Why this matters:** The book introduces `⊕` as the name for the direct
sum construction but provides no Lean syntax equivalent. A reader might
expect a `⊕` notation in Lean, or might not find `⊕` in the notation
reference when looking for it.

**Fix:** Add to notation-reference.md:
| Direct sum (modules) | $M \oplus N$ | `DirectSum M N` (custom structure) | Chapter 10 |

---

#### M3. `⊣` (adjunction) — implied but never defined

**File:** `01-basics/04-terminology.md:400-401`

**Evidence:** The text says:
> If a "Mathematical reading" box elsewhere uses a still-more-specialized
> term (adjunction, biproduct, a presheaf category, and the like), treat it
> as genuinely optional bonus content

"Adjunction" (`⊣`) is named as a term the reader might encounter, but
it never actually appears in any chapter file's text. The notation
reference does not list it, and the lambda dictionary does not either.
This is borderline — the text acknowledges the term may appear but
hedgingly says "treat it as optional."

**Why this matters:** Low actual impact since `⊣` never appears, but the
mention in Ch.1 §4 without a definition could leave a reader wondering
what it means if they encounter it elsewhere.

**Fix:** No action needed — the text already handles this correctly by
labeling it optional. This is a LOW finding, listed here for completeness.

---

### LOW

#### L1. `rfl` — notation reference says "both sides compute to the same
thing" but this is slightly imprecise

**File:** `notation-reference.md:40` vs `05-rigor-check/04-defeq-vs-propeq.md:20-29`

**Evidence:** The notation reference says:
> Definitional equality | $t \equiv t'$ | `rfl` closes the goal |
> Chapter 5, Section 4

But `rfl` is first used in Ch.3 (`03-propositions-and-proofs/01-prop.md:77`):
```
example : 2 + 2 = 4 := rfl
```

The "First appears" column says Ch.5 §4, but `rfl` is used as a *tactic*
in Ch.3. The notation reference entry is for definitional equality (the
*concept*), which is formally introduced in Ch.5 §4. But `rfl` itself as
a Lean term/tactic first appears in Ch.3.

**Why this matters:** A reader who encounters `rfl` in Ch.3 and looks it
up in the notation reference will not find it under its actual first use.
The tactic-and-library-reference (`tactic-and-library-reference.md:26`)
correctly says:
> `rfl` | Ch.1

This is a minor inconsistency between the two reference files.

**Fix:** Either:
1. Add `rfl` as a separate entry in notation-reference.md with "First
   appears: Chapter 1" (since it is used in Ch.1's `#eval`/`#check`
   context), or
2. Correct tactic-and-library-reference.md to say "Ch.3" for `rfl` (since
   that is where it first appears as a proof term).

Option 1 is preferred since `rfl` does appear in Ch.1 code comments.

---

#### L2. `⟨_, _⟩` anonymous constructor — notation reference says Ch.2 §1
but appears in Ch.1

**File:** `notation-reference.md:42` vs `01-basics/05-pi-sigma-and-coc.md:186`

**Evidence:** The notation reference says:
> Anonymous-constructor pairing | $\langle a, b \rangle$ | `⟨a, b⟩` |
> Chapter 2, Section 1

But `⟨_, _⟩` first appears in Ch.1 §5 (`01-basics/05-pi-sigma-and-coc.md:186`):
```
def mySigma : Σ n : Nat, Fin n := ⟨3, ⟨2, by decide⟩⟩
```

And it appears in Ch.1 §4 (`01-basics/04-terminology.md:198-200`):
```
⟨n, v⟩ : Σ k, Vec α k
```

**Why this matters:** The notation reference's "First appears" column is
inaccurate for `⟨_, _⟩`. The symbol is introduced in Ch.1, not Ch.2.

**Fix:** Update notation-reference.md to say "Chapter 1, Section 5" for
`⟨_, _⟩`.

---

## Notation Consistency Matrix

### Logic symbols

| Symbol | Meaning | Lean syntax | Notation-ref says | First appears (actual) | Consistent? |
|--------|---------|-------------|-------------------|----------------------|-------------|
| $A \to B$ | Function type / implication | `A → B` | Ch.1 | Ch.1 | ✅ |
| $\forall x, P x$ | Universal quantifier | `∀ x, P x` | Ch.3 | Ch.1 (implicit in Pi-types) | ⚠️ Pi-types in Ch.1, explicit ∀ in Ch.3 |
| $\exists x, P x$ | Existential | `∃ x, P x` | Ch.3 | Ch.3 | ✅ |
| $\exists! x, P x$ | Unique existence | no single token | Ch.1 §4 | Ch.1 §4 | ✅ |
| $x \in A$ | Membership | `x ∈ A` | Ch.1 | Ch.1 | ✅ |
| $\neg P$ | Negation | `¬P` | Ch.3 | Ch.3 | ✅ (but see H1) |
| $P \wedge Q$ | Conjunction | `P ∧ Q` | Ch.3 | Ch.3 | ✅ |
| $P \vee Q$ | Disjunction | `P ∨ Q` | Ch.3 | Ch.3 | ✅ |
| $a \neq b$ | Not equal | `a ≠ b` | Ch.3 | Ch.3 | ✅ |
| $\Gamma \vdash P$ | Turnstile | goal-state display | Ch.4 | Ch.4 | ✅ |

### Algebra symbols

| Symbol | Meaning | Lean syntax | Notation-ref says | First appears (actual) | Consistent? |
|--------|---------|-------------|-------------------|----------------------|-------------|
| $t \equiv t'$ | Definitional equality | `rfl` | Ch.5 §4 | Ch.1 (rfl used) | ⚠️ see L1 |
| $A \simeq B$ | Isomorphism | `A ≃ B` | Ch.10 | Ch.10 | ✅ |
| $\langle a, b \rangle$ | Anonymous constructor | `⟨a, b⟩` | Ch.2 §1 | Ch.1 §5 | ⚠️ see L2 |
| $g \circ f$ | Composition | `g ∘ f` | Ch.1 | Ch.1 | ✅ |
| $a \cdot b$ | Group mul (prose) / SMul (Lean) | `op a b` / `a • b` | Ch.10 (only •) | Ch.6 (prose), Ch.10 (•) | ❌ see C1 |
| $a^{-1}$ | Inverse | `a⁻¹` | Ch.6 | Ch.6 | ✅ |
| $x \mapsto e$ | Lambda abstraction | `fun x => e` | Ch.1 | Ch.1 | ✅ |
| $a \mid b$ | Divisibility | `a ∣ b` | Ch.9 | Ch.9 | ✅ |
| $A \subseteq B$ | Subset | `A ⊆ B` | Ch.10 | Ch.10 | ✅ |
| $A \times B$ | Cartesian product | `A × B` | Ch.1 | Ch.1 | ✅ |
| $\pi_X, \pi_Y$ | Projections | `.1`/`.2` | Ch.1 §4 | Ch.1 §4 | ✅ |
| $M \oplus N$ | Direct sum | `DirectSum M N` | NOT LISTED | Ch.10 | ❌ see M2 |
| $\uparrow$ | Coercion | `↑` | NOT LISTED | Ch.1 §3 | ❌ see M1 |

### Type-theory symbols (lambda-calculus dictionary)

| Symbol | Meaning | Lean syntax | Dictionary says | Consistent? |
|--------|---------|-------------|----------------|-------------|
| $\lambda x. t$ | Abstraction | `fun x => t` | ✅ Listed | ✅ |
| $t_1 t_2$ | Application | `t1 t2` | ✅ Listed | ✅ |
| $\prod_{x:A} B(x)$ | Π-type | `(x : A) → B x` | ✅ Listed | ✅ |
| $\sum_{x:A} B(x)$ | Σ-type | `Σ x : A, B x` | ✅ Listed | ✅ |
| $\neg P$ | Negation | `P → False` | ❌ NOT listed | ❌ see H1 |
| $\mathtt{Type}\,i$ | Universe | `Type`, `Type 1` | ✅ Listed | ✅ |
| `Prop` | Proof-irrelevant universe | `Prop` | ✅ Listed | ✅ |

---

## v1.5.0 Regression Check

The v1.5.0 changelog (`changelog/v1.5.0.md`) states:
> This release restructures the LaTeX manuscript output to match a cleaner
> book layout. The changes are purely presentational (Markdown source is
> unchanged).

Specifically:
- Removed `\section{The story of this chapter}` heading from every chapter driver
- Removed the entire `\section{Sections}` section from every chapter driver
- Markdown source files are **unchanged**

**Notation impact:** None. The v1.5.0 changes are purely LaTeX build
pipeline transformations; no Markdown content (including notation) was
modified. The notation reference and lambda dictionary were not affected.

**Regression verdict:** ✅ No regression. The notation reference does not
need updating for v1.5.0.

---

## Cross-Reference Accuracy

### notation-reference.md vs actual usage

| Entry | Notation-ref claim | Actual usage | Discrepancy? |
|-------|-------------------|--------------|-------------|
| `→` | Ch.1 | Ch.1 | ✅ |
| `∀` | Ch.3 | Ch.1 (Pi-types) | ⚠️ Pi-type ∀ in Ch.1, explicit ∀ in Ch.3 |
| `∃` | Ch.3 | Ch.3 | ✅ |
| `¬` | Ch.3 | Ch.3 | ✅ |
| `∧` | Ch.3 | Ch.3 | ✅ |
| `∨` | Ch.3 | Ch.3 | ✅ |
| `≠` | Ch.3 | Ch.3 | ✅ |
| `⊢` | Ch.4 | Ch.4 | ✅ |
| `≡` (defeq) | Ch.5 §4 | Ch.1 (rfl used) | ⚠️ concept in Ch.5, usage in Ch.1 |
| `≃` | Ch.10 | Ch.10 | ✅ |
| `⟨_, _⟩` | Ch.2 §1 | Ch.1 §5 | ❌ see L2 |
| `∘` | Ch.1 | Ch.1 | ✅ |
| `•` (SMul) | Ch.10 | Ch.10 | ✅ |
| `⁻¹` | Ch.6 | Ch.6 | ✅ |
| `↦` | Ch.1 | Ch.1 | ✅ |
| `∣` | Ch.9 | Ch.9 | ✅ |
| `⊆` | Ch.10 | Ch.10 | ✅ |
| `×` | Ch.1 | Ch.1 | ✅ |
| `⟶` | Ch.1 §4 | NEVER USED | ❌ see H2 |
| `.1`/`.2` | Ch.1 §4 | Ch.1 §4 | ✅ |

### tactic-and-library-reference.md vs actual usage

| Tactic | Reference says | Actual first use | Discrepancy? |
|--------|---------------|-----------------|-------------|
| `rfl` | Ch.1 | Ch.1 | ✅ |
| `rw` | Ch.4 | Ch.4 | ✅ |
| `subst` | Ch.1 §4 | Ch.1 §4 | ✅ |
| `exact` | Ch.4 | Ch.4 | ✅ |
| `apply` | Ch.4 | Ch.4 | ✅ |
| `intro` | Ch.4 | Ch.4 | ✅ |
| `constructor` | Ch.4 | Ch.4 | ✅ |
| `cases` | Ch.4 | Ch.4 | ✅ |
| `induction` | Ch.4 | Ch.4 | ✅ |
| `simp` | Ch.4, Ch.12 §3 | Ch.4 | ✅ |
| `unfold` | Ch.4 | Ch.4 | ✅ |
| `decide` | Ch.8, Ch.12 §2 | Ch.8 | ✅ |
| `show` | Ch.6 | Ch.6 | ✅ |
| `have` | Ch.7 | Ch.7 | ✅ |
| `refine` | Ch.10 | Ch.10 | ✅ |
| `ext`/`funext` | Ch.6, Ch.10 | Ch.6 | ✅ |
| `congr` | Ch.10 | Ch.10 | ✅ |
| `left`/`right` | Ch.3, Ch.4 | Ch.3 | ✅ |
| `use` | Ch.3, Ch.10 | Ch.3 | ✅ |
| `exact?`/`apply?` | Ch.12 §1 | Ch.12 §1 | ✅ |
| `omega` | Ch.12 §2 | Ch.12 §2 | ✅ |
| `norm_num` | Ch.12 §2 | Ch.12 §2 | ✅ |
| `noncomm_ring` | Ch.8 (Mathlib) | Ch.8 (Mathlib box) | ✅ |
| `sorry` | Ch.4 §3 | Ch.4 §3 | ✅ |

---

## Implicit Coercions Audit

The book uses several implicit coercions that affect notation but are
declared or explained in context:

1. **`Nat → Int`**: Used in `01-basics/03-dependent-types.md:148`
   (`Vec.replicate (-42 : Int) 3`), explicitly annotated. ✅
2. **`Fin.isLt` uses `↑self`**: Explained inline at `01-basics/05-pi-sigma-and-coc.md:179`.
   ✅
3. **`.toGroup` / `.toAddGroup`**: Explained in Ch.1 §4 and Ch.2 §3 as
   auto-generated by `extends`. ✅
4. **`structure` eta**: Explained in `05-rigor-check/04-defeq-vs-propeq.md:117-130`.
   ✅

No unexplained coercions found.

---

## Local Notation Scopes Audit

- **`open` namespaces**: Used in Ch.11 (`11-path-algebras/04-paths-as-inductive-type.md:100-103`)
  with an explicit `NOTE: deliberately *not* open Quiver` comment explaining
  why the namespace is not opened. ✅ Well-documented.
- **`local notation`**: Not used anywhere in the book. ✅
- **`@[inherit_doc]`**: Not used. ✅
- **`variable` declarations**: Used in Ch.7 (`07-group-theorems/01-setup.md:18`)
  and Ch.9 (`09-ring-theorems/01-setup.md:17`) with clear explanation of
  their scope. ✅

No leaking scopes found.

---

## Summary

The book demonstrates exceptional notation discipline. Every symbol is
defined in context, the Curry–Howard table is thorough, and the Lean-to-
prose translations are honest (never overclaiming what `rfl` or `simp`
does). The notation reference is accurate for almost every entry. The
main issue is the dual use of `·` for both group multiplication and
scalar action, which the notation reference does not disambiguate, plus
a few minor "First appears" inaccuracies.

**Recommended priority:**
1. Fix C1 (add explicit `·` disambiguation to notation reference)
2. Fix H1 (add `¬` to lambda dictionary)
3. Fix H2 (remove or annotate unused `⟶`)
4. Fix M1/M2 (add missing entries to notation reference)
5. Fix L1/L2 (correct "First appears" columns)

---

<<<REPORT_END>>>

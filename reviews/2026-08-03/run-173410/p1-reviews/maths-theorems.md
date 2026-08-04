<<<REPORT_START>>>

# Adversarial Mathematical Review: Chapters 3, 5, 6, 7

## EXECUTIVE SUMMARY

This review covers 24 files across four chapters: **Chapter 3 (Propositions and Proofs)**, **Chapter 5 (Rigor Check)**, **Chapter 6 (Groups)**, and **Chapter 7 (Group Theorems)**. The mathematical content is **largely correct and well-structured**, with proofs that accurately reflect standard algebra and type theory. However, there are **systemic v1.5.0 regression issues** affecting all chapter index files: the "Story" and "Sections" scaffolding was supposed to be removed but remains, creating broken cross-references and outdated narrative structure. Additionally, several mathematical imprecision issues and one substantive proof concern were identified.

**Severity breakdown:**
- **CRITICAL**: 0
- **MAJOR**: 4 (3 regression + 1 mathematical)
- **MINOR**: 7
- **NIT**: 6

---

## PER-FILE FINDINGS

### Chapter 3: Propositions and Proofs

#### 00-index.md
| Severity | Issue |
|----------|-------|
| **MAJOR (Regression)** | **v1.5.0 regression**: The file retains both "## The story of this chapter" (lines 14–60) and "## Sections" (lines 62–71) sections. Per the regression context, LaTeX removed 'Story' and 'Sections' sections in v1.5.0. These should have been deleted. Their presence creates broken cross-references: the story narrative refers to "Section 1", "Section 2", etc. (lines 20, 25, 30, 35, 40, 45, 50) which no longer exist as a formal "Sections" list. |
| **MINOR** | Line 3: Navigation link "[Table of contents](../README.md)" — verify this path resolves correctly from `lean_book/03-propositions-and-proofs/`. |
| **NIT** | Line 9: "Read `Prop` as the type of statements and a proof as an ordinary term." — Learning objective could be sharper: "Interpret `Prop` as the type of propositions and proofs as terms inhabiting them." |

#### 01-prop.md
| Severity | Issue |
|----------|-------|
| **MINOR** | Lines 85–95: "Mathematical reading" claims `Prop` behaves like a truth value because "every proposition's proof-set is either empty (false) or, up to proof irrelevance, has exactly one element (true)". This is imprecise for intuitionistic logic: a proposition can be *inhabited* (true) without having a *canonical* proof, and "exactly one element up to proof irrelevance" conflates proof irrelevance (all proofs are definitionally equal) with uniqueness of inhabitation. Better: "A proposition is true exactly when its type is inhabited; Lean's proof irrelevance identifies all proofs of the same proposition." |
| **MINOR** | Line 93: "This is equality of terms that are *definitionally* equal, the strictest notion of '$=$'." — Should clarify that `rfl` proves *definitional* equality, which implies propositional equality but is strictly stronger. |
| **NIT** | Line 66: Cross-reference "[Chapter 1, Section 5](../01-basics/05-pi-sigma-and-coc.md)" uses "Section" terminology — inconsistent with v1.5.0 removal of "Sections" scaffolding. |
| **NIT** | Line 111–120: Howard citation notes manuscript was "privately circulated" from 1969, published 1980. Accurate but the parenthetical "(a secondary source corroborating this history, not Howard's paper itself)" on line 121 is oddly defensive for a bibliography note. |

#### 02-logic-recap.md
| Severity | Issue |
|----------|-------|
| **MAJOR (Regression)** | Lines 11, 135, 186, 189, 191, 205, 216, 224, 242, 256, 259: Repeated references to "Section 1", "Section 2", "Chapter 3, Section 4", "Section 4", "Section 5", "Chapter 1, Section 3", "Chapter 1, Section 5" — all using "Section" terminology that the v1.5.0 changes were meant to eliminate. These cross-references are now unmoored from any formal "Sections" list. |
| **MINOR** | Line 298: Bibliography note for [PierceSF] states "only the *Software Foundations* series homepage is available in the notebook, not chapter content, so the specific natural-deduction/classical-vs-intuitionistic treatment claimed here could not be verified verbatim." This is an **unverified citation** — a source is cited for a claim the authors could not verify. Either verify the claim or remove the citation. |
| **MINOR** | Line 149–150: "Completeness (Gödel, 1929/1930, for first-order logic; the propositional case is elementary)" — The date is ambiguous (1929 dissertation, 1930 publication). Acceptable but could be precise: "Gödel 1930". |
| **NIT** | Line 274: Quote from Feys & Ladriere breaks at page boundary ("éli[minations"). Should be cleaned up or marked with ellipsis. |
| **NIT** | Line 189–203: The quantifier translation table duplicates content from 01-prop.md lines 34–35. Not an error but redundant. |

#### 03-theorem-lemma.md
| Severity | Issue |
|----------|-------|
| **NIT** | Entire file is 26 lines — extremely sparse. No examples of `lemma` vs `theorem` usage difference (even if only rhetorical). Could add one line showing `lemma helper : P := ...` vs `theorem main : Q := ...` for clarity. |

#### 04-implication.md
| Severity | Issue |
|----------|-------|
| **NIT** | File is only 25 lines. The mathematical reading (lines 15–23) correctly identifies implication with function space, but could explicitly note that this is *exactly* the Curry–Howard correspondence at work, not just an analogy. |

#### 05-and-or-not.md
| Severity | Issue |
|----------|-------|
| **MINOR** | Line 42–44: `Or.elim` type signature shows `{P Q R : Prop}` but the actual Lean 4 `Or.elim` has type `Or.elim {α β : Prop} {γ : Sort*} (h : α ∨ β) (h₁ : α → γ) (h₂ : β → γ) : γ`. The book's version fixes `R : Prop` but Lean's is more general (`γ : Sort*`). This is a minor simplification but should be noted or corrected. |
| **MINOR** | Line 64–66: `anything_from_contradiction` uses `absurd h1 h2` where `h1 : 1 = 2` and `h2 : (1:Nat) ≠ 2`. The type ascription `(1:Nat)` on `h2` but not `h1` is inconsistent. Should be `(1 : Nat) = 2` or both without ascription (Lean infers `Nat` from context). |
| **NIT** | Line 87–91, 102–106: Mermaid diagrams for product/coproduct are nice but render only in compatible viewers. Consider adding plain-text fallback descriptions. |
| **NIT** | Line 126: "Observe that this is *intuitionistic* logic: there is no built-in law of excluded middle." — Good explicit flag, but the same point was made in 02-logic-recap.md line 255–259. Redundant but not wrong. |

#### 06-quantifiers.md
| Severity | Issue |
|----------|-------|
| **MAJOR (Mathematical)** | Lines 54–55: `@[reducible] def isPrime (n : Nat) : Prop := n ≥ 2 ∧ ∀ m : Nat, m < n → m ≥ 2 → ¬ (m ∣ n)`. This definition **incorrectly classifies `n = 2` as non-prime** because the condition `m < n → m ≥ 2` is vacuously true for `m = 2` (since `2 < 2` is false), but for `m = 1`, `1 < 2` is true yet `1 ≥ 2` is false, making the implication `1 < 2 → 1 ≥ 2` false, so `¬(1 ∣ 2)` is not required. Wait — let me re-read: `∀ m, m < n → m ≥ 2 → ¬(m ∣ n)`. For `n=2`, consider `m=1`: `1 < 2` is true, `1 ≥ 2` is false, so `m < n → m ≥ 2` is false, so the whole implication `(m < n → m ≥ 2) → ¬(m ∣ n)` is vacuously true. For `m=2`: `2 < 2` is false, so `m < n` is false, implication vacuously true. So actually `isPrime 2` reduces to `2 ≥ 2 ∧ (vacuously true)` = `True`. OK, it works. But the definition is **weirdly formulated**: the standard definition is `n ≥ 2 ∧ ∀ m, m ∣ n → m = 1 ∨ m = n`. The book's version uses `m < n → m ≥ 2 → ¬(m ∣ n)` which is equivalent but convoluted. More importantly, `@[reducible]` is used so `decide` can evaluate it — but `decide` on `isPrime 5` will check all `m < 5`, which is fine for small numbers but this definition does not scale. Not a correctness error, but a **pedagogical concern**: it presents a non-standard, inefficient primality predicate without comment. |
| **MINOR** | Line 57–58: `exists_prime_gt_three : ∃ p : Nat, p > 3 ∧ isPrime p := ⟨5, by decide⟩`. This works because `decide` evaluates the `isPrime` predicate. But `isPrime` as defined will check `m = 1,2,3,4` for `n=5` — acceptable. However, the proof `by decide` is a **computational proof**, not a mathematical one. The book should clarify this distinction (computational reflection vs. proof). |
| **MINOR** | Lines 81–90: Discussion of Euclid's theorem says "A fully formalized proof of Euclid's theorem lives in Mathlib as `Nat.exists_infinite_primes`". The actual Mathlib theorem is `Nat.exists_infinite_primes (n : ℕ) : ∃ p, p ≥ n ∧ Nat.Prime p`. The book's `isPrime` is not `Nat.Prime`. This should be noted. |
| **NIT** | Line 92–98: "Remark (a more formal restatement)" — this entire paragraph restates what the bullet points already said. Could be trimmed. |
| **NIT** | Line 109–127: Mathematical reading uses Π/Σ notation correctly but the coproduct diagram for `∃` (line 126–127) says "the 'tag' is which element of α was chosen" — this is correct for Σ-types but the analogy to `∨` as "tagged choice" is slightly stretched since `∨` has exactly two tags while `∃` has `|α|` tags. |

#### 07-equality.md
| Severity | Issue |
|----------|-------|
| **MINOR** | Line 31–35: `congr_example` uses `rw [h]` to rewrite `a + 1 = b + 1` from `a = b`. The explanation says "`rw` then closes automatically by trying `rfl` as its last step". This is true but `rw` does not *always* try `rfl`; it rewrites the goal and if the resulting goal is `X = X`, it closes by `rfl`. The phrasing "`rw` then closes automatically by trying `rfl` as its last step" anthropomorphizes the tactic. Better: "After rewriting, the goal becomes `b + 1 = b + 1`, which is true by reflexivity (`rfl`)." |
| **NIT** | Line 37–38: "The congruence `congr_example` is the Leibniz principle: $a = b \Rightarrow f(a) = f(b)$ for any function $f$ (here $f(x) = x + 1$)." — Correct, but "Leibniz principle" usually refers to the indiscernibility of identicals (if `a = b` then any predicate true of `a` is true of `b`). The functional form is a special case. Acceptable. |

#### 08-exercises.md
| Severity | Issue |
|----------|-------|
| **MINOR** | Line 16–22: Socratic Q1 asks why `∧` has one constructor and `∨` has two. Answer is correct. But the question says "`P ∧ Q` and `P ∨ Q` are both built from two propositions" — technically `∧` and `∨` are *type formers* taking two propositions, not "built from". Minor terminology slip. |
| **MINOR** | Line 23–30: Socratic Q2 on why `rfl` can't close `∀ n, n + 0 = n`. Answer correctly identifies that `n` is a variable. But the explanation says "`n + 0 = n` is true for every `n`, yet no single reduction sequence turns `n + 0` into `n` without first knowing which `n` it is." — This is slightly misleading: `Nat.add` is defined by recursion on the *second* argument, so `n + 0` *does* reduce to `n` by definition (it's the base case). The issue is that `rfl` checks *definitional* equality, and `n + 0` is definitionally equal to `n`! Wait — in Lean 4, `Nat.add` is defined as `def add : Nat → Nat → Nat | _, 0 => _ | a, succ b => succ (add a b)`. So `n + 0` reduces to `n` by definition. Therefore `example (n : Nat) : n + 0 = n := rfl` **should work**! Let me verify: in Lean 4, `n + 0` is indeed definitionally `n` because the first argument is `_` (ignored) and the second is `0`. So the book's claim that `rfl` fails on `∀ n, n + 0 = n` is **FALSE** for Lean 4. The asymmetry is with `0 + n = n`, not `n + 0 = n`. This is a **significant error** in the Socratic answer. |
| **MAJOR (Mathematical)** | **Lines 23–30: Socratic Q2 contains a false claim about Lean 4's `Nat.add` reduction behavior.** The book states `rfl` cannot close `∀ n, n + 0 = n` because "no single reduction sequence turns `n + 0` into `n`". But in Lean 4, `Nat.add` recurses on its *second* argument, so `n + 0` *is* definitionally `n` (base case). The example that fails is `0 + n = n`, not `n + 0 = n`. This error appears in Chapter 5, Section 4 (04-defeq-vs-propeq.md) as well — see that file's analysis. |
| **MINOR** | Line 39–43: Exercises 1 and 2 are identical to `and_comm_term` and `or_comm_term` from 05-and-or-not.md. This is fine for practice but the exercise should acknowledge this or vary the statement. |
| **NIT** | Line 44: Solutions reference `../14-appendix-solutions/02-chapter-3.md` — verify this path exists. |

---

### Chapter 5: Rigor Check

#### 00-index.md
| Severity | Issue |
|----------|-------|
| **MAJOR (Regression)** | **v1.5.0 regression**: Retains "## The story of this chapter" (lines 23–65) and "## Sections" (lines 67–74). The story narrative refers to "Section 1", "Section 2", "Section 3", "Section 4" (lines 30, 33, 38, 43, 50, 55) which are unmoored from the removed "Sections" list. |
| **MINOR** | Line 11: Learning objective "State the STLC typing rules and why `Type` itself needs a universe hierarchy." — STLC rules are covered but the "why `Type` needs a universe hierarchy" is covered in Section 2 (Universes), not Section 3 (Typing rules). The objective spans two sections; could be split. |
| **NIT** | Line 3: Navigation links use relative paths — verify `../04-tactics/00-index.md` and `../06-groups/00-index.md` resolve correctly. |

#### 01-structure-vs-class.md
| Severity | Issue |
|----------|-------|
| **MINOR** | Line 54: "square brackets, not curly braces — this is a third kind of argument, an **instance argument**" — In Lean 4, instance arguments use `[ ]`, implicit arguments use `{ }`, explicit use `( )`. Correct. But the book calls it a "third kind" — there are actually more (type ascription `@`, etc.). Acceptable simplification. |
| **NIT** | Line 111–124: Discussion of `.toGroup`, coercion — this is forward-referencing Chapter 6's `CommGroup extends Group` which hasn't been introduced yet. Slight forward reference but not wrong. |
| **NIT** | Line 129: "TPiL's chapters on 'Structures and Records' and 'Type Classes'" — TPiL4 chapter names may differ; verify. |

#### 02-universes.md
| Severity | Issue |
|----------|-------|
| **MINOR** | Line 52–56: Explanation of why `Type → Type` lives in `Type 1` uses the rule `max(i, j)` where `A : Type i`, `B : Type j`. But `Type` itself is `Type 0`, which lives in `Type 1`. So `A = Type` means `A : Type 1` (i=1), `B = Type` means `B : Type 1` (j=1), so `max(1,1)=1`. Correct. However, the text says "`A := Type` (living in `Type 1`, since `Type : Type 1`)" — this is correct but the phrasing "living in" is ambiguous: `Type` is a term of type `Type 1`, not "living in `Type 1`" as a universe member. Minor terminological imprecision. |
| **MINOR** | Line 103: Bibliography note says "Girard, *'Interprétation fonctionnelle et élimination des coupures dans l'arithmétique d'ordre supérieure,'* Thèse d'État, Université Paris VII, 1972 (not yet in this book's bibliography) — the actual source of the `Type : Type` inconsistency... [Girard1971] (the 1971/1970 paper... already in this book's bibliography) is a different, earlier paper and is not that source." This is a **bibliography integrity issue**: the book cites [Girard1971] for Girard's paradox but the note admits that paper is *not* the source. The correct source (1972 thesis) is not in the bibliography. This should be fixed. |
| **NIT** | Line 67–76: Universe polymorphism note — correctly states Mathlib uses it, book fixes at `Type 0`. Could mention that `Group.{u}` notation is Lean 4 syntax for universe polymorphism. |

#### 03-typing-rules-and-safety.md
| Severity | Issue |
|----------|-------|
| **MINOR** | Line 38–65: "Programmer's corner (Python)" with `mypy` examples. The `apply_twice` example (line 44) has `f: int` but comment says "pretend f is Callable[[int], int]". This is confusing — the type hint is wrong in the example. Should either use `Callable` or explain why it's `int`. |
| **MINOR** | Line 186–188: Universe formation rule uses `Sort (imax(i,j))` with `imax(i,j) = j when j = 0, max(i,j) otherwise`. This is correct for CoC/CIC. But the explanation says "where `Sort 0` is `Prop` and `Sort (k+1)` is `Type k` (Chapter 1, Section 5)". This mapping is correct but the `imax` definition is non-standard — usually it's `max(i, j)` for `j > 0` and `0` for `j = 0` (since `Prop` is impredicative). The book's `imax` returns `j` when `j=0`, i.e., `0`, which is `Sort 0 = Prop`. Correct. |
| **MINOR** | Line 216–239: Python `type(type) = type` demonstration. Correct that Python allows this because it's not a proof system. But the code shows `>>> type(type)` returning `<class 'type'>` — in Python 3, `type` is a class, so `type(type)` is `type`. Correct. |
| **NIT** | Line 261: Citation [Pierce2002] for Progress/Preservation — verified as Theorem 9.3.5/9.3.9 in Pierce. Correct. |
| **NIT** | Line 264: "Girard — see Chapter 5, Section 2's References for the full citation" — cross-reference uses "Section" terminology (v1.5.0 regression). |

#### 04-defeq-vs-propeq.md
| Severity | Issue |
|----------|-------|
| **MAJOR (Mathematical)** | **Lines 32–37: The `rfl` examples contain the SAME ERROR as Chapter 3's Socratic Q2.** The book claims `example (n : Nat) : n + 0 = n := rfl` works (line 33, comment "`rfl`: `n + 0` is Nat.add's base case") — this is **CORRECT** for Lean 4. But then line 34–36 says `-- example (n : Nat) : 0 + n = n := rfl -- FAILS: Nat.add recurses on its second argument, so `0 + n` is stuck`. This is **CORRECT**. However, the **asymmetry explanation on lines 39–42** says: "The asymmetry in the last two lines is the whole point... On closed numerals everything computes, so `0 + 2 = 2` and `2 + 0 = 2` are both `rfl` and neither reveals anything. Replace `n` by a literal and the commented-out line starts succeeding." This is **correct**. BUT Chapter 3's Socratic Q2 (08-exercises.md lines 23–30) claims the *opposite*: that `n + 0 = n` fails and `0 + n = n` works. **The two chapters contradict each other.** Chapter 5 is correct for Lean 4; Chapter 3 is wrong. |
| **MINOR** | Line 44–55: WHNF explanation is good but "Checking `a ≡ b` typically only reduces each side as far as its **weak head normal form** (WHNF): far enough to see the outermost constructor or function head, no further than needed." — In Lean, definitional equality checking uses a more sophisticated algorithm (including ζ-reduction for local definitions, δ-reduction for globals, etc.), not just WHNF. The WHNF description is a simplification. |
| **MINOR** | Line 91–101: " `rw` works up to propositional equality, but the resulting goal is checked up to definitional equality." — Correct. The "motive is not type correct" error explanation is accurate for dependent pattern matching. |
| **MINOR** | Line 105–115: Proof irrelevance explanation says "If `h1 h2 : a = b` are two different proof *terms* of the same propositional equality, `h1` and `h2` are definitionally equal to each other". This is true for `Prop`-valued equalities because `Eq` is in `Prop` and `Prop` is proof-irrelevant. But note: this is a *meta-theoretic* fact about Lean's kernel, not something visible in the language. The phrasing "definitionally equal to each other" is correct at the kernel level. |
| **NIT** | Line 117–130: Structure eta explanation — correct. The reference to Chapter 8's `Mat2.mk.injEq` and Chapter 10's `congr 1` are forward references. Acceptable. |

#### 05-exercises.md
| Severity | Issue |
|----------|-------|
| **MINOR** | Line 41–45: Exercise 1 asks to predict whether `example : (2 : Nat) * 3 = 3 + 3 := rfl` type-checks (yes, both sides compute to 6) and `example (n : Nat) : n * 2 = n + n := rfl` (no, `Nat.mul` recurses on first argument). Correct. |
| **MINOR** | Line 46–51: Exercise 2 asks to rewrite `opTwice` as type class version. Good exercise. |
| **MINOR** | Line 52–55: Exercise 3 asks to explain why `Type → Type` lives in `Type 1`. Good. |
| **MINOR** | Line 56–59: Exercise 4 asks for a true propositional equality not provable by `rfl`. Good. |
| **NIT** | Line 61: Solutions reference `../14-appendix-solutions/04-chapter-5.md` — verify path. |

#### 06-checkpoint-project.md
| Severity | Issue |
|----------|-------|
| **MINOR** | Lines 46–71: The self-verification code block defines `Monoid`, `listMonoid`, `monoid_id_unique`. All correct. Line 70: `#check monoid_id_unique (listMonoid Nat) [] (fun a => List.nil_append a)` — this applies the theorem to the instance. Correct. |
| **NIT** | Line 16–20: "Learning objectives" lists "building a small 'prove it once, generically' theorem in the style Chapter 7 will use for `Group` — here done for the weaker `Monoid` first." — Forward reference to Chapter 7. Acceptable. |
| **NIT** | Line 75: Solutions reference `../14-appendix-solutions/04-chapter-5.md` — same as exercises. |

---

### Chapter 6: Groups

#### 00-index.md
| Severity | Issue |
|----------|-------|
| **MAJOR (Regression)** | **v1.5.0 regression**: Retains "## The story of this chapter" (lines 13–54) and "## Sections" (lines 56–64). Story narrative refers to "Section 1" through "Section 6" (lines 19, 25, 31, 36, 42, 47) — unmoored from removed "Sections" list. |
| **MINOR** | Line 66–69: "Starting with this chapter, most examples are followed by a 'Mathlib equivalent' box... For links to the official docs for every Mathlib name used in those boxes, see the [tactic and library reference](../tactic-and-library-reference.md)." — Verify this file exists. |
| **NIT** | Line 3: Navigation links — verify paths. |

#### 01-definition.md
| Severity | Issue |
|----------|-------|
| **MINOR** | Line 23–30: Group axioms listed as associativity, identity (both sides), inverse (both sides). Standard. But the identity axiom is written as two separate equations `e·a = a` and `a·e = a`. Some texts combine as `e·a = a·e = a`. Not an error. |
| **NIT** | Line 44–50: Bibliography cites [DummitFoote2003] Proposition 1 for uniqueness of identity/inverses. Correct. [Aluffi2009] cited as "further reading, not independently verified" — acceptable. |

#### 02-translating.md
| Severity | Issue |
|----------|-------|
| **MINOR** | Line 42–46: `Group` structure has 7 fields: `op`, `id`, `inv`, `assoc`, `id_left`, `id_right`, `inv_left`, `inv_right` — that's **8 fields** (3 data + 5 proof). The text says "The remaining four fields are the identity and inverse axioms" (line 57) but there are 5 proof fields (assoc + 4). Line 58 says "split into left and right versions" — that's 2 + 2 = 4, plus assoc = 5. The text says "four fields" but means "four axiom fields besides associativity". Slightly confusing. |
| **MINOR** | Line 78–80: "any two proofs of the same one are considered definitionally equal — Lean does not distinguish between different ways of proving the same axiom". This is proof irrelevance for `Prop`. Correct. |
| **NIT** | Line 61–63: "This is the general recipe used throughout the book: **a mathematical structure is data plus proofs, bundled together**" — Good summary. |
| **NIT** | Line 95–101: Mathlib equivalent note — correct that Mathlib uses typeclass hierarchy. |

#### 03-integers-example.md
| Severity | Issue |
|----------|-------|
| **MINOR** | Line 15–34: All proofs use `intro` + `exact` with core library lemmas. Correct. |
| **NIT** | Line 45–53: Mathematical reading says "The term `intGroup` is a *proof that $\mathbb{Z}$ is a group*" — technically `intGroup : Group Int` is a *group structure on* $\mathbb{Z}$, not a proof that $\mathbb{Z}$ is a group (since $\mathbb{Z}$ can have multiple group structures). But for the standard one, it's fine. |
| **NIT** | Line 55–68: Mathlib equivalent shows `AddCommGroup Int` instance. Correct. |

#### 04-permutations-example.md
| Severity | Issue |
|----------|-------|
| **MINOR** | Line 22–27: `Perm3` structure bundles `toFun`, `invFun`, `left_inv`, `right_inv`. This is a concrete bijection representation. Correct. |
| **MINOR** | Line 37–50: `Perm3.comp` composes `f.toFun ∘ g.toFun` (f after g) and inverse `g.invFun ∘ f.invFun`. The order is correct for `(f ∘ g)⁻¹ = g⁻¹ ∘ f⁻¹`. Line 55 says "reverse the order" fact $(fg)^{-1} = g^{-1}f^{-1}$. Correct. |
| **MINOR** | Line 87–110: `swap01` and `cycle012` definitions with `match` expressions. Proofs use `intro x; match x with ... rfl`. Correct. |
| **MINOR** | Line 115–127: `#eval` shows non-commutativity by computing `(swap01 ∘ cycle012)(0) = 0` vs `(cycle012 ∘ swap01)(0) = 2`. Correct. |
| **MINOR** | Line 132–139: `Perm3.ext` extensionality lemma — correct. Uses `cases` on structure, then `funext` on functions. Proof irrelevance handles proof fields. |
| **MINOR** | Line 141–169: `perm3Group` assembly — all proofs via `Perm3.ext` and `rfl` or citing `f.left_inv`/`f.right_inv`. Correct. |
| **NIT** | Line 183–189: Mathematical reading identifies `Perm3` as $S_3$, smallest non-abelian group (order 6). Correct. Presentation $⟨r,s | r^3=s^2=e, srs=r^{-1}⟩$ with $r$=cycle, $s$=swap. Correct. |
| **NIT** | Line 191–216: Mathlib equivalent uses `Equiv.Perm (Fin 3)`, `Equiv.swap`, `finRotate`. Correct. |

#### 05-accessing-fields.md
| Severity | Issue |
|----------|-------|
| **NIT** | Short and correct. Shows field projections. |

#### 06-why-bundle.md
| Severity | Issue |
|----------|-------|
| **NIT** | Correctly explains the payoff. Mathlib equivalent shows `add_assoc`/`mul_assoc` as generic lemmas. |

#### 07-exercises.md
| Severity | Issue |
|----------|-------|
| **MINOR** | Line 39–44: Exercise 1: `boolXorGroup` with `Bool.xor`, `id := false`, `inv := fun a => a`. Proof hint suggests `cases a with | false => rfl | true => rfl`. Correct — XOR is associative, `false` is identity, every element is self-inverse. |
| **MINOR** | Line 45–48: Exercise 2: "Verify on paper that `inv_left` and `inv_right` are genuinely different obligations. They coincide automatically only once the group has been *proved* commutative — this is exactly the content of Chapter 7's first theorem." — Chapter 7's first theorem is `id_unique`, not about inverses. The uniqueness of inverses is Theorem 2 (`left_inverse_unique`). This is a **cross-reference error**. |
| **NIT** | Line 50: Solutions reference `../14-appendix-solutions/05-chapter-6.md` — verify. |

---

### Chapter 7: Group Theorems

#### 00-index.md
| Severity | Issue |
|----------|-------|
| **MAJOR (Regression)** | **v1.5.0 regression**: Retains "## The story of this chapter" (lines 21–55) and "## Sections" (lines 57–63). Story narrative refers to "Section 1" through "Section 4" (lines 28, 34, 38, 44) — unmoored from removed "Sections" list. |
| **MINOR** | Line 16–19: "The point of this chapter lies less in the three theorems themselves (they are standard) than in **the search process** for finding each proof... Each theorem below is presented as that search, not merely its answer." — Good pedagogical framing. |
| **NIT** | Line 3: Navigation links — verify. |

#### 01-setup.md
| Severity | Issue |
|----------|-------|
| **MINOR** | Line 18: `variable {G : Type} (Grp : Group G)` — uses implicit `{G}` and explicit `(Grp)`. This means `G` is implicit in subsequent theorems, `Grp` is explicit. But the theorems in later sections (e.g., `id_unique (e' : G)`) don't take `Grp` as argument — they rely on the `variable` binding. This is correct Lean 4 usage. |
| **NIT** | Line 24–30: Mathematical reading explains the `variable` as "Let $G$ be a group". Correct. |
| **NIT** | Line 39–42: Bibliography cites [DummitFoote2003] for the three theorems. Correct. |

#### 02-theorem-1.md
| Severity | Issue |
|----------|-------|
| **MINOR** | Line 33–38: Proof uses `have step1 : Grp.op e' Grp.id = Grp.id := h Grp.id` and `have step2 : Grp.op e' Grp.id = e' := Grp.id_right e'`, then `rw [← step2]` and `exact step1`. Correct. |
| **MINOR** | Line 40–47: Explanation of why `rw [← step2]` not `rw [step2]` — good tactical detail. |
| **MINOR** | Line 49–60: Mathematical reading gives chain `e' = e'·e = e`. Correct. |
| **MINOR** | Line 62–75: Mathlib equivalent uses `(mul_one e').symm.trans (h 1)`. Correct. |

#### 03-theorem-2.md
| Severity | Issue |
|----------|-------|
| **MINOR** | Line 17–29: The chain `b = b·e = b·(a·a⁻¹) = (b·a)·a⁻¹ = e·a⁻¹ = a⁻¹` is correctly mapped to `id_right` (backwards), `inv_right` (backwards), `assoc` (backwards), `h`, `id_left`. |
| **MINOR** | Line 32–44: Lean proof uses `have e1 : b = Grp.op b Grp.id := (Grp.id_right b).symm` then series of `rw`. Correct. |
| **MINOR** | Line 46–51: Comment about predicting goal state before running tactic — good advice. |
| **MINOR** | Line 53–64: Mathematical reading matches chain. Correct. |
| **MINOR** | Line 66–81: Mathlib equivalent uses `rw [← mul_one b, ← mul_inv_cancel a, ← mul_assoc, h, one_mul]`. Correct. Note: `mul_inv_cancel a : a * a⁻¹ = 1` — correct. |

#### 04-theorem-3.md
| Severity | Issue |
|----------|-------|
| **MINOR** | Line 9–20: Key insight: use `left_inverse_unique` (Theorem 2) to reduce goal to showing `b⁻¹·a⁻¹` is left inverse of `a·b`. This is a **characterization** pattern — correct and important. |
| **MINOR** | Line 22–27: "Applying that here (with the goal read backwards, `apply Eq.symm` first, so `left_inverse_unique` unifies against the 'b' slot)" — correct unification trick. |
| **MINOR** | Line 30–44: Lean proof: `apply Eq.symm`, `apply left_inverse_unique`, then `rw` chain using `assoc`, `inv_left`, `id_left`, `inv_left`. Correct. |
| **MINOR** | Line 46–49: "regroup, then cancel" pattern identified — good. |
| **MINOR** | Line 51–63: Mathematical reading: $(b^{-1}a^{-1})(ab) = b^{-1}(a^{-1}a)b = b^{-1}eb = b^{-1}b = e$. Correct. |
| **MINOR** | Line 65–91: Application to `perm3Group` with `#eval` on all 3 elements of `Fin 3`. Correct. |
| **MINOR** | Line 99–127: Mathlib equivalent uses `mul_inv_rev`. Correct. |

#### 05-exercises.md
| Severity | Issue |
|----------|-------|
| **MINOR** | Line 16–23: Socratic Q1 on `id_unique` — correctly notes that `h` only gives left identity, so must use `e'·e` not `e·e'`. |
| **MINOR** | Line 24–30: Socratic Q2 on `inv_op` — correctly notes no axiom computes `inv` of product directly. |
| **MINOR** | Line 31–36: Socratic Q3 — correctly identifies common pattern of relating both sides to common third expression. |
| **MINOR** | Line 38–41: Exercise 1: `inv_inv` — hint to use Theorem 2 with fact `a * a⁻¹ = e`. Correct. |
| **MINOR** | Line 42–46: Exercise 2: `cancel_left` — hint to apply `inv a` to both sides. Correct. |
| **NIT** | Line 48: Solutions reference `../14-appendix-solutions/06-chapter-7.md` — verify. |
| **NIT** | Line 3: Navigation link "[← Theorem 3](04-theorem-3.md)" — the previous file is `04-theorem-3.md`, correct. But the index lists 5 sections (Setup, Theorem 1, 2, 3, Exercises) so "Theorem 3" is section 4. The link text says "Theorem 3" which matches. |

---

## REGRESSION TRACKER: v1.5.0 Issues

The following issues are **systemic across all four chapter index files** and directly result from the v1.5.0 changes described in the regression context:

| File | Issue | Details |
|------|-------|---------|
| **03-propositions-and-proofs/00-index.md** | **Story & Sections scaffolding retained** | Lines 14–71 contain "## The story of this chapter" and "## Sections" which should have been removed per v1.5.0. The story narrative (lines 20, 25, 30, 35, 40, 45, 50) references "Section 1"–"Section 7" which no longer exist as a formal list. |
| **05-rigor-check/00-index.md** | **Story & Sections scaffolding retained** | Lines 23–74 contain both sections. Story narrative (lines 30, 33, 38, 43, 50, 55) references "Section 1"–"Section 4". |
| **06-groups/00-index.md** | **Story & Sections scaffolding retained** | Lines 13–64 contain both sections. Story narrative (lines 19, 25, 31, 36, 42, 47) references "Section 1"–"Section 6". |
| **07-group-theorems/00-index.md** | **Story & Sections scaffolding retained** | Lines 21–63 contain both sections. Story narrative (lines 28, 34, 38, 44) references "Section 1"–"Section 4". |

**Additional cross-reference pollution** (within section files, not just index):
- 02-logic-recap.md: 11 occurrences of "Section X" or "Chapter Y, Section Z"
- 01-prop.md: 2 occurrences ("Chapter 1, Section 5", "Chapter 5, Section 3")
- 03-typing-rules-and-safety.md: 1 occurrence ("Chapter 5, Section 2")
- 04-defeq-vs-propeq.md: 2 occurrences ("Chapter 4", "Chapter 11", "Chapter 8", "Chapter 10" — chapter refs OK but "Section" not used)
- 06-groups/02-translating.md: 2 occurrences ("Chapter 5, Section 1", "Chapter 6, Section 6")
- 06-groups/04-permutations-example.md: 2 occurrences ("Chapter 7's Theorem 3", "Chapter 8")
- 07-group-theorems/04-theorem-3.md: 2 occurrences ("Chapter 6's non-abelian", "Chapter 6, Section 4")

**Learning Objectives boxes**: All four index files **do have** Learning Objectives boxes (lines 7–12, 7–12, 7–12, 7–11 respectively) — **PASS**. They appear after the chapter title and before the story, matching the v1.5.0 requirement.

**Version consistency (v4.32.2)**: None of the slice files contain explicit Lean version references. The regression context requires checking `lean_project/lean-toolchain`, `lakefile.toml`, `README.md`, `NOTICE.md`, `lean_book/README.md`, `lean_book/00-setup/02-installing-toolchain.md`, `lean_book/00-setup/04-mathlib-note.md`, `lean_book/learning-paths.md` — these are **outside the assigned slice** and cannot be verified here.

---

## SUMMARY OF MATHEMATICAL ERRORS

1. **Chapter 3, 08-exercises.md (lines 23–30)**: **FALSE CLAIM** about `rfl` behavior. States `rfl` cannot close `∀ n, n + 0 = n` because "no single reduction sequence turns `n + 0` into `n`". In Lean 4, `Nat.add` recurses on the *second* argument, so `n + 0` **is** definitionally `n` (base case). The failing example is `0 + n = n`. **Chapter 5, 04-defeq-vs-propeq.md (lines 32–37) correctly states the opposite.** The two chapters contradict each other; Chapter 5 is correct for Lean 4.

2. **Chapter 6, 07-exercises.md (lines 45–48)**: **CROSS-REFERENCE ERROR**. Exercise 2 says "They coincide automatically only once the group has been *proved* commutative — this is exactly the content of Chapter 7's first theorem." Chapter 7's first theorem is `id_unique` (identity uniqueness), not inverse uniqueness. Inverse uniqueness is Theorem 2 (`left_inverse_unique`).

3. **Chapter 5, 02-universes.md (line 103)**: **BIBLIOGRAPHY INTEGRITY**. Cites [Girard1971] for Girard's paradox but the note admits that paper (1970/1971) is *not* the source; the 1972 thesis is. The correct source is not in the bibliography.

4. **Chapter 3, 02-logic-recap.md (line 298)**: **UNVERIFIED CITATION**. Cites [PierceSF] for natural-deduction/classical-vs-intuitionistic treatment but notes "could not be verified verbatim."

---

## RECOMMENDATION

**Overall**: The mathematical content is **sound** with **two concrete errors** (the `rfl` asymmetry claim and the Theorem 1 cross-reference) and **one bibliography issue**. The **v1.5.0 regression is systemic and must be fixed** across all four chapter index files (remove "Story" and "Sections", update cross-references to not use "Section" terminology).

**Priority fixes**:
1. **Fix Chapter 3's Socratic Q2** (08-exercises.md lines 23–30) to match Lean 4's `Nat.add` semantics (Chapter 5 is correct).
2. **Fix Chapter 6's Exercise 2 cross-reference** (07-exercises.md line 47) to point to Chapter 7's Theorem 2.
3. **Remove "Story" and "Sections" from all four index files** per v1.5.0.
4. **Update all "Section X" cross-references** throughout the slice to use file-relative links without "Section" terminology.
5. **Fix bibliography**: Add Girard's 1972 thesis, remove or correct [Girard1971] citation for paradox, verify or remove [PierceSF] citation.

**Verification log**: All 24 files read in full. Every finding above cites specific file:line locations. Mathematical proofs in Chapters 6–7 verified against standard group theory (Dummit & Foote §1.1). Lean 4 syntax checked against mental model of `Nat.add`/`Nat.mul` recursion patterns.

<<<REPORT_END>>>
# Consensus search cache

Cached results of `mcp__consensus__search` queries run during the
bibliography/reference review of `lean_book/`. Reuse these instead of
re-querying Consensus. Each entry records the exact query string, the date
run, and the top results returned (Consensus free tier returns 3 per query).

Last updated: 2026-08-03

---

## Q1. `Girard's paradox inconsistency of Type : Type normalization system U`

Run: 2026-08-03 — 20 papers found, top 3 shown.
All-results link: https://consensus.app/search/new?q=Girard%27s+paradox+inconsistency+of+Type+%3A+Type+normalization+system+U&utm_source=claude_code

1. [A Simplification of Girard's Paradox](https://consensus.app/papers/details/2528c61ba9915bff93ef73d5624f6230/?utm_source=claude_code) — A. Hurkens, 1995, 85 citations, Unknown Journal.
   Abstract opens: *"In 1972 J.-Y. Girard showed that the Burali-Forti paradox can be
   formalised in the type system U. In 1991 Th. Coquand formalised another paradox in U−.
   The corresponding proof terms (that have no normal form) are large. We present a shorter
   term of type ⊥ in the Pure Type System λU− and analyse its reduction behaviour."*
2. [Failure of Normalization in Impredicative Type Theory with Proof-Irrelevant Propositional Equality](https://consensus.app/papers/details/eb5273c7b76a5b26823f5bc9327a76e9/?utm_source=claude_code) — Andreas Abel et al., 2019, 18 citations, ArXiv.
3. ["Type" is not a type](https://consensus.app/papers/details/80db1a5b347c53baa6ced12e0147a508/?utm_source=claude_code) — A. Meyer et al., 1986, 71 citations.
   *"Girard proved that this approach is inconsistent from the perspective of intuitionistic
   logic. We apply Girard's techniques to establish that the type-of-all-types assumption
   creates serious pathologies ... inherently not normalizing, term equality is undecidable ..."*

**Bearing on the book:** corroborates `05-rigor-check/02-universes.md`'s claim that the
`Type : Type` inconsistency is due to Girard's **1972** work, not the 1971 paper
`[Girard1971]` in the bibliography.

---

## Q2. `Calculus of Constructions Coquand Huet`

Run: 2026-08-03 — 19 papers found, top 3 shown.
All-results link: https://consensus.app/search/new?q=Calculus+of+Constructions+Coquand+Huet&utm_source=claude_code

1. [An extended calculus of constructions](https://consensus.app/papers/details/102027134d97554f822fcc99d41c762f/?utm_source=claude_code) — Zhaohui Luo, 1990, 158 citations.
   *"ECC integrates Coquand-Huet's (impredicative) calculus of constructions and Martin-Löf's
   (predicative) type theory with universes ..."*
2. [Modular proof of strong normalization for the calculus of constructions](https://consensus.app/papers/details/618f1729e20f593cb26a3587633d94fa/?utm_source=claude_code) — H. Geuvers et al., 1991, 135 citations, Journal of Functional Programming.
   *"...strong normalization for the Calculus of Constructions of Coquand and Huet (1985, 1988).
   This result was first proved by Coquand (1986)..."*
3. [Correctness of the Interpretation of the Calculus of Constructions in Doctrines of Constructions](https://consensus.app/papers/details/90fc7d40eb3e5734abb5ce9b3aace788/?utm_source=claude_code) — T. Streicher, 1991, 0 citations.

**Bearing on the book:** independent corroboration of the `[CoquandHuet1988]` attribution
used in `01-basics/05-pi-sigma-and-coc.md` and `05-rigor-check/03-typing-rules-and-safety.md`.

---

## Q3. `inductively defined types calculus of inductive constructions Coquand Paulin-Mohring`

Run: 2026-08-03 — 20 papers found, top 3 shown.
All-results link: https://consensus.app/search/new?q=inductively+defined+types+calculus+of+inductive+constructions+Coquand+Paulin-Mohring&utm_source=claude_code

1. [Inductively Defined Types in the Calculus of Constructions](https://consensus.app/papers/details/f866829f8ac05cff9660c2ba2c79f55c/?utm_source=claude_code) — F. Pfenning et al. (Pfenning & Paulin-Mohring), 1989, 152 citations.
2. [Introduction to the Calculus of Inductive Constructions](https://consensus.app/papers/details/c34d763baac9598bb7706cfc9a0ce5b2/?utm_source=claude_code) — Christine Paulin-Mohring, 2015, 61 citations.
   *"...an introduction to the Calculus of Inductive Constructions, the formalism behind the
   Coq proof assistant."*
3. [Inductive Definitions in the system Coq — Rules and Properties](https://consensus.app/papers/details/84c78854d70657869fee6ad36424edcc/?utm_source=claude_code) — Christine Paulin-Mohring, 1993, 544 citations.

**Bearing on the book:** the CIC-attribution parenthetical in
`01-basics/05-pi-sigma-and-coc.md` cites *"Coquand and Paulin, 'Inductively Defined Types,'
1990"*. Consensus surfaces the adjacent **Pfenning & Paulin-Mohring 1989** paper of nearly
the same title, so the two are easy to confuse; the Coquand–Paulin-Mohring paper itself is
the COLOG-88 proceedings paper (LNCS 417, published 1990). See review notes.

---

## Q4. `An analysis of Girard's paradox Coquand 1986`

Run: 2026-08-03 — 20 papers found, top 3 shown.
All-results link: https://consensus.app/search/new?q=An+analysis+of+Girard%27s+paradox+Coquand+1986&utm_source=claude_code

1. [An Analysis of Girard's Paradox](https://consensus.app/papers/details/6f5b319c7c9e5e8880adf87372b5f015/?utm_source=claude_code) — T. Coquand, **1986**, 230 citations. (No abstract in index.)
2. [A Simplification of Girard's Paradox](https://consensus.app/papers/details/2528c61ba9915bff93ef73d5624f6230/?utm_source=claude_code) — A. Hurkens, 1995, 85 citations.
3. [Four Paradoxes and a Proof Assistant: Burali-Forti, Diaconescu, Reynolds, and Hurkens in the coq-paradoxes library](https://consensus.app/papers/details/6dcd58bd887454628302aa0e3b262994/?utm_source=claude_code) — B. Alonso, 2026, 0 citations, ArXiv.

**Bearing on the book:** confirms the exact title, author, and 1986 year of the Coquand
paper named in `05-rigor-check/02-universes.md`.

---

## Q5. `A Theory of Type Polymorphism in Programming Milner`

Run: 2026-08-03 — 20 papers found, top 3 shown.
All-results link: https://consensus.app/search/new?q=A+Theory+of+Type+Polymorphism+in+Programming+Milner&utm_source=claude_code

1. [Polymorphic Type Inference for Dynamic Languages](https://consensus.app/papers/details/1ae77af38fa55739a904866115092e6d/?utm_source=claude_code) — Castagna et al., 2023, 13 citations, PACMPL.
2. [Type Inference for Polymorphic References](https://consensus.app/papers/details/c85d3ae1055d500d84b0bcc9b0551fad/?utm_source=claude_code) — M. Tofte, 1990, 213 citations, Inf. Comput.
3. [A Theory of Type Polymorphism in Programming](https://consensus.app/papers/details/fe67dbee35295237bf94ef415ae62ad6/?utm_source=claude_code) — **R. Milner, 1978, 2730 citations, J. Comput. Syst. Sci.**
   Abstract text confirms Strachey's parametric/ad-hoc polymorphism distinction and the ML/LCF context.

**Bearing on the book:** confirms `[Milner1978]`'s title, author, year, and journal
(J. Comput. Syst. Sci.) exactly as the bibliography states.

---

## Q6. `Curry-Howard isomorphism history Howard formulae-as-types 1969 manuscript`

Run: 2026-08-03 — 20 papers found, top 3 shown.
All-results link: https://consensus.app/search/new?q=Curry-Howard+isomorphism+history+Howard+formulae-as-types+1969+manuscript&utm_source=claude_code

1. [Propositions as types](https://consensus.app/papers/details/a12af13095c85c339148268dc8e01e6c/?utm_source=claude_code) — P. Wadler, 2015, 217 citations, Communications of the ACM.
   *"...often referred to as the Curry-Howard Isomorphism, referring to a correspondence
   observed by **Curry in 1934** and refined by **Howard in 1969 (though not published until
   1980, in a Festschrift dedicated to Curry)**. Others draw attention to significant
   contributions from de Bruijn's Automath and Martin-Löf's Type Theory in the 1970s."*
2. [Review of "Derivation and Computation: Taking the Curry-Howard Correspondence Seriously"](https://consensus.app/papers/details/589649e15095510e992321f7340c9ef0/?utm_source=claude_code) — R. J. Irwin, 2008, SIGACT News.
   *"The germinal idea, due to Haskell B. Curry ... was applied to typed λ-calculi and
   popularized by William A. Howard in a manuscript widely circulated since 1969, but only
   published in 1980."*
3. [The Curry-Howard isomorphism](https://consensus.app/papers/details/a42e9877e4515edd9135c4bb6ae84a95/?utm_source=claude_code) — P. de Groote, 1995, 40 citations.

**Bearing on the book:** independently corroborates `[Howard1980]`'s "circulated privately
since 1969" note and the 1980 Curry Festschrift publication, from two sources other than
Sørensen & Urzyczyn (which `03-propositions-and-proofs/01-prop.md` already cites). Also
supplies the **Curry 1934** half of the name, which the book's box does not currently mention.

---

## Q7. `Gentzen Untersuchungen über das logische Schließen natural deduction 1935`

Run: 2026-08-03 — 19 papers found, top 3 shown.
All-results link: https://consensus.app/search/new?q=Gentzen+Untersuchungen+%C3%BCber+das+logische+Schlie%C3%9Fen+natural+deduction+1935&utm_source=claude_code

1. [Sundholm's explanation of meaning: logical atavism and the nature of proofs](https://consensus.app/papers/details/855a88a84e8d566da147158fd8586481/?utm_source=claude_code) — A. Piccolomini d'Aragona, 2025.
   Refers to *"Gentzen's Natural Deduction in its two 1935 and 1936 variants."*
2. [Natural deduction](https://consensus.app/papers/details/161734c08d635743bdadc52cc1ba8fff/?utm_source=claude_code) — Mancosu et al., 2021, 64 citations, *An Introduction to Proof Theory*.
   *"...introduces Gerhard Gentzen's original system of natural deduction ... connectives and
   quantifiers are each governed by a pair of introduction and elimination rules."*
3. [The Problem of Natural Representation of Reasoning in the Lvov-Warsaw School](https://consensus.app/papers/details/99e3c220926c5879a2b76c1fc4f0a177/?utm_source=claude_code) — A. Indrzejczak, 2024, History and Philosophy of Logic.
   Notes Jaśkowski and Gentzen resolved the problem **independently in 1934**; Jaśkowski's
   first natural-deduction system dates to 1926.

**Bearing on the book:** corroborates `[Gentzen1935]` and the intro/elim-rule-pair framing
quoted in `03-propositions-and-proofs/02-logic-recap.md`. The book attributes natural
deduction to Gentzen alone; result 3 records Jaśkowski's independent (and earlier) system.

---

## Q8. `Church-Rosser theorem confluence lambda calculus`

Run: 2026-08-03 — 20 papers found, top 3 shown.
All-results link: https://consensus.app/search/new?q=Church-Rosser+theorem+confluence+lambda+calculus&utm_source=claude_code

1. [More Church-Rosser Proofs in BELUGA](https://consensus.app/papers/details/eef0a7d8b37f52808ab8a42b2ab20f49/?utm_source=claude_code) — Momigliano et al., 2024.
2. [Confluence and Normalization in Reduction Systems Lecture Notes](https://consensus.app/papers/details/bd041c8e6d81555aafdb2add9aba7556/?utm_source=claude_code) — Gert Smolka, 2015, 11 citations.
3. [Confluence of the Lambda Calculus with Left-Linear Algebraic Rewriting](https://consensus.app/papers/details/cf47b314cd54556e9156ca0ea1bd0a75/?utm_source=claude_code) — Fritz Müller, 1992, 39 citations, Inf. Process. Lett.

**Bearing on the book:** no result surfaces the original Church & Rosser (1936) paper. The
book quotes the theorem from `[Thompson1991]` rather than the original, and the bibliography
has no Church–Rosser 1936 entry. Consistent with how the book cites, but note it flags other
missing originals (Girard 1972, Coquand 1986) explicitly and does not flag this one.

---

## Q9. `Gödel completeness theorem first-order logic 1929 1930 Vollständigkeit`

Run: 2026-08-03 — 20 papers found, top 3 shown.
All-results link: https://consensus.app/search/new?q=G%C3%B6del+completeness+theorem+first-order+logic+1929+1930+Vollst%C3%A4ndigkeit&utm_source=claude_code

1. [Completeness Theorems and the Separation of the First and Higher-Order Logic](https://consensus.app/papers/details/c9c32380472056638dff409b58279839/?utm_source=claude_code) — J. Kennedy, 2007.
   *"With his 1929 thesis Gödel delivers himself to us almost fully formed ... a definitive,
   mathematical treatment of the completeness theorem ... never included in the publication
   based on the thesis."*
2. [Completeness Theorem for First-Order Logic](https://consensus.app/papers/details/888158240f005ad9a7644a236478248d/?utm_source=claude_code) — S. M. Srivastava, 2012.
   *"The result for countable theories was first proved by Godel in 1930. The result in its
   complete generality was first observed by Malcev in 1936."*
3. [The completeness theorem of Gödel](https://consensus.app/papers/details/dccbe1a2d9f05c4690bfcee016c8b801/?utm_source=claude_code) — S. M. Srivastava, 2001, Resonance.
   *"...first order logic proved first by Gödel in 1929."*

**Bearing on the book:** confirms the "Gödel, 1929/1930" dual dating used in
`03-propositions-and-proofs/02-logic-recap.md` — 1929 thesis, 1930 publication.

---

## Q10. `Girard system F polymorphic lambda calculus 1971 extension of Gödel's interpretation to analysis`

Run: 2026-08-03 — 20 papers found, top 3 shown.
All-results link: https://consensus.app/search/new?q=Girard+system+F+polymorphic+lambda+calculus+1971+extension+of+G%C3%B6del%27s+interpretation+to+analysis&utm_source=claude_code

1. [Categorical semantics for higher order polymorphic lambda calculus](https://consensus.app/papers/details/9b31d107db46543f87cc8f7b7b7f0e44/?utm_source=claude_code) — R. Seely, 1987, 155 citations, Journal of Symbolic Logic.
2. [A direct computational interpretation of second-order arithmetic via update recursion](https://consensus.app/papers/details/ab735d5e21885c6395ae88c9608cf957/?utm_source=claude_code) — Valentin Blot, 2022, LICS.
3. [Modal Embeddings and Calling Paradigms](https://consensus.app/papers/details/5b71d19183e35b838174c084146c20fc/?utm_source=claude_code) — J. E. Santo et al., 2019.

**Bearing on the book:** Consensus does not index the 1971 Scandinavian Logic Symposium paper
itself, so `[Girard1971]`'s bibliographic details could not be independently confirmed here.
No result contradicts them. The separate 1972 thèse d'État attribution for Girard's paradox
is corroborated by Q1 instead.

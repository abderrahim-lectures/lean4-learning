# Typesetting Audit Report — Lean for Working Algebraists

**Date:** 2026-08-03  
**Book version:** v1.5.1 (from preamble.tex `\bookversion`)  
**Engine:** XeTeX 3.141592653-2.6-0.999997 (TeX Live 2025/Debian)  
**PDF output:** `lean_book_latex/lean-for-working-algebraists.pdf` (4.0 MB, 255 pages)  
**log file:** `lean_book_latex/lean-for-working-algebraists.log` (3163 lines)

---

## Executive Summary

The PDF compiles successfully with XeTeX and produces a 255-page document with no fatal errors. However, the typesetting has **two critical rendering defects** (Infoview screenshot images overflowing the page width by 649pt), **seven infinite-glue-shrinkage page-breaking failures** that produce visually broken pages, and **196 overfull hbox warnings** (14 exceeding 50pt, the worst being the 537pt bibliography URL). Cross-references all resolve cleanly; the v1.5.0 learning-objectives boxes and "Story"/"Sections" removal are verified clean. The bibliography is misnumbered as "Chapter 14".

**Overall severity: HIGH** — the image and page-breaking issues are reader-visible defects in the rendered PDF.

---

## 1. latexmk Log Analysis

### 1.1 Summary Statistics

| Metric | Count |
|---|---|
| Overfull \hbox | 196 |
| Underfull \hbox | 15 |
| Underfull \vbox | 23 |
| Ignored errors (infinite glue shrinkage) | 7 |
| Float too large for page | 2 |
| Hyperref warnings (duplicate anchors) | 3 |
| Font substitution warnings | 2 |
| Undefined references (??) | 0 |
| Total pages | 255 |

### 1.2 Build Status

The `latexmk` run completed without fatal errors. Biber processed 28 citation keys with no warnings. The `.bcf` and `.bbl` files are up to date. No rerun is needed (`rerunfilecheck` reports the `.out` file has not changed).

---

## 2. CRITICAL Findings

### CRIT-1: Infoview Screenshot Images Overflow Page Width (649.7pt)

**Location:** Pages 83 (Ch. 4) and 240 (Ch. 11 solutions)  
**Evidence (log lines 1867–1872 and 2992–3005):**
```
Overfull \hbox (649.67743pt too wide) in paragraph at lines 47--48
 [][] 
 []
LaTeX Warning: Float too large for page by 29.9973pt on input line 49.
```
and
```
Overfull \hbox (649.67743pt too wide) in paragraph at lines 57--58
 [][] 
 []
LaTeX Warning: Float too large for page by 80.02203pt on input line 59.
```

**Description:** Two PNG screenshots of the Lean Infoview panel (`goal-state-infoview.png` and `append-nil-left-infoview.png`) are wrapped in `\pandocbounded{\includegraphics[keepaspectratio,...]{...}}` inside `figure` environments. The `\pandocbounded` command is a pass-through (`\providecommand{\pandocbounded}[1]{#1}`) — it does **not** constrain the image to `\textwidth`. The raw image width (approximately 650pt, far exceeding the 448pt text width) is placed at full size, causing a 649.7pt overflow. The first overflow produces a float that is 30pt too tall for the page; the second is 80pt too tall.

**Impact:** The images are rendered at native resolution and extend ~145% beyond the right margin. The second overflow (80pt too tall) causes content from the following section to be pushed to the next page, creating a large blank region.

**Fix:** Replace `\pandocbounded{\includegraphics[keepaspectratio,...]{...}}` with `\includegraphics[keepaspectratio,width=\textwidth]{...}` in both locations (`04-tactics/01-goal-state.tex:47` and `14-appendix-solutions/10-chapter-1.tex:57`), or redefine `\pandocbounded` to actually constrain width:
```latex
\renewcommand{\pandocbounded}[1]{\maxsizebox{\textwidth}{!}{#1}}
```

### CRIT-2: Bibliography URL Overflow (537.3pt)

**Location:** Page 250 (Bibliography chapter, entry for Church1941)  
**Evidence (log lines 3051–3057):**
```
Overfull \hbox (537.34871pt too wide) in paragraph at lines 3--3
\TU/TeXGyrePagella(0)/m/n/12 1941. \TU/TeXGyrePagella(0)/m/sc/12 url\TU/TeXGyre
Pagella(0)/m/n/12 : [][]$[][][][][] [] [] [] [][][][][][][] ...
```

**Description:** The `Church1941` bibliography entry contains an extremely long URL (`https://archive.org/details/AnnalsOfMathematicalStudies6ChurchAlonzoTheCalculiOfLambdaConversionPrincetonUniversityPress1941`) that BibLaTeX's `numeric` style renders inline without line-breaking. The URL alone is 537pt wider than the text width. Additional entries (Weibel1994, AssemSimsonSkowronski2006, DummitFoote2003) also have long URLs causing 16–54pt overflows in the same bibliography chapter.

**Impact:** The Church1941 entry's URL runs off the right edge of page 250, making it partially unreadable. The `url` field is rendered in small caps (`m/sc`) which compounds the visual break.

**Fix:** Add `\sloppy` to the bibliography chapter, or configure BibLaTeX to break URLs: `\appto{\bibsetup}{\sloppy}` in `preamble.tex`. Alternatively, add `\usepackage[hyphens]{url}` or configure `biblatex` with `urlbreak=auto`.

---

## 3. HIGH Findings

### HIGH-1: Seven Infinite Glue Shrinkage Errors

**Location:** Pages 23, 31, 42–43, 62–63, 245, 246, 249  
**Evidence (log lines 1469, 1587, 1612, 1762, 3022, 3030, 3034):**
```
ignored error: Infinite glue shrinkage found in box being split [23
ignored error: Infinite glue shrinkage found in box being split [31]
ignored error: Infinite glue shrinkage found in box being split [42] [43]
ignored error: Infinite glue shrinkage found in box being split [62] [63]
ignored error: Infinite glue shrinkage found in box being split [245
ignored error: Infinite glue shrinkage found in box being split [246])
ignored error: Infinite glue shrinkage found in box being split [249])
```

**Description:** TeX encountered content that could not be split across pages because the glue (stretchable space) had infinite shrinkage. This typically occurs inside unbreakable boxes (tcolorboxes, minipages inside longtable cells, or tall listing blocks) that are taller than the page. The error is "ignored" by XeTeX (it does not halt compilation), but the result is that the content is placed on the page at its natural height, potentially overlapping with footer/header content or spilling into the margin.

**Pages affected:**
- Page 23: `notation-reference.tex` (longtable with notation entries)
- Page 31: Near `diagrams/universal-property.tex` (tikz-cd diagram)
- Pages 42–43: `01-basics/05-pi-sigma-and-coc.tex` (heavy math content)
- Pages 62–63: `03-propositions-and-proofs/01-prop.tex` (content with theorem boxes)
- Pages 245–249: `tactic-and-library-reference.tex` and `lambda-calculus-dictionary.tex` (longtable reference pages)

**Impact:** These pages have uncontrolled vertical overflow. The visual result is content that may overlap with page decorations or extend beyond the bottom margin.

**Fix:** Ensure all tcolorbox environments inside longtable cells are `breakable`, and reduce the content density on the notation-reference and tactic-reference pages. For the lambda-calculus dictionary, consider splitting the longtable across more pages.

### HIGH-2: Massive Overfull Hboxes in Code-Heavy Paragraphs (>50pt)

**Location:** Throughout, concentrated in Chs. 1, 8, 9, 11, 13  
**Evidence:** 14 overfull hbox instances exceeding 50pt (log lines scattered throughout)

| Overfull (pt) | Location | Content |
|---|---|---|
| 143.1 | Ch. 13, lines 90–92 | Long Mathlib module path `Mathlib.CategoryTheory.Quiver` |
| 105.9 | Ch. 6 solutions, lines 106–1 | List of Mathlib lemma names |
| 90.3 | Ch. 13, lines 19–21 | `intGroup`/`boolXorGroup` in one paragraph |
| 87.7 | Ch. 13, lines 12–14 | `Mathlib.LinearAlgebra.*` wildcard |
| 70.1 | Ch. 9, lines 24–26 | `Rg.addGrp.toGroup.inv` nested field access |
| 68.7 | Ch. 1, lines 314–316 | `NatList = μX.Σ h: nil:Unit` |
| 62.9 | Ch. 6, lines 161–162 | Two `#eval` expressions side by side |
| 62.7 | Ch. 2, lines 85–87 | `Point3D.toPoint` function discussion |
| 59.8 | Ch. 11, lines 73–74 | `pathBetaAlphaViaAppend = pathBetaAlpha` |
| 52.0 | Ch. 1, lines 241–242 | `Nat.rec` peels off `5 = succ(...)` |

**Description:** Paragraphs containing long inline code identifiers (DejaVu Sans Mono at 12pt is wider than the proportional body font) are not breaking at natural word boundaries. The `listings` package `\lstinline` rendering within running text does not support line-breaking by default, and the `\allowbreak` inserted by `build_latex.py` only appears in some locations.

**Impact:** These 14 worst-case overflows extend 50–143pt beyond the right margin, making the affected text invisible in the PDF reader's default view and creating a ragged right edge.

**Fix:** 
1. In `preamble.tex`, add `\emergencystretch=3em` to allow TeX more flexibility in line-breaking.
2. In `build_latex.py`, ensure `\allowbreak` is inserted after every `_` and `.` in inline code, not just at selected points.
3. Consider using `\seqsplit` or manual `\linebreak[0]` for the worst offenders.

### HIGH-3: Bibliography Misnumbered as "Chapter 14"

**Location:** Page 250  
**Evidence (log line 3036):**
```
Chapter 14.
```

**Description:** `bibliography.tex` uses `\chapter{Bibliography}`, which increments the chapter counter. Since the last content chapter is Chapter 13, the bibliography becomes "Chapter 14". However, the table of contents and `\setcounter{chapter}{-1}` at the start of the main matter mean the bibliography is labeled as Chapter 14 in the running head and PDF bookmarks, despite not being a content chapter. The appendix solutions (Chapter 14 equivalent in the book's own numbering) are placed *before* the bibliography in the input order, so the appendix is numbered correctly but the bibliography inherits "Chapter 14" from LaTeX's counter.

**Impact:** Minor but confusing: the bibliography appears as "Chapter 14" in the PDF bookmarks and running headers, while the book's own Chapter 14 is the appendix solutions. This creates a numbering collision in the reader's mental model.

**Fix:** Use `\chapter*{Bibliography}` (unnumbered) and manually add it to the TOC, or use `\renewcommand{\thechapter}{}` before the bibliography chapter to suppress numbering.

---

## 4. MEDIUM Findings

### MED-1: 196 Total Overfull Hbox Warnings

**Location:** Throughout all chapters  
**Description:** Beyond the 14 severe cases (>50pt), there are 97 overfull hbox warnings exceeding 10pt and 85 between 0.1–10pt. The majority (estimated 60%+) involve inline code identifiers (DejaVu Sans Mono) that are wider than the column can accommodate without breaking.

**Impact:** Individual instances of 1–5pt overflow are barely noticeable in print but accumulate to create a visually uneven right margin throughout the book. The PDF viewer will clip content at the page edge for the worse cases.

### MED-2: Twelve Underfull vbox with Badness 10000

**Location:** Pages 5, 11, 19, 36, 55, 98, 107, 108, 152, 153, 180, 242  
**Description:** These pages have almost no content (badness 10000 = maximum underfull). They correspond to pages that are mostly blank due to float placement, chapter openings, or large unbreakable content blocks pushing content to the next page.

**Impact:** Visually jarring — the reader encounters pages that are almost entirely white space, sometimes two in a row (e.g., pages 107–108, 152–153).

### MED-3: Three Hyperref Duplicate-Anchor Warnings

**Location:** Log lines 1457, 1466, 3019  
**Evidence:**
```
Package hyperref Warning: The anchor of a bookmark and its parent's must not
(hyperref)                be the same. Added a new anchor on input line 8.
Package hyperref Warning: The anchor of a bookmark and its parent's must not
(hyperref)                be the same. Added a new anchor on input line 10.
Package hyperref Warning: The anchor of a bookmark and its parent's must not
(hyperref)                be the same. Added a new anchor on input line 18.
```

**Description:** Three sections have bookmark anchors that collide with their parent (chapter) anchor. This occurs in `learning-paths.tex` (line 8 and 10) and `tactic-and-library-reference.tex` (line 18). Hyperref silently adds new anchors to disambiguate, but the PDF bookmark tree may show duplicate or confusing entries.

**Impact:** The PDF reader's bookmark/outline panel may show slightly wrong destinations for these entries. Not a rendering defect but a navigational annoyance.

### MED-4: Font Substitution — DejaVu Sans Mono Missing Small Caps

**Location:** `01-basics/01-everything-has-a-type.tex` line 18  
**Evidence (log lines 1509–1510):**
```
LaTeX Font Warning: Font shape `TU/DejaVuSansMono(0)/m/sc' undefined
(Font)              using `TU/DejaVuSansMono(0)/m/n' instead on input line 18.
```

**Description:** DejaVu Sans Mono does not have a small-caps (`/m/sc`) variant. When the text requests small-caps in monospace (e.g., `\textsc` inside a code context), XeTeX falls back to regular-weight monospace. The bibliography also uses `/m/sc` for the "url" label (seen in the 537pt overflow line), so all bibliography URL labels render in regular monospace rather than small-caps.

**Impact:** Minor visual inconsistency — the "url" labels in bibliography entries and any in-text monospace small-caps will appear in regular weight, slightly larger than intended.

---

## 5. LOW Findings

### LOW-1: Cleveref "First Aid" Applied

**Location:** Log line 1093  
**Description:** `cleveref.sty` requires the LaTeX team's "First Aid" patch to work correctly with the current kernel. The patch was applied successfully. This is informational and does not affect output.

### LOW-2: Listings "First Aid" No Longer Applied

**Location:** Log line 698  
**Description:** The log reports that the `listings` First Aid is no longer needed because the installed version (1.11b, 2025/11/14) is newer than the version the patch was written for (1.10c). This is expected and benign.

### LOW-3: tcblistingsutf8 Compatibility Note

**Location:** Log line 1206  
**Description:** `tcblistingsutf8` is loaded but noted as "compatible with pdftex only" under XeTeX. The `listings` library is loaded instead. This is handled automatically and does not affect output.

### LOW-4: pdfcol Interface Disabled

**Location:** Log line 1178  
**Description:** `pdfcol.sty` reports its interface is disabled because XeTeX does not use pdfTeX's color stacks. This is expected under XeTeX and does not affect tcolorbox rendering.

### LOW-5: Cover/Back-Cover Images Detected as "bmp"

**Location:** Log lines 1383, 3133  
**Description:** XeTeX reports the cover and back-cover PNG files as "type bmp" — this is the XeTeX driver's generic label for bitmap images, not an actual BMP format issue. The files are valid PNGs and render correctly.

---

## 6. v1.5.0 Regression Check

### 6.1 Learning Objectives Boxes

**Status: PASS** — All 15 chapter index files (00-setup through 14-appendix-solutions) contain `\begin{learningobjectives}...\end{learningobjectives}` blocks immediately after the `\chapter{}` command. The `learningobjectives` tcolorbox environment is defined in `preamble.tex:196–200` with the expected styling (RoyalBlue, breakable, titled "Learning objectives"). The box rendered on page 112 (Ch. 5 checkpoint) shows "Learning objectives" text, confirming the tcolorbox renders correctly.

### 6.2 Removal of "Story" and "Sections" Sections

**Status: PASS** — Grep of all `.tex` files found zero occurrences of standalone "Story" or "Sections" section headings. The word "story" appears only in natural-language prose (e.g., "the second half of the dependent-types story" in `01-basics/03-dependent-types.tex:42`), not as a section label. The word "Sections" appears only in cross-references (e.g., "Sections 4–5" in checkpoint project descriptions), not as removed scaffolding.

### 6.3 Broken Cross-References to Removed Content

**Status: PASS** — The `.aux` file contains zero `??` entries. All `\label`/`\ref` and `\cref`/`\hyperref` pairs resolve correctly. No "Reference `...' on page N undefined" warnings appear in the log.

### 6.4 Artifacts from Removed Scaffolding

**Status: PASS** — No orphaned `\section*{}` commands, no empty `.toc` entries for removed sections, no dangling `\label`s without corresponding content.

---

## 7. Summary of Recommendations (Priority Order)

1. **CRIT-1 (Image overflow):** Constrain `\includegraphics` to `\textwidth` in both figure environments, or redefine `\pandocbounded` — **estimated effort: 10 minutes**
2. **CRIT-2 (Bibliography URL overflow):** Add `\sloppy` to bibliography setup or configure URL line-breaking — **estimated effort: 10 minutes**
3. **HIGH-1 (Infinite glue shrinkage):** Review longtable content density and ensure tcolorboxes are breakable inside table cells — **estimated effort: 1–2 hours**
4. **HIGH-2 (Overfull code paragraphs):** Add `\emergencystretch=3em` and audit `\allowbreak` insertion in `build_latex.py` — **estimated effort: 1 hour**
5. **HIGH-3 (Bibliography numbering):** Switch to `\chapter*{Bibliography}` with manual TOC entry — **estimated effort: 5 minutes**
6. **MED-3 (Hyperref anchors):** Investigate and fix the three duplicate-anchor locations — **estimated effort: 15 minutes**

---

*Report generated by adversarial typesetting reviewer (mimo-v2.5-free).*

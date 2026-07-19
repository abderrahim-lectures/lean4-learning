## Chapter 11: Quivers and path algebras

[← Chapter 10](09-chapter-10.md) | [Index](00-index.md)

---

**1. Adding a cycle**

<p><a href="https://live.lean-lang.org/#code=inductive%20CyclicArrow%20where%0A%20%20%7C%20alpha%20%3A%20CyclicArrow%20%20%20--%200%20%E2%86%92%201%0A%20%20%7C%20beta%20%3A%20CyclicArrow%20%20%20%20%20--%201%20%E2%86%92%202%0A%20%20%7C%20gamma%20%3A%20CyclicArrow%20%20%20%20--%202%20%E2%86%92%200%0A%0Adef%20cyclicQuiver%20%3A%20Quiver%20%28Fin%203%29%20CyclicArrow%20where%0A%20%20source%20%3A%3D%20fun%20a%20%3D%3E%20match%20a%20with%0A%20%20%20%20%7C%20CyclicArrow.alpha%20%3D%3E%200%0A%20%20%20%20%7C%20CyclicArrow.beta%20%3D%3E%201%0A%20%20%20%20%7C%20CyclicArrow.gamma%20%3D%3E%202%0A%20%20target%20%3A%3D%20fun%20a%20%3D%3E%20match%20a%20with%0A%20%20%20%20%7C%20CyclicArrow.alpha%20%3D%3E%201%0A%20%20%20%20%7C%20CyclicArrow.beta%20%3D%3E%202%0A%20%20%20%20%7C%20CyclicArrow.gamma%20%3D%3E%200%0A%0Adef%20cPathAlpha%20%3A%20Path%20cyclicQuiver%200%201%20%3A%3D%0A%20%20Path.cons%20CyclicArrow.alpha%20rfl%20rfl%20%28Path.nil%200%29%0A%0Adef%20cPathBetaAlpha%20%3A%20Path%20cyclicQuiver%200%202%20%3A%3D%0A%20%20Path.cons%20CyclicArrow.beta%20rfl%20rfl%20cPathAlpha%0A%0Adef%20cPathGammaBetaAlpha%20%3A%20Path%20cyclicQuiver%200%200%20%3A%3D%0A%20%20Path.cons%20CyclicArrow.gamma%20rfl%20rfl%20cPathBetaAlpha" target="_blank" rel="noopener">&#8599; Open in Lean playground (new tab)</a></p>
<iframe src="https://live.lean-lang.org/#code=inductive%20CyclicArrow%20where%0A%20%20%7C%20alpha%20%3A%20CyclicArrow%20%20%20--%200%20%E2%86%92%201%0A%20%20%7C%20beta%20%3A%20CyclicArrow%20%20%20%20%20--%201%20%E2%86%92%202%0A%20%20%7C%20gamma%20%3A%20CyclicArrow%20%20%20%20--%202%20%E2%86%92%200%0A%0Adef%20cyclicQuiver%20%3A%20Quiver%20%28Fin%203%29%20CyclicArrow%20where%0A%20%20source%20%3A%3D%20fun%20a%20%3D%3E%20match%20a%20with%0A%20%20%20%20%7C%20CyclicArrow.alpha%20%3D%3E%200%0A%20%20%20%20%7C%20CyclicArrow.beta%20%3D%3E%201%0A%20%20%20%20%7C%20CyclicArrow.gamma%20%3D%3E%202%0A%20%20target%20%3A%3D%20fun%20a%20%3D%3E%20match%20a%20with%0A%20%20%20%20%7C%20CyclicArrow.alpha%20%3D%3E%201%0A%20%20%20%20%7C%20CyclicArrow.beta%20%3D%3E%202%0A%20%20%20%20%7C%20CyclicArrow.gamma%20%3D%3E%200%0A%0Adef%20cPathAlpha%20%3A%20Path%20cyclicQuiver%200%201%20%3A%3D%0A%20%20Path.cons%20CyclicArrow.alpha%20rfl%20rfl%20%28Path.nil%200%29%0A%0Adef%20cPathBetaAlpha%20%3A%20Path%20cyclicQuiver%200%202%20%3A%3D%0A%20%20Path.cons%20CyclicArrow.beta%20rfl%20rfl%20cPathAlpha%0A%0Adef%20cPathGammaBetaAlpha%20%3A%20Path%20cyclicQuiver%200%200%20%3A%3D%0A%20%20Path.cons%20CyclicArrow.gamma%20rfl%20rfl%20cPathBetaAlpha" title="Lean playground" loading="lazy" style="width:100%;height:497px;border:1px solid #ccc;border-radius:8px;">
</iframe>

Each [`rfl`](https://lean-lang.org/doc/reference/latest/Tactic-Proofs/Tactic-Reference/) again discharges a source/target proof obligation that reduces,
by definition, from the `match` in `cyclicQuiver`. Observe that
`cPathGammaBetaAlpha` is a nontrivial loop at vertex `0`. The path
algebra of a quiver with cycles has elements of arbitrarily high "length,"
which is exactly why such algebras are usually infinite-dimensional unless
relations (an "admissible ideal") are imposed on the path algebra.

**2. `theorem append_nil_left`**

<p><a href="https://live.lean-lang.org/#code=theorem%20append_nil_left%20%7BV%20A%20%3A%20Type%7D%20%7BQ%20%3A%20Quiver%20V%20A%7D%20%7Bu%20v%20%3A%20V%7D%20%28p%20%3A%20Path%20Q%20u%20v%29%20%3A%0A%20%20%20%20Path.append%20%28Path.nil%20u%29%20p%20%3D%20p%20%3A%3D%20by%0A%20%20induction%20p%20with%0A%20%20%7C%20nil%20%3D%3E%0A%20%20%20%20--%20Goal%3A%20Path.append%20%28Path.nil%20u%29%20%28Path.nil%20u%29%20%3D%20Path.nil%20u%0A%20%20%20%20--%20%28%60nil%60%27s%20case%20binds%20no%20fresh%20variable%20here%20%E2%80%94%20the%20vertex%20is%20already%0A%20%20%20%20--%20fixed%20by%20p%27s%20own%20type%20%E2%80%94%20so%20there%20is%20nothing%20to%20name.%29%0A%20%20%20%20--%20Path.append%20unfolds%20on%20its%20second%20argument%20being%20%60nil%60%2C%20giving%0A%20%20%20%20--%20%60Path.nil%20u%60%20on%20the%20nose.%0A%20%20%20%20rfl%0A%20%20%7C%20cons%20a%20h%20h%27%20q%27%20ih%20%3D%3E%0A%20%20%20%20--%20ih%20%3A%20Path.append%20%28Path.nil%20u%29%20q%27%20%3D%20q%27%0A%20%20%20%20--%20Goal%3A%20Path.append%20%28Path.nil%20u%29%20%28Path.cons%20a%20h%20h%27%20q%27%29%20%3D%20Path.cons%20a%20h%20h%27%20q%27%0A%20%20%20%20show%20Path.cons%20a%20h%20h%27%20%28Path.append%20%28Path.nil%20u%29%20q%27%29%20%3D%20Path.cons%20a%20h%20h%27%20q%27%0A%20%20%20%20rw%20%5Bih%5D" target="_blank" rel="noopener">&#8599; Open in Lean playground (new tab)</a></p>
<iframe src="https://live.lean-lang.org/#code=theorem%20append_nil_left%20%7BV%20A%20%3A%20Type%7D%20%7BQ%20%3A%20Quiver%20V%20A%7D%20%7Bu%20v%20%3A%20V%7D%20%28p%20%3A%20Path%20Q%20u%20v%29%20%3A%0A%20%20%20%20Path.append%20%28Path.nil%20u%29%20p%20%3D%20p%20%3A%3D%20by%0A%20%20induction%20p%20with%0A%20%20%7C%20nil%20%3D%3E%0A%20%20%20%20--%20Goal%3A%20Path.append%20%28Path.nil%20u%29%20%28Path.nil%20u%29%20%3D%20Path.nil%20u%0A%20%20%20%20--%20%28%60nil%60%27s%20case%20binds%20no%20fresh%20variable%20here%20%E2%80%94%20the%20vertex%20is%20already%0A%20%20%20%20--%20fixed%20by%20p%27s%20own%20type%20%E2%80%94%20so%20there%20is%20nothing%20to%20name.%29%0A%20%20%20%20--%20Path.append%20unfolds%20on%20its%20second%20argument%20being%20%60nil%60%2C%20giving%0A%20%20%20%20--%20%60Path.nil%20u%60%20on%20the%20nose.%0A%20%20%20%20rfl%0A%20%20%7C%20cons%20a%20h%20h%27%20q%27%20ih%20%3D%3E%0A%20%20%20%20--%20ih%20%3A%20Path.append%20%28Path.nil%20u%29%20q%27%20%3D%20q%27%0A%20%20%20%20--%20Goal%3A%20Path.append%20%28Path.nil%20u%29%20%28Path.cons%20a%20h%20h%27%20q%27%29%20%3D%20Path.cons%20a%20h%20h%27%20q%27%0A%20%20%20%20show%20Path.cons%20a%20h%20h%27%20%28Path.append%20%28Path.nil%20u%29%20q%27%29%20%3D%20Path.cons%20a%20h%20h%27%20q%27%0A%20%20%20%20rw%20%5Bih%5D" title="Lean playground" loading="lazy" style="width:100%;height:345px;border:1px solid #ccc;border-radius:8px;">
</iframe>

This is exactly what the editor shows in the `cons` case: the Lean
Infoview lists every hypothesis the pattern match introduces —
`Q : Quiver V A`, `h : Q.source a = v`, `h' : Q.target a = wt`,
`q' : Path Q u vt`, and the induction hypothesis
`ih : (Path.nil u).append q' = q'` — above the line, with the goal
`(Path.nil u).append (Path.cons a h h' q') = Path.cons a h h' q'` below
it:

![The Lean Infoview panel in VS Code, showing the tactic state for the `cons` case of `append_nil_left`'s induction: hypotheses `V A : Type`, `Q : Quiver V A`, `u v vt wt : V`, `a : A`, `h : Q.source a = v`, `h' : Q.target a = wt`, `q' : Path Q u vt`, `ih : (Path.nil u).append q' = q'`, and the goal `(Path.nil u).append (Path.cons a h h' q') = Path.cons a h h' q'`.](../11-path-algebras/images/append-nil-left-infoview.png)

This mirrors `Path.append`'s own recursion, case for case. `Path.append`
was defined by matching on its second argument, so `induction p` (which
splits into cases on exactly that argument, generating the matching
induction hypothesis `ih` in the `cons` case) unfolds the definition
directly. In the `nil` case, both sides are `Path.nil u` by definition. In
the `cons` case, unfolding `Path.append`'s defining equation turns the goal
into `Path.cons a h h' (Path.append (Path.nil u) q') = Path.cons a h h' q'`
(the [`show`](https://lean-lang.org/doc/reference/latest/Tactic-Proofs/Tactic-Reference/) line makes this explicit rather than leaving it to
elaboration), and `rw [ih]` completes the proof using the induction
hypothesis.

**3. Sketch of `PathAlgebra`**

<p><a href="https://live.lean-lang.org/#code=--%20A%20k-linear%20combination%20of%20paths%20from%20u%20to%20v%2C%20as%20a%20finitely-supported%0A--%20function%20from%20paths%20to%20coefficients.%20%60Finsupp%60-style%20support%20tracking%20is%0A--%20the%20honest%20way%20to%20do%20this%3B%20a%20simplified%20sketch%3A%0Astructure%20PathAlgebraElem%20%28V%20A%20%3A%20Type%29%20%28Q%20%3A%20Quiver%20V%20A%29%20%28k%20%3A%20Type%29%20where%0A%20%20--%20coeff%20p%20%3D%20the%20coefficient%20of%20path%20p%2C%20for%20finitely%20many%20nonzero%20p%0A%20%20coeff%20%3A%20%7Bu%20v%20%3A%20V%7D%20%E2%86%92%20Path%20Q%20u%20v%20%E2%86%92%20k%0A%20%20--%20%28a%20finiteness%2Fsupport%20condition%20would%20be%20required%20here%20in%20a%20full%0A%20%20--%20development%2C%20e.g.%20via%20Mathlib%27s%20%60Finsupp%60%29%0A%0A--%20To%20satisfy%20%60Ring%60%20%28Chapter%208%29%2C%20%60PathAlgebraElem%60%20would%20need%3A%0A--%20%20%20addGrp%20%3A%20CommGroup%20%28PathAlgebraElem%20V%20A%20Q%20k%29%20%20%20--%20pointwise%20addition%20of%20coefficients%0A--%20%20%20mul%20%20%20%20%3A%20concatenate%20paths%2C%20multiplying%20and%20summing%20coefficients%20over%0A--%20%20%20%20%20%20%20%20%20%20%20%20all%20ways%20two%20paths%20compose%20%28zero%20when%20endpoints%20don%27t%20match%29%0A--%20%20%20one%20%20%20%20%3A%20the%20sum%2C%20over%20all%20vertices%20v%2C%20of%201%20%C2%B7%20%28trivial%20path%20at%20v%29%0A--%20%20%20%20%20%20%20%20%20%20%20%20%28an%20idempotent%20identity%2C%20since%20Q%20may%20have%20infinitely%20many%0A--%20%20%20%20%20%20%20%20%20%20%20%20vertices%20this%20%22one%22%20is%20only%20literally%20an%20element%20when%20Q0%20is%0A--%20%20%20%20%20%20%20%20%20%20%20%20finite%20%E2%80%94%20for%20infinite%20Q%20the%20path%20algebra%20is%20typically%20only%0A--%20%20%20%20%20%20%20%20%20%20%20%20a%20%22ring%20with%20local%20units%2C%22%20a%20subtlety%20Mathlib%27s%20category-%0A--%20%20%20%20%20%20%20%20%20%20%20%20theoretic%20treatment%20handles%20more%20gracefully%20than%20a%20bare%20Ring%29" target="_blank" rel="noopener">&#8599; Open in Lean playground (new tab)</a></p>
<iframe src="https://live.lean-lang.org/#code=--%20A%20k-linear%20combination%20of%20paths%20from%20u%20to%20v%2C%20as%20a%20finitely-supported%0A--%20function%20from%20paths%20to%20coefficients.%20%60Finsupp%60-style%20support%20tracking%20is%0A--%20the%20honest%20way%20to%20do%20this%3B%20a%20simplified%20sketch%3A%0Astructure%20PathAlgebraElem%20%28V%20A%20%3A%20Type%29%20%28Q%20%3A%20Quiver%20V%20A%29%20%28k%20%3A%20Type%29%20where%0A%20%20--%20coeff%20p%20%3D%20the%20coefficient%20of%20path%20p%2C%20for%20finitely%20many%20nonzero%20p%0A%20%20coeff%20%3A%20%7Bu%20v%20%3A%20V%7D%20%E2%86%92%20Path%20Q%20u%20v%20%E2%86%92%20k%0A%20%20--%20%28a%20finiteness%2Fsupport%20condition%20would%20be%20required%20here%20in%20a%20full%0A%20%20--%20development%2C%20e.g.%20via%20Mathlib%27s%20%60Finsupp%60%29%0A%0A--%20To%20satisfy%20%60Ring%60%20%28Chapter%208%29%2C%20%60PathAlgebraElem%60%20would%20need%3A%0A--%20%20%20addGrp%20%3A%20CommGroup%20%28PathAlgebraElem%20V%20A%20Q%20k%29%20%20%20--%20pointwise%20addition%20of%20coefficients%0A--%20%20%20mul%20%20%20%20%3A%20concatenate%20paths%2C%20multiplying%20and%20summing%20coefficients%20over%0A--%20%20%20%20%20%20%20%20%20%20%20%20all%20ways%20two%20paths%20compose%20%28zero%20when%20endpoints%20don%27t%20match%29%0A--%20%20%20one%20%20%20%20%3A%20the%20sum%2C%20over%20all%20vertices%20v%2C%20of%201%20%C2%B7%20%28trivial%20path%20at%20v%29%0A--%20%20%20%20%20%20%20%20%20%20%20%20%28an%20idempotent%20identity%2C%20since%20Q%20may%20have%20infinitely%20many%0A--%20%20%20%20%20%20%20%20%20%20%20%20vertices%20this%20%22one%22%20is%20only%20literally%20an%20element%20when%20Q0%20is%0A--%20%20%20%20%20%20%20%20%20%20%20%20finite%20%E2%80%94%20for%20infinite%20Q%20the%20path%20algebra%20is%20typically%20only%0A--%20%20%20%20%20%20%20%20%20%20%20%20a%20%22ring%20with%20local%20units%2C%22%20a%20subtlety%20Mathlib%27s%20category-%0A--%20%20%20%20%20%20%20%20%20%20%20%20theoretic%20treatment%20handles%20more%20gracefully%20than%20a%20bare%20Ring%29" title="Lean playground" loading="lazy" style="width:100%;height:421px;border:1px solid #ccc;border-radius:8px;">
</iframe>

The real finiteness/support bookkeeping (tracking which paths have nonzero
coefficient) is exactly what makes a full formalization a genuine project
rather than a one-page exercise. This sketch identifies the three `Ring`
fields that require it (`addGrp`, `mul`, `one`), and shows why `one` is the
subtle one when $Q_0$ is infinite.

**Checkpoint project: path length, and composition respects it**

<p><a href="https://live.lean-lang.org/#code=def%20Path.length%20%7BV%20A%20%3A%20Type%7D%20%7BQ%20%3A%20Quiver%20V%20A%7D%20%3A%20%7Bu%20v%20%3A%20V%7D%20%E2%86%92%20Path%20Q%20u%20v%20%E2%86%92%20Nat%0A%20%20%7C%20_%2C%20_%2C%20Path.nil%20_%20%3D%3E%200%0A%20%20%7C%20_%2C%20_%2C%20Path.cons%20_%20_%20_%20p%20%3D%3E%20p.length%20%2B%201%0A%0Atheorem%20Path.append_length%20%7BV%20A%20%3A%20Type%7D%20%7BQ%20%3A%20Quiver%20V%20A%7D%20%7Bu%20v%20w%20%3A%20V%7D%0A%20%20%20%20%28p%20%3A%20Path%20Q%20u%20v%29%20%28q%20%3A%20Path%20Q%20v%20w%29%20%3A%0A%20%20%20%20%28Path.append%20p%20q%29.length%20%3D%20p.length%20%2B%20q.length%20%3A%3D%20by%0A%20%20induction%20q%20with%0A%20%20%7C%20nil%20%3D%3E%0A%20%20%20%20simp%20only%20%5BPath.append%2C%20Path.length%5D%0A%20%20%20%20rw%20%5BNat.add_zero%5D%0A%20%20%7C%20cons%20a%20h%20h%27%20q%27%20ih%20%3D%3E%0A%20%20%20%20simp%20only%20%5BPath.append%2C%20Path.length%5D%0A%20%20%20%20rw%20%5Bih%2C%20Nat.add_assoc%5D%0A%0Aexample%20%3A%20%28Path.append%20pathAlpha%20pathBetaOnly%29.length%20%3D%0A%20%20%20%20pathAlpha.length%20%2B%20pathBetaOnly.length%20%3A%3D%0A%20%20Path.append_length%20pathAlpha%20pathBetaOnly%0A%0A%23eval%20pathAlpha.length%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20--%201%0A%23eval%20pathBetaAlpha.length%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20--%202%0A%23eval%20%28Path.append%20pathAlpha%20pathBetaOnly%29.length%20%20%20%20%20%20%20%20%20%20--%202" target="_blank" rel="noopener">&#8599; Open in Lean playground (new tab)</a></p>
<iframe src="https://live.lean-lang.org/#code=def%20Path.length%20%7BV%20A%20%3A%20Type%7D%20%7BQ%20%3A%20Quiver%20V%20A%7D%20%3A%20%7Bu%20v%20%3A%20V%7D%20%E2%86%92%20Path%20Q%20u%20v%20%E2%86%92%20Nat%0A%20%20%7C%20_%2C%20_%2C%20Path.nil%20_%20%3D%3E%200%0A%20%20%7C%20_%2C%20_%2C%20Path.cons%20_%20_%20_%20p%20%3D%3E%20p.length%20%2B%201%0A%0Atheorem%20Path.append_length%20%7BV%20A%20%3A%20Type%7D%20%7BQ%20%3A%20Quiver%20V%20A%7D%20%7Bu%20v%20w%20%3A%20V%7D%0A%20%20%20%20%28p%20%3A%20Path%20Q%20u%20v%29%20%28q%20%3A%20Path%20Q%20v%20w%29%20%3A%0A%20%20%20%20%28Path.append%20p%20q%29.length%20%3D%20p.length%20%2B%20q.length%20%3A%3D%20by%0A%20%20induction%20q%20with%0A%20%20%7C%20nil%20%3D%3E%0A%20%20%20%20simp%20only%20%5BPath.append%2C%20Path.length%5D%0A%20%20%20%20rw%20%5BNat.add_zero%5D%0A%20%20%7C%20cons%20a%20h%20h%27%20q%27%20ih%20%3D%3E%0A%20%20%20%20simp%20only%20%5BPath.append%2C%20Path.length%5D%0A%20%20%20%20rw%20%5Bih%2C%20Nat.add_assoc%5D%0A%0Aexample%20%3A%20%28Path.append%20pathAlpha%20pathBetaOnly%29.length%20%3D%0A%20%20%20%20pathAlpha.length%20%2B%20pathBetaOnly.length%20%3A%3D%0A%20%20Path.append_length%20pathAlpha%20pathBetaOnly%0A%0A%23eval%20pathAlpha.length%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20--%201%0A%23eval%20pathBetaAlpha.length%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20--%202%0A%23eval%20%28Path.append%20pathAlpha%20pathBetaOnly%29.length%20%20%20%20%20%20%20%20%20%20--%202" title="Lean playground" loading="lazy" style="width:100%;height:478px;border:1px solid #ccc;border-radius:8px;">
</iframe>

`Path.length` recurses on the same two constructors as `Path.append`
itself (§4–§5): `nil` contributes `0`, and each `cons` adds one to the
length of the shorter path it extends. The proof of `append_length`
mirrors `Path.append`'s own recursion case for case, exactly as the
project asked, but with one genuine surprise if `rfl` is tried first in
either case: it fails. `Path` is *indexed* by both endpoints. Because of
this, Lean compiles a match on an indexed family so that its defining
equations reduce only through their auto-generated equation lemmas, not
through plain iota-reduction, once an abstract path (`p`, `q'`) is
involved. Concrete, fully closed paths like `pathAlpha` still reduce fine
under `#eval` — that is why the three checks above work directly. But the
*general*, universally-quantified theorem does not close by `rfl`.
`simp only [Path.append, Path.length]` names exactly the two
definitions being unfolded and nothing else, so it plays the same explicit
role a `rw` would if these equations were reachable that way — it is not
standing in for an unknown pile of simp lemmas, only for the two named
here. This is the same kind of real, verified obstacle Chapter 6 §4's
`Perm3.ext` ran into with core Lean's lack of a `structure`
extensionality lemma, now met again with indexed recursion instead.

---

[← Chapter 10](09-chapter-10.md) | [Index](00-index.md) | [Table of contents](../README.md)

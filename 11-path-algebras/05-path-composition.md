## Path composition

[← Paths as an inductive type](04-paths-as-inductive-type.md) | [Index](00-index.md) | [Next: Exercises →](06-exercises.md)

---

Given a path `p : Path Q u v` and a path `q : Path Q v w`, they can be concatenated
into a path `Path Q u w`, defined by recursion on `q`:

<p><a href="https://live.lean-lang.org/#code=structure%20Quiver%20%28V%20%3A%20Type%29%20%28A%20%3A%20Type%29%20where%0A%20%20source%20%3A%20A%20%E2%86%92%20V%0A%20%20target%20%3A%20A%20%E2%86%92%20V%0A%0Ainductive%20ExampleArrow%20where%0A%20%20%7C%20alpha%20%3A%20ExampleArrow%20%20%20--%200%20%E2%86%92%201%0A%20%20%7C%20beta%20%3A%20ExampleArrow%20%20%20%20%20--%201%20%E2%86%92%202%0A%0Adef%20exampleQuiver%20%3A%20Quiver%20%28Fin%203%29%20ExampleArrow%20where%0A%20%20source%20%3A%3D%20fun%20a%20%3D%3E%20match%20a%20with%0A%20%20%20%20%7C%20ExampleArrow.alpha%20%3D%3E%200%0A%20%20%20%20%7C%20ExampleArrow.beta%20%3D%3E%201%0A%20%20target%20%3A%3D%20fun%20a%20%3D%3E%20match%20a%20with%0A%20%20%20%20%7C%20ExampleArrow.alpha%20%3D%3E%201%0A%20%20%20%20%7C%20ExampleArrow.beta%20%3D%3E%202%0A%0Ainductive%20Path%20%7BV%20A%20%3A%20Type%7D%20%28Q%20%3A%20Quiver%20V%20A%29%20%3A%20V%20%E2%86%92%20V%20%E2%86%92%20Type%20where%0A%20%20%7C%20nil%20%28v%20%3A%20V%29%20%3A%20Path%20Q%20v%20v%0A%20%20%7C%20cons%20%7Bu%20v%20w%20%3A%20V%7D%20%28a%20%3A%20A%29%20%28h%20%3A%20Q.source%20a%20%3D%20v%29%20%28h%27%20%3A%20Q.target%20a%20%3D%20w%29%0A%20%20%20%20%20%20%28p%20%3A%20Path%20Q%20u%20v%29%20%3A%20Path%20Q%20u%20w%0A%0Adef%20pathAlpha%20%3A%20Path%20exampleQuiver%200%201%20%3A%3D%0A%20%20Path.cons%20ExampleArrow.alpha%20rfl%20rfl%20%28Path.nil%200%29%0A%0Adef%20pathBetaAlpha%20%3A%20Path%20exampleQuiver%200%202%20%3A%3D%0A%20%20Path.cons%20ExampleArrow.beta%20rfl%20rfl%20pathAlpha%0A%0Adef%20Path.append%20%7BV%20A%20%3A%20Type%7D%20%7BQ%20%3A%20Quiver%20V%20A%7D%20%7Bu%20v%20w%20%3A%20V%7D%0A%20%20%20%20%28p%20%3A%20Path%20Q%20u%20v%29%20%28q%20%3A%20Path%20Q%20v%20w%29%20%3A%20Path%20Q%20u%20w%20%3A%3D%0A%20%20match%20q%20with%0A%20%20%7C%20Path.nil%20_%20%3D%3E%20p%0A%20%20%7C%20Path.cons%20a%20h%20h%27%20q%27%20%3D%3E%20Path.cons%20a%20h%20h%27%20%28Path.append%20p%20q%27%29" target="_blank" rel="noopener">&#8599; Open in Lean playground (new tab)</a></p>
<iframe src="https://live.lean-lang.org/#code=structure%20Quiver%20%28V%20%3A%20Type%29%20%28A%20%3A%20Type%29%20where%0A%20%20source%20%3A%20A%20%E2%86%92%20V%0A%20%20target%20%3A%20A%20%E2%86%92%20V%0A%0Ainductive%20ExampleArrow%20where%0A%20%20%7C%20alpha%20%3A%20ExampleArrow%20%20%20--%200%20%E2%86%92%201%0A%20%20%7C%20beta%20%3A%20ExampleArrow%20%20%20%20%20--%201%20%E2%86%92%202%0A%0Adef%20exampleQuiver%20%3A%20Quiver%20%28Fin%203%29%20ExampleArrow%20where%0A%20%20source%20%3A%3D%20fun%20a%20%3D%3E%20match%20a%20with%0A%20%20%20%20%7C%20ExampleArrow.alpha%20%3D%3E%200%0A%20%20%20%20%7C%20ExampleArrow.beta%20%3D%3E%201%0A%20%20target%20%3A%3D%20fun%20a%20%3D%3E%20match%20a%20with%0A%20%20%20%20%7C%20ExampleArrow.alpha%20%3D%3E%201%0A%20%20%20%20%7C%20ExampleArrow.beta%20%3D%3E%202%0A%0Ainductive%20Path%20%7BV%20A%20%3A%20Type%7D%20%28Q%20%3A%20Quiver%20V%20A%29%20%3A%20V%20%E2%86%92%20V%20%E2%86%92%20Type%20where%0A%20%20%7C%20nil%20%28v%20%3A%20V%29%20%3A%20Path%20Q%20v%20v%0A%20%20%7C%20cons%20%7Bu%20v%20w%20%3A%20V%7D%20%28a%20%3A%20A%29%20%28h%20%3A%20Q.source%20a%20%3D%20v%29%20%28h%27%20%3A%20Q.target%20a%20%3D%20w%29%0A%20%20%20%20%20%20%28p%20%3A%20Path%20Q%20u%20v%29%20%3A%20Path%20Q%20u%20w%0A%0Adef%20pathAlpha%20%3A%20Path%20exampleQuiver%200%201%20%3A%3D%0A%20%20Path.cons%20ExampleArrow.alpha%20rfl%20rfl%20%28Path.nil%200%29%0A%0Adef%20pathBetaAlpha%20%3A%20Path%20exampleQuiver%200%202%20%3A%3D%0A%20%20Path.cons%20ExampleArrow.beta%20rfl%20rfl%20pathAlpha%0A%0Adef%20Path.append%20%7BV%20A%20%3A%20Type%7D%20%7BQ%20%3A%20Quiver%20V%20A%7D%20%7Bu%20v%20w%20%3A%20V%7D%0A%20%20%20%20%28p%20%3A%20Path%20Q%20u%20v%29%20%28q%20%3A%20Path%20Q%20v%20w%29%20%3A%20Path%20Q%20u%20w%20%3A%3D%0A%20%20match%20q%20with%0A%20%20%7C%20Path.nil%20_%20%3D%3E%20p%0A%20%20%7C%20Path.cons%20a%20h%20h%27%20q%27%20%3D%3E%20Path.cons%20a%20h%20h%27%20%28Path.append%20p%20q%27%29" title="Lean playground" loading="lazy" style="width:100%;height:180px;border:1px solid #ccc;border-radius:8px;">
</iframe>

Reading the recursion:

- If `q` is trivial (`Path.nil _`, a path of length zero from `v` to `v`),
  then appending `p` before it just gives back `p` itself (there is nothing
  to append).
- If `q` ends with an arrow `a` (i.e. `q = Path.cons a h h' q'` for some
  shorter path `q'`), then appending `p` before all of `q` is the same as
  appending `p` before the shorter `q'`, and then re-attaching the same
  final arrow `a` on top.

This recursion terminates because each recursive call is on the strictly
shorter path `q'`. This is the same structural recursion principle behind
the `induction` tactic from Chapter 4.

### A worked instance: rebuilding `pathBetaAlpha` via `append`

The previous section built `pathBetaAlpha : Path exampleQuiver 0 2`
directly, one `Path.cons` at a time. Here it is again, built instead by
*composing* the shorter path `pathAlpha` with a fresh one-arrow path using
`Path.append`. Both constructions produce the exact same path.

<p><a href="https://live.lean-lang.org/#code=structure%20Quiver%20%28V%20%3A%20Type%29%20%28A%20%3A%20Type%29%20where%0A%20%20source%20%3A%20A%20%E2%86%92%20V%0A%20%20target%20%3A%20A%20%E2%86%92%20V%0A%0Ainductive%20ExampleArrow%20where%0A%20%20%7C%20alpha%20%3A%20ExampleArrow%20%20%20--%200%20%E2%86%92%201%0A%20%20%7C%20beta%20%3A%20ExampleArrow%20%20%20%20%20--%201%20%E2%86%92%202%0A%0Adef%20exampleQuiver%20%3A%20Quiver%20%28Fin%203%29%20ExampleArrow%20where%0A%20%20source%20%3A%3D%20fun%20a%20%3D%3E%20match%20a%20with%0A%20%20%20%20%7C%20ExampleArrow.alpha%20%3D%3E%200%0A%20%20%20%20%7C%20ExampleArrow.beta%20%3D%3E%201%0A%20%20target%20%3A%3D%20fun%20a%20%3D%3E%20match%20a%20with%0A%20%20%20%20%7C%20ExampleArrow.alpha%20%3D%3E%201%0A%20%20%20%20%7C%20ExampleArrow.beta%20%3D%3E%202%0A%0Ainductive%20Path%20%7BV%20A%20%3A%20Type%7D%20%28Q%20%3A%20Quiver%20V%20A%29%20%3A%20V%20%E2%86%92%20V%20%E2%86%92%20Type%20where%0A%20%20%7C%20nil%20%28v%20%3A%20V%29%20%3A%20Path%20Q%20v%20v%0A%20%20%7C%20cons%20%7Bu%20v%20w%20%3A%20V%7D%20%28a%20%3A%20A%29%20%28h%20%3A%20Q.source%20a%20%3D%20v%29%20%28h%27%20%3A%20Q.target%20a%20%3D%20w%29%0A%20%20%20%20%20%20%28p%20%3A%20Path%20Q%20u%20v%29%20%3A%20Path%20Q%20u%20w%0A%0Adef%20pathAlpha%20%3A%20Path%20exampleQuiver%200%201%20%3A%3D%0A%20%20Path.cons%20ExampleArrow.alpha%20rfl%20rfl%20%28Path.nil%200%29%0A%0Adef%20pathBetaAlpha%20%3A%20Path%20exampleQuiver%200%202%20%3A%3D%0A%20%20Path.cons%20ExampleArrow.beta%20rfl%20rfl%20pathAlpha%0A%0Adef%20Path.append%20%7BV%20A%20%3A%20Type%7D%20%7BQ%20%3A%20Quiver%20V%20A%7D%20%7Bu%20v%20w%20%3A%20V%7D%0A%20%20%20%20%28p%20%3A%20Path%20Q%20u%20v%29%20%28q%20%3A%20Path%20Q%20v%20w%29%20%3A%20Path%20Q%20u%20w%20%3A%3D%0A%20%20match%20q%20with%0A%20%20%7C%20Path.nil%20_%20%3D%3E%20p%0A%20%20%7C%20Path.cons%20a%20h%20h%27%20q%27%20%3D%3E%20Path.cons%20a%20h%20h%27%20%28Path.append%20p%20q%27%29%0A%0A--%20A%20worked%20instance%3A%20rebuilding%20pathBetaAlpha%20via%20append%2C%20and%20confirming%0A--%20both%20constructions%20agree%20definitionally.%0Adef%20pathBetaOnly%20%3A%20Path%20exampleQuiver%201%202%20%3A%3D%0A%20%20Path.cons%20ExampleArrow.beta%20rfl%20rfl%20%28Path.nil%201%29" target="_blank" rel="noopener">&#8599; Open in Lean playground (new tab)</a></p>
<iframe src="https://live.lean-lang.org/#code=structure%20Quiver%20%28V%20%3A%20Type%29%20%28A%20%3A%20Type%29%20where%0A%20%20source%20%3A%20A%20%E2%86%92%20V%0A%20%20target%20%3A%20A%20%E2%86%92%20V%0A%0Ainductive%20ExampleArrow%20where%0A%20%20%7C%20alpha%20%3A%20ExampleArrow%20%20%20--%200%20%E2%86%92%201%0A%20%20%7C%20beta%20%3A%20ExampleArrow%20%20%20%20%20--%201%20%E2%86%92%202%0A%0Adef%20exampleQuiver%20%3A%20Quiver%20%28Fin%203%29%20ExampleArrow%20where%0A%20%20source%20%3A%3D%20fun%20a%20%3D%3E%20match%20a%20with%0A%20%20%20%20%7C%20ExampleArrow.alpha%20%3D%3E%200%0A%20%20%20%20%7C%20ExampleArrow.beta%20%3D%3E%201%0A%20%20target%20%3A%3D%20fun%20a%20%3D%3E%20match%20a%20with%0A%20%20%20%20%7C%20ExampleArrow.alpha%20%3D%3E%201%0A%20%20%20%20%7C%20ExampleArrow.beta%20%3D%3E%202%0A%0Ainductive%20Path%20%7BV%20A%20%3A%20Type%7D%20%28Q%20%3A%20Quiver%20V%20A%29%20%3A%20V%20%E2%86%92%20V%20%E2%86%92%20Type%20where%0A%20%20%7C%20nil%20%28v%20%3A%20V%29%20%3A%20Path%20Q%20v%20v%0A%20%20%7C%20cons%20%7Bu%20v%20w%20%3A%20V%7D%20%28a%20%3A%20A%29%20%28h%20%3A%20Q.source%20a%20%3D%20v%29%20%28h%27%20%3A%20Q.target%20a%20%3D%20w%29%0A%20%20%20%20%20%20%28p%20%3A%20Path%20Q%20u%20v%29%20%3A%20Path%20Q%20u%20w%0A%0Adef%20pathAlpha%20%3A%20Path%20exampleQuiver%200%201%20%3A%3D%0A%20%20Path.cons%20ExampleArrow.alpha%20rfl%20rfl%20%28Path.nil%200%29%0A%0Adef%20pathBetaAlpha%20%3A%20Path%20exampleQuiver%200%202%20%3A%3D%0A%20%20Path.cons%20ExampleArrow.beta%20rfl%20rfl%20pathAlpha%0A%0Adef%20Path.append%20%7BV%20A%20%3A%20Type%7D%20%7BQ%20%3A%20Quiver%20V%20A%7D%20%7Bu%20v%20w%20%3A%20V%7D%0A%20%20%20%20%28p%20%3A%20Path%20Q%20u%20v%29%20%28q%20%3A%20Path%20Q%20v%20w%29%20%3A%20Path%20Q%20u%20w%20%3A%3D%0A%20%20match%20q%20with%0A%20%20%7C%20Path.nil%20_%20%3D%3E%20p%0A%20%20%7C%20Path.cons%20a%20h%20h%27%20q%27%20%3D%3E%20Path.cons%20a%20h%20h%27%20%28Path.append%20p%20q%27%29%0A%0A--%20A%20worked%20instance%3A%20rebuilding%20pathBetaAlpha%20via%20append%2C%20and%20confirming%0A--%20both%20constructions%20agree%20definitionally.%0Adef%20pathBetaOnly%20%3A%20Path%20exampleQuiver%201%202%20%3A%3D%0A%20%20Path.cons%20ExampleArrow.beta%20rfl%20rfl%20%28Path.nil%201%29" title="Lean playground" loading="lazy" style="width:100%;height:180px;border:1px solid #ccc;border-radius:8px;">
</iframe>

`pathBetaOnly` is that fresh one-arrow path: a path from `1` to `2`
consisting of just the single arrow `beta`, built on its own rather than
by extending `pathAlpha`.

<p><a href="https://live.lean-lang.org/#code=structure%20Quiver%20%28V%20%3A%20Type%29%20%28A%20%3A%20Type%29%20where%0A%20%20source%20%3A%20A%20%E2%86%92%20V%0A%20%20target%20%3A%20A%20%E2%86%92%20V%0A%0Ainductive%20ExampleArrow%20where%0A%20%20%7C%20alpha%20%3A%20ExampleArrow%20%20%20--%200%20%E2%86%92%201%0A%20%20%7C%20beta%20%3A%20ExampleArrow%20%20%20%20%20--%201%20%E2%86%92%202%0A%0Adef%20exampleQuiver%20%3A%20Quiver%20%28Fin%203%29%20ExampleArrow%20where%0A%20%20source%20%3A%3D%20fun%20a%20%3D%3E%20match%20a%20with%0A%20%20%20%20%7C%20ExampleArrow.alpha%20%3D%3E%200%0A%20%20%20%20%7C%20ExampleArrow.beta%20%3D%3E%201%0A%20%20target%20%3A%3D%20fun%20a%20%3D%3E%20match%20a%20with%0A%20%20%20%20%7C%20ExampleArrow.alpha%20%3D%3E%201%0A%20%20%20%20%7C%20ExampleArrow.beta%20%3D%3E%202%0A%0Ainductive%20Path%20%7BV%20A%20%3A%20Type%7D%20%28Q%20%3A%20Quiver%20V%20A%29%20%3A%20V%20%E2%86%92%20V%20%E2%86%92%20Type%20where%0A%20%20%7C%20nil%20%28v%20%3A%20V%29%20%3A%20Path%20Q%20v%20v%0A%20%20%7C%20cons%20%7Bu%20v%20w%20%3A%20V%7D%20%28a%20%3A%20A%29%20%28h%20%3A%20Q.source%20a%20%3D%20v%29%20%28h%27%20%3A%20Q.target%20a%20%3D%20w%29%0A%20%20%20%20%20%20%28p%20%3A%20Path%20Q%20u%20v%29%20%3A%20Path%20Q%20u%20w%0A%0Adef%20pathAlpha%20%3A%20Path%20exampleQuiver%200%201%20%3A%3D%0A%20%20Path.cons%20ExampleArrow.alpha%20rfl%20rfl%20%28Path.nil%200%29%0A%0Adef%20pathBetaAlpha%20%3A%20Path%20exampleQuiver%200%202%20%3A%3D%0A%20%20Path.cons%20ExampleArrow.beta%20rfl%20rfl%20pathAlpha%0A%0Adef%20Path.append%20%7BV%20A%20%3A%20Type%7D%20%7BQ%20%3A%20Quiver%20V%20A%7D%20%7Bu%20v%20w%20%3A%20V%7D%0A%20%20%20%20%28p%20%3A%20Path%20Q%20u%20v%29%20%28q%20%3A%20Path%20Q%20v%20w%29%20%3A%20Path%20Q%20u%20w%20%3A%3D%0A%20%20match%20q%20with%0A%20%20%7C%20Path.nil%20_%20%3D%3E%20p%0A%20%20%7C%20Path.cons%20a%20h%20h%27%20q%27%20%3D%3E%20Path.cons%20a%20h%20h%27%20%28Path.append%20p%20q%27%29%0A%0A--%20A%20worked%20instance%3A%20rebuilding%20pathBetaAlpha%20via%20append%2C%20and%20confirming%0A--%20both%20constructions%20agree%20definitionally.%0Adef%20pathBetaOnly%20%3A%20Path%20exampleQuiver%201%202%20%3A%3D%0A%20%20Path.cons%20ExampleArrow.beta%20rfl%20rfl%20%28Path.nil%201%29%0A%0Adef%20pathBetaAlphaViaAppend%20%3A%20Path%20exampleQuiver%200%202%20%3A%3D%0A%20%20Path.append%20pathAlpha%20pathBetaOnly" target="_blank" rel="noopener">&#8599; Open in Lean playground (new tab)</a></p>
<iframe src="https://live.lean-lang.org/#code=structure%20Quiver%20%28V%20%3A%20Type%29%20%28A%20%3A%20Type%29%20where%0A%20%20source%20%3A%20A%20%E2%86%92%20V%0A%20%20target%20%3A%20A%20%E2%86%92%20V%0A%0Ainductive%20ExampleArrow%20where%0A%20%20%7C%20alpha%20%3A%20ExampleArrow%20%20%20--%200%20%E2%86%92%201%0A%20%20%7C%20beta%20%3A%20ExampleArrow%20%20%20%20%20--%201%20%E2%86%92%202%0A%0Adef%20exampleQuiver%20%3A%20Quiver%20%28Fin%203%29%20ExampleArrow%20where%0A%20%20source%20%3A%3D%20fun%20a%20%3D%3E%20match%20a%20with%0A%20%20%20%20%7C%20ExampleArrow.alpha%20%3D%3E%200%0A%20%20%20%20%7C%20ExampleArrow.beta%20%3D%3E%201%0A%20%20target%20%3A%3D%20fun%20a%20%3D%3E%20match%20a%20with%0A%20%20%20%20%7C%20ExampleArrow.alpha%20%3D%3E%201%0A%20%20%20%20%7C%20ExampleArrow.beta%20%3D%3E%202%0A%0Ainductive%20Path%20%7BV%20A%20%3A%20Type%7D%20%28Q%20%3A%20Quiver%20V%20A%29%20%3A%20V%20%E2%86%92%20V%20%E2%86%92%20Type%20where%0A%20%20%7C%20nil%20%28v%20%3A%20V%29%20%3A%20Path%20Q%20v%20v%0A%20%20%7C%20cons%20%7Bu%20v%20w%20%3A%20V%7D%20%28a%20%3A%20A%29%20%28h%20%3A%20Q.source%20a%20%3D%20v%29%20%28h%27%20%3A%20Q.target%20a%20%3D%20w%29%0A%20%20%20%20%20%20%28p%20%3A%20Path%20Q%20u%20v%29%20%3A%20Path%20Q%20u%20w%0A%0Adef%20pathAlpha%20%3A%20Path%20exampleQuiver%200%201%20%3A%3D%0A%20%20Path.cons%20ExampleArrow.alpha%20rfl%20rfl%20%28Path.nil%200%29%0A%0Adef%20pathBetaAlpha%20%3A%20Path%20exampleQuiver%200%202%20%3A%3D%0A%20%20Path.cons%20ExampleArrow.beta%20rfl%20rfl%20pathAlpha%0A%0Adef%20Path.append%20%7BV%20A%20%3A%20Type%7D%20%7BQ%20%3A%20Quiver%20V%20A%7D%20%7Bu%20v%20w%20%3A%20V%7D%0A%20%20%20%20%28p%20%3A%20Path%20Q%20u%20v%29%20%28q%20%3A%20Path%20Q%20v%20w%29%20%3A%20Path%20Q%20u%20w%20%3A%3D%0A%20%20match%20q%20with%0A%20%20%7C%20Path.nil%20_%20%3D%3E%20p%0A%20%20%7C%20Path.cons%20a%20h%20h%27%20q%27%20%3D%3E%20Path.cons%20a%20h%20h%27%20%28Path.append%20p%20q%27%29%0A%0A--%20A%20worked%20instance%3A%20rebuilding%20pathBetaAlpha%20via%20append%2C%20and%20confirming%0A--%20both%20constructions%20agree%20definitionally.%0Adef%20pathBetaOnly%20%3A%20Path%20exampleQuiver%201%202%20%3A%3D%0A%20%20Path.cons%20ExampleArrow.beta%20rfl%20rfl%20%28Path.nil%201%29%0A%0Adef%20pathBetaAlphaViaAppend%20%3A%20Path%20exampleQuiver%200%202%20%3A%3D%0A%20%20Path.append%20pathAlpha%20pathBetaOnly" title="Lean playground" loading="lazy" style="width:100%;height:180px;border:1px solid #ccc;border-radius:8px;">
</iframe>

`pathBetaAlphaViaAppend` composes the shorter path `pathAlpha` with
`pathBetaOnly` via `Path.append`, yielding a path from `0` to `2`. This has
the same endpoints as `pathBetaAlpha`, but is assembled by composition
rather than by chaining `Path.cons` calls directly.

<p><a href="https://live.lean-lang.org/#code=structure%20Quiver%20%28V%20%3A%20Type%29%20%28A%20%3A%20Type%29%20where%0A%20%20source%20%3A%20A%20%E2%86%92%20V%0A%20%20target%20%3A%20A%20%E2%86%92%20V%0A%0Ainductive%20ExampleArrow%20where%0A%20%20%7C%20alpha%20%3A%20ExampleArrow%20%20%20--%200%20%E2%86%92%201%0A%20%20%7C%20beta%20%3A%20ExampleArrow%20%20%20%20%20--%201%20%E2%86%92%202%0A%0Adef%20exampleQuiver%20%3A%20Quiver%20%28Fin%203%29%20ExampleArrow%20where%0A%20%20source%20%3A%3D%20fun%20a%20%3D%3E%20match%20a%20with%0A%20%20%20%20%7C%20ExampleArrow.alpha%20%3D%3E%200%0A%20%20%20%20%7C%20ExampleArrow.beta%20%3D%3E%201%0A%20%20target%20%3A%3D%20fun%20a%20%3D%3E%20match%20a%20with%0A%20%20%20%20%7C%20ExampleArrow.alpha%20%3D%3E%201%0A%20%20%20%20%7C%20ExampleArrow.beta%20%3D%3E%202%0A%0Ainductive%20Path%20%7BV%20A%20%3A%20Type%7D%20%28Q%20%3A%20Quiver%20V%20A%29%20%3A%20V%20%E2%86%92%20V%20%E2%86%92%20Type%20where%0A%20%20%7C%20nil%20%28v%20%3A%20V%29%20%3A%20Path%20Q%20v%20v%0A%20%20%7C%20cons%20%7Bu%20v%20w%20%3A%20V%7D%20%28a%20%3A%20A%29%20%28h%20%3A%20Q.source%20a%20%3D%20v%29%20%28h%27%20%3A%20Q.target%20a%20%3D%20w%29%0A%20%20%20%20%20%20%28p%20%3A%20Path%20Q%20u%20v%29%20%3A%20Path%20Q%20u%20w%0A%0Adef%20pathAlpha%20%3A%20Path%20exampleQuiver%200%201%20%3A%3D%0A%20%20Path.cons%20ExampleArrow.alpha%20rfl%20rfl%20%28Path.nil%200%29%0A%0Adef%20pathBetaAlpha%20%3A%20Path%20exampleQuiver%200%202%20%3A%3D%0A%20%20Path.cons%20ExampleArrow.beta%20rfl%20rfl%20pathAlpha%0A%0Adef%20Path.append%20%7BV%20A%20%3A%20Type%7D%20%7BQ%20%3A%20Quiver%20V%20A%7D%20%7Bu%20v%20w%20%3A%20V%7D%0A%20%20%20%20%28p%20%3A%20Path%20Q%20u%20v%29%20%28q%20%3A%20Path%20Q%20v%20w%29%20%3A%20Path%20Q%20u%20w%20%3A%3D%0A%20%20match%20q%20with%0A%20%20%7C%20Path.nil%20_%20%3D%3E%20p%0A%20%20%7C%20Path.cons%20a%20h%20h%27%20q%27%20%3D%3E%20Path.cons%20a%20h%20h%27%20%28Path.append%20p%20q%27%29%0A%0A--%20A%20worked%20instance%3A%20rebuilding%20pathBetaAlpha%20via%20append%2C%20and%20confirming%0A--%20both%20constructions%20agree%20definitionally.%0Adef%20pathBetaOnly%20%3A%20Path%20exampleQuiver%201%202%20%3A%3D%0A%20%20Path.cons%20ExampleArrow.beta%20rfl%20rfl%20%28Path.nil%201%29%0A%0Adef%20pathBetaAlphaViaAppend%20%3A%20Path%20exampleQuiver%200%202%20%3A%3D%0A%20%20Path.append%20pathAlpha%20pathBetaOnly%0A%0Aexample%20%3A%20pathBetaAlphaViaAppend%20%3D%20pathBetaAlpha%20%3A%3D%20rfl" target="_blank" rel="noopener">&#8599; Open in Lean playground (new tab)</a></p>
<iframe src="https://live.lean-lang.org/#code=structure%20Quiver%20%28V%20%3A%20Type%29%20%28A%20%3A%20Type%29%20where%0A%20%20source%20%3A%20A%20%E2%86%92%20V%0A%20%20target%20%3A%20A%20%E2%86%92%20V%0A%0Ainductive%20ExampleArrow%20where%0A%20%20%7C%20alpha%20%3A%20ExampleArrow%20%20%20--%200%20%E2%86%92%201%0A%20%20%7C%20beta%20%3A%20ExampleArrow%20%20%20%20%20--%201%20%E2%86%92%202%0A%0Adef%20exampleQuiver%20%3A%20Quiver%20%28Fin%203%29%20ExampleArrow%20where%0A%20%20source%20%3A%3D%20fun%20a%20%3D%3E%20match%20a%20with%0A%20%20%20%20%7C%20ExampleArrow.alpha%20%3D%3E%200%0A%20%20%20%20%7C%20ExampleArrow.beta%20%3D%3E%201%0A%20%20target%20%3A%3D%20fun%20a%20%3D%3E%20match%20a%20with%0A%20%20%20%20%7C%20ExampleArrow.alpha%20%3D%3E%201%0A%20%20%20%20%7C%20ExampleArrow.beta%20%3D%3E%202%0A%0Ainductive%20Path%20%7BV%20A%20%3A%20Type%7D%20%28Q%20%3A%20Quiver%20V%20A%29%20%3A%20V%20%E2%86%92%20V%20%E2%86%92%20Type%20where%0A%20%20%7C%20nil%20%28v%20%3A%20V%29%20%3A%20Path%20Q%20v%20v%0A%20%20%7C%20cons%20%7Bu%20v%20w%20%3A%20V%7D%20%28a%20%3A%20A%29%20%28h%20%3A%20Q.source%20a%20%3D%20v%29%20%28h%27%20%3A%20Q.target%20a%20%3D%20w%29%0A%20%20%20%20%20%20%28p%20%3A%20Path%20Q%20u%20v%29%20%3A%20Path%20Q%20u%20w%0A%0Adef%20pathAlpha%20%3A%20Path%20exampleQuiver%200%201%20%3A%3D%0A%20%20Path.cons%20ExampleArrow.alpha%20rfl%20rfl%20%28Path.nil%200%29%0A%0Adef%20pathBetaAlpha%20%3A%20Path%20exampleQuiver%200%202%20%3A%3D%0A%20%20Path.cons%20ExampleArrow.beta%20rfl%20rfl%20pathAlpha%0A%0Adef%20Path.append%20%7BV%20A%20%3A%20Type%7D%20%7BQ%20%3A%20Quiver%20V%20A%7D%20%7Bu%20v%20w%20%3A%20V%7D%0A%20%20%20%20%28p%20%3A%20Path%20Q%20u%20v%29%20%28q%20%3A%20Path%20Q%20v%20w%29%20%3A%20Path%20Q%20u%20w%20%3A%3D%0A%20%20match%20q%20with%0A%20%20%7C%20Path.nil%20_%20%3D%3E%20p%0A%20%20%7C%20Path.cons%20a%20h%20h%27%20q%27%20%3D%3E%20Path.cons%20a%20h%20h%27%20%28Path.append%20p%20q%27%29%0A%0A--%20A%20worked%20instance%3A%20rebuilding%20pathBetaAlpha%20via%20append%2C%20and%20confirming%0A--%20both%20constructions%20agree%20definitionally.%0Adef%20pathBetaOnly%20%3A%20Path%20exampleQuiver%201%202%20%3A%3D%0A%20%20Path.cons%20ExampleArrow.beta%20rfl%20rfl%20%28Path.nil%201%29%0A%0Adef%20pathBetaAlphaViaAppend%20%3A%20Path%20exampleQuiver%200%202%20%3A%3D%0A%20%20Path.append%20pathAlpha%20pathBetaOnly%0A%0Aexample%20%3A%20pathBetaAlphaViaAppend%20%3D%20pathBetaAlpha%20%3A%3D%20rfl" title="Lean playground" loading="lazy" style="width:100%;height:180px;border:1px solid #ccc;border-radius:8px;">
</iframe>

That final `rfl` is not a weak or approximate check. It says the two
constructions are *definitionally* the same term, reducing to an
identical normal form (Chapter 5), not merely "provably equal after some
argument." This is the concrete payoff of `Path.append`'s recursive
definition: composing paths built independently, via arbitrarily different
routes, agrees exactly with building the composite path directly by hand,
because both ultimately unfold to the same sequence of `Path.cons`
applications.

**Mathematical reading.** `Path.append` is **composition in the free
category** $\mathrm{Free}(Q)$, written throughout this section in *path
order*: "$p$ then $q$," matching the argument order of `Path.append p q`.
This is not the function-composition order $q \circ p$ standard in
category theory texts. The two conventions denote the same composite;
only the order in which the symbols are written differs. Mixing them
mid-explanation is a common source of confusion, so this book fixes path
order throughout. In path order, `Path.append` is the map

$$
\mathrm{Hom}(u,v) \times \mathrm{Hom}(v,w) \longrightarrow \mathrm{Hom}(u,w),
\qquad (p, q) \longmapsto p\,;\,q
$$

(the semicolon "$;$" is a common notation for path-order composition,
distinguishing it from function-order $\circ$). The identity laws, stated
in path order: `Path.append p (Path.nil v) = p` (appending the trivial
path *after* `p` changes nothing; this case is implemented directly by the
`nil` branch of the `match` above, since recursion is on `q`), and,
separately, `Path.append (Path.nil u) p = p` (appending the trivial path
*before* `p` also changes nothing; proved as Exercise 2 by induction on
`p`, since the `nil` branch alone does not give this one for free). The
`cons` case of the recursion is exactly associativity of concatenation.
Together with `nil` as identities, this makes $\mathrm{Free}(Q)$ a genuine
category: the smallest/most general category containing $Q$'s arrows, in
the sense of a
[universal property](../01-basics/04-terminology.md#category-theory-terms-used-beyond-the-baseline).

**Mathlib equivalent.** `Path.append` is already in Mathlib, as
`Quiver.Path.comp`. It is the same recursion (on the *second* path), with
the same "`nil` does nothing, `cons` re-attaches its trailing arrow" shape:

<p><a href="https://live.lean-lang.org/#code=import%20Mathlib%0A%0Adef%20pathBetaOnly%27%20%3A%20Quiver.Path%20%281%20%3A%20Fin%203%29%202%20%3A%3D%20Quiver.Path.cons%20Quiver.Path.nil%20MyArrow.beta%0Adef%20pathBetaAlphaViaComp%27%20%3A%20Quiver.Path%20%280%20%3A%20Fin%203%29%202%20%3A%3D%20Quiver.Path.comp%20pathAlpha%27%20pathBetaOnly%27%0A%0Aexample%20%3A%20pathBetaAlphaViaComp%27%20%3D%20pathBetaAlpha%27%20%3A%3D%20rfl" target="_blank" rel="noopener">&#8599; Open in Lean playground (new tab)</a></p>
<iframe src="https://live.lean-lang.org/#code=import%20Mathlib%0A%0Adef%20pathBetaOnly%27%20%3A%20Quiver.Path%20%281%20%3A%20Fin%203%29%202%20%3A%3D%20Quiver.Path.cons%20Quiver.Path.nil%20MyArrow.beta%0Adef%20pathBetaAlphaViaComp%27%20%3A%20Quiver.Path%20%280%20%3A%20Fin%203%29%202%20%3A%3D%20Quiver.Path.comp%20pathAlpha%27%20pathBetaOnly%27%0A%0Aexample%20%3A%20pathBetaAlphaViaComp%27%20%3D%20pathBetaAlpha%27%20%3A%3D%20rfl" title="Lean playground" loading="lazy" style="width:100%;height:180px;border:1px solid #ccc;border-radius:8px;">
</iframe>

This is the same closing `rfl` as the book's
`pathBetaAlphaViaAppend = pathBetaAlpha` check: two paths built via
different routes (direct `cons`-chaining versus composing two shorter
paths) reduce to the identical term, because `Quiver.Path.comp` unfolds to
exactly the same sequence of `cons` applications `Path.append` does.

### The path algebra

The **path algebra** $kQ$ of a quiver $Q$ over a field (or ring) $k$ is the
ring whose elements are $k$-linear combinations of paths in $Q$, with
multiplication given by path composition (composing two paths whose
endpoints do not match gives $0$). Formalizing $kQ$ fully (as a `Ring`, per
Chapter 8) requires "formal sums of paths with ring coefficients," which is
a genuinely bigger construction: essentially a finitely-supported function
from paths to $k$. It is a natural next project once the material above is
well understood. This chapter stops at "paths and their composition"
because that data (the *category* of paths, really) is the essential
content of the construction; once it is in place, the ring structure on
top is routine to add.

**Mathematical reading.** The **path algebra** $kQ$ is the free $k$-module
on the set of all paths, $kQ = \bigoplus_{p\ \text{path}} k\cdot p$, with
multiplication extending path composition $k$-bilinearly:
$$
q \cdot p = \begin{cases} q\circ p & \text{if } t(p) = s(q),\\ 0 &
\text{otherwise,}\end{cases}
$$
and unit $\sum_{v\in V} e_v$ (the sum of the trivial paths) — well-defined
as a finite sum, hence a genuine identity element, precisely when $Q_0$ is
finite; see [AssemSimsonSkowronski2006], Definition 1.2, remark following.
So representations of $Q$ are exactly $kQ$-modules, the bridge to
Chapter 10 promised there. The construction requires finitely-supported
functions $\{\text{paths}\} \to k$, i.e. the free module, which is why
only the composition (the category layer) is formalized here.

> **Not independently verified.** The description of $kQ$ as "the
> $k$-linearization of the free category $\mathrm{Free}(Q)$, its category
> algebra" is standard category-theory folklore, but it is *not* stated
> verbatim in either of this chapter's two cited sources
> ([AssemSimsonSkowronski2006], [Schiffler2014]) — both define $kQ$
> directly by basis-and-multiplication, as above, without naming it a
> "category algebra." Treat that equivalence as a remark, not a cited
> fact, until a source stating it explicitly is added to the
> bibliography.

> Read more: [Chapter 10](../10-modules/00-index.md)'s [`Module`](https://loogle.lean-lang.org/?q=Module),
> [`LinearMap`](https://loogle.lean-lang.org/?q=LinearMap), and direct-sum material is exactly the vocabulary a full
> $kQ$-module (i.e. quiver representation) formalization would need.
> Externally, Assem–Simson–Skowroński's *Elements of the Representation
> Theory of Associative Algebras* (Vol. 1) and Schiffler's *Quiver
> Representations* both develop path algebras and their representations
> from scratch, at a similar level of explicitness to this chapter.

### References

Full citations in the [Bibliography](../bibliography.md).

- Assem, Simson, and Skowroński ([AssemSimsonSkowronski2006]), **Definition 1.2** (Chapter II, §1) — the path algebra $kQ$: basis = all paths (including stationary ones), product of two basis paths equal to their concatenation if endpoints match, else $0$, extended by distributivity. Also notes each stationary path $\varepsilon_x$ is idempotent, and $\sum_{x\in Q_0}\varepsilon_x$ is the identity *when $Q_0$ is finite*.
- Schiffler ([Schiffler2014]), **Definition 4.5** (Chapter 4, §4.2) — same construction; unit given explicitly as $1 = \sum_{i\in Q_0} e_i$ in the lemma immediately following (Lemma 4.3 in that source's numbering).

[AssemSimsonSkowronski2006]: ../bibliography.md#assemsimsonskowronski2006
[Schiffler2014]: ../bibliography.md#schiffler2014

---

[← Paths as an inductive type](04-paths-as-inductive-type.md) | [Index](00-index.md) | [Next: Exercises →](06-exercises.md)

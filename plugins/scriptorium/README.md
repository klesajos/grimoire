# scriptorium

> The monastic room where manuscripts were copied and illuminated.

A grimoire plugin that captures a proven recipe for building a **Czech academic LaTeX
compendium** — the setup behind the 833-page *Kompendium k přijímací zkoušce* (MÚVS ČVUT).
It ships one reference spell plus copy-ready template files so the recipe can be re-applied
to a new study book without re-deriving it.

## What's inside

- **Spell `latex-compendium`** — a reference skill covering the whole setup:
  - `reference/build-system.md` — XeLaTeX, the 3-pass build, the isolated single-chapter
    compile harness, dependencies.
  - `reference/preamble-and-fonts.md` — `\documentclass`, `fontspec`/`polyglossia` Czech,
    the font-by-file gotcha, page layout, packages, colour palette.
  - `reference/environments.md` — the `tcolorbox` box system (`pojem`, `priklad`, `otazka`,
    `reseni`, `odpoved`, `pozor`, `kucharka`, `veta`, `dukaz`), the `\en{}` macro, the `kde`
    symbol-list, and the TikZ decision-tree styles.
  - `reference/chapter-conventions.md` — file naming, the fixed chapter template, math &
    typography rules, the writing contract.
  - `reference/volumes.md` — the standalone per-topic volume (`svazky/`) pattern.
- **`assets/`** — copy-ready scaffolding (verbatim from the live project):
  `preamble/preamble.tex`, `build.sh`, `build-svazek.sh`, `test/wrap.tex`,
  `main.tex.template`.
- **`assets/sample/`** — a self-contained 17-page showcase: [`sample.pdf`](assets/sample/sample.pdf)
  and its source [`sample.tex`](assets/sample/sample.tex). It exercises every environment
  (`pojem`, `priklad`, `otazka`, `reseni`, `odpoved`, `pozor`, `kucharka`, `veta`, `dukaz`),
  the `\en{}` macro and `kde` symbol list, mathematical definitions / theorems / proofs and
  formulas with their variants, a vector TikZ figure, a TikZ decision tree, TikZ data charts
  (bar, line, a Gaussian curve, plus a ranked horizontal bar chart and a box plot built from a
  real-world dataset — the ten largest Czech cities by population), **Mermaid diagrams**
  (flowchart + sequence) rendered to vector PDF (`assets/sample/figures/`, regenerable per its
  README), `booktabs` tables, a list of figures and list of tables, and citations with a
  bibliography formatted per **ČSN ISO 690** (typography per **ČSN 01 6910**). Compile with
  `xelatex sample.tex` (run three times for the TOC, lists, and citations).

## The setup in one paragraph

**XeLaTeX** (required for `fontspec`/`polyglossia`) builds a Czech `book` whose every
chapter is assembled from a small, fixed set of `tcolorbox` environments defined once in a
shared preamble. Method-choice **decision trees** are drawn in TikZ. The book builds in
**3 passes** (no `latexmk` under BasicTeX), each chapter can be compiled in **isolation**
for fast feedback, and each topic can also be exported as a **standalone volume**.

## Scaffold a new compendium

Copy from `assets/` in this order — full steps in the spell's *Scaffolding* section:

1. `assets/preamble/preamble.tex` → `preamble/preamble.tex`
2. `assets/main.tex.template` → `main.tex` (fill in the title + `\part`/`\input` list)
3. `assets/build.sh` → `build.sh` (adjust the `TEX=` path per machine)
4. `assets/test/wrap.tex` → `test/wrap.tex`
5. (optional) `assets/build-svazek.sh` → `build-svazek.sh`

Then write chapters under `chapters/` following `chapter-conventions.md`, compiling each in
isolation before adding it to `main.tex`.

## Requirements

A TeX distribution with XeLaTeX and the packages listed in `reference/build-system.md`
(`tcolorbox`, `polyglossia`, `fontspec`, `enumitem`, `csquotes`, `needspace`, …) plus the
Latin Modern OTF fonts. Verify with `xelatex --version` and
`kpsewhich lmroman10-regular.otf`.

---

Source of truth: the live project at `~/dev/prijimacky`. The `assets/` here are copied
verbatim from it; the reference docs distill its `STYLE.md` and preamble.

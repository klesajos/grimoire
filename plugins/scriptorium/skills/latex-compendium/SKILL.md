---
name: latex-compendium
description: Reference for building a Czech academic LaTeX compendium / exam study book the proven way — the XeLaTeX + polyglossia setup, a custom tcolorbox environment system (pojem, priklad, otazka, reseni, odpoved, pozor, kucharka, veta, dukaz), the \en{} term macro and kde symbol-list, TikZ decision trees, a 3-pass build with an isolated single-chapter compile harness, and standalone per-topic volumes. Use when the user wants to build, extend, or maintain a compendium/skripta/study book in this style (e.g. the prijimacky / MÚVS ČVUT setup), asks how that LaTeX setup works, needs the preamble/environments/build recipe, or wants the copy-ready template assets to start a similar book. Czech-language, beginner-audience study material is the target; for unrelated general LaTeX questions this may be more than is needed.
---

# LaTeX academic compendium (XeLaTeX, Czech)

A reproducible recipe for a large Czech study compendium — the setup behind the
833-page MÚVS ČVUT *Kompendium k přijímací zkoušce*. It is **XeLaTeX**-based (for
`fontspec`/`polyglossia`), uses a shared preamble that defines a small, fixed set of
`tcolorbox` environments so every chapter looks identical, renders method-choice
**decision trees** in TikZ, builds in **3 passes**, and can also export each topic as a
**standalone volume** (`svazek`). Audience: a complete beginner aiming to pass an exam,
so the writing contract is strict (define everything, every formula gets a symbol list,
test questions verbatim).

This skill is a **reference + scaffolding** spell: the `reference/` files explain how each
piece works, and `assets/` ships the working files to copy into a new project.

## When to use this skill

- The user wants to **start a new compendium / skripta / study book** in this style, or
  rebuild the `prijimacky`-style setup elsewhere.
- The user is **writing or extending a chapter** and needs the environment usage, the
  chapter template, or the math/typography conventions.
- The user asks **how the build works** (XeLaTeX, why 3 passes, isolated chapter compile)
  or hits a build/font error in this setup.
- The user wants the **copy-ready preamble / build scripts / harness** (see Scaffolding).

## When NOT to use this skill

- **General, unrelated LaTeX questions** (a one-off article, a CV, a beamer deck): the
  conventions here are specific to a Czech beginner-audience exam compendium and will be
  more than is needed.
- **pdfLaTeX/LuaLaTeX projects**: this setup is XeLaTeX-only (font-by-file loading +
  `polyglossia`); the preamble will not compile under pdfLaTeX unchanged.

## Reference files (open the one you need)

| File | What it covers | Open it when |
|------|----------------|--------------|
| `reference/build-system.md` | The XeLaTeX engine choice, why **3 passes**, `build.sh` and `build-svazek.sh`, the isolated single-chapter compile harness (`test/wrap.tex`) with `-jobname` collision-avoidance, output naming, and the full dependency list (TeX Live/BasicTeX packages, Latin Modern OTF fonts, `kpsewhich` check). | You need to build the PDF, compile one chapter in isolation, set up the toolchain, or debug a build/font failure. |
| `reference/preamble-and-fonts.md` | `\documentclass`, the `fontspec` + `polyglossia` Czech setup and the **font-by-file loading gotcha**, page geometry / `fancyhdr`, the full package list with one-line purposes, the 6-colour palette, and `hyperref`. | You need to understand or adjust the preamble, change fonts/margins, or learn why a font/package line is there. |
| `reference/environments.md` | Every reusable building block with definition + usage: the `\en{}` term macro, the `kde` symbol-list, and the tcolorbox boxes `pojem` / `priklad` / `otazka` / `reseni` / `odpoved` / `pozor` / `kucharka` / `veta` / `dukaz`, plus the TikZ node styles (`rozhodnuti` / `vysledek` / `sipka` / `popisek`) for decision trees. | You're writing chapter content and need to know which box to use and how to call it. **Don't redefine these** — they live in `assets/preamble/preamble.tex`. |
| `reference/chapter-conventions.md` | The file-naming scheme (numeric core + prefixed module families), the **fixed chapter template order**, the math & typography conventions (display math, Czech decimal `1{,}05`, `5\,\%`, every formula followed by a `kde` list), and the STYLE.md writing contract distilled into hard rules. | You're authoring a chapter and need the structure, naming, and the must-follow rules; or you're reviewing a chapter for compliance. |
| `reference/volumes.md` | The standalone-volume (`svazky/`) pattern — each volume is a self-contained `book` that re-uses the shared preamble plus a chosen chapter subset, built into `dist/` with `build-svazek.sh`. | The user wants to split the compendium into per-topic PDFs, or add/define a new volume. |

## Scaffolding a new compendium

Copy-ready files live under `${CLAUDE_PLUGIN_ROOT}/assets/`. To start a new project, copy in this order:

1. `assets/preamble/preamble.tex` → `preamble/preamble.tex` (the environment system + fonts).
2. `assets/main.tex.template` → `main.tex` (fill in the title block and the `\part` / `\input` list).
3. `assets/build.sh` → `build.sh` (full 3-pass build; adjust the `TEX=` path per machine — see `reference/build-system.md`).
4. `assets/test/wrap.tex` → `test/wrap.tex` (isolated single-chapter compile harness).
5. Optionally `assets/build-svazek.sh` → `build-svazek.sh` if you'll export standalone volumes.

Then write chapters under `chapters/` following `reference/chapter-conventions.md`, and
compile each in isolation before adding it to `main.tex`.

> Source of truth: the live project at `~/dev/prijimacky` (`preamble/preamble.tex`,
> `build.sh`, `STYLE.md`). The `assets/` here are copied verbatim from it.

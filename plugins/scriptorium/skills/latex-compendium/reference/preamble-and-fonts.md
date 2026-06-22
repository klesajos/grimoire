# Preamble and fonts

The whole look of the compendium is defined in **one shared file**,
`preamble/preamble.tex`, which `main.tex`, every volume, and the test harness all
`\input`. Chapters never load packages or define environments themselves — they only *use*
what the preamble provides. This is what keeps 100+ chapters visually identical.

The shipped copy is `${CLAUDE_PLUGIN_ROOT}/assets/preamble/preamble.tex` (verbatim from the
live project). This page explains each block; for the environments themselves see
`environments.md`.

## Document class

```latex
\documentclass[11pt, a4paper, oneside]{book}
```

- **`book`** — gives `\part`, `\chapter`, front matter, and the running heads the headers
  rely on.
- **`oneside`** — single-sided layout (same margins on every page); the running-head setup
  below is written for it.
- **11pt / A4** — body size and paper.

## Language and fonts (the gotcha)

```latex
\usepackage{fontspec}
\usepackage{polyglossia}
\setmainlanguage{czech}
% BasicTeX nemá fonty registrované v macOS — načítáme přímo soubory přes kpathsea
\setmainfont{lmroman10-regular.otf}[
  BoldFont = lmroman10-bold.otf,
  ItalicFont = lmroman10-italic.otf,
  BoldItalicFont = lmroman10-bolditalic.otf,
  Ligatures = TeX ]
\setsansfont{lmsans10-regular.otf}[ ... ]
\setmonofont{lmmonolt10-regular.otf}[ ... ]
```

- **`polyglossia` + `\setmainlanguage{czech}`** is the modern (XeLaTeX) replacement for
  `babel`: Czech hyphenation, date format, and quote conventions.
- **Font-by-file loading is the key gotcha.** BasicTeX does not register its fonts with the
  OS font system, so `\setmainfont{Latin Modern Roman}` (by family name) fails. Loading the
  **`.otf` files by name** (`lmroman10-regular.otf`, …) makes `fontspec` find them through
  `kpathsea` regardless of OS registration. If you ever see *"cannot find font"*, this is
  why — check `kpsewhich lmroman10-regular.otf`.
- **No `inputenc` / `fontenc`.** XeLaTeX is natively UTF-8 and uses real Unicode fonts, so
  those pdfLaTeX-era packages are deliberately absent. Source files are plain UTF-8 with
  Czech diacritics typed directly.
- `Ligatures = TeX` keeps the `---`, `` `` ``, `''` input ligatures working.

## Page layout

```latex
\usepackage[a4paper, margin=2.5cm]{geometry}
\usepackage{parskip}
\usepackage{fancyhdr}
\pagestyle{fancy}
\fancyhf{}
\fancyhead[LE]{\small\leftmark}
\fancyhead[RO]{\small\rightmark}
\fancyfoot[C]{\thepage}
\renewcommand{\headrulewidth}{0.4pt}
```

- **`geometry`** — uniform 2.5 cm margins on A4.
- **`parskip`** — paragraphs separated by vertical space, no first-line indent (cleaner for
  definition-heavy study text).
- **`fancyhdr`** — running heads: chapter name on the left (`\leftmark`), section on the
  right (`\rightmark`), page number centered in the footer.

## Packages (one-line purposes)

| Package | Purpose |
|---|---|
| `amsmath`, `amssymb`, `mathtools` | Display math, symbols, `\coloneqq`-style refinements |
| `xcolor` | Named colours (the palette below) |
| `tikz` (+ libs `shapes.geometric, arrows.meta, positioning, calc, fit`) | Decision trees and diagrams |
| `tcolorbox` (+ `skins, breakable, theorems`) | The boxed environments; `breakable` lets a box span a page break |
| `enumitem` | Tunable lists (`[label=\alph*)]`, `[nosep]`) |
| `csquotes` (`autostyle`) | Language-aware quotation marks |
| `booktabs`, `multirow`, `tabularx`, `longtable` | Professional tables, incl. multi-page |
| `needspace` | Keep a heading + following lines together across a page break |
| `hyperref` | Clickable TOC / cross-references / URLs — **loaded last** |

## Colour palette

Six named colours drive the environments (each box keys off one):

```latex
\definecolor{pojemModra}{RGB}{21, 101, 192}     % definitions  (blue)
\definecolor{prikladSeda}{RGB}{84, 110, 122}    % worked examples (slate)
\definecolor{otazkaOranzova}{RGB}{230, 126, 34} % test questions (orange)
\definecolor{reseniZelena}{RGB}{46, 125, 50}    % solutions / answers (green)
\definecolor{pozorCervena}{RGB}{198, 40, 40}    % warnings / traps (red)
\definecolor{kucharkaFialova}{RGB}{106, 27, 154}% step-by-step recipes (purple)
```

A seventh, `vetaTeal` (`0,121,107`), is defined later next to the `veta` (theorem) box.

## hyperref last

```latex
\usepackage[unicode, colorlinks=true, linkcolor=pojemModra, urlcolor=pojemModra]{hyperref}
```

`hyperref` patches many internal commands, so it is loaded **after everything else**
(standard LaTeX guidance). `unicode` is required under XeLaTeX so bookmarks render Czech
diacritics correctly; links are coloured (not boxed) in the palette blue.

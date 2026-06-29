# Build system

## Engine: XeLaTeX (not pdfLaTeX)

The compendium **must** be built with XeLaTeX. The preamble uses `fontspec` and
`polyglossia`, which require a Unicode engine (XeLaTeX or LuaLaTeX). pdfLaTeX cannot load
the OpenType fonts by file or run the `polyglossia` Czech setup, so it will not compile the
document unchanged.

On the reference machine the engine is BasicTeX's XeLaTeX at `/Library/TeX/texbin/xelatex`
(XeTeX from TeX Live). Full TeX Live works identically — only the binary path differs.

## Why 3 passes

`build.sh` runs `xelatex` **three times**. LaTeX resolves the table of contents,
`\leftmark`/`\rightmark` running heads, `hyperref` anchors, and the auto-counters
(`Pojem~\thetcbcounter` etc.) by writing `.aux`/`.toc` on one pass and reading them on the
next, so a single pass leaves the TOC and references stale. `latexmk` would normally manage
this automatically, but it is **unavailable in BasicTeX user mode**, hence the fixed 3-pass
loop. Three passes is enough for a stable TOC + cross-references in a document this size.

## `build.sh` — full build

```bash
#!/bin/bash
# Full build: 3 xelatex passes (TOC + references need multiple passes; latexmk
# is unavailable in BasicTeX user mode).
set -u
cd "$(dirname "$0")"
mkdir -p build
TEX=/Library/TeX/texbin/xelatex

for i in 1 2 3; do
  $TEX -interaction=nonstopmode -halt-on-error -output-directory=build main.tex \
    > "build/pass$i.stdout" 2>&1
  if [ $? -ne 0 ]; then
    echo "FAIL: pass $i"
    grep -B1 -A4 '^!' build/main.log | head -60
    exit 1
  fi
done
...
cp build/main.pdf kompendium.pdf
```

Key points:

- **`-interaction=nonstopmode -halt-on-error`** — never block on a prompt, and stop on the
  first real error so the loop fails fast.
- **`-output-directory=build`** — all aux files land in `build/`, which is git-ignored; only
  the final PDF is copied to the project root.
- **On failure** it greps `build/main.log` for lines starting with `!` (TeX errors) and
  prints them — read those first when a build fails.
- After a clean build it prints a **warnings summary** (`LaTeX Warning` count, any
  `undefined` references, any `Missing character` — the latter usually means a glyph the
  current font can't render).
- The one machine-specific thing to adjust is the **`TEX=` path** (`which xelatex` to find
  yours). The output filename `kompendium.pdf` is also project-specific.

## Isolated single-chapter compile (`test/wrap.tex`)

To compile **one chapter** without building the whole book — fast feedback while writing,
and the gate every chapter must pass before being added to `main.tex`:

```latex
% test/wrap.tex
\documentclass[11pt, a4paper, oneside]{book}
\input{preamble/preamble}
\begin{document}
\input{\chapterfile}
\end{document}
```

`\chapterfile` is injected on the command line, so the same harness compiles any chapter:

```bash
cd <project-root>
/Library/TeX/texbin/xelatex -interaction=nonstopmode -halt-on-error \
  -output-directory=build \
  "\def\chapterfile{chapters/22-derivace.tex}\input{test/wrap.tex}"
```

**Zero errors is the requirement** before a chapter is considered done.

### `-jobname` to avoid collisions

When several chapters are compiled in parallel (e.g. multiple writer agents), they all
default to the jobname `wrap` and clobber each other's `build/wrap.*` files. Give each its
own jobname:

```bash
xelatex -interaction=nonstopmode -halt-on-error -jobname=wrap-22-derivace \
  -output-directory=build \
  "\def\chapterfile{chapters/22-derivace.tex}\input{test/wrap.tex}"
```

## `build-svazek.sh` — per-volume build

Same 3-pass logic, parameterised by a volume name, writing the result to `dist/`:

```bash
./build-svazek.sh svazek-01-podnikove-finance   # → dist/svazek-01-podnikove-finance.pdf
```

See `volumes.md` for how the `svazky/*.tex` files are structured.

## Output naming

- Full book → `build/main.pdf`, copied to `kompendium.pdf` at the root
  (the committed artifact).
- Volumes → `build/<svazek>.pdf`, copied to `dist/<svazek>.pdf`.
- Everything under `build/` (aux, log, toc, per-pass stdout) is git-ignored.

## Dependencies

A TeX distribution with XeLaTeX plus these packages (all in TeX Live; on BasicTeX install
via `tlmgr install`):

- **Math:** `amsmath`, `amssymb`, `mathtools`
- **Layout:** `geometry`, `parskip`, `fancyhdr`, `needspace`
- **Colour / graphics / boxes:** `xcolor`, `tikz`, `tcolorbox` (with the `skins`,
  `breakable`, `theorems` libraries)
- **Lists / quotes / tables:** `enumitem`, `csquotes`, `booktabs`, `multirow`, `tabularx`,
  `longtable`
- **Language / fonts:** `fontspec`, `polyglossia`
- **Links:** `hyperref`

**Fonts:** Latin Modern OpenType files (`lmroman10-*`, `lmsans10-*`, `lmmonolt10-*`),
shipped with TeX Live's `lm` package. They are loaded **by filename**, so verify they are on
the `kpathsea` path:

```bash
xelatex --version                  # confirm XeTeX is present
kpsewhich lmroman10-regular.otf    # must print a path, else install the `lm` fonts
```

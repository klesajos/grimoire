# Standalone volumes (svazky)

Besides the single full book (`main.tex` → `kompendium.pdf`), the same chapters can also be
published as **standalone per-topic PDFs** — one topic on its own. A reader who only needs
one topic gets a slim book instead of the full multi-part volume.

## How a volume works

A volume is just **another root document** that re-uses the shared preamble and `\input`s a
**chosen subset** of the same `chapters/*.tex` files. No chapter content is duplicated — the
chapters are the single source of truth; volumes and the full book are two different
selections over them.

Volume roots live in `svazky/`. Template (`svazky/svazek-01-podnikove-finance.tex`):

```latex
% Samostatný svazek kompendia — kompilovat z kořene projektu:
%   xelatex -interaction=nonstopmode -output-directory=build svazky/svazek-01-podnikove-finance.tex
\documentclass[11pt, a4paper, oneside]{book}
\input{preamble/preamble}
\title{\Huge\bfseries Podnikové finance\\[0.8em]
       \Large Podtitul kompendia\\[0.4em]
       \normalsize svazek 01}
\author{}
\date{\today}
\begin{document}
\maketitle
\tableofcontents
\input{chapters/legenda}
\input{chapters/11-pf-zaklady}
\input{chapters/12-pf-majetkova-financni-struktura}
\input{chapters/13-pf-financni-zdroje}
\input{chapters/14-pf-casova-hodnota-penez}
\input{chapters/15-pf-hodnoceni-investic}
\input{chapters/16-pf-financni-analyza}
\end{document}
```

Notes:

- Same `\documentclass` and `\input{preamble/preamble}` as `main.tex` — identical styling,
  environments, and numbering behaviour.
- No `\part` — a single-topic volume is usually a flat chapter list. Often it opens with
  `\input{chapters/legenda}` (a one-page legend of the box types) so the volume is
  self-explanatory standalone.
- `\input` paths are **relative to the project root** (`chapters/...`, `preamble/...`), so
  volumes must be compiled from the root, not from inside `svazky/`.

## Building a volume

```bash
./build-svazek.sh svazek-01-podnikove-finance
# → 3 passes → build/svazek-01-...pdf → copied to dist/svazek-01-...pdf
```

`build-svazek.sh` is the per-volume twin of `build.sh` (same 3-pass logic; see
`build-system.md`). Volume PDFs land in `dist/`.

## Adding a new volume

1. Create `svazky/svazek-NN-<topic>.tex` from the template above.
2. Set the `\title` and list the chapters that belong to the topic (a subset of the files
   already in `chapters/`).
3. Build it: `./build-svazek.sh svazek-NN-<topic>`.

That's all — because chapters are shared, a volume needs no new content, only a new
selection.

# Chapter conventions

Each chapter is **its own file** under `chapters/`, `\input` from `main.tex` (and from the
relevant volume). These are the rules every chapter follows — distilled from the live
project's `STYLE.md` writing contract.

## File naming

Numeric prefixes keep files sorted on disk in reading order, grouped by part:

- **Core exam topics** use a two-digit code where the first digit is the part:
  `11`–`16` finance, `21`–`25` math/stats, `31` English, `41`–`42` sample tests,
  `51`–`59` micro, `61`–`65` macro. Example: `chapters/22-derivace.tex`.
- **Specials:** `00-uvod`, `legenda`, `90-tahak` (formula cheat sheet), `91-glosar`
  (Czech–English glossary).
- **Advanced module families** use a letter prefix + number, one family per course:
  `pkm-`, `la1-`, `la2-`, `ma1-`, `ma2-`, `dml-`, `mlo-`, `mpi-`, `pst-`, `vsm-`, `vmm-`.
  Example: `chapters/pkm-04-funkce.tex`.

Labels use ASCII slugs only: `\label{ch:pf-zaklady}`, `\label{sec:limita-intuitivne}`.

## Fixed chapter template (order matters)

1. `\chapter{...}` + a **one-paragraph motivation**: *K čemu to je a co z toho zkouší* —
   what the topic is for and what the exam asks from it.
2. **Výklad** (exposition): `pojem` boxes for definitions, prose between them, `pozor` boxes
   for traps. Define every concept before using it.
3. **Vzorce** (formulas): display math, each immediately followed by a `kde` symbol list.
4. **`priklad` boxes**: at least one worked example per major concept, step by step.
5. `\section{Testové otázky ze zdrojových materiálů}`: every assigned question as
   `otazka{<source>}` immediately followed by `reseni{<letter>}` (MCQ) or `odpoved` (open).

Where the topic involves **choosing a method** (which distribution, which integration
technique, which investment metric), include the relevant `\input{figures/...}` decision
tree and a `kucharka` with numbered steps.

## Math and typography conventions

- **Display math, not inline.** Formulas go in `\[ ... \]`, never mid-sentence `$...$` for
  anything substantive — so each can carry its `kde` list.
- **Every formula is followed by a `kde` list** defining *every* symbol (see
  `environments.md`).
- **Czech decimal comma in math mode:** write `1{,}05`, never `1.05`. The braces keep the
  spacing correct.
- **Percent:** `5\,\%` — thin space before the (escaped) percent sign.
- **Escape special characters** in Czech text and especially in `otazka{...}` source
  filenames: `%` → `\%`, `&` → `\&`, `_` → `\_`.
- Reconstruct any **PDF-mangled formula** to standard form and verify it numerically against
  any bracketed ground-truth answer before writing it.

## Hard rules (the writing contract)

1. **Czech with English terms.** Every technical term gets `\en{...}` at first use.
2. **Assume zero prior knowledge.** Define everything first; never *"jak známo"* / *"zřejmě"*.
3. **Every formula** → display math → `kde` list. No exceptions.
4. **Worked examples** in `priklad`, step by step, final result marked `\textbf{Výsledek:}`.
5. **Test questions verbatim** from the source, options as
   `\begin{enumerate}[label=\alph*)]`; each followed by `reseni` (why correct + why each
   distractor is wrong) or `odpoved` for open questions.
6. **Use only the preamble's environments** — don't define your own.
7. **Compile clean in isolation** before adding the chapter to `main.tex`:
   ```bash
   xelatex -interaction=nonstopmode -halt-on-error -jobname=wrap-<slug> \
     -output-directory=build "\def\chapterfile{chapters/<file>.tex}\input{test/wrap.tex}"
   ```
   Zero errors required (see `build-system.md`).

## Skeleton

```latex
\chapter{Podnikové finance — základy}
\label{ch:pf-zaklady}

K čemu to je a co z toho zkouší: ...(one-paragraph motivation)...

\section{Co jsou podnikové finance}
\label{sec:pf-co-jsou}

...prose...

\begin{pojem}{Podnikové finance}{corporate finance}
...definice...
\end{pojem}

\[ ... \]
\begin{kde}
  \item $X$ — ...
\end{kde}

\begin{priklad}{...}
...krok za krokem...
\textbf{Výsledek: ...}
\end{priklad}

\section{Testové otázky ze zdrojových materiálů}

\begin{otazka}{zdroj.pdf} ... \end{otazka}
\begin{reseni}{c} ... \end{reseni}
```

# Environments and macros

These are the reusable building blocks every chapter is made of. They are all defined in
`preamble/preamble.tex` (shipped at `${CLAUDE_PLUGIN_ROOT}/assets/preamble/preamble.tex`).
**Use them — never redefine them in a chapter.** Boxes built with `[auto counter, number
within=chapter]` number themselves per chapter (Pojem 3.1, Příklad 3.2, …).

## `\en{}` — English equivalent of a term

```latex
\newcommand{\en}[1]{ \textit{(angl. #1)}}
```

Attach the English term at the **first** occurrence of a Czech technical term — readers may
meet it in either language. Don't repeat it on later uses.

```latex
úrok\en{interest}        % → úrok (angl. interest)
```

## `kde` — symbol list after a formula

```latex
\newenvironment{kde}
  {\par\noindent\textit{kde:}\begin{itemize}[nosep, leftmargin=2.5em]}
  {\end{itemize}\medskip}
```

Every display formula is **immediately** followed by a `kde` list defining every symbol:

```latex
\[ FV = PV \cdot (1 + r)^t \]
\begin{kde}
  \item $FV$ — budoucí hodnota\en{future value}
  \item $PV$ — současná hodnota\en{present value}
  \item $r$ — úroková míra\en{interest rate}
  \item $t$ — počet období
\end{kde}
```

## tcolorbox environments

| Environment | Signature | Colour | Use for |
|---|---|---|---|
| `pojem` | `{název}{english}` | blue | A **definition**. English equivalent is mandatory (2nd arg). |
| `priklad` | `{název}` | slate | A **worked example**, computed step by step. |
| `otazka` | `{zdroj.pdf}` | orange | A **test question**, verbatim; arg = source filename. |
| `reseni` | `{písmeno}` | green | **Solution to an MCQ**; arg = correct option letter. |
| `odpoved` | — | green | **Model answer** to an open/control question. |
| `pozor` | — | red | A **trap / common mistake** warning. |
| `kucharka` | `{název}` | purple | A **step-by-step recipe** (numbered method). |
| `veta` | `{název}` | teal | A **theorem / proposition** (rigorous chapters). |
| `dukaz` | — | — | A **proof**, ends with a QED □. |

### Definition — `pojem{název}{english}`

```latex
\begin{pojem}{Úrok}{interest}
Úrok je cena za zapůjčení peněz...
\end{pojem}
```

Renders a left-bordered blue panel titled *Pojem 3.1: Úrok (angl. interest)*.

### Worked example — `priklad{název}`

```latex
\begin{priklad}{Reálná úroková míra}
Spočítáme krok za krokem...
\[ ... \]
\textbf{Výsledek: 2\,\%}
\end{priklad}
```

Each step on its own line with a one-sentence explanation; mark the final result with
`\textbf{Výsledek: ...}`.

### Test question + solution — `otazka` / `reseni`

```latex
\begin{otazka}{PF_tema_4.pdf}
Která z následujících veličin...?
\begin{enumerate}[label=\alph*)]
  \item ...
  \item ...
\end{enumerate}
\end{otazka}
\begin{reseni}{c}
Správně je c), protože... Distraktor a) je špatně, protože...
\end{reseni}
```

`reseni{<letter>}` is for **multiple-choice** questions. For an **open** control question
use `odpoved` (model answer) instead:

```latex
\begin{otazka}{kontrolni-otazky.pdf}
Vysvětlete rozdíl mezi ...
\end{otazka}
\begin{odpoved}
...
\end{odpoved}
```

### Warning — `pozor`

```latex
\begin{pozor}
Nezaměňuj nominální a reálnou úrokovou míru...
\end{pozor}
```

Titled *Pozor — častá chyba!*.

### Recipe — `kucharka{název}`

```latex
\begin{kucharka}{Jak číst tabulku Studentova rozdělení}
\begin{enumerate}
  \item ...
  \item ...
\end{enumerate}
\end{kucharka}
```

### Theorem / proof — `veta{název}` and `dukaz`

```latex
\begin{veta}{Lagrangeova věta}
Nechť ...
\end{veta}
\begin{dukaz}
... \end{dukaz}     % automatically appends □
```

## TikZ decision-tree node styles

Defined in the preamble so method-choice trees look consistent. Typically the tree lives in
a `figures/*.tex` file that a chapter `\input`s, paired with a `kucharka`.

```latex
\tikzset{
  rozhodnuti/.style={diamond, ...},   % a decision node (purple diamond)
  vysledek/.style={rectangle, ...},   % an outcome node (green rounded box)
  sipka/.style={-{Stealth}, thick},   % an arrow
  popisek/.style={font=\footnotesize\itshape, midway}  % edge label (ano/ne)
}
```

```latex
\begin{tikzpicture}[node distance=1.0cm and 1.2cm]
  \node[rozhodnuti] (d1) {Je to elementární funkce z tabulky?};
  \node[vysledek, right=of d1] (r1) {použij \textbf{tabulku derivací}};
  \draw[sipka] (d1) -- node[popisek, above] {ano} (r1);
\end{tikzpicture}
```

See `chapter-conventions.md` for where trees and recipes fit in a chapter, and the live
project's `figures/strom-*.tex` for full examples.

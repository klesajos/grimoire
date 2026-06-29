# figures/

Vector diagrams for `sample.tex`.

- `*.mmd` — Mermaid sources.
- `*.pdf` — rendered vector PDFs, included by `sample.tex` via `\includegraphics`.

## Regenerate the PDFs

Needs Node + a Chrome/Chromium. Point Puppeteer at your browser, then render each
diagram to a tightly-cropped vector PDF with `--pdfFit`:

```bash
cat > puppeteer-config.json <<'EOF'
{ "executablePath": "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome", "args": ["--no-sandbox"] }
EOF
export PUPPETEER_SKIP_DOWNLOAD=true
for f in *.mmd; do
  npx -y @mermaid-js/mermaid-cli@latest -p puppeteer-config.json -i "$f" -o "${f%.mmd}.pdf" --pdfFit
done
rm puppeteer-config.json
```

Chrome renders the labels (so Czech diacritics and `<`/`>` come out correct); `--pdfFit`
crops the page to the diagram. Don't disable `htmlLabels` — that drops `>` from edge labels.

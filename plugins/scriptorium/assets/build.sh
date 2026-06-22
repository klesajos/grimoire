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

echo "BUILD OK"
echo "--- Warnings summary ---"
grep -c 'LaTeX Warning' build/main.log 2>/dev/null || echo "0"
grep 'undefined' build/main.log | head -10 || true
grep 'Missing character' build/main.log | head -10 || true

cp build/main.pdf kompendium-prijimacky-muvs.pdf
echo "PDF: $(pwd)/kompendium-prijimacky-muvs.pdf ($(du -h kompendium-prijimacky-muvs.pdf | cut -f1))"

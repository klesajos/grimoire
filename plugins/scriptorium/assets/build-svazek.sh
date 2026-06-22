#!/bin/bash
# Usage: ./build-svazek.sh svazek-01-podnikove-finance
set -e
cd "$(dirname "$0")"
S="$1"
for i in 1 2 3; do
  /Library/TeX/texbin/xelatex -interaction=nonstopmode -halt-on-error \
    -output-directory=build "svazky/$S.tex" > "build/$S-pass$i.log" 2>&1 \
    || { echo "FAIL pass $i"; grep -A3 "^!" "build/$S.log" | head -30; exit 1; }
done
cp "build/$S.pdf" "dist/$S.pdf"
echo "OK dist/$S.pdf ($(grep -o '([0-9]* pages' "build/$S.log" | tail -1 | tr -d '(') )"

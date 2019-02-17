#!/bin/bash
latexmk -pdf -pdflatex='lualatex -interaction=batchmode -draftmode %O %S && touch %D' -print=pdf -e '$lpr_pdf=q|lualatex -interaction=batchmode -synctex=1 %R|' "$@"

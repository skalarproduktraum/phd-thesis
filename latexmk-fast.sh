#!/bin/bash
latexmk -pdf -pdflatex='lualatex -draftmode %O %S && touch %D' -print=pdf -e '$lpr_pdf=q|lualatex -interaction=batchmode -synctex=1 %R|' "$@"

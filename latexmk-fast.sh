#!/bin/bash
# check if we are in debug mode, otherwise use batch mode
if [[ -z "${DEBUG}" ]]; then
  INTERACTION_MODE="-interaction=batchmode"
else
  INTERACTION_MODE=""
fi

echo "interaction mode is $INTERACTION_MODE"

# run latexmk with lualatex
latexmk -pdf -pdflatex='lualatex '"$INTERACTION_MODE"' -draftmode %O %S && touch %D' -print=pdf -e '$lpr_pdf=q|lualatex '"$INTERACTION_MODE"' -synctex=1 %R|' "$@"


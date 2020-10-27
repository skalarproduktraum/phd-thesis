#!/bin/bash
# check if we are in debug mode, otherwise use batch mode
if [[ -z "${DEBUG}" ]]; then
  INTERACTION_MODE="-interaction=batchmode"
else
  INTERACTION_MODE=""
fi

echo "interaction mode is $INTERACTION_MODE"


if [[ -z "${NICE}" ]]; then
  echo "Creating draft PDF"
  QUALITY="-draftmode"
else
  echo "Creating print-quality PDF"
  QUALITY=""
fi


# run latexmk with lualatex
latexmk -pdf -pdflatex='lualatex '"$INTERACTION_MODE"' '"$QUALITY"' %O %S && touch %D' -print=pdf -e '$lpr_pdf=q|lualatex '"$INTERACTION_MODE"' -synctex=1 %R|' "$@"


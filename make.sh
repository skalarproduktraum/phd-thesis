CHAPTERS=`cat chapters.list | sed -e ':a; N; s/\n/ chapters\//; ba'`
PREAMBLE="tex/preamble.tex"

echo "pandoc'ing $CHAPTERS to thesis.pdf"

pandoc --pdf-engine=xelatex -H $PREAMBLE -V fontsize=12pt -V documentclass:book -V papersize:a4paper -V classoption:openright -V subparagraph --top-level-division=chapter $CHAPTERS -o thesis.pdf

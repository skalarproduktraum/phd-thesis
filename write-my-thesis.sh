CHAPTERS=`cat chapters.list | tr '\n' ' chapters/'`
PREAMBLE="tex/preamble.tex"
BIBLIOGRAPHY="thesis.bib"
CSL="csl/pnas.csl"

echo "pandoc'ing $CHAPTERS to thesis.pdf"

pandoc --bibliography=$BIBLIOGRAPHY --csl=$CSL --metadata link-citations=true --pdf-engine=xelatex -H $PREAMBLE -V fontsize=12pt -V documentclass:book -V papersize:a4 -V classoption:openright -V subparagraph --top-level-division=chapter $CHAPTERS -s -o thesis.pdf

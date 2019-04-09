PANDOC=pandoc
CHAPTERS := $(shell cat chapters.list | grep -v '\#' | tr '\n' ' chapters/')
PREAMBLE=tex/preamble.tex
BIBLIOGRAPHY=bibliography.bib
CSL=csl/chicago-author-date.csl
TEMPLATE=tex/thesis-template.latex
OUTPUTFORMAT=tex

all: thesis.$(OUTPUTFORMAT)

thesis.$(OUTPUTFORMAT): $(CHAPTERS) $(PREAMBLE) $(CSL) $(BIBLIOGRAPHY) $(TEMPLATE) Makefile
	@echo "Removing unnecessary fields from bibliography ..."
	bibtool -i $(BIBLIOGRAPHY) -o thesis.bib -- "delete.field { doi url annote abstract }"
	@echo "pandoc'ing $(CHAPTERS) to thesis.$(OUTPUTFORMAT)"
	@echo " "
	$(PANDOC) -F pandoc-latex-environment -F pandoc-tablenos \
		--bibliography=thesis.bib --natbib \
		--metadata link-citations=true --pdf-engine=lualatex -H $(PREAMBLE) \
		-V fontsize=12pt -V documentclass:tufte-book \
		-V classoption:a4paper -V papersize:a4 -V classoption:openright \
		-V subparagraph -V lof -V lot --top-level-division=chapter \
		--template=$(TEMPLATE) \
		metadata.yaml $(CHAPTERS) -s -o $@
	./latexmk-fast.sh thesis.tex
	rm -f thesis.bib

clean:
	rm -f thesis.$(OUTPUTFORMAT)
	rm -f thesis.bbl
	rm -f thesis.bib
	latexmk -c -f thesis.tex


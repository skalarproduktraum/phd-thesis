PANDOC=pandoc
CHAPTERS := $(shell cat chapters.list | tr '\n' ' chapters/')
PREAMBLE=tex/preamble.tex
BIBLIOGRAPHY=bibliography.bib
CSL=csl/chicago-author-date.csl
OUTPUTFORMAT=tex

all: thesis.$(OUTPUTFORMAT)

thesis.$(OUTPUTFORMAT): $(CHAPTERS) $(PREAMBLE) $(CSL) $(BIBLIOGRAPHY) Makefile
	@echo "pandoc'ing $(CHAPTERS) to thesis.$(OUTPUTFORMAT)"
	@echo " "
	$(PANDOC) -F pandoc-latex-environment -F pandoc-tablenos \
		--bibliography=$(BIBLIOGRAPHY) --natbib \
		--metadata link-citations=true --pdf-engine=lualatex -H $(PREAMBLE) \
		-V fontsize=12pt -V documentclass:tufte-book -V papersize:a4 -V classoption:openright \
		-V subparagraph -V lof -V lot --top-level-division=chapter \
		--template=tex/thesis-template.latex \
		metadata.yaml $(CHAPTERS) -s -o $@
	latexmk -pdflatex=lualatex -pdf thesis.tex
	latexmk -c

clean:
	rm thesis.$(OUTPUTFORMAT)


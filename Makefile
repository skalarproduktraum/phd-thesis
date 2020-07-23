PANDOC=pandoc
CHAPTERS := $(shell cat chapters.list | grep -v '\#' | tr '\n' ' chapters/')
PREAMBLE=tex/preamble.tex
CSL=csl/chicago-author-date.csl
TEMPLATE=tex/thesis-template.latex
OUTPUTFORMAT=tex

all: thesis.$(OUTPUTFORMAT)

thesis.$(OUTPUTFORMAT): $(CHAPTERS) $(PREAMBLE) $(CSL) $(BIBLIOGRAPHY) $(TEMPLATE) tufte-common-local.tex chapters.list chapters/statement-of-authorship.md Makefile
	@echo "pandoc'ing $(CHAPTERS) to thesis.$(OUTPUTFORMAT)"
	@echo " "
	$(PANDOC) -F pandoc-latex-environment -F pandoc-tablenos \
		--bibliography=thesis.bib --natbib \
		--metadata link-citations=true --pdf-engine=lualatex -H $(PREAMBLE) \
		-V fontsize=12pt -V documentclass:tufte-book \
		-V classoption:a4paper -V classoption:justified -V papersize:a4 -V classoption:openright \
		-V subparagraph -V lof -V lot --top-level-division=chapter \
		--include-after-body=chapters/statement-of-authorship.md \
		--template=$(TEMPLATE) -N \
		metadata.yaml $(CHAPTERS) -s -o $@
	# sed -ie 's/\\cite[t,p]{/\\cite{/g' thesis.tex
	bash ./latexmk-fast.sh thesis.tex

clean:
	rm -f thesis.$(OUTPUTFORMAT)
	rm -f thesis.bbl
	latexmk -c -f thesis.tex


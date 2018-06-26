PANDOC=pandoc
CHAPTERS := $(shell cat chapters.list | tr '\n' ' chapters/')
PREAMBLE=tex/preamble.tex
BIBLIOGRAPHY=thesis.bib
CSL=csl/pnas.csl
OUTPUTFORMAT=pdf

all: thesis.$(OUTPUTFORMAT)

thesis.$(OUTPUTFORMAT): $(CHAPTERS) $(PREAMBLE) $(CSL) $(BIBLIOGRAPHY)
	@echo "pandoc'ing $(CHAPTERS) to thesis.$(OUTPUTFORMAT)"
	@echo " "
	$(PANDOC) --bibliography=$(BIBLIOGRAPHY) --csl=$(CSL) \
		--metadata link-citations=true --pdf-engine=xelatex -H $(PREAMBLE) \
		-V fontsize=12pt -V documentclass:book -V papersize:a4 -V classoption:openright \
		-V subparagraph --top-level-division=chapter \
		$(CHAPTERS) -s -o $@

clean:
	rm thesis.$(OUTPUTFORMAT)

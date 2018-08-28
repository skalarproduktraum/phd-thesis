# ulrik's official phd thesis repository

## Requirements

* [pandoc](https://pandoc.org)
* pandoc-citeproc
* [mermaid-filter](https://github.com/raghur/mermaid-filter) for diagram creation
* [pandoc-latex-environment](https://github.com/chdemko/pandoc-latex-environment) for using LaTeX environments in Pandoc Markdown documents
* a working TeX distribution that includes XeLaTeX and BiBTeX, e.g. TeXLive

## Building

* Put chapters in wanted order in `chapters.list`, can include both TeX and
Markdown files.
* Run `make`, rest happens magically.

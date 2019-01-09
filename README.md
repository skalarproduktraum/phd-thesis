# ulrik's official phd thesis repository

## Requirements

* [pandoc](https://pandoc.org)
* pandoc-citeproc
* [pandoc-latex-environment](https://github.com/chdemko/pandoc-latex-environment) for using LaTeX environments in Pandoc Markdown documents
* [bibtool](http://gerd-neugebauer.de/software/TeX/BibTool/en/), available for most Linux distributions via their package manager, and on Homebrew
* a working TeX distribution that includes XeLaTeX and BiBTeX, e.g. TeXLive

## Building

* Put chapters in wanted order in `chapters.list`, can include both TeX and
  Markdown files.
* Bibliography is in `bibliography.bib`, and will be filtered by bibtool to get rid of fields that often cause issues (e.g. `abstract`, `annote`, `url`,...)
* Run `make`, rest happens magically.

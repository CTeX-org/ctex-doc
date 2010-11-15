## Makefile
## Copyright 2003-2005  Nicolas Markey
#
# This work may be distributed and/or modified under the
# conditions of the LaTeX Project Public License, either version 1.3
# of this license or (at your option) any later version.
# The latest version of this license is in
#   http://www.latex-project.org/lppl.txt
# and version 1.3 or later is part of all distributions of LaTeX
# version 2003/12/01 or later.
#
# This work has the LPPL maintenance status "maintained".
# The Current Maintainer of this work is Nicolas Markey

all:
	LATEX=xelatex make tex

tex:	*.tex
	${LATEX} ttb-zh-cn.tex
	makeindex -s idxstyle.ist bibtex
	makeindex -s idxstyle.ist latex
	bibtex ttb-zh-cn
	${LATEX} ttb-zh-cn.tex
	${LATEX} ttb-zh-cn.tex

clean:
	rm -f *.aux ttb-zh-cn.log ttb-zh-cn.blg *.ilg *.ind *.idx \
	  ttb-zh-cn.bbl ttb-zh-cn.toc ttb-zh-cn.dvi ttb-zh-cn.out \
	  ttb-zh-cn.ptc* ttb-zh-cn.mtc* ttb-zh-cn.bmt *
~

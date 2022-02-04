.PHONY: ctan doc install save test

test:
	l3build ckeck

ctan:
	l3build ctan

doc:
	latexmk -xelatex *-doc.tex

install:
	l3build install

save:
	bash tools/l3build-save.sh

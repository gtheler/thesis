all: pdf html epub

pdf: hash
	cp math-for-latex.md math-macros.md
	quarto render --to pdf --no-clean
	mv _book/phd-theler.pdf _book/phd-theler-$(shell grep git_hash _date.yml.local | cut -f2 -d: | tr -d " ").pdf
	cd _book; ln -s phd-theler-$(shell grep git_hash _date.yml.local | cut -f2 -d: | tr -d " ").pdf phd-theler.pdf

html: hash
	cp math-for-katex.md math-macros.md
	quarto render --to html --no-clean

epub: html
	quarto render --to epub3 --no-clean
	mv _book/phd-theler.epub _book/phd-theler-$(shell grep git_hash _date.yml.local | cut -f2 -d: | tr -d " ").epub
	cd _book; ln -s phd-theler-$(shell grep git_hash _date.yml.local | cut -f2 -d: | tr -d " ").epub phd-theler.epub

clean:
	rm -rf _book

hash:
	./hash.sh


.PHONY: all pdf clean hash


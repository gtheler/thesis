pdf:
	./hash.sh
	cp math-pdf.md math.md
	cp full.yml _quarto.yml
	quarto render --to pdf
	mv _book/phd-theler.pdf _book/phd-theler-$(shell grep git_hash _date.yml.local | cut -f2 -d: | tr -d " ").pdf
	cd _book; ln -s phd-theler-$(shell grep git_hash _date.yml.local | cut -f2 -d: | tr -d " ").pdf phd-theler.pdf

single:
	./hash.sh
	cp math-pdf.md math.md
	cp single.yml _quarto.yml
	quarto render --to pdf
	mv _book/phd-theler.pdf _book/phd-theler-$(shell grep git_hash _date.yml.local | cut -f2 -d: | tr -d " ").pdf
	cd _book; ln -s phd-theler-$(shell grep git_hash _date.yml.local | cut -f2 -d: | tr -d " ").pdf phd-theler.pdf


html:
	./hash.sh
	cp math-html.md math.md
	quarto render --to html

	
clean:
	rm -rf _book

.PHONY: pdf clean

all: pdf

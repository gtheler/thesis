pdf:
	./hash.sh
	cp math-pdf.md math.md
	quarto render --to pdf

html:
	./hash.sh
	cp math-html.md math.md
	quarto render --to html

	
clean:
	rm -rf _book

.PHONY: pdf clean

all: pdf

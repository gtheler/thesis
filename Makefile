pdf:
	./hash.sh
	quarto render --to pdf

html:
	./hash.sh
	quarto render --to html

	
clean:
	rm -rf _book

.PHONY: pdf clean

all: pdf

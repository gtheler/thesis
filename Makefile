build:
	./hash.sh
	quarto render --to pdf

clean:
	rm -rf _book

.PHONY: build clean

all: build

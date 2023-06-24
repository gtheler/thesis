# Ecuaciones diferenciales en la nube: aplicación al transporte de neutrones

A PhD thesis written in markdown.

# Dependencias

 * Git
 * Quarto
 * Pandoc
 * XeLaTeX
 * Inkscape

# Compilar a PDF

```
make
```

o

```
make pdf
```

generan `_book/phd-theler.pdf`.

# Compilar a HTML

```
make html
```

genera `_book/index.html`.

# Caveats

 * El hash del último commit va a parar al footer del PDF y al index del HTML
 * Trato de no usar un custom template porque seguro que en algún momento pandoc lo cambia y deja de compilar
 * No me termina de convencer el estilo IEEE de CSL
 
# License
 
Shield: [![CC BY 4.0][cc-by-shield]][cc-by]

This work is licensed under a
[Creative Commons Attribution 4.0 International License][cc-by].

[![CC BY 4.0][cc-by-image]][cc-by]

[cc-by]: http://creativecommons.org/licenses/by/4.0/
[cc-by-image]: https://i.creativecommons.org/l/by/4.0/88x31.png
[cc-by-shield]: https://img.shields.io/badge/License-CC%20BY%204.0-lightgrey.svg 

```{=latex}
% \vspace{-1cm}
```

# Resumen {.unnumbered .unlisted}

```{=latex}
% \vspace{0.25cm plus 0.25cm}
```

### {{< meta title >}} {.unnumbered  .unlisted}

```{=latex}
% \vspace{0.15cm plus 0.15cm}
```

Las herramientas neutrónicas a nivel de núcleo tradicionales suelen resolver la ecuación de difusión de neutrones multigrupo sobre mallas estructurales hexahédricas.
Aunque este enfoque puede ser razonable para reactores de potencia de agua liviana, los núcleos en los cuales el moderador está separador del refrigerante---como por ejemplo los reactores de potencia de agua peasda y algunos reactores de investigación---no pueden ser representados en forma precisa con mallas estructuradas.
En este trabajo, mostramos cómo podemos usar una herramienta libre y abierta que permite escalabilidad en paralelo corriendo en la nube para resolver ecuaciones en derivadas parciales discretizadas espacialmente con el método de elementos finitos para resolver neutrónica a nivel de núcleo con el método angular de ordenadas discretas S$_N$ multigrupo.
Esta herramienta, llamada FeenoX y desarrollada desde cero usando la filosofía de programación Unix, puede resolver PDEs genéricas al proveeer un mecanimos basado en puntos de entrada arbitrarios usando apuntadores a funciones de C que construyen los objetos elementales de la formulación FEM.
También permite escalar en paralelo utilizando el estándar MPI de forma que pueda ser lanzada sobre varios servidores en la nube.
De esta manera, en principio, problemas arbitrariamente grandes pueden ser divididos en trozos más que pequeños con técnicas de descomposición de dominio para poder franquear las limitaciones usuales en términos de memoria RAM.
Dos de las PDEs que esta versión inicial del código puede resolver incluyen difusión de neutrones multigrupo y transporte de neutrones usando el método de ordenadas discretas.

Esta tesis explica la matemática de la ecuación de transporte de neutrones, cómo la aproximación de difusión puede ser derivada a partir de la primera y una de las posibles discretizaciones en espacio y tiempo de estas ecuaciones. También discute el diseño e implementación de FeenoX que cumple un conjunto de especificaciones de requerimientos (SRS) ficticio (pero plausible) proponiendo un documento de especificaciones de diseño (SDS) explicando cómo la herramienta desarrollada aborda cada uno de los requerimientos del pliego.
En el capítulo de resultados, resolvemos diez problemas neutrónicos. Todos ellos necesitan al menos una de las características distintivas de FeenoX: 1. simulación programática (derivada de la filosofpia Unix); 2. mallas no estructuradas; 3. ordenadas discretas; 4. paralelización con MPI.
Este trabajo sienta las bases para eventuales estudios numéricos comparando los esquemas de S$_N$ y difusión para análisis avanzados de reactores.

---
comment: |
  * state the problem
  * say why it's an interesting problem
  * say what your solution achieves
  * say what follows from your solution
...

```{=latex}
\vspace{\fill}
```

Palabras clave

:   {{< meta palabras_clave >}}

Revisión

:   {{< meta git_hash >}}


```{=latex}
%\vspace{0.5cm plus 0.5cm minus 0.5cm}
```

```{=latex}
\begin{centering}
```

![](by){width=1.25cm} Tesis distribuida bajo licencia [Creative Commons Attribution 4.0 International](http://creativecommons.org/licenses/by/4.0/")

```{=latex}
\end{centering}
```


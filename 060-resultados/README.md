# Resultados {#sec-resultados}

::::: {.chapterquote data-latex=""}
::: {lang=en-US}
> FeenoX has releases with a proper tarball! It has `INSTALL`, `./configure` and 
> just compiles. Wow. Yeah, these are free software basics, but majority of 
> the sim software (some discrete circuit simulators included!) I've tried 
> fail on most of these points. So thanks for making quality software!
>
> _Tibor 'Igor2' Palinkas, maintainer of the open source PCB editor pcb-rnd_
:::

> Es el "tocate una que sepamos todos" de S$_N$.
>
> _Dr. Ignacio Márquez Damián, sobre el problema de Reed (2023)_
:::::


\vspace{-1cm plus 0.5cm minus 0.5cm}

En este capítulo mostramos diez problemas resueltos con la herramienta computacional FeenoX descripta en el @sec-implementacion que ilustran algunas de sus características particulares.
Cada uno de estos diez problemas no puede ser resuelto con un [solver]{lang=en-US} neutrónico a nivel núcleo que no soporte alguno de los cuatro puntos distintivos de FeenoX:

 a. Filosofía Unix, integración en scripts y simulación programática
 b. Mallas no estructuradas
 c. Ordenadas discretas (además de difusión)
 d. Paralelización en varios nodos de cálculo con MPI
 
 Problema                                              |    a    |    b    |    c    |    d
:------------------------------------------------------|:-------:|:-------:|:-------:|:-------:
 Mapeo en mallas no conformes ([-@sec-non-conformal])  |    ●    |    ●    |         |    ◓
 El problema de Reed ([-@sec-reed])                    |    ○    |    ◓    |    ●    | 
 Benchmark PWR IAEA ([-@sec-2dpwr])                    |    ◓    |    ●    |         |    ◓
 El problema de Azmy ([-@sec-azmy])                    |    ●    |    ●    |    ●    |    ○
 Benchmarks de Los Alamos ([-@sec-losalamos])          |    ●    |    ◓    |    ●    |
 Slab a dos zonas ([-@sec-slab])                       |    ●    |    ●    |         |
 Reactor cubo-esfera ([-@sec-cubesphere])              |    ●    |    ●    |         |
 El problema de los pescaditos ([-@sec-pescaditos])    |    ●    |    ●    |    ○    |
 MMS con el Stanford bunny ([-@sec-mms-dif])           |    ●    |    ●    |    ○    |    ○
 PHWR vertical con barras inclinadas ([-@sec-phwr])    |    ●    |    ●    |    ●    |    ●

\vspace{-0.5cm plus 0.25cm minus 0.25cm}
\nopagebreak 
 
|   |                         |   |                         |   |                         |
|:-:|:------------------------|:-:|:------------------------|:-:|:------------------------|
| ● | requerido               | ◓ | recomendado             | ○ | opcional                |

---
comment: |
  * ● requerido
  * ◓ recomendado
  * ○ opcional
...


::: {.remark} 
Excepto el primer problema de la @sec-non-conformal, este capítulo se centra en resolver neutrónica a nivel de núcleo tanto con difusión como con ordenadas discretas.
En el documento [Software Design Specifications]{lang=en-US} del @sec-sds se pueden encontrar otro tipo de problemas que ilustran cómo FeenoX resuelve los requerimientos del @sec-srs. En la [página web de FeenoX](https://www.seamplex.com/feenox), en particular en el apartado de ejemplos, se pueden encontrar más problemas resueltos divididos por tipo de ecuación en derivadas parciales (conducción de calor, elasticidad lineal, análisis modal, netrónica por difusión, neutrónica por ordenadas discretas).
:::

::: {.remark}
Todos los archivos necesarios para reproducir los resultados mostrados en este capítulo, junto con el fuente original de esta tesis en Markdown y los archivos de metadata necesarios para compilar a PDF y/o HTML a través de LaTeX, están dispnibles en <https://github.com/gtheler/thesis> bajo licencia CC-BY. Todas las herramientas utilizadas, incluyendo el sistema operativo, el mallador, el propio solver FeenoX, los post-procesadores, los graficadores, los generadores de documentación (y todas las bibliotecas de las cuales todo este software depende) son libres y/o de código abierto.
:::

::: {.remark}
Las mallas de los problemas resueltos en este capítulo son generadas con la herramienta de mallado Gmsh @gmsh y las vistas de post-procesamiento son creadas con la herramienta ParaView. Ambas son libres, abiertas y amenas a la simulación programática.
:::



```{.include shift-heading-level-by=1}
060-resultados/010-non-conformal-mesh-mapping/README.md
```

```{.include shift-heading-level-by=1}
060-resultados/020-reed/README.md
```

```{.include shift-heading-level-by=1}
060-resultados/030-iaea-2d/README.md
```

```{.include shift-heading-level-by=1}
060-resultados/040-azmy/README.md
```

```{.include shift-heading-level-by=1}
060-resultados/050-los-alamos/README.md
```

```{.include shift-heading-level-by=1}
060-resultados/060-two-zone-slab/README.md
```

```{.include shift-heading-level-by=1}
060-resultados/070-cube-sphere/README.md
```

```{.include shift-heading-level-by=1}
060-resultados/080-pescaditos/README.md
```

```{.include shift-heading-level-by=1}
060-resultados/090-mms/README.md
```

```{.include shift-heading-level-by=1}
060-resultados/100-phwr/README.md
```

# Resultados {#sec-resultados}

::::: {lang=en-US}
::: {.chapterquote data-latex=""}
> | A good hockey player plays where the puck is.  
> | A great hockey player plays where the puck is going to be.
>
> _Wayne Gretzky_
:::
:::::


::: {.chapterquote data-latex=""}
> Es el "tocate una que sepamos todos" de S$_N$.
>
> _Dr. Ignacio Márquez Damián, sobre el problema de Reed (2023)_
:::



Cada uno de estos diez problemas no puede ser resuelto con una herramienta computacional neutrónica de nivel núcleo que no soporte alguno de los cuatro puntos distintivos de FeenoX:

 a. Filosofía Unix, especialmente integración en scripts
 b. Mallas no estructuradas
 c. Ordenadas discretas (además de difusión)
 d. Paralelización en varios nodos de cálculo
 

 Problema                                      |       Unix       |     Mallas       |       S$_N$      |  Paralelización
:----------------------------------------------|:----------------:|:----------------:|:----------------:|:-----------------:
 Mallas no conformes ([-@sec-non-conformal])   |       ●          |        ●         |                  |         ◓
 Reed ([-@sec-reed])                           |       ○          |        ◓         |         ●        |
 IAEA 2D PWR ([-@sec-2dpwr])                   |       ◓          |        ●         |                  | 
 Azmy ([-@sec-azmy])                           |       ●          |        ●         |         ●        |         ○
 Los Alamos ([-@sec-losalamos])                |       ●          |        ◓         |         ●        |
 Slab a dos zonas ([-@sec-slab])               |       ●          |        ●         |                  |
 Cubo-esfera ([-@sec-cubesphere])              |       ●          |        ●         |                  |
 Pescaditos ([-@sec-pescaditos])               |       ●          |        ●         |         ○        |
 Stanford bunny ([-@sec-mms])                  |       ●          |        ●         |         ○        |
 Vertical PHWR ([-@sec-phwr])                  |                  |        ●         |         ◓        |         ●
 

 * ● requerido
 * ◓ recomendado
 * ○ opcional

::: {.remark} 
Ver apéndice para más problemas.
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




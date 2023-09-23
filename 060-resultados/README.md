# Resultados {#sec-resultados}

```{=latex}
\begin{chapterquote}
```
::: {lang=en-US}
A good hockey player plays where the puck is.  
A great hockey player plays where the puck is going to be.

\smallskip

_Wayne Gretzky_
:::
```{=latex}
\end{chapterquote}
```

Cada uno de estos diez problemas no puede ser resuelto con una herramienta computacional que no soporte alguno de los cuatro puntos distintivos de FeenoX:

 a. Filosofía Unix, especialmente integración en scripts
 b. Mallas no estructuradas
 c. Ordenadas discretas (además de difusión)
 d. Paralelización en varios nodos de cálculo
 

 Problema                                 |       Unix       |     Mallas       |       S$_N$      |  Paralelización
:-----------------------------------------|:----------------:|:----------------:|:----------------:|:-----------------:
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
060-resultados/non-conformal-mesh-mapping/README.md
```


## El problema de Reed {#sec-reed}

> Este problema tiene curiosidad histórica, es uno de los problemas más sencillos no triviales que podemos encontrar y sirve para mostrar que para tener en cuenta regiones vacías no se puede utilizar una formulación de difusión.


## IAEA PWR Benchmark {#sec-2dpwr}

> El problema original de 1976 propone resolver un cuarto de núcleo cuando en realidad la simetría es 1/8.

### Caso 2D original

### Caso 2D con simetría 1/8

### Caso 2D con reflector circular

### Caso 3D original con simetría 1/8




## El problema de Azmy {#sec-azmy}

> Este problema ilustra el "efecto rayo" de la formulación de ordenadas discretas.
> Para estudiar completamente el efecto se necesita o rotar la geometría con respecto a las direcciones de S$_N$.

## Benchmarks de criticidad de Los Alamos {#sec-losalamos}

> Curiosidad histórica y verificación con el método de soluciones exactas.

## Slab a dos zonas, efecto de dilución de XSs {#sec-slab}

> Este problema ilustra el error cometido al analizar casos multi-material con mallas estructuradas donde la interfaz no coincide con los nodos de la malla.


## Estudios paramétricos: el reactor cubo-esfera {#sec-cubesphere}

> No es posible resolver una geometría con bordes curvos con una malla cartesiana estructurada.

## Optimización: el problema de los pescaditos {#sec-pescaditos}

> Composición con una herramienta de optimización.

## Verificación con el método de soluciones fabricadas {#sec-mms}

> Para verificar los métodos numéricos con el método de soluciones fabricadas se necesita un solver que permita definir propiedades materiales en función del espacio a través de expresiones algebraicas.

reactor tipo conejo
MMS

ver thermal-slab-transient-mms-capacity-of-T.fee  thermal-slab-transient-mms.fee


## PHWR de siete canales y tres barras de control inclinadas {#sec-phwr}

> Mallas no estructuradas, dependencias espaciales no triviales, escalabilidad.




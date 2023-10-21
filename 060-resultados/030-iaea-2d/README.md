# IAEA PWR Benchmark {#sec-2dpwr}

> **TL;DR:** El problema original de 1976 propone resolver un cuarto de núcleo cuando en realidad la simetría es 1/8.

Este problema fue propuesto por Argonne National Laboratory @anl7416 y luego adoptado por la IAEA como un benchmkar estándar para validar códigos de difusión. Está compuesto

 a. por un problema 2D que representa un cuarto de una geometría típica de PWR sobre el plano $x$-$y$ más un buckling geométrico para tener en cuenta las pérdidas en la dirección $z$, y
 b. un problema completamente tridimensional de un cuarto de núcleo

## Caso 2D original

La @fig-iaea-2dpwr-figure, preparada en su momento para la publicación @unstructured-stni, muestra la geometría del problema.
La @tbl-iaea-xs muestra las secciones eficaces macroscópicas a dos grupos de cada zona.
El problema pide calcular varios puntos, incluyendo

 * el factor de multiplicación efectivo $k_\text{eff}$
 * perfiles de flujo a lo largo de la diagonal
 * valores y ubicación de flujos máximos
 * potencias medias en cada canal


![Caso 2D original del benchmark PWR de IAEA](iaea-2dpwr-figure.svg){#fig-iaea-2dpwr-figure}


::: {#tbl-iaea-xs}

Región | $D_1$ | $D_2$ | $\Sigma_{s1 \rightarrow 2}$ | $\Sigma_{a1}$ | $\Sigma_{a2}$ | $\nu\Sigma_{f2}$ | Material
:-----:|:-----:|:-----:|:-----:|:-----:|:-----:|:-----:|:-------------:
   1   |  1.5  |  0.4  | 0.02  | 0.01  | 0.08  | 0.135 | Fuel 1
   2   |  1.5  |  0.4  | 0.02  | 0.01  | 0.085 | 0.135 | Fuel 2
   3   |  1.5  |  0.4  | 0.02  | 0.01  | 0.13  | 0.135 | Fuel 2 + Rod
   4   |  2.0  |  0.3  | 0.04  |  0    | 0.01  |   0   | Reflector
   5   |  2.0  |  0.3  | 0.04  |  0    | 0.055 |   0   | Refl. + Rod

: {#tbl-iaea-xs2}

Secciones eficaces macroscópicas (uniformes por zonas) del benchmark PWR de IAEA
:::


En la referencia @unstructured-stni hemos resuelto completamente el problema utilizando una versión anterior de FeenoX, incluso utilizando triángulos y cuadrángulos, diferentes algoritmos y densidades de mallado, etc. Más aún, esa versión era capaz de resolver la ecuación de difusión tanto con elementos como con volúmenes finitos tal como explicamos en la monografía @monografia.
En esta sección calculamos solamente el factor de multiplicación y la distribución espacial de flujos.
En este caso vamos a prestar más atención al archivo de entrada de FeenoX que a la generación de la malla, que para este caso puede ser estructurada como mostramos en la @fig-iaea-2dpwr-quarter.

![Malla para el caso 2D original con simetría 1/4](iaea-2dpwr-quarter.png){#fig-iaea-2dpwr-quarter width=50%}

```{.feenox include="iaea-2dpwr.fee"}
```

::: {.remark}
Hay una relación bi-unívoca bastate clara entre la definición del problema en el reporte @anl7416 y el archivo de entrada necesario para resolverlo con FeenoX.
El lector experimentado podrá notar que esta característica (que es parte de la base de diseño del software) no es común en otros solvers, ni neutrónicos ni termo-mecánicos.
:::

```terminal
$ gmsh -2 iaea-2dpwr-quarter.geo
[...]
Info    : Done meshing 2D (Wall 0.0422971s, CPU 0.042152s)
Info    : 1033 nodes 1286 elements
Info    : Writing 'iaea-2dpwr-quarter.msh'...
Info    : Done writing 'iaea-2dpwr-quarter.msh'
Info    : Stopped on Fri Oct 20 15:55:03 2023 (From start: Wall 0.0522626s, CPU 0.060603s)
$ time feenox iaea-2dpwr.fee
grados de libertad =    2066
keff =  1.02985

real    0m0.696s
user    0m0.090s
sys     0m0.162s
$
```

## Caso 2D con simetría 1/8

Bien mirado, el problema no tiene simetría 1/4 sino simetría 1/8.
Sucede que para poder explotar dicha simetría se necesita una malla no estructurada, que ni en 1976 ni en 2023 (excepto algunos casos puramente académicos como [@chaboncito, @park, @babcsany]) es una característica de los solvers neutrónicos de nivel de núcleo. De hecho el paper @unstructured-stni justamente ilustra el hecho de que las mallas estructuradas permiten reducir la cantidad de grados de libertad necesarios para resolver un cierto problema.

![Malla para el caso 2D original con simetría 1/8](iaea-2dpwr-eighth.png){#fig-iaea-2dpwr-eighth width=50%}

Utilizando `eighth` como argumento `$1` podemos usar el mismo archivo de entrada pero con la malla de la @fig-iaea-2dpwr-eighth:

```terminal
$ gmsh -2 iaea-2dpwr-eighth.geo
[...]
Info    : 668 nodes 1430 elements
Info    : Writing 'iaea-2dpwr-eighth.msh'...
Info    : Done writing 'iaea-2dpwr-eighth.msh'
Info    : Stopped on Fri Oct 20 17:58:06 2023 (From start: Wall 0.0331908s, CPU 0.040327s)
$ time feenox iaea-2dpwr.fee eighth
grados de libertad =    1336
keff =  1.02974

real    0m0.681s
user    0m0.075s
sys     0m0.161s
$
```


![Flujos rápidos y térmicos en el problema 2D de IAEA con simetría 1/8](iaea-2dpwr-fluxes.png){#fig-iaea-2dpwr-fluxes width=80%}

::: {.remark}
El tiempo de CPU reportado por `time`  es el mismo independiente de la cantidad de grados de libertad.
Esto indica que el tama&ntilde;o del problema es muy peque&ntilde; y el tiempo necesario para construir las matrices y resolverlas es despreciable frente al [overhead]{lang=en-US] de cargar un ejecutable, inicializar bibliotecas compartidas, etc.
Podemos verificar esta afirmaci'on analizando la salida de la opcion `--log_view` que le indica a PETSc que agregue una salida con datos de performance:

```terminal
$ feenox iaea-2dpwr.fee eighth --log_view
grados de libertad =    1336
keff =  1.02974
[...]
Summary of Stages:   ----- Time ------  ----- Flop ------  --- Messages ---  -- Message Lengths --  -- Reductions --
                        Avg     %Total     Avg     %Total    Count   %Total     Avg         %Total    Count   %Total
 0:      Main Stage: 2.0911e-03   7.7%  0.0000e+00   0.0%  0.000e+00   0.0%  0.000e+00        0.0%  0.000e+00   0.0%
 1:            init: 2.1185e-04   0.8%  0.0000e+00   0.0%  0.000e+00   0.0%  0.000e+00        0.0%  0.000e+00   0.0%
 2:           build: 9.7703e-03  36.1%  0.0000e+00   0.0%  0.000e+00   0.0%  0.000e+00        0.0%  0.000e+00   0.0%
 3:           solve: 1.4487e-02  53.6%  1.9467e+07 100.0%  0.000e+00   0.0%  0.000e+00        0.0%  0.000e+00   0.0%
 4:            post: 4.8677e-04   1.8%  0.0000e+00   0.0%  0.000e+00   0.0%  0.000e+00        0.0%  0.000e+00   0.0%
[...]
$
```

En efecto, se necesitan menos de 10 milisegundos para construir las matrices del problema y menos de 15 para resolverlo.
:::

## Caso 2D con reflector circular

Mirando un poco más en detalle la geometría, hay un detalle que también puede ser considerado con mallas no estruturadas:
la superficie exterior del reflector.
En efecto, en una geometría tipo PWR cada uno de los canales proyecta un cuadrado en la sección transversal.
Pero el reflector sigue la forma del recipiente presión que es un cilindro (@fig-pwr).
Con FeenoX es posible resolver fácilmente esta geometría con el mismo archivo de entrada con la malla de la @fig-iaea-2dpwr-eighth-circular que incluye una mezcla de

 a. zonas estructuradas y no estructuradas, y
 b. triángulos y cuadrángulos.

![Geometría típica de un PWR](1694041862141.jpeg){#fig-pwr width=50%}

![Malla para el caso 2D con simetría 1/8 y reflector circular](iaea-2dpwr-eighth-circular.png){#fig-iaea-2dpwr-eighth-circular width=50%}

```terminal
$ gmsh -2 iaea-2dpwr-eighth-circular.geo
Info    : 524 nodes 680 elements
Info    : Writing 'iaea-2dpwr-eighth-circular.msh'...
Info    : Done writing 'iaea-2dpwr-eighth-circular.msh'
Info    : Stopped on Fri Oct 20 17:58:37 2023 (From start: Wall 0.0314288s, CPU 0.043231s)
$ time feenox iaea-2dpwr.fee eighth-circular
grados de libertad =    1048
keff =  1.02970

real    0m0.649s
user    0m0.048s
sys     0m0.156s
$
```

## Caso 3D con simetría 1/8, reflector circular resuelto con difusión



## Caso 3D con simetría 1/8, reflector circular resuelto con S$_4$


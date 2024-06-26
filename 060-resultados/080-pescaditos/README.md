# Optimización: el problema de los pescaditos {#sec-pescaditos}

> **TL;DR:** Estudios paramétricos y de optimización al estilo Unix.

\renewcommand{\vec}[1]{\mathbf{#1}}


Los tres problemas de esta sección---inventados para escribir el artículo @enief2013-opt---ilustran cómo generalizar las facilidades que provee FeenoX para realizar estudios paramétricos (tal como ya hemos hecho en casi todos los problemas anteriores) para dar un paso más allá y resolver un problema de optimización. Para eso comenzamos resolviendo numéricamente "el problema del pescadito^[Decidimos usar la palabra _pescadito_ en lugar de _pececito_ ya que es mucho más simpática. Además, es poco probable que un pez pueda sobrevivir nadando en un reactor líquido homogéneo de sales fundidas.]", que es un clásico en la teoría de perturbaciones lineales.
Agregamos luego un segundo pescadito que nada en forma diametralmente opuesta al primero donde mostramos cómo aparecen los dos efectos de apantallamiento y anti-apantallamiento según las posiciones relativas de ambos pescaditos.
Pasamos finalmente a dejar dos pescaditos fijos y resolver la pregunta: ¿dónde tenemos que poner un tercer pescadito para que la reactividad neta sea mínima?

::: {.remark}
El problema "tradicional" de los pescaditos en tri-dimensional.
En esta sección nos quedamos con la versión en dos dimensiones para simplificar el tratamiento---especialmente en la @sec-tres-pescaditos---pero el espíritu es el mismo.
:::

::: {.remark}
En los dos primeros problemas podríamos explotar la simetría para reducir el tamaño del problema pero preferimos resolver la geometría completa para ilustrar mejor el problema. Ya hemos discutido la reducción del número total de grados de libertad en la @sec-2dpwr.
:::


## Un pescadito: teoría de perturbaciones lineales {#sec-un-pescadito}

Consideremos un reactor bi-dimensional circular de radio $A$ con centro en el origen del plano $x$-$y$ y con secciones eficaces macroscópicas homogéneas a un grupo de energías.
Supongamos que un pescadito circular absorbente de radio $a$ puede moverse a lo largo del eje $x$ positivo.
Un ejercicio clásico de análisis de reactores es dar la reactividad negativa introducida por el pescadito en función de la posición $x = r$ de su centro utilizando teoría de perturbaciones (es decir, suponiendo que $a \ll A$.

![Un pescadito de radio $a$ nada a lo largo del eje $x$ en un reactor homogéneo de radio $A$.](un-pescadito-geo.svg){#un-pescadito-geo width=50%}

En esta sección vamos a obtener con FeenoX la reactividad neta introducida por el pescadito variando paramétricamente la posición $r \in [0:A-a]$ de su centro $x=r$, $y=0$. Para eso, comenzamos con un script de Bash que...

  1. genera un archivo de texto `vars.geo` (que es incluido desde `un-pescadito.geo` para ubicar el círculo pequeño correspondiente al pescadito),
  2. crea una malla no estructurada con Gmsh (@fig-un-pescadito-mesh)
  3. resuelve la ecuación de difusión con FeenoX para diferentes posiciones $r$ del pescadito.
  

::: {#fig-un-pescadito-mesh layout="[45,-10,45]"}
![$r=20$](un-pescadito-20.png){#fig-un-pescadito-20}

![$r=40$](un-pescadito-40.png){#fig-un-pescadito-40}
 
Mallas para un pescadito rojo de radio $a=2$ nadando dos posiciones $x=r$, $y=0$ en un reactor celeste de radio $A=50$.
:::


```{.bash include="un-pescadito.sh"}
```

::: {.remark}
Notar que a diferencia de los estudios paramétricos realizados hasta el momento que involucraban una serie creciente de valores, en este caso el bucle `for` de Bash se realiza sobre la salida del archivo de FeenoX `steps.fee`:

```{.feenox include="steps.fee"}
```
que genera una sucesión (determinística) de números cuasi-aleatorios que, eventualmente, llena densamente un hipercubo @sobol.
En los lazos paramétricos crecientes, si se desea aumentar la densidad del barrido hay que volver a calcular todo el intervalo nuevamente.
En una serie de números cuasi-aleatorios, es posible agregar nuevos puntos a los ya calculados dando un _offset_ inicial.
En la @sec-cinetica-puntual esta característica de las serie cuasi-aleatorias es más evidente ya que allí barremos densamente un espacio de parámetro bi-dimensional.
Por ejemplo, podemos barrer el intervalo $[0,1]$ con tres puntos con el archivo `steps.fee` como

```terminal
$ feenox steps.fee 0 1 3
0.5
0.75
0.25
$
```

Si luego del estudio quisiéramos agregar cuatro puntos más, comenzamos con el offset 3 para obtener 

```terminal
$ feenox steps.fee 0 1 4 3
0.375
0.875
0.625
0.125
$ 
```
:::

El archivo de entrada de Gmsh genera dos círculos y asigna etiquetas para materiales y condiciones de contorno:

```{.geo include="un-pescadito.geo"}
```

El archivo de entrada de FeenoX es muy sencillo:

```{.feenox include="un-pescadito.fee"}
```

La única "complejidad" aparece al calcular el incremento negativo de reactividad con respecto al $k_\text{eff}$ analítico del círculo original. Para ello ponemos una condición de contorno de flujo nulo en la circunferencia dentro del archivo incluido `xs.fee`:

```{.feenox include="xs.fee"}
```

::: {.remark}
La constante 2.4048 que aparece en el archivo de entrada de FeenoX es una aproximación del primer cero de la función $J_0(\xi)$ de Bessel.
:::

Al ejecutar el script obtenemos la curva que mostramos en la @fig-un-pescadito: mientras más alejado del centro nade el pescadito, menor es la reactividad neta introducida.

```terminal
$ ./un-pescadito.sh 
23.5    -606.765
35.25   -202.255
11.75   -1094.41
[...]
24.2344 -576.9
0.734375        -1339.52
1.10156 -1338.06
$
```

![Curva "S" de reactividad negativa introducida por un pescadito en un reactor circular.](un-pescadito.svg){#fig-un-pescadito}


## Dos pescaditos: estudio paramétrico no lineal {#sec-dos-pescaditos}

![Dos pescaditos de radio $a$ nadan a lo largo del eje $x$ en forma diametralmente opuesta.](dos-pescaditos-geo.svg){#fig-dos-pescaditos-geo width=50%}

Agreguemos ahora otro pescadito nadando en forma diametralmente opuesta al primero (@fig-dos-pescaditos-geo).
El script de Bash, el archivo de entrada de Gmsh y el de FeenoX son muy similares a los de la sección anterior por lo que no los mostramos.
Ahora al graficar la curva de reactividad en función de $r$ y compararla con el doble de la reactividad introducida por un único pescadito calculada en la sección anterior (@fig-dos-pescaditos) vemos los dos efectos explicados en el capítulo 14 de la referencia clásica @lamarsh (@fig-lamarsh-14-5).
Si los pescaditos están lejos entre sí sus reactividades negativas son más efectivas porque se anti-apantallan. Pero al acercarse, se apantallan y la reactividad neta es menor que por separado.



::: {#fig-shadowing layout="[90]"}
![Reactividad debida a dos pescaditos y el doble de la reactividad de uno solo.](dos-pescaditos.svg){#fig-dos-pescaditos}

![Figura 14-5 de la referencia @lamarsh](lamarsh-14-5.svg){#fig-lamarsh-14-5 width=75%}
 
Efecto de apantallamiento y anti-apantallamiento
:::


## Tres pescaditos: optimización {#sec-tres-pescaditos}

Supongamos ahora que agregamos un tercer pescadito. Por alguna razón, los primeros dos pescaditos están fijos en dos posiciones arbitrarias $[x_1,y_1]$ y $[x_2,y_2]$. Tenemos que poner el tercer pescadito en una posición $[x_3,y_3]$ de forma tal de hacer que la reactividad total sea lo menor posible.^[Reemplazar "pescadito" por "lanza de inyección de boro de emergencia" para pasar de un problema puramente académico a un problema de interés en ingeniería nuclear.]

Una forma de resolver este problema con FeenoX es atacarlo en forma similar a la manera en que procedimos que en las secciones anteriores. Pero ahora en lugar de variar la posición del tercer pescadito en forma paramétrica según una receta determinística ya conocida de antemano, utilizar un algoritmo de optimización que decida la nueva posición del tercer pescadito en función de la historia de posiciones y los valores de reactividad calculados por FeenoX en cada paso.

::: {.remark}
En la reciente tesis de maestría @perezwinter se emplea FeenoX para resolver la ecuación de calor y, mediante un script en Python, optimizar topológicamente el reflector de un reactor nuclear integrado. Esa tesis, junto con esta sección, ayuda a ilustrar el punto que queremos enfatizar sobre la flexibilidad en el diseño de FeenoX para ser utilizada como una herramienta de optimización. 
:::


En particular, podemos usar la biblioteca de Python SciPy que provee acceso a algoritmos de optimización y permite con muy pocas líneas de Python implementar el bucle de optimización:

```{.python include="tres.py"}
```

::: {.remark}
En forma deliberada hemos mostrado en este caso un driver script muy sencillo para mostrar que realmente es posible realizar un cálculo de optimización con muy poco código extra. Sin embargo, el esquema propuesto también funciona para otros algoritmos de optimización más complejos como recocido simulado, algoritmos genéticos o incluso aquellos basados en redes neuronales.
:::

La función `keff()` a optimizar es función de la posición $\vec{x}_3$ del tercer pescadito, cuyas dos componentes son pasadas como argumento al script de Bash que llama primero a Gmsh y luego a FeenoX para devolver el $k_\text{eff}(\vec{x}_3)$ para $\vec{x}_1$ y $\vec{x}_2$ fijos:

```{.bash include="tres.sh"}
```

```{.geo include="tres-pescaditos.geo"}
```

```{.feenox include="tres-pescaditos.fee"}
```

::: {.remark}
Si FeenoX, tal como Gmsh, tuviese una interfaz Python (tarea que está planificada e incluso tenida en cuenta en la base de diseño de FeenoX) entonces la función `keff(x3)` a minimizar sería más elegante que la propuesta, que involucra hacer un `fork()+exec()` para invocar a un script de Bash que hace otros dos `fork()+exec()` para ejecutar `gmsh` y `feenox`.
:::

La ejecución del script de optimización muestra la reactividad mínima en `fun` y la posición óptima del tercer pescadito en `x`. Podemos ver los pasos intermedios en la @fig-tres-pescaditos y [-@fig-tres3d].

```terminal
$ ./tres.py 
 final_simplex: (array([[ 3.55380249, -1.15953827],
       [ 3.41708565, -1.71419764],
       [ 3.89513397, -1.83193016]]), array([1.29409226, 1.29409476, 1.294099  ]))
           fun: 1.29409226
       message: 'Optimization terminated successfully.'
          nfev: 37
           nit: 20
        status: 0
       success: True
             x: array([ 3.55380249, -1.15953827])
$ 
```


![Pasos intermedios del problema de optimización de los tres pescaditos resuelto con el algoritmo de Nelder-Mead @neldermead.](tres-pescaditos.svg){#fig-tres-pescaditos width=80%}


::: {#fig-tres3d layout="[1,-0.05,1]"}
![](tres3d-1.svg){#fig-tres3d-1}

![](tres3d-2.svg){#fig-tres3d-2}
 
Factor de multiplicación $k_\text{eff}$ en función de la posición $\vec{x}_3$ para los pasos intermedios.
:::

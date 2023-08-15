# Implementación computacional {#sec-implementacion}

::::: {lang=en-US}
::: {.chapterquote data-latex=""}
> | A good hockey player plays where the puck is.
> | A great hockey player plays where the puck is going to be.
> |
> | _Wayne Gretzky_
:::
:::::


Hay virtualmente infinitas maneras de diseñar un programa para que una computadora para que realice una determinada tarea.
Y otras infinitas maneras de implementarlo. La herramienta computacional desarrollada en esta tesis, denominada [FeenoX](https://www.seamplex.com/feenox/), fue diseñada siguiendo un patrón frecuente en la industria de software:

 1. el "cliente" define un documento titulado [_Sofware Design Requirements_]{lang=en-US}, y
 2. el "proveedor" indica cómo cumplirá esos requerimientos en un [_Sofware Design Specifications_]{lang=en-US}. Una vez que ambas partes están de acuerdo, se comienza con el proyecto de ingeniería en sí con [kick-off meetings]{lang=en-US}, certificaciones de avance, órdenes de cambio, etc.

El SRS para FeenoX (@sec-srs) es ficticio pero plausible. Podríamos pensarlo como un llamado a licitación por parte de una empresa, entidad pública o laboratorio nacional, para que alguien desarrolle una herramienta computacional que permita resolver problemas matemáticos con interés práctico en aplicaciones de ingeniería. En forma muy resumida, requiere

 a. buenas prácticas generales de desarrollo de software tales como
 
    * trazabilidad del código fuente
    * integración continua
    * posibilidad de reportar errores
    * portabilidad razonable
    * disponibilidad de dependencias adecuadas
    * documentación apropiada
 
 b. que la herramienta pueda ser ejecutada en la nube

    * ejecución remota 
    * mecanismos de reporte de estado
    * paralelización en diferentes nodos computacionales
    
 c. que sea aplicable a problemas de ingeniería
  
    * eficiencia computacional razonable
    * flexibilidad en la definición de problemas
    * verificación y validación
    * extensibilidad
    
::: {.remark}
El requerimiento de paralelización está relacionado con el tamaño de los problemas a resolver y no (tanto) con la performance.
Si bien está claro que, de tener la posibilidad, resolver ecuaciones en forma paralela es más eficiente en términos del tiempo de pared^[Del inglés [_wall time_]{lang=en-US}.] necesario para obtener un resultado, en el SRS la posibilidad de paralelizar el código se refiere a la capacidad de poder resolver problemas de tamaño arbitrario que no podrían ser resueltos sin esta capacidad, principalmente por una limitación de la cantidad de memoria RAM.
:::

::: {.remark}
Si bien es cierto que en teoría un algoritmo implementado en un lenguaje Turing-completo podría resolver un sistema de ecuaciones algebraicas de tamaño arbitrario independientemente de la memoria RAM disponible (por ejemplo usando almacenamiento en dispositivos magnéticos o de estado sólido), prácticamente no es posible obtener un resultado útil en un tiempo razonable si no se dispone de suficiente memoria RAM para evitar tener que descargar el contenido de esta memoria de alta velocidad de acceso a medios alternativos ([out-of-core memory]{lang=en-US} como los mencionados en el paréntesis anterior) cuya velocidad de acceso es varios órdenes de magnitud más lenta.
:::

Según el pliego, es mandatorio que el software desarrollado sea de código abierto según la definición de la _Open Source Initiative_.
El SDS (@sec-sds) comienza indicando que la herramienta FeenoX es al software tradicional de ingeniería y a las bibliotecas especializadas de elementos finitos lo que Markdown es a Word y a LaTeX, respectivamente.
Y que no sólo es de código abierto en el sentido de la OSI sino que es libre en el sentido de la _Free Software Foundation_ @faif.
La diferencia entre código abierto y software libre es sutil más que práctica, ya que las definiciones técnicas prácticamente coinciden.
El punto principal de que el código sea abierto es que permite obtener mejores resultados con mejor performance mientras más personas puedan estudiar el código, escrutarlo y eventualmente mejorarlo. 
Por otro lado, el software libre persigue un fin ético relacionado con la libertad de poder ejecutar, distribuir, modificar y distribuir las modificaciones del software recibido.

::: {.remark}
Ninguno de los dos conceptos, código abierto o software libre se refiere a la idea de _precio_.
En Español no debería haber ninguna confusión. Pero en inglés, el sustantivo adjetivado [_free software_]{lang=en-US} se suele tomar como gratis en lugar de libre. Si bien es cierto que la mayoría de las veces la utilización de software libre y abierto no implica el pago de ninguna tarifa directa al autor del programa, el software libre puede tener otros costos asociados y terminar siendo más caro que otro tipo de software. El concepto importante es _libertad_: la libertad de poder contratar a uno o más programadores que modifiquen el código para que el software se comporte como uno necesita.
:::


De hecho, como Unix^[A principios de 1960, los Bell Labs en EEUU llegaron a desarrollar un sistema operativo que funcionaba bien, así que decidieron encarar MULTICS. Como terminó siendo una monstruosidad, empezaron UNIX que es lo que quedó bien.]
y C^[A fines de 1960, también en los Bell Labs, llegaron a desarrollar un un lenguaje de programación A que funcionaba bien, así que decidieron encarar B. Como terminó siendo una monstruosidad, empezaron C que es lo que quedó bien.], FeenoX es un "efecto de tercer sistema"^[Del inglés [_third-system effect_]{lang=en-US}.] @raymond.
De hecho, esta diferencia entre el concepto de código abierto y software libre fue discutida en la referencia @enief-milonga-2014 durante el desarrollo de la segunda versión del sistema.

De las lecciones aprendidas en las dos primeras versiones, la primera un poco naïve pero funcional y la segunda más pretenciosa y compleja (apalancada en la funcionalidad de la primera), hemos convergido al diseño explicado en el SDS del @sec-sds donde definimos la filosofía de diseño del software y elegimos una de las infinitas formas de diseñar una herramienta computacional mencionadas al comienzo de este capítulo.
Gran parte de este diseño está basado en la filosofía de programación Unix @raymond.
Damos ejemplos de cómo son las interfaces para definir un cierto problema y de ·cómo obtener los resultados.
Comparamos alternativas e indicamos por qué hemos decidido diseñar el software de la forma en la que fue diseñado.
Por otro lado, en este capítulo nos centramos en la implementación, tratando de converger a una de las infinitas formas de implementar el diseño propuesto en el SDS.


## Arquitectura del código

Comencemos preguntándonos qué debemos tener en cuenta para implementar una herramienta computacional que permita resolver ecuaciones en derivadas parciales con aplicación en ingeniería.
Por el momento enfoquémonos en problemas lineales^[Si el problema fuese no lineal o incluso transitorio, la discusión de esta sección sigue siendo válida para la construcción de la matriz jacobiana global.] como los analizados en los dos capítulos anteriores.
Las dos tareas principales son

 1. construir la matriz global de rigidez $\mat{K}$ y el vector $\vec{b}$ (o la matriz de masa $\mat{M}$), y
 2. resolver el sistema de ecuaciones $\mat{K} \cdot \vec{u} = \vec{b}$ (o $\mat{K} \cdot \vec{u} = \lambda \cdot \mat{M} \cdot \vec{u}$)

 
Haciendo énfasis en la filosofía Unix, tenemos que escribir un programa que haga bien una sola cosa^[[Do only one thing but do it well]{lang=en-US}.] que nadie más hace y que interactúe con otros que hacen bien otras cosas (regla de composición).
En este sentido, nuestra herramienta se tiene que enfocar en el punto 1.
Pero tenemos que definir quién va a hacer el punto 2 para que sepamos cómo es que tenemos que construir $\mat{K}$ y $\vec{b}$.

Las bibliotecas PETSc [@petsc-user-ref;@petsc-efficient] junto con la extensión SLEPc [@slepc-manual;@slepc-toms] proveen exactamente lo que necesita una herramienta que satisfaga el SRS siguiendo la filosofía de diseño del SDS.
Otra vez desde el punto de vista de la filosofía de programación Unix, la tarea 1 consiste en un cemento de contacto^[En el sentido del inglés [_glue layer_]{lang=en-US}.] entre la definición del problema a resolver por parte del ingeniero usuario y la biblioteca matemática para resolver problemas ralos^[Del inglés [_sparse_]{lang=en-US}.] PETSc. 
Cabe preguntarnos entonces cuál es el lenguaje de programación adecuado para implementar el diseño del SDS.
Aún cuando ya mencionamos que cualquier lenguaje Turing-completo es capaz de resolver un sistema de ecuaciones algebraicas, está claro que no todos son convenientes.
Por ejemplo Assembly o BrainFuck son interesantes en sí mismos (por diferentes razones) pero para nada útiles para la tarea que tenemos que realizar.
De la misma manera, en el otro lado de la distancia con respecto al hardware, lenguajes de alto nivel como Python también quedan fuera de la discusión. A lo sumo, estos lenguajes interpretados podrían servir para proveer clientes finos^[Del inglés [_thin clients_]{lang=en-US}.] a través de APIs que puedan llegar a simplificar la definición del (o los) problema(s) que tenga que resolver FeenoX.
Para resumir una discusión mucho más compleja, los lenguajes candidatos para implementar la herramienta requerida por el SRS podrían ser

 a. Fortran
 b. C
 c. C++

Según la regla de representación de Unix, la implementación debería poner la complejidad en las estructuras de datos más que en la lógica. Sin embargo, en el área de mecánica computacional, paradigmas de programación demasiado orientados a objetos impactan en la performance. La tendencia es encontrar una balance, tal como persigue la filosofía desde hace más de dos mil quinientos años, entre programación orientada a objetos y programación orientada a datos.

::: {.remark}
En los últimos años el lenguaje Rust se ha comenzado a posicionar como una alternativa a C para _system programming_^[No hay traducción de este término. En el año 2008, se propuso una materia en el IB con este nombre en inglés. El consejo académico decidió traducirla y nombrarla como "programación de sistemas". Ni el nombre elegido ni el ligeramente más correcto "programación del sistema" tienen la misma denotación que el concepto original [_system programming_]{lang=en-US}] debido al requerimiento intrínseco de que todos las referencias deben apuntar a una dirección de memoria virtual válida. A principios de 2023 aparecieron por primera vez líneas de código en Rust en el kernel de Linux. Pero desde el punto de vista de computación de alto rendimiento^[Del inglés [_high-performance computing_]{lang=en-US} (HPC).], Rust (o incluso Go) no tienen nada nuevo que aportar con respecto a C.
:::


Tal como explican los autores de PETSc (y coincidentemente Eric Raymond en @raymond), es C el lenguaje que mejor se presta a este paradigma:
```{=latex}
\label{polymorphism}
```

::: {lang=en-US}
> Why is PETSc written in C, instead of Fortran or C++?
> 
> When this decision was made, in the early 1990s, C enabled us to build data structures for storing sparse matrices, solver information, etc. in ways that Fortran simply did not allow. ANSI C was a complete standard that all modern C compilers supported. The language was identical on all machines. C++ was still evolving and compilers on different machines were not identical. Using C function pointers to provide data encapsulation and polyRmorphism allowed us to get many of the advantages of C++ without using such a large and more complicated language. It would have been natural and reasonable to have coded PETSc in C++; we opted to use C instead.
:::

Fortran fue diseñado en la década de 1950 y fue un salto cualitativo con respecto a la forma de programar las incipientes computadoras digitales. Sin embargo, las suposiciones que se han tenido en cuenta con respecto al hardware sobre el cual estos programas debería ejecutarse ya no son válidas. Las revisiones posteriores como Fortran 90 son modificaciones y parches que no resuelven el problema de fondo.
En cambio, C fue diseñado a principios de la década 1970 suponiendo arquitecturas de hardware que justamente son las que se emplean hoy en día, tales como

 * espacio de direcciones plano^[Del inglés [_flat address space_]{lang=en-US}.]
 * registros
 * entrada y salida basada en archivos
 * etc.
 
para correr en entornos Unix, que justamente, es el sistema operativo de la vasta mayoría de los servidores de la nube pública, que justa y nuevamente, es lo que perseguimos en esta tesis.

Una vez más, en principio la misma tarea puede ser implementada en cualquier lenguaje: Fortran podría implementar programación con objetos y C++ podría ser utilizado con un paradigma orientado a datos.
Pero lo usual es que código escrito en Fortran sea procedural y basado en estructuras `COMMON`, resultando difícil de entender y depurar. Código escrito en C++ suele ser orientado a objetos y con varias capas de encapsulamiento, polimorfismo, métodos virtuales, redefinición de operadoras y contenedores enplantillados^[Del inglés [_templated_]{lang=en-US}.] resultando difícil de entender y depurar.
De la misma manera que el lenguaje Fortran permite realizar ciertas prácticas que bien utilizadas agregan potencia y eficiencia pero cuyo abuso lleva a código ininteligible (por ejemplo el uso y abuso de bloques `COMMON`), C++ permite ciertas prácticas que bien utilizadas agregan potencia pero cuyo abuso lleva a código de baja calidad (por ejemplo el uso y abuso de `template`s, `shared_pointer`s, `bind`s, `move`s, lambdas, wrappers sobre wrappers, objetos sobre objetos, interfaz sobre interfaz, etc.), a veces en términos de eficiencia, a veces en términos del concepto de Unix _compactness_ @raymond

::: {lang=en-US}
> Compactness is the property that a design can fit inside a human being's head. A good practical test for compactness is this: Does an experienced user normally need a manual? If not, then the design (or at least the subset of it that covers normal use) is compact.
:::
y usualmente en términos de la regla de simplicidad en la filosofía de Unix:

::: {lang=en-US}
> Add complexity only where you must.
:::


**TODO**: feenox está en el medio y busca ser compacto:
mapdl es un quilombo de commons y no se entiende nada
reflex es un quilombo de visitors, interfaces, etc. y no se entiende nada
feenox es lo más straightforward

todo lo que sea turing completo es equivalente
pero c++ te hace facil complicarla al pedo
y fortran te hace facil hacer chanchadas

c te hace dificil agregar complejidad

unix rule of complexity: only add complexity when a solution thing won't do


### Construcción de los elementos globales

Habiendo decidido entonces construir la matriz $\mat{K}$ y el vector $\vec{b}$ como una [glue-layer]{lang=en-US} implementada en C utilizando una estructura de datos que PETSc pueda entender, preguntémonos ahora qué necesitamos para construir estos objetos.
Para simplificar el argumento, supongamos por ahora que queremos resolver la ecuación generalizada de Poisson de la @sec-poisson. La matriz global $\mat{K}$ proviene de ensamblar las matrices elementales $\mat{K}_i$ para todos los elementos volumétricos $e_i$ según la @def-Ki-poisson. De la misma manera, el vector global $\vec{b}_i$ proviene de ensamblar las contribuciones elementales $\vec{b}_i$ tanto de los elementos volumétricos (@def-bi-volumetrico-poisson) como de los elementos de superficie con condiciones de contorno naturales (@def-bi-superficial-poisson).



```{=latex}
\DontPrintSemicolon
\begin{algorithm}
\ForEach{ elemento volumétrico $e_i$}{ 
 $\mat{K}_i \leftarrow 0$\;
 $\mat{b}_i \leftarrow 0$\;
 \For{ cada punto de cuadratura $q = 1, \dots, Q_i$}{
  $\mat{J}_i(\symbf{\xi}_q) \leftarrow \mat{B}_c(\symbf{\xi}_q) \cdot \mat{C}_i$\;
  $\mat{B}_i(\symbf{\xi}_q) \leftarrow \mat{J}_i^{-T}(\symbf{\xi}_q) \cdot \mat{B}_c(\symbf{\xi}_q)$ \;
  $\vec{x}_q(\symbf{\xi}_q) \leftarrow \sum_{j=1}^{J_i} h_j(\symbf{\xi}_q) \cdot \vec{x}_j$\;
  $\mat{K}_i \leftarrow \mat{K}_i + \omega_q \cdot \Big|\det{\left[\mat{J}_i\left(\symbf{\xi}_q\right)\right]}\Big| \left\{ \mat{B}_i^T(\symbf{\xi}_q) \cdot k(\vec{x}_q) \cdot \mat{B}_i(\symbf{\xi}_q) \right\} $\; 
  $\vec{b}_i \leftarrow \vec{b}_i + \omega_q \cdot \Big|\det{\left[\mat{J}_i\left(\symbf{\xi}_q\right)\right]}\Big| \left\{\mat{H}_c^T(\symbf{\xi}_q) \cdot f(\vec{x}_q) \right\}$ \;
 }
 ensamblar $\mat{K}_i \rightarrow \mat{K}$\;
 ensamblar $\vec{b}_i \rightarrow \vec{b}$\;
}

\ForEach{ elemento superficial $e_i$ con condición de Neumann $p(\vec{x})$}{ 
 $\mat{b}_i \leftarrow 0$\;
 \For{ cada punto de cuadratura $q = 1, \dots, Q_i$}{
  $\vec{b}_i \leftarrow \vec{b}_i + \omega_q^{(D-1)} \cdot \Big|\det{\left[\mat{J}_i\left(\symbf{\xi}_q\right)\right]}\Big|  \cdot \left\{ \mat{H}_{c^\prime}^T(\symbf{\xi}_q) \cdot p(\vec{x}_q) \right\}$ \; 
 }
 ensamblar $\vec{b}_i \rightarrow \vec{b}$\;
}
\caption{\label{alg:poisson}Posible implementación de alto nivel de la construcción de $\mat{K}$ y $\vec{b}$ para el problema de Poisson generalizado de la \ref{sec-poisson}}
\end{algorithm}
```

```{=latex}
\DontPrintSemicolon
\begin{algorithm}
\ForEach{ elemento superficial $e_i$ con condición de Dirichlet $g(\vec{x})$}{ 
 \For{ cada nodo local $j = 1, \dots, J_i$}{
  calcular la fila global $k$ correspondiente al nodo local $j$ del elemento $e_i$\;
  hacer cero la fila $k$ de la matriz global $\mat{K}$\;
  poner un uno en la diagonal de la fila $k$ de la matriz global $\mat{K}$\;
  poner $g(\vec{x}_j)$ en la fila $k$ del vector global $\vec{b}$\;
 }
}
\caption{\label{alg:poisson-dirichlet1}Una forma de poner condiciones de Dirichlet en el problema discretizado, barriendo sobre elementos y calculando la fila global a partir del nodo local.}
\end{algorithm}
```

```{=latex}
\DontPrintSemicolon
\begin{algorithm}
\ForEach{ nodo global $j = 1, \dots J$}{ 
 \ForEach{ elemento $e_i$ al que pertenece el nodo global $j$}{
  \If{ el elemento $e_i$ tiene una condición de Dirichlet}{
    hacer cero la fila $j$ de la matriz global $\mat{K}$\;
    poner un uno en la diagonal de la fila $j$ de la matriz global $\mat{K}$\;
    poner $g(\vec{x}_j)$ en la fila $j$ del vector global $\vec{b}$\;
  }
 }
}
\caption{\label{alg:poisson-dirichlet2}Otra forma de poner condiciones de Dirichlet en el problema discretizado, barriendo sobre nodos globales y encontrando los elementos asociados.}
\end{algorithm}
```


Una posible implementación en pseudo código de alto nivel de esta construcción podría ser la ilustrada en el algoritmo \ref{alg:poisson}. La aplicación de las condiciones de contorno de Dirichlet según la discusión de la @sec-dirichlet-nh puede ser realizada con el algoritmo \ref{alg:poisson-dirichlet1} o con el algoritmo \ref{alg:poisson-dirichlet2}. En un caso barremos sobre elementos y tenemos que encontrar el índice global asociado a cada nodo local. En otro caso barremos sobre nodos globales pero tenemos que encontrar los elementos asociados al nodo global.

La primera conclusión que podemos extraer es que para problemas escalares, la ecuación a resolver está determinada por la expresión entre llaves de los términos evaluados en cada punto de Gauss para $\mat{K}_i$ y para $\vec{b}_i$.
Si el problema tuviese más de una incógnita por nodo y reemplazamos las matrices $\mat{H}_c$ y $\mat{B}_i$ por sus versiones $G$-aware $\mat{H}_{Gc}$ y $\mat{B}_{Gi}$, entonces otra vez la ecuación a resolver está completamente definida por la expresión entre llaves.

Por ejemplo, si quisiéramos resolver difusión de neutrones multigrupo tendríamos que hacer

$$
\mat{K}_i \leftarrow \mat{K}_i + \omega_q \cdot \Big|\det{\left[\mat{J}_i\left(\symbf{\xi}_q\right)\right]}\Big| \cdot \left\{ \mat{L}_i(\symbf{\xi}_q) + \mat{A}_i(\symbf{\xi}_q) - \mat{F}_i(\symbf{\xi}_q)\right\}
$$
con las matrices intermedias según la @eq-LAF

$$ \tag{\ref{eq-LAF}}
\begin{aligned}
\mat{L}_i &= \mat{B}_{Gi}^T(\symbf{\xi}_q) \cdot \mat{D}_D(\symbf{\xi}_q) \cdot \mat{B}_{Gi}(\symbf{\xi}_q)  \\
\mat{A}_i &= \mat{H}_{Gc}^T(\symbf{\xi}_q) \cdot \mat{R}(\symbf{\xi}_q) \cdot \mat{H}_{Gc}(\symbf{\xi}_q) \\
\mat{F}_i &= \mat{H}_{Gc}^T(\symbf{\xi}_q) \cdot \mat{X}(\symbf{\xi}_q) \cdot \mat{H}_{Gc}(\symbf{\xi}_q)
\end{aligned}
$$
más las contribuciones a la matriz de rigidez para condiciones de Robin.
Pero en principio podríamos escribir un algoritmo genérico que implemente el método de elementos finitos para resolver una cierta ecuación diferencial completamente definida por la expresión dentro de las llaves.

La segunda conclusión proviene de preguntarnos qué es lo que necesitan los algoritmos \ref{alg:poisson}, \ref{alg:poisson-dirichlet2} y \ref{alg:poisson-dirichlet2} para construir la matriz de rigidez global $\mat{K}$ y el vector $\vec{b}$:

 i. los conjuntos de cuadraturas de gauss $\omega_q, \symbf{\xi}_q$ para el elemento $e_i$
 ii. las matrices canónicas $\mat{H}_{c}$, $\mat{B}_{c}$ y $\mat{H}_{Gc}$
 iii. las matrices elementales $\mat{C}_i$, $\mat{B}_{Gi}$,
 iv. poder evaluar en $\vec{x}_q$
     a. las conductividad $k(\vec{x})$ (o las secciones eficaces para construir $\mat{D}_D(\symbf{\xi}_q)$, $\mat{R}(\symbf{\xi}_q)$ y $\mat{X}(\symbf{\xi}_q)$)
     b. la fuente volumétrica $f(\vec{x})$ (o las fuentes independientes isotrópicas $s_{0,g}(\symbf{\xi}_q)$)
     c. las condiciones de contorno $p(\vec{x})$ y $g(\vec{x})$ (o las correspondientes a difusión de neutrones)

Los tres primeros puntos no dependen de la ecuación a resolver.
Lo único que se necesita para evaluar los tres primeros puntos es tener disponible la topología de la malla no estructurada que discretiza el dominio $U \in \mathbb{R}^D$ a través la posición $\vec{x}_j \in \mathbb{R}^D$ de los nodos y la topología de cada uno de los elementos $e_i$.

El tercer cuarto en principio sí depende de la ecuación, pero finalmente se reduce a la capacidad de evaluar

 1. propiedades de materiales
 2. condiciones de contorno
 
en una ubicación espacial arbitraria $\vec{x}$.

Para fijar ideas, supongamos que tenemos un problema de conducción de calor.
La conductividad $k(\vec{x})$^[Si la conductividad dependiera de la temperatura $T$ el problema sería no lineal. Pero en el paso $k$ e la iteración de Newton tendríamos $k(\vec{T}_k(\vec{x})=k_k(\vec{x})$ por lo que la discusión sigue siendo válida.] o en general, cualquier propiedad material puede depender de la posición $\vec{x}$ porque

 1. existen materiales con propiedades discontinuas en diferentes ubicaciones $\vec{x}$, y/o
 2. la propiedad depende continuamente de la posición aún para el mismo material.

De la misma manera, una condición de contorno (sea esencial o natural) puede depender discontinuamente con la superficie donde esté aplicada o continuamente dentro de la misma superficie a través de alguna dependencia con la posición $\vec{x}$.
 
Entonces, la segunda conclusión es que si nuestra herramienta fuese capaz de proveer un mecanismo para definir propiedades materiales y condiciones de contorno que puedan depender discontinuamente según el volúmen o superficie al que pertenezca cada elemento (algunos elementos volumétricos pertenecerán al combustible y otros al moderador, algunos elementos superficiales pertenecerán a una condición de simetría y otros a una condición de vacío) y/o continuamente en el espacio según variaciones locales (por ejemplo cambios de temperatura y/o densidad, concentración de venenos, etc.) entonces podríamos resolver ecuaciones diferenciales arbitrarias discretizadas espacialmente con el método de elementos finitos.

      
### Polimorfismo con apuntadores a función 

Según la discusión de la sección anterior, podemos diferenciar entre cierta parte del código que tendrá que realizar tareas "comunes" (en el sentido de que son las mismas para todas las PDEs tal como leer la malla y evaluar funciones en un punto $\vec{x}$ arbitrario del espacio) y otra parte que tendrá que realizar tareas particulares para cada ecuación a resolver (por ejemplo evaluar las expresiones entre llaves en el $q$-ésimo punto de Gauss del elemento $i$-ésimo.

::: {#def-framework}

## framework 

Llamamos [_framework_]{lang=en-US} a la parte del código que implementa las tareas comunes.
:::

Por diseño, el problema que FeenoX tiene que resolver tiene que estar completamente definido en el archivo de entrada.
Entonces éste debe justamente definir qué clase de ecuación se debe resolver.
Como el tipo de ecuación se lee en tiempo de ejecución, el framework debe poder ser capaz de llamar a una u otra (u otra) función que le provea la información particular que necesita: por ejemplo las expresiones entre llaves para la matriz de rigidez y para las condiciones de contorno.

Una posible implementación (ingenua) sería 

```{=latex}
\DontPrintSemicolon
\begin{algorithm}[H]
\uIf{ la PDE es poisson } { evaluar $\mat{B}_i^T \cdot k(\vec{x}_q) \cdot \mat{B}_i$\; }
\uElseIf{ la PDE es difusión } { evaluar $\mat{L}_i(\symbf{\xi}_q) + \mat{A}_i(\symbf{\xi}_q) + \mat{F}_i(\symbf{\xi}_q)$ \;}
\uElseIf{ la PDE es S$_N$ } { evaluar $\mat{L}_i(\symbf{\xi}_q) + \mat{A}_i(\symbf{\xi}_q) + \mat{F}_i(\symbf{\xi}_q)$\; }
\Else{ quejarse “no sé resolver esta PDE” \; }
\end{algorithm}
```

De la misma manera, necesitaríamos bloques `if` de este tipo para inicializar el problema, evaluar condiciones de contorno, calcular resultados derivados (por ejemplo flujos de calor a partir de las temperaturas, tensiones a partir de desplazamientos o corrientes a partir de flujos neutrónicos), etc.
Está claro que esto es 

 1. feo,
 2. ineficiente, y
 3. difícil de extender
 
En C++ esto se podría implementar mediante una jerarquía de clases donde las clases hijas implementaría métodos virtuales que el framework llamaría cada vez que necesite evaluar el término entre llaves.
Si bien C no tiene "métodos virtuales", sí tiene apuntadores a función (que es justamente lo que PETSc usa para implementar polimorfismo `como mencionamos en la página~\pageref{polymorphism}`{=latex}) por lo que podemos usar este mecanismo para lograr una implementación superior, que explicamos a continuación.

Por un lado, sí existe un lugar del código con un bloque `if` según el tipo de PDE requerida en tiempo de ejecución que consideramos feo, ineficiente y difícil de extender.
Pero,

 a. este único bloques `if` se ejecutan una sola vez en el momento de analizar gramaticalmente^[Del inglés [_parse_]{lang=en-US}.] el archivo de entrada y lo que hacen es definir la dirección de memoria de una función de inicialización que el framework debe llamar antes de comenzar a construir $\mat{K}$ y $\vec{b}$:
 
    ```c
      if (strcasecmp(token, "laplace") == 0) {
        feenox.pde.init_parser_particular = feenox_problem_init_parser_laplace;
      } else if (strcasecmp(token, "mechanical") == 0) {
        feenox.pde.init_parser_particular = feenox_problem_init_parser_mechanical;
      } else if (strcasecmp(token, "modal") == 0) {
        feenox.pde.init_parser_particular = feenox_problem_init_parser_modal;
      } else if (strcasecmp(token, "neutron_diffusion") == 0) {
        feenox.pde.init_parser_particular = feenox_problem_init_parser_neutron_diffusion;
      } else if (strcasecmp(token, "neutron_sn") == 0) {
        feenox.pde.init_parser_particular = feenox_problem_init_parser_neutron_sn;
      } else if (strcasecmp(token, "thermal") == 0) {
        feenox.pde.init_parser_particular = feenox_problem_init_parser_thermal;
      } else {
        feenox_push_error_message("unknown problem type '%s'", token);
        return FEENOX_ERROR;
      }
    ```

    Estas funciones de inicialización a su vez resuelven los apuntadores a función particulares para evaluar contribuciones elementales volumétricas en puntos de Gauss, condiciones de contorno, post-procesamiento, etc.
    
 b. El bloque `if` mostrado en el punto anterior es generado programáticamente a partir de un script (regla de Unix de generación) que analiza (_parsea_) el árbol del código fuente y, para cada subdirectorio en [`src/pdes`](https://github.com/seamplex/feenox/tree/main/src/pdes), genera un bloque `if` automáticamente. 
 Es fácil ver el patrón que siguen cada una de las líneas del listado en el punto a y escribir un script o macro para generarlo programáticamente.
 
Entonces,

 1. Si bien ese bloque sigue siendo feo, lo genera y lo compila una máquina que no tiene el mismo sentido estético que un programador humano.
 2. Reemplazamos la evaluación de $n$ condiciones `if` para llamar a una dirección de memoria fija para cada punto de Gauss para cada elemento por una des-referencia de un apuntador a función en cada puntos de Gauss de cada elemento. En términos de eficiencia, esto es similar (tal vez más eficiente) que un método virtual de C++. Esta des-referencia dinámica no permite que el compilador pueda hacer un `inline` de la función llamada, pero el gasto extra^[Del inglés [_overhead_]{lang=en-US}.] es muy pequeño. En cualquier caso, el mismo script que parsea la estructura en `src/pdes` podría modificarse para generar un binario de FeenoX para cada PDE donde en lugar de llamar a un apuntador a función se llame directamente a las funciones propiamente dichas permitiendo optimización en tiempo de vinculación^[Del inglés [_link-time optimization_]{lang=en-US}.] que le permita al compilador hacer el `inline` de la función particular.
 3. El script que parsea la estructura de `src/pdes` en busca de los tipos de PDEs disponibles es parte del paso `autogen.sh` (a veces llamado `bootstrap` @fig-bootstrap) dentro del esquema `configure` + `make` de Autotools. Las PDEs soportadas por FeenoX puede ser extendidas agregando un nuevo subdirectorio dentro de `src/pdes` donde ya existen
 
    * [`laplace`](https://github.com/seamplex/feenox/tree/main/src/pdes/laplace)
    * [`thermal`](https://github.com/seamplex/feenox/tree/main/src/pdes/thermal)
    * [`mechanical`](https://github.com/seamplex/feenox/tree/main/src/pdes/mechanical)
    * [`modal`](https://github.com/seamplex/feenox/tree/main/src/pdes/modal)
    * [`neutron_diffusion`](https://github.com/seamplex/feenox/tree/main/src/pdes/neutron_difussion)
    * [`neutron_sn`](https://github.com/seamplex/feenox/tree/main/src/pdes/neutron_sn)
 
    tomando uno de estos subdirectorios como plantilla. De hecho también es posible eliminar completamente uno de estos directorios en el caso de no querer que FeenoX pueda resolver alguna PDE en particular.
    De esta forma, `autogen.sh` permitirá extender (o reducir) la funcionalidad del código, que es uno de los puntos solicitados en el SDS.
    Más aún, sería posible utilizar este mecanismo para cargar funciones particulares desde objetos compartidos^[Del inglés [_shared objects_]{lang=en-US}.] en tiempo de ejecución, incrementando aún más la extensibilidad de la herramienta.

![El concepto de `bootstrap` (también llamado `autogen.sh`).](bootstrap_marked.jpg){#fig-bootstrap width=35%}
    
### Definiciones e instrucciones


En el @sec-neutronica-phwr mencionamos (y en el @sec-sds explicamos en detalle) que la herramienta desarrollada es una especie de "función de transferencia" entre uno o más archivos de entrada y cero o más archivos de salida (incluyendo la salida estándar `stdout`):

```include
110-sds/transfer.md
```

Este archivo de entrada, que a su vez puede incluir otros archivos de entrada y/o hacer referencia a otros archivos de datos (incluyendo la malla en formato `.msh`) contiene palabras clave^[Del inglés [_keywords_]{lang=en-US}.] en inglés que, por decisión de diseño, deben 

 #. definir completamente el problema de resolver
 #. ser lo más autodescriptivas posible
 #. permitir una expresión algebraica en cualquier lugar donde se necesite un valor numérico
 #. mantener una correspondencia uno a uno entre la definición "humana" del problema y el archivo de entrada
 #. hacer que el archivo de entrada de un problema simple sea simple
 
Estas keywords pueden ser
 
 a. definiciones (sustantivos), o
 
    * qué PDE hay que resolver
    * propiedades materiales
    * condiciones de contorno
    * variables, vectores y/o funciones auxiliares
    * etc.
    
 b. instrucciones (verbos)
 
    * leer la malla
    * resolver problema
    * asignar valores a variables
    * calcular integrales o encontrar extremos sobre la malla
    * escribir resultados
    * etc.
 
Las definiciones se realizan a tiempo de parseo. Una vez que el FeenoX acepta que el archivo de entrada es válido, comienza la ejecución de las instrucciones en el orden indicado en el archivo de entrada.
De hecho, FeenoX tiene un apuntador a instrucción^[Del inglés [_instruction pointer_]{lang=en-US}.] que se incrementa a medida que avanza la ejecución de las instrucciones. Existen palabras clave `IF` y `WHILE` que permiten flujos de ejecución no triviales, especialmente en problemas iterativos, cuasi-estáticos o transitorios.

Por ejemplo, la lectura del archivo de malla es una instrucción y no una definición porque por ejemplo

 1. el nombre del archivo de la malla puede depender de alguna variable cuyo valor deba ser evaluado en tiempo de ejecución con una instrucción previa,
 2. el archivo con la malla en sí puede ser creado internamente por FeenoX con una instrucción previa "escribir resultados", y/o
 3. en problemas complejos puede ser necesario leer varias mallas antes de resolver la PDE en cuestión, por ejemplo leer una distribución de temperaturas en una malla gruesa de primer orden para utilizarla al evaluar las propiedades de los materiales de la PDE que se quiere resolver.

Comencemos con un problema sencillo para luego agregar complejidad en forma incremental.
A la luz de la discusión de este capítulo, preguntémonos ahora qué necesitamos para resolver por ejemplo un problema de conducción de calor estacionario sobre un dominio $U \mathbb{R}^D$ con un único material:

 1. definir que la PDE es conducción de calor en $D$ dimensiones
 2. leer la malla con el dominio $U \in \mathbb{R}^D$ discretizado
 3. definir la conductividad térmica $k$ del material
 4. definir las condiciones de contorno del problema
 5. construir $\mat{K}$ y $\vec{b}$
 6. resolver $\mat{K} \cdot \vec{u} = \vec{b}$
 7. hacer algo con los resultados
    - calcular $T_\text{max}$
    - calcular $T_\text{mean}$
    - comparar con soluciones analíticas
    - etc.
 8. escribir los resultados
 
El problema de conducción de calor más sencillo es un slab en el intervalo $x \in [0,1]$ con conductividad uniforme y condiciones de Dirichlet $T(0)=0$ y $T(1)=1$ en ambos extremos. Por diseño, el archivo de entrada tiene que ser sencillo y tener una correspondencia uno a uno con la definición "humana" del problema:

```feenox
PROBLEM thermal 1D               # 1. definir que la PDE es calor 1D
READ_MESH slab.msh               # 2. leer la malla
k = 1                            # 3. definir conductividad uniforme igual a uno
BC left  T=0                     # 4. condiciones de contorno de Dirichlet
BC right T=1                     #    "left" y "right" son nombres en la malla
SOLVE_PROBLEM                    # 5. y 6. construir y resolver
PRINT T(0.5)                     # 7. y 8. imprimir en stdout la temperatura en x=0.5
```

En este caso sencillo, la conductividad $k$ fue dada como una variable `k` con un valor igual a uno.
Estrictamente hablando, la asignación fue una instrucción. Pero en el momento de resolver el problema, las funciones particulares de la PDE de conducción de calor (dentro de `src/pdes/thermal`) buscan una variable llamada `k` y toman su valor para utilizarlo idénticamente en todos los puntos de Gauss de los elementos volumétricos al calcular el término $\mat{B}_i^T \cdot k \cdot \mat{B}_i$.

Si la conductividad no fuese uniforme sino que dependiera del espacio por ejemplo como

$$
k(x) = 1+x
$$
entonces el archivo de entrada sería

```feenox
PROBLEM thermal 1D
READ_MESH slab.msh
k(x) = 1+x                       # 3. conductividad dada por una función de x
BC left  T=0
BC right T=1
SOLVE_PROBLEM
PRINT T(1/2) log(1+1/2)/log(2)   # 7. y 8. imprimir el valor numérico y la solución analítica
```

En este caso, no hay una variable llamada `k` sino que hay una función de $x$ con la expresión algebraica $1+x$.
Entonces la función que evalúa las contribuciones volumétricas elementales de la matriz de rigidez toman dicha función como la propiedad "conductividad" y la evalúan como $\mat{B}_i^T \cdot k(\symbf{x}_q) \cdot \mat{B}_i$.
La salida, que por diseño está 100% definida por el archivo de entrada (reglas de Unix de silencio y de economía) consiste en la temperatura evaluada en $x=1/2$ junto con la solución analítica en dicho punto.

Por completitud, mostramos que también la conductividad podría depender de la temperatura.
En este caso particular el problema queda no lineal y mencionamos algunas particularidades sin ahondar en detalles.
El parser algebraico de FeenoX sabe que $k$ depende de $T$, por lo que la rutina particular de inicialización de la PDE de conducción de calor marca que el problema debe ser resuelto por PETSc con un objeto SNES (en lugar de un KSP como para el caso lineal). FeenoX también calcula el jacobiano necesario para resolver el problema con un método de Newton iterativo:

```feenox
PROBLEM thermal 1D
READ_MESH slab.msh
k(x) = 1+T(x)                    # 3. la conductividad ahora depende de T(x)
BC left  T=0
BC right T=1
SOLVE_PROBLEM
PRINT T(1/2) sqrt(1+(3*0.5))-1
```

La ejecución de FeenoX sigue también las reglas tradicionales de Unix.
Se debe proveer la ruta al archivo de entrada como principal argumento luego del ejecutable.
Es un argumento y no como una opción ya que la funcionalidad del programa depende de que se indique un archivo de entrada, por lo que no es "opcional".
Sí pueden agregar opciones siguiendo las reglas POSIX. Algunas opciones son para FeenoX (por ejemplo `--progress` o `--elements_info` y otras son pasadas a PETSc/SLEPc (por ejemplo `--ksp_view` o `--mg_levels_pc_type=sor`).
Al ejecutar los tres casos anteriores, obtenemos los resultados solicitados con la instrucción `PRINT` en la salida estándar:

```terminal
$ feenox thermal-1d-dirichlet-uniform-k.fee
0.5
$ feenox thermal-1d-dirichlet-space-k.fee
0.584945        0.584963
$ feenox thermal-1d-dirichlet-temperature-k.fee
0.581139        0.581139
$ 
```

Para el caso de conducción de calor estacionario solamente hay una única propiedad cuyo nombre debe ser `k` para que las rutinas particulares la detecten como la conductividad $k$ que debe aparecer en la contribución volumétrica.
Si el problema (es decir, la malla) tuviese dos materiales diferentes, digamos `A` y `B` hay dos maneras de definir sus propiedades materiales en FeenoX:

 1. agregando el sufijo `_A` y `_B` a la variable `k` o a la función `k(x)`, es decir
 
    ```feenox
    k_A = 1
    k_B = 2
    ```
    si $k_A = 1$ y $k_B=2$, o
    
    ```feenox
    k_A(x) = 1+2*x
    k_B(x) = 3+4*x
    ``` 
    si $k_A(x) = 1+2x$ y $k_B(x) = 3+4x$.
    
 2. utilizando una palabra clave `MATERIAL` (definición) para cada material, del siguiente modo
 
    ```feenox
    MATERIAL A k=1
    MATERIAL B k=2
    ```
    
    o
    
    ```feenox
    MATERIAL A k=1+2*x
    MATERIAL B k=3+4*x
    ```
    
De esta forma, el framework implementa las dos posibles dependencias de las propiedades de los materiales:

 a. continua con el espacio a través de expresiones algebraicas que pueden involucrar funciones definidas por puntos en interpoladas como discutimos en la sec-xxx
 b. discontinua según el material al que pertenece el elemento
 
Con respecto a las condiciones de contorno, la lógica es similar pero ligeramente más complicada.
Mientras que a partir del nombre la propiedad las rutinas particulares pueden evaluar las contribuciones volumétricas, sean a la matriz de rigidez a través de la conductividad `k` o al vector $\vec{b}$ a través de la fuente de calor por unidad de volumen `q`, para las condiciones de contorno se necesita un poco más de información.
Supongamos que una superficie tiene una condición de "simetría" y que queremos que la línea del archivo de entrada que la defina sea

```feenox
BC left  symmetry
```
donde `left` es el nombre de la entidad superficial definida en la malla y `symmetry` es una palabra clave que indica qué tipo de condición de contorno tienen los elementos que pertenecen a `left`.
La forma de implementar numéricamente (e incluso el signficado físico) esta condición de contorno depende de la PDE que estamos resolviendo. No es lo mismo poner una condición de simetría en

 * poisson generalizada
 * elasticidad lineal
 * difusión de neutrones
 * transporte por S$_N$
 
Entonces, si bien las propiedades de materiales pueden ser parseadas por el framework y aplicadas por las rutinas particulares, las condiciones de contorno deben ser parseadas y aplicadas por las rutinas particulares.
De todas maneras, la lógica es similar: las rutinas particulares proveen puntos de entrada^[Del inglés [_entry points_]{lang=en-US}.] que el framework llama en los momentos pertinentes durante la ejecución de las instrucciones.

Para terminar de ilustrar la idea, consideremos el problema de Reed que propone resolver con S$_N$ un slab uni-dimensional compuesto por varios materiales, algunos con una fuente independiente, otros sin fuente e incluso un material de vacío:

```feenox
#
#     |         |    |         |    |         |
#  m  | src= 50 | 0  |    0    | 1  |    0    |    v
#  i  |         |    |         |    |         |    a
#  r  | tot= 50 | 5  |    0    | 1  |    1    |    c
#  r  |         |    |         |    |         |    u
#  o  | scat=0  | 0  |    0    | 0.9|   0.9   |    u
#  r  |         |    |         |    |         |    m
#     |         |    |         |    |         |
#     |    1    | 2  |    3    | 4  |    5    |
#     |         |    |         |    |         |
#     +---------+----+---------+----+---------+-------> x
#    x=0       x=2  x=3       x=5  x=6       x=8   

PROBLEM neutron_sn DIM 1 GROUPS 1 SN $1

READ_MESH reed.msh
 
MATERIAL source_abs    S1=50 Sigma_t1=50 Sigma_s1.1=0
MATERIAL absorber      S1=0  Sigma_t1=5  Sigma_s1.1=0
MATERIAL void          S1=0  Sigma_t1=0  Sigma_s1.1=0
MATERIAL source_scat   S1=1  Sigma_t1=1  Sigma_s1.1=0.9
MATERIAL reflector     S1=0  Sigma_t1=1  Sigma_s1.1=0.9

BC left  mirror
BC right vacuum

SOLVE_PROBLEM

FUNCTION ref(x) FILE reed-ref.csv INTERPOLATION steffen
PRINT sqrt(integral((ref(x)-phi1(x))^2,x,0,8))/8
```

 * La primera línea es una definición (`PROBLEM` es un sustantivo) le indica a FeenoX que debe resolver las ecuaciones S$_N$ en $D=1$ dimensión con $G=1$ grupo de energías y utilizando una discretrización angular $N$ dada por el primer argumento de la línea de comando luego del nombre del archivo de entrada. De esta manera se pueden probar diferentes discretizaciones con el mismo archivo de entrada, digamos `reed.fee`
 
   ```terminal
   $ feenox reed 2   # <- usa S2
   [...]
   $ feenox reed 4   # <- usa S4
   [...]
   ```
   
 * La segunda línea es una instrucción (el verbo `READ`) que indica que la malla a utilizar por el problema se llama `reed.msh`.
   Si el archivo de entrada se llama `reed.fee`, esta línea podría haber sido `READ_MESH $0.msh`.
   
 * El bloque de palabras claves `MATERIAL` definen (con un sustantivo) las secciones eficaces macroscópicas (`Sigma`) y las fuentes independientes (`S`). En este caso todas las propiedades son uniformes dentro de cada material.
 
 * Las siguientes dos líneas definien las condiciones de contorno (`BC` quiere decir boundary condition): la superficie `left` tiene una condición espejo y la superficie `right` tiene una condición de vacío.
 
 * La instrucción `SOLVE_PROBLEM` le pide a FeenoX que
 
    1. construya la matriz global $\mat{K}$ y el vector $\vec{b}$ (pidiéndole a su vez a las rutinas específicas del subdirectorio `src/pdes/neutron_sn`)
    2. que le pida a PETSc que resuelva el problema $\mat{K} \cdot \vec{u} = \vec{b}$ (como hay fuentes independientes entonces la rutina de inicialización del problema `neutron_sn` sabe que debe resolver un problema lineal, si no hubiese fuentes y sí secciones eficaces de fisión se resolvería un problema de autovalores con la biblioteca SLEPc)
    3. que extraiga los valores nodales de la solución $\vec{u}$ y defina las funciones del espacio $\psi_{mg}(x)$ y $\phi_{g}(x)$. Si `$1` fuese `2` entonces las funciones con la solución serían
       - `psi1.1(x)`
       - `psi1.2(x)`
       - `phi1(x)`
      
       Estas funciones están disponibles para que subsiguientes instrucciones las utilicen como salida directamente, como parte de otras expresiones intermedias, etc.
    4. Si el problema fuese de criticidad, entonces esta instrucción también pondría el valor del factor de multiplicación efectivo $k_\text{eff}$ en una variable llamada `keff`.
    
 * La siguiente línea define una función auxiliar de la variable espacial $x$ a partir de un archivo de columnas de datos. Este archivo contiene una solución de referencia del problema de Reed. La función `ref(x)` puede ser evaluada en cualquier punto $x$ utilizando una interpolación monotónica cúbica de tipo `steffen`.
 
 * La última línea imprime en la salida estándar una representación ASCII (por defecto utilizando el formato `%g` de la instrucción `printf()` de C) del error $L_2$ cometido por la solución calculada con FeenoX con respecto a la solución de referencia, es decir

 $$
 \sqrt{\frac{1}{8} \cdot \int_0^8 \left[ \text{ref}(x) - \phi_1(x) \right]^2}
 $$

La ejecución de FeenoX con este archivo de entrada para S$_2$, S$_4, S$_6$ y S$_8$ da como resultado
 
```terminal
$ feenox reed.fee 2
0.0505655
$ feenox reed.fee 4
0.0143718
$ feenox reed.fee 6
0.010242
$ feenox reed.fee 8
0.0102363
$ 
```

### Puntos de entrada

autogen.sh

## Algoritmos auxiliares

### Expresiones algebraicas

pemdas

### Evaluación de funciones 

#### Una dimensión

gsl interpolation

#### Varias dimensiones

k-dimensional trees

non-conformal mesh mapping


### Campos secundarios

stress recovery




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



## Construcción de los elementos globales

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

Tal como explican los autores de PETSc (y coincidentemente Eric Raymond en @raymond), es C el lenguaje que mejor se presta a este paradigma:

::: {lang=en-US}
> Why is PETSc written in C, instead of Fortran or C++?
> 
> When this decision was made, in the early 1990s, C enabled us to build data structures for storing sparse matrices, solver information, etc. in ways that Fortran simply did not allow. ANSI C was a complete standard that all modern C compilers supported. The language was identical on all machines. C++ was still evolving and compilers on different machines were not identical. Using C function pointers to provide data encapsulation and polymorphism allowed us to get many of the advantages of C++ without using such a large and more complicated language. It would have been natural and reasonable to have coded PETSc in C++; we opted to use C instead.
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



Habiendo decidido entonces construir la matriz $\mat{K}$ y el vector $\vec{b}$ como una [glue-layer]{lang=en-US} implementada en C utilizando una estructura de datos que PETSc pueda entender, preguntémonos ahora qué necesitamos para construir estos objetos.
Para simplificar el argumento, supongamos por ahora que queremos resolver la ecuación generalizada de Poisson de la @sec-poisson. La matriz global $\mat{K}$ proviene de ensamblar las matrices elementales $\mat{K}_i$ para todos los elementos volumétricos $e_i$ según la @def-Ki-poisson. De la misma manera, el vector global $\vec{b}_i$ proviene de ensamblar las contribuciones elementales $\vec{b}_i$ tanto de los elementos volumétricos (@def-bi-volumetrico-poisson) como de los elementos de superficie con condiciones de contorno naturales (@def-bi-superficial-poisson).



```{=latex}
\DontPrintSemicolon
\begin{algorithm}
\For{ cada elemento volumétrico $e_i$}{ 
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

\For{ cada elemento superficial $e_i$ con condición de Neumann $p(\vec{x})$}{ 
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
\For{ cada elemento superficial $e_i$ con condición de Dirichlet $g(\vec{x})$}{ 
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
\For{ cada nodo global $j = 1, \dots J$}{ 
 \For{ cada elemento $e_i$ al que pertenece el nodo global $j$}{
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

      
## Arquitectura del código

Según la discusión de la sección anterior, podemos diferenciar entre cierta parte del código que tendrá que realizar tareas "comunes" (en el sentido de que son las mismas para todas las PDEs tal como leer la malla y evaluar funciones en un punto $\vec{x}$ arbitrario del espacio) y otra parte que tendrá que realizar tareas particulares para cada ecuación a resolver (por ejemplo evaluar las expresiones entre llaves en el $q$-ésimo punto de Gauss del elemento $i$-ésimo.



      
## Misc


no tenemos virtual methods en C, pero es turing complete
tenemos

 * punteros a funciones
 * lenguajes de macro

`autogen.sh` + entry points

macros/wrappers para `gsl_cblas_dgemmv()` = `MatAtBA()`


LTO. Macro para single-pde.



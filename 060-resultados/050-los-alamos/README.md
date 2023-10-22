# Benchmarks de criticidad de Los Alamos {#sec-losalamos}

> **TL;DR:** Estos problemas tienen proveen una manera de realizar una primerea verificación del código con el método de soluciones exactas.

El proceso de verificación de un código numérico involucra justamente, verificar que las ecuaciones se estén resolviendo bien.^[Hay un juego de palabras en inglés que indica que verificación quiere decir ["are we solving the equations right?"]{lang=en-US} mientras que validación quiere decir ["are we solving the right equations?"]{lang=en-US}.]
La forma estricta de realizarlo es comparar alguna medida del error cometido en la solución numérica con respecto a la solución exacta de la ecuación que estamos resolviendo y mostrar que éste tiende a cero con el orden teórico según el método numérico empleado.
En particular, la incógnita primaria de una ecuación en derivadas parciales discretizada con el método de elementos finitos debe ir a cero con un order superior en una unidad al orden de los elementos utilizados. Las incógnitas secundarias, con el mismo orden.
Es decir, los desplazamientos en elasticidad y las temperaturas en conducción de calor deben converger a cero como $h^3$ y las tensiones y los flujos de calor como $h^2$ si $h$ es el tamaño característico de los elementos de segundo orden utilizados para discretizar el dominio del problema.

Una de las dificultades de la verificación consiste en encontrar la solución de referencia con la cual calcular la medida del error numérico cometido. En la @sec-mms-dif proponemos una alternativa utilizando el método de soluciones fabricadas^[Del inglés [_Method of Manufactured Solutions_]{lang=en-US}]. En esta sección tomamos algunos de los 75 casos resueltos en la referencia @losalamos que incluyen


 * problemas a uno, dos, tres y seis grupos de energía
 * scattering isotrópico y linealmente anisotrópico
 * geometrías
   - de medio infinito
   - de slab en 1D
   - de círculo en 2D
   - de esfera en 2D
 * dominios de uno o varios materiales

El informe provee

 a. el factor de multiplicación efectivo infinito $k_\infty$, o
 b. el tamaño crítico
 
de cada una de las 75 configuraciones de reactores en geometrías triviales para diferentes conjuntos de secciones eficaces macroscópicas uniformes a zonas. Cada una de ellas se identifica con una cadena que tiene la forma

\begin{centering}
Material físil--Material reflector (espesor)---Grupos de energía--Orden de scattering--Geometría
\end{centering}

Por ejemplo UD2O-H2O(10)-1-0-SL indica un reactor de uranio y D$_2$O con un reflector de H$_2$O de 10 caminos libres medios de espesor, un grupo de energías, scattering isotrópico en geometría tipo slab.




## Casos de medio infinito

Una forma de implementar un medio infinito en FeenoX es utilizar una geometría unidimensional tipo slab y poner condiciones de contorno de simetría en ambos extremos.

Problema | Identificador                             | $k_\infty$ de referencia 
:-------:|:------------------------------------------|:------------------------:| 
 01      | PUa-1-0-IN                                |    2.612903              
 05      | PUb-1-0-IN                                |    2.290323
 47      | U-2-0-IN                                  |    2.216349
 50      | UAl-2-0-IN                                |    2.661745
 70      | URRa-2-1-IN                               |    1.631452
 74      | la-p74-URR-3-0-IN                         |    1.6


## Casos de medio finito

La forma de "verificar" FeenoX es entonces resolver algunos de los problemas planteados en la referencia, que incluyen 
creando una malla con el tamaño indicado como crítico y mostrar que el factor de multiplicación efectivo $k_\text{eff}$ obtenido se acerca a la unidad a medida que aumentamos el tamaño del problema discretizado, sea por refinar la malla espacial o por aumentar el número $N$ de ordenadas discretas. 

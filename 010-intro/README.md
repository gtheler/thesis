# Introducción {#sec-introduccion}

::: {.chapterquote .raggedright data-latex=""}
> | En su programa de televisión junto a Antonio Carrizo, el personaje de “El Contra” le pregunta a un invitado DT:
> | --- Supongamos que van 48’ del segundo tiempo y su equipo está atacando. ¿Qué prefiere? ¿Que le den un córner o un lateral?
> | --- ¿Qué pregunta es esa? Un córner, porque tengo una chance de llegar al área.
> | --- Con el lateral también. Nosotros allá en Villa Dálmine, durante la semana entrenamos laterales con sandías. Cuando llega el domingo, (lo mira a Antonio Carrizo) ¿sabés hasta dónde tiramos la pelota?
> 
> _Juan Carlos Calabró, 1993_

> Lo que yo daba por obvio dejó de serlo de un día para otro, concretando un choque que
> ---debo admitir--- ha vuelto a sucederme muchas veces desde entonces.
> Si hoy no me detengo a pensar un momento, vivo  convencido de que todo el mundo es ingeniero nuclear o doctor en física.
>
> _Germán Theler, La Singularidad, 2006_
:::


 1. En los congresos académicos sobre métodos numéricos y aplicaciones, muchas veces uno puede ver un esquema similar al siguiente:

    a. Se muestra el estado del arte y se describen las falencias de un cierto algoritmo tradicional.
    b. Se propone una nueva idea o metodología para mejorar dicho estado del arte.
    c. Se aplican las novedades a un caso sencillo donde, efectivamente, la eficiencia o la precisión mejoran sensiblemente.
    d. Se indica que los próximos pasos serán resolver no ya problemas canónicos sino problemas de interés industrial.

    Pero también muchas veces, el nuevo desarrollo nunca llega efectivamente a la industria.
    El ímpetu de la investigación se va difundiendo a lo ancho de nuevas asignaciones de fondos de investigación que se enfocan en otras áreas, de gente que cambia de ideas, se jubila, etc. Las aplicaciones quedan en una lista de tareas "por hacer" ([TO-DOs]{lang=en-US}).

 2. Los proyectos de ingeniería industriales están indefectiblemente restringidos por los tres vértices del triángulo de gerenciamiento de proyectos costos-alcance-calidad.
 Cualquier tarea de tipo de I+D+i en temas de modelado numérico debe necesariamente 

    a. Ser pagada por el cliente.
    b. Ser aprobada por el cliente (o por quien el cliente designe, incluyendo agencias de regulación).
    c. Ser gerenciada de forma tal que los costos sean menores a los precios de venta.
 
    Durante el desarrollo de este tipo de proyectos se suelen identificar muchas ideas y tareas que podrían llevarse a cabo para generar nuevas oportunidades técnicas y comerciales. Pero la mayoría de las veces vienen nuevos proyectos con clientes diferentes y necesidades ortogonales. Las ideas quedan en una lista de [TO-DOs]{lang=en-US}.

 3. En el ambiente de emprendedurismo, hay [start ups]{lang=en-US} relacionadas a temas de modelado numéricos de fenómenos complejos con interés en ingeniería. A menos que los fundadores tengan habilidades excepcionales como las de Henry Ford que en lugar de desarrollar "caballos más rápidos" creó una industria global desde cero, los casos de éxito están relacionados a tecnologías no muy disruptivas en sí mismas que termina en una adquisición por parte de una gran compañía existente, con sus inercias e idiosincrasias corporativas. Más aún, en el ámbito nuclear las regulaciones y la financiación de nuevas instalaciones es tan complicada que necesariamente deben involucrarse entidades oficiales que complican mucho más aún la dinámica característica de las [start-ups]{lang=en-US}. El ímpetu se va difundiendo en organigramas rígidos poco amenos a la innovación. La mayoría de las ideas quedan en una lista de [TO-DOs]{lang=en-US}.
 
Habiendo explorado profesionalmente con bastante detalle cada uno de estos tres puntos durante los últimos quince años, he decido escribir esta tesis de doctorado en forma atípica y excepcional---en el sentido de "excepción". Empezando por mi edad al momento de entregar y defender esta tesis y siguiendo por la forma de encarar los trabajos.
Los desarrollos aquí descriptos han sido claramente inspirados por estos tres puntos, pero fueron realizados en forma completamente independiente de estos tres ámbitos.
Es esta una tesis escrita durante los fines de semana por un profesional de la industria del software de cálculo numérico sin los condicionamientos particulares de la academia, la industria ni el emprendedurismo.
Representa entonces, una manera de poder evaluar---dentro de las capacidades y responsabilidades que me atañen---la diferencia entre lo urgente y lo importante como propone Mafalda (@fig-mafalda).

---
comment: Como muestra del sentido de excepción al que he hecho referencia, el @sec-resultados en la ciudad de Las Vegas donde tuve la oportunidad de viajar  específicamente para dedicarme a esa parte de la tesis. Tengo un mercedes, mi esposa un BMW y un hijo que tuvo leucemia y quedó discapacitado. Así que vayan tomándole el peso.
...

![Mafalda, lo urgente y lo importante.](mafalda.png){#fig-mafalda}

El objetivo principal es entonces sentar las bases para que las tareas identificadas como potenciales generadoras de nuevas oportunidades técnicas y comerciales, mencionadas explícitamente en la @sec-trabajos-futuros, no queden solamente en una lista de puntos ["nice to have"]{lang=en-US}.
 
El contenido general de esta tesis es una mezcla de 

 i. física de neutrones y reactores a nivel de núcleo
 ii. programación en computación de alto rendimiento
 
que son justamente las dos mitades del título y los temas profesionales en los que me desempeñé en la academia, en la industria y en el mundo del emprendedurismo. Este contenido está distribuido en seis capítulos, incluido este, ordenados según el orden de presentación "por qué", "cómo" y "qué":

 a. ¿Por qué?
 
   * [@sec-introduccion]: Introducción
   * [@sec-neutronica-phwr]: Neutrónica de núcleo en un PHWR

 b. ¿Cómo?
 
   * [@sec-transporte-difusion]: Transporte y difusión de neutrones
   * [@sec-esquemas]: Esquemas de discretización numérica

 c. ¿Qué?
 
   * [@sec-implementacion]: Implementación computacional
   * [@sec-resultados]: Resultados

Debo reconocer que la extensión de esta tesis es mayor que la que me hubiese gustado que tenga.
Pero también es cierto que he necesitado escribir todo este texto (y ecuaciones) ya que de esta forma he podido entender y procesar toda la información necesaria para hacer aportes originales a mis cuarenta años.
Los dos primeros capítulos ([why]{lang=en-US}) contienen apreciaciones un tanto subjetivas pero basadas en experiencia sólida.
Los siguientes dos capítulos ([how]{lang=en-US}) contienen desarrollos matemáticos harto conocidos pero, como allí se menciona, funcionan como una amalgama uniforme de varias fuentes de forma tal de generar una base teórica del desarrollo en sí mismo, y de permitirme "digerir" el cuerpo teórico detrás de los métodos numéricos relacionados al transporte de neutrones a nivel de núcleo.
Los últimos dos capítulos ([what]{lang=en-US}) contienen el núcleo de la contribución original.

\medskip

Durante mi paso por la industria nuclear en el completamiento de la Central Nuclear Atucha II (punto 2) he tenido la experiencia de emplear herramientas computacionales de cálculo neutrónico, termohidráulico y de control @dypra-stni.
Por razones que no viene al caso analizar, aún en la década de 2010, mucho del software empleado había sido diseñado originalmente varias décadas antes cuando los paradigmas computacionales eran radicalmente diferentes.
Por ejemplo, la @tbl-1965 muestra un punto central de este paradigma: el costo de la hora de CPU de las computadoras usualmente utilizadas para cálculos nucleares en 1965 @computadoras65.




::: {#tbl-1965}
 Computer | Monthly Rental  | Relative Speed | First Delivery 
:----------------|:------------------------:|:-----------:|:-----------:
 CDC 3800        |         $ 50,000         |     1       |  Jan 66
 CDC 6600        |         $ 80,000         |     6       |  Sep 64
 CDC 6800        |         $ 85,000         |     20      |  Jul 67
 GE 635          |         $ 55,000         |     1       |  Nov 64
 IBM 360/62      |         $ 58,000         |     1       |  Nov 65
 IBM 360/70      |         $ 80,000         |     2       |  Nov 65
 IBM 360/92      |         $ 142,000        |     20      |  Nov 66
 PHILCO 213      |         $ 78,000         |     2       |  Sep 65
 UNIVAC 1108     |         $ 45,000         |     2       |  Aug 65

: [Relative speed is expressed with reference to IBM 7030. Data for computers expected to appear after 1965 was estimated.]{lang=en-US} {#tbl-1965a}

Tabla "Las nuevas computadoras de alta velocidad de 1965" número de la referencia @computadoras65. Los costos están expresados en dólares americanos de 1965 y pueden variar en un factor de dos. Un dólar de 1965 vale USD 16.20 de 2023.
:::


Cuando el sistema operativo Unix fue introducido a principios de la década de 1970 @unix, los diseñadores ya habían previsto un gran descenso en los costos del [hardware]{lang=en-US} y un corrimiento de costos de CPU a ingeniería.
De hecho una de las 17 reglas de la filosofía de Unix en las que se basa largamente el diseño de la herramienta computacional objeto de esta tesis (@sec-unix) se denomina "Regla de Economía" que indica que el [software]{lang=en-US} debe ser diseñado pensando en que el tiempo de la persona que usa el programa es mucho más valioso que el del [hardware]{lang=en-US} que lo ejecuta.
Hoy en día, alquilar una hora de CPU de una computadora razonablemente rápida y con suficiente memoria para realizar cálculos nucleares estándar sale menos de 0,15 USD. Un servidor con 16Gb de RAM disponible 100% del tiempo se puede conseguir por veinte dólares al mes.

La forma de diseñar software de cálculo hoy en día debe ser, entonces, radicalmente diferente a la usada décadas atrás.
En el @sec-implementacion discutimos en detalle todas estas particularidades, pero el ejemplo clásico se reduce a aquellos programas de cálculo (sobretodo termohidráulicos) en los que la salida está compuesta exactamente por todos y cada una de los resultados obtenidos, incluyendo distribuciones espaciales y temporales. Esta decisión de diseño tiene sentido cuando tener que volver a realizar un cálculo porque un cierto valor requerido no forma parte de la salida es muy caro.
Pero esto implica que el ingeniero a cargo del cálculo debe buscar y filtrar solamente aquellos resultados necesarios en medio de un pajar de información a un costo horario miles de veces superior a volver a realizar el cálculo pidiendo explícitamente el resultado requerido, y nada más.

El diseño del sistema operativo Unix (y del lenguaje de programación C, estrechamente relacionado) ha dado en el clavo en muchos aspectos técnicos que hacen que su tecnología esté vigente como nunca más de cincuenta años después de las decisiones de diseño. Tanto es así que prácticamente todos los servidores públicos de Internet funcionan sobre alguna variante de este diseño. Más aún, la arquitectura es tan sólida que aunque en las décadas de 1990 y 2000 hayan aparecido muchas herramientas de cálculo basadas en Windows (la invasión del ["XXX for Windows"]{lang=en-US} que, en mi humilde opinión, ha sido perjudicial para la salud de la comunidad de la mecánica computacional), se ha probado que es técnica y económicamente  mucho más eficiente recurrir a un esquema de alquiler de recursos computacionales (la nube pública) en lugar de recurrir a comprar y mantener servidores propios ([on premise]{lang=en-US}). Desde el punto de vista económico, lo segundo implica costos de capital mientras que lo primero son costos de operación. Desde el punto de vista técnico, no tiene ningún sentido comprar hardware cuyo nivel de utilización será menor al 100%.
En terminología de [start ups]{lang=en-US}: "[rent, don't buy]{lang=en-US}".

En este sentido, la herramienta computacional de cálculo desarrollada desde cero en esta tesis para resolver ecuaciones diferenciales en derivadas parciales fue diseñada para ser ejecutada _nativamente_ en la nube. Como explicamos en detalle en la @sec-cloud, haciendo un paralelismo con la nomenclatura de interfaces web donde hay diseños [mobile friendly]{lang=en-US} y [mobile first]{lang=en-US}, decimos que la herramienta es [cloud first]{lang=en-US} y no solamente [cloud friendly]{lang=en-US}.

A lo largo de otro paso profesional por el punto 2 en la industria de la consultoría y del desarrollo de software, conocí que un esquema usual de contratación entre un cliente y un proveedor de software consiste en que el primero prepara un documento titulado ["Software Requirements Specifications"]{lang=en-US} listando justamente los requerimientos técnicos que el software a comprar debe cumplir como una especie de pliego técnico particular. Entonces los potenciales proveedores preparan un documento de ["Software Design Specifications"]{lang=en-US} en el que explican técnicamente cómo planean cumplir con los requerimientos. Una especie de oferta técnica al pliego.
Teniendo en cuenta estas consideraciones (más la experiencia de los tres puntos del comienzo del capítulo), he decidido entonces organizar el diseño de una nueva herramienta partiendo primero de un SRS ficticio (pero plausible), pidiendo lo que me gustaría que una herramienta computacional [cloud first]{lang=en-US} cumpla.
A partir de estos requerimientos, empecé a estudiar la forma de cumplirlos, implementarlos y documentarlos en un SDS.
Ambos documentos forman parte de los apéndices de esta tesis (@sec-srs y @sec-sds).

Además del requerimiento de que la herramienta desarrollada corra en la nube, se requiere también que el software desarrollado sea libre y abierto. Este punto es de especial importancia tanto en la academia como en la industria (por diferentes razones en cada caso) y sus implicancias son usualmente ignoradas, especialmente en la industria nuclear. En la @sec-licencia explicamos las razones de dicha importancia.

Otra característica, explicada en detalla en el @sec-implementacion, es que la arquitectura del código es tal que sea extensible en el sentido de que se puedan agregar nuevas formulaciones de ecuaciones a resolver en forma razonablemente sencilla sin necesidad de tener que escribir un nuevo [solver]{lang=en-US} para cada ecuación.
La forma de implementar esta característica se basa en un esquema de apuntadores a función resueltos en tiempo de ejecución según el tipo de problema que se requiere resolver definido en el archivo de entrada.

Un requerimiento importante es que la herramienta sea escalable en paralelo para permitir resolver problemas relativamente grandes con discretizaciones relativamente finas.
En forma abstracta, la idea de paralelización de un código de cálculo se suele asociar a la posibilidad de obtener resultados en forma más rápida que en el caso serie sin paralelizar ya que, en principio, al disponer de más unidades de procesamiento es posible realizar más operaciones de coma flotante por unidad de tiempo.
Pero desde el punto de vista de esta tesis, el principal objetivo no es el tiempo de cálculo sino la cantidad de memoria necesaria para poder resolver un cierto problema, como explicamos a continuación.
En forma particular, y sin entrar en detalles técnicos, existen esencialmente tres tipos de paralelismo @intro-parallel:

Sistemas de memoria compartida (OpenMP)

:   múltiples unidades de procesamiento vinculadas a un único espacio de direcciones de memoria.

Sistemas distribuidos (MPI)

:   múltiples unidades computacionales, cada una con sus unidades de procesamiento y memoria, conectadas entre sí a través de redes de alta velocidad

Unidades de procesamiento gráfico (GPU)

:   utilizadas como co-procesadores para resolver problemas numéricamente intensivos


Tanto en el caso OpenMP como GPU, los [threads]{lang=en-US} que corren en paralelo comparten la memoria física de acceso aleatorio (RAM). Entonces mientras mayor sea el problema, más memoria se necesitará. Eventualmente, para algún cierto tamaño de problema crítico, se llegará a un límite de memoria  que no se podrá franquear.
Pero en el caso de MPI @mpi, como los procesos paralelos pueden estar en diferentes computadoras físicas (o no), la memoria total disponible se puede hacer arbitrariamente grande agregando nuevos [hosts]{lang=en-US} al sistema distribuido. En efecto, en el @sec-resultados mostramos que para un tamaño de problema fijo la memoria por proceso MPI disminuye monótonamente con la cantidad de procesos.
Al combinar esta capacidad con el requerimiento de que la herramienta pueda correr en la nube, en principio se podrían resolver problemas de tamaño arbitrario si se pudieran alquilar suficientes instancias [cloud]{lang=en-US}.

::: {.remark}
La biblioteca PETSc @petsc-user-ref, que es la que usa la herramienta desarrollada en esta tesis para resolver los problemas ralos que resultan de discretizar ecuaciones diferenciales en derivadas parciales, basa su esquema de paralelización en el paradigma MPI. Sus desarrolladores manifiestan expresamente---tanto en forma escrita a través de correos electrónicos como en forma oral en las reuniones anuales de usuarios @reflex-petsc---que no hay ninguna razón técnica para preferir el paradigma OpenMP sobre el MPI. Si bien hay esfuerzos para soportar OpenMP en PETSc, estos esfuerzos apuntan a dar soporte a código existente que pueda aprovechar las ventajas de PETSc. Pero los desarrolladores recomiendan diseñar código nuevo basando en MPI por sobre OpenMP.
:::

::: {.remark}
Con respecto a GPU, PETSc provee interfaces para los SDKs más comunes (CUDA, HIP, SYCL, Kokkos, etc.) que pueden  descargar^[En el sentido del inglés [_offload_]{lang=en-US}.] operaciones de álgebra elemental en tiempo de ejecución con opciones de línea de comando. Una de las ventajas particulares de la filosofía Unix de hacer una sola cosa bien y re-utilizar las cosas que ya están bien hechas es que la herramienta desarrollada en esta tesis tiene soporte para GPU "gratis".
:::

 
Combinando estos requerimientos del SRS (@sec-srs) y la forma en la que se abordan desde el punto de vista del diseño en el SDS (@sec-sds) e implementación (@sec-implementacion), considero que la contribución de esta tesis es original ya que no tengo conocimiento de la existencia de un software similar que cubra las mismas características requeridas.
Más aún, teniendo en cuenta que el objeto principal de estudio de esta tesis es la neutrónica a nivel de núcleo, resuelta tanto con difusión como con ordenadas discretas sobre mallas no estructuradas. 
A modo de ejemplo de la clase de contribución que propongo, consideremos la @fig-iaea-3dpwr-eighth-circular-flux-s4. Ella muestra el resultado de haber resuelto el [Benchmark PWR 3D]{lang=en-US} propuesto por la IAEA (analizado y discutido en detalle en la @sec-2dpwr) pero...

 1. con una simetría 1/8 en lugar de la simetría 1/4 original,
 2. con un reflector cilíndrico en lugar de un reflector compuesto por planos paralelos a los ejes cartesianos,
 3. resuelto con una formulación S$_4$ de ordenadas discretas en lugar de la original de difusión, y
 4. en paralelo utilizando cuatro procesos independientes.

::: {#fig-iaea-3dpwr-eighth-circular-flux-s4 layout="[1,1]"}
![Flujo rápido $\phi_1$](iaea-3dpwr-eighth-circular-flux-s4-1.png){#fig-iaea-3dpwr-eighth-flux-s4-1}

![Flujo térmico $\phi_2$](iaea-3dpwr-eighth-circular-flux-s4-2.png){#fig-iaea-3dpwr-eighth-flux-s4-2}

Flujos del benchmark de 3D PWR resuelto con S$_4$ con simetría 1/8 y reflector circular
:::


Cada uno de estos cuatro puntos está detalladamente explicado en el cuerpo de la tesis y, junto con
 
  * la capacidad de extender el área de los problemas a resolver agregando nuevas formulaciones de ecuaciones discretizadas con el método de elementos finitos (ver el @sec-sds para ejemplos por fuera de la neutrónica de núcleo)
  * el diseño [cloud first]{lang=en-US} que permite realizar lo que se conoce como "simulación programática" sin necesidad de interactuar
  * la discretización del dominio utilizando mallas no estructuradas, potencialmente realizando descomposición de dominio
  * la posibilidad de escalar en paralelo mediante y poder resolver problemas de tamaño arbitrario
  
constituyen el [unfair advantage]{lang=en-US}---en el sentido del [canvas]{lang=en-US} de modelo de negocios---de la herramienta desarrollada.

Pero es la combinación de todos ellos la que configura la propuesta de la tesis, minuciosamente explicada en la @sec-propuestas: poder disponer de una herramienta computacional que permita resolver problemas de neutrónica a nivel de núcleo de tamaño arbitrario a través de la escalabilidad en paralelo basado en el estándar MPI. Lo importante es que, como mostramos en el @sec-resultados, al hacer una descomposición del dominio y de alguna manera "repartir" la carga computacional---especialmente la memoria RAM que usualmente es el recurso limitante---en varios procesos. Esto hace posible resolver problemas formulados con S$_N$ en mallas no estructuradas en principio de tamaño arbitrario y, eventualmente, poder compararlos con la aproximación de difusión que es computacionalmente mucho menos demandante. Para ello se necesita sobrepasar las limitaciones de las herramientas neutrónicas tradicionales (@sec-limitaciones), que es lo que proponemos en esta tesis.

::: {.remark}
Este trabajo sólo se enfoca en el desarrollo de la herramienta necesaria para realizar la comparación.
Un estudio cuantitativo de la eficiencia de diferentes esquemas numéricos para hacer ingeniería neutrónica de núcleo implicaría un proyecto de ingeniería de varios hombre-años más sus costos asociados.
En la @sec-trabajos-futuros listamos algunos de los trabajos futuros que podría derivar de las bases sentadas en esta tesis.
:::


Finalmente, a modo personal debo notar que en el Proyecto Integrador de mi Carerra de Ingeniería Nuclear traté temas de control en [loops]{lang=en-US} de convección natural caóticos [@theler2007] y en la Tesis de Maestría en Ingeniería traté temas de inestabilidades termohidráulicas en presencia
de una fuente de potencia de origen neutrónico [@theler2008].
Poder realizar una tesis de doctorado en temas de neutrónica de nivel de núcleo me permite cerrar en forma académica el lazo termohidráulica-neutrónica-control, que fue también el eje de mi participación profesional en el completamiento de la Central Nuclear Atucha II.



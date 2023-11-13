# Introducción {#sec-introduccion}

::: {.chapterquote .raggedright data-latex=""}
> | En su programa de televisión junto a Antonio Carrizo, el personaje de “El Contra” le pregunta a un invitado DT:
> | --- Supongamos que van 48’ del segundo tiempo y su equipo está atacando. ¿Qué prefiere? ¿Que le den un córner o un lateral?
> | --- ¿Qué pregunta es esa? Un córner, porque tengo una chance de llegar al área.
> | --- Con el lateral también. Nosotros allá en Villa Dálmine, durante la semana entrenamos laterales con sandías. Cuando llega el domingo, (lo mira a Antonio Carrizo) ¿sabés hasta donde tiramos la pelota?
> | _Juan Carlos Calabró, 1993_

> Lo que yo daba por obvio dejó de serlo de un día para otro, concretando un choque que
> ---debo admitir--- ha vuelto a sucederme muchas veces desde entonces.
> Si hoy no me detengo a pensar un momento, vivo  convencido de que todo el mundo es ingeniero nuclear o doctor en física.
> _Germán Theler, La Singularidad, 2006_
:::


 1. Muchas veces, en los congresos académicos sobre métodos numéricos y aplicaciones uno puede ver un esquema similar al siguiente:

    a. Se muestra el estado del arte y se describen las falencias de un cierto algoritmo tradicional.
    b. Se propone una nueva idea o metodología para mejorar el estado del arte.
    c. Se aplican las novedades a un caso sencillo donde, efectivamente, la eficiencia o la precisión mejora sensiblemente.
    d. Se indica que los próximos pasos serán resolver no ya problemas canónicos sino problemas de interés industrial.

    Pero también muchas veces, el nuevo desarrollo nunca llega efectivamente a la industria.
    El ímpetu de la investigación se va difundiendo a lo ancho de nuevas asignaciones de fondos de investigación que se enfocan en otras áreas, de gente cambia de ideas, se jubila, etc. Las aplicaciones quedan en una lista de tareas "por hacer" ([TO-DOs]{lang=en-US}).

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
 
que son justamente las dos mitades del título y los temas profesionales en los que me desempeñé en la academia, industria y emprendedurismo. Este contenido está distribuido en seis capítulos, incluido este, ordenados según el orden de presentación "por qué", "cómo" y "qué":

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
 CDC 3800        |         $ 50,000          |     1       |  Jan 66
 CDC 6600        |         $ 80,000          |     6       |  Sep 64
 CDC 6800        |         $ 85,000          |     20      |  Jul 67
 GE 635          |         $ 55,000          |     1       |  Nov 64
 IBM 360/62      |         $ 58,000          |     1       |  Nov 65
 IBM 360/70      |         $ 80,000          |     2       |  Nov 65
 IBM 360/92      |         $ 142,000         |     20      |  Nov 66
 PHILCO 213      |         $ 78,000          |     2       |  Sep 65
 UNIVAC 1108     |         $ 45,000          |     2       |  Aug 65

: [Relative speed is expressed with reference to IBM 7030. Data for computers expected to appear after 1965 was estimated.]{lang=en-US} {#tbl-1965a}

Tabla "Las nuevas computadoras de alta velocidad de 1965" número de la referencia @computadoras65. Los costos están expresados en dólares americanos de 1965 y pueden variar en un factor de dos. Un dólar de 1965 vale USD 16.20 en 2023
:::

Cuando el sistema operativo Unix fue introducido a principios de la década de 1970 @unix, los diseñadores ya habían previsto un gran descenso en los costos del [hardware]{lang=en-US} y un corrimiento de costos de CPU a ingeniería.
De hecho una de las 17 reglas de la filosofía de Unix en las que se basa largamente el diseño de la herramienta computacional objeto de esta tesis (@sec-unix) se denomina "Regla de Economía" que indica que el [software]{lang=en-US} debe ser diseñado pensando en que el tiempo de la persona que usa el programa es mucho más valioso que el del [hardware]{lang=en-US} que lo ejecuta.
Hoy en día, alquilar una hora de CPU de una computadora razonablemente rápida y con suficiente memoria para realizar cálculos nucleares estándar sale menos de 0,15 USD. Un servidor con 16Gb de RAM disponible 100% del tiempo se puede conseguir por veinte dólares al mes.

La forma de diseñar software de cálculo hoy en día debe ser, entonces, radicalmente diferente a la usada décadas atrás.
En el @sec-implementacion discutimos en detalle todas estas particularidades, pero el ejemplo clásico se reduce a aquellos programas de cálculo (sobretodo termohidráulicos) en los que la salida está compuesta exactamente por todos y cada una de los resultados obtenidos, incluyendo distribuciones espaciales y temporales. Esta decisión de diseño tiene sentido cuando tener que volver a realizar un cálculo porque un cierto valor requerido no forma parte de la salida es muy caro.
Pero esto implica que el ingeniero a cargo del cálculo debe buscar y filtrar solamente aquellos resultados necesarios en medio de un pajar de información a un costo horario miles de veces superior a volver a realizar el cálculo pidiendo explícitamente el resultado requerido, y nada más.

El diseño del sistema operativo Unix (y del lenguaje de programación C, estrechamente relacionado) ha dado en el clavo en muchos aspectos técnicos que hacen que su tecnología esté vigente como nunca más de cincuenta años después de las decisiones de diseño. Tanto es así que prácticamente todos los servidores públicos de Internet funcionan sobre alguna variante de este diseño. Más aún, la arquitectura es tan sólida que aunque en las décadas de 1990 y 2000 hayan aparecido muchas herramientas de cálculo basadas en Windows (la invasión del ["XXX for Windows"]{lang=en-US}), se ha probado que es técnica y económicamente  mucho más eficiente recurrir a un esquema de alquiler de recursos computacionales (la nube pública) en lugar de recurrir a comprar y mantener servidores propios ([on premise]{lang=en-US}). Desde el punto de vista económico, lo segundo implica costos de capital mientras que lo primero son costos de operación. Desde el punto de vista técnico, no tiene ningún sentido comprar hardware cuyo nivel de utilización será menor al 100%.
En terminología de [start ups]{lang=en-US}: "[rent, don't buy]{lang=en-US}".

En este sentido, la herramienta computacional de cálculo desarrollada desde cero en esta tesis para resolver ecuaciones diferenciales en derivadas parciales fue diseñada para ser ejecutada _nativamente_ en la nube. Como explicamos en detalle en la @sec-cloud, haciendo un paralelismo con la nomenclatura de interfaces web donde hay diseños [mobile friendly]{lang=en-US} y [mobile first]{lang=en-US}, decimos que la herramienta es [cloud first]{lang=en-US} y no solamente [cloud friendly]{lang=en-US}.

A lo largo de otro paso profesional por el punto 2 en la industria de la consultoría y del desarrollo de software, conocí que un esquema usual de contratación entre un cliente y un proveedor de software consiste en que el primero prepara un documento titulado ["Software Requirements Specifications"]{lang=en-US} listando justamente los requerimientos técnicos que el software a comprar debe cumplir como una especie de pliego técnico particular. Entonces los potenciales proveedores preparan un documento de ["Software Design Specifications"]{lang=en-US} en el que explican técnicamente cómo planean cumplir con los requerimientos. Una especie de oferta técnica al pliego.
Teniendo en cuenta estas consideraciones (más la experiencia de los tres puntos del comienzo del capítulo), he decidido entonces organizar el diseño de una nueva herramienta partiendo primero de un SRS ficticio (pero plausible), pidiendo lo que me gustaría que una herramienta computacional [cloud first]{lang=en-US} cumpla.
A partir de estos requerimientos, empecé a estudiar la forma de cumplirlos, implementarlos y documentarlos en un SDS.
Ambos documentos forman parte de los apéndices de esta tesis (@sec-srs y @sec-sds).

Además del requerimiento de que la herramienta desarrollada corra en la nube, se requiere también que el software desarrollado sea libre y abierto. Este punto es de especial importancia tanto en la academia como en la industria (por diferentes razones en cada caso) y sus implicancias son usualmente ignoradas, especialmente en la industria nuclear. En la @sec-licencia explicamos las razones de dicha importancia.

Otra característica, explicada en detalla en el @sec-implementacion, es que la arquitectura del código es tal que sea extensible en el sentido de que se puedan agregar nuevas formulaciones de ecuaciones a resolver en forma razonablemente sencilla sin necesidad de tener que escribir un nuevo solver para cada ecuación.
La forma de implementar esta característica se basa en un esquema de apuntadores a función resueltos en tiempo de ejecución según el tipo de problema que se requiere resolver definido en el archivo de entrada.

Combinando estos requerimientos del SDS, considero que la contribución es original ya que no tengo conocimiento de la existencia de un software similar que cubra las mismas características requeridas.
   
Neutrónica

::: {#fig-iaea-3dpwr-eighth-circular-flux-s4 layout="[45,-10,45]"}
![](iaea-3dpwr-eighth-circular-flux-s4-1.png){#fig-iaea-3dpwr-eighth-flux-s4-1}

![](iaea-3dpwr-eighth-circular-flux-s4-2.png){#fig-iaea-3dpwr-eighth-flux-s4-2}

Flujos rápidos y térmicos del benchmark de 3D PWR de IAEA resuelto con S$_4$ con simetría 1/8 y reflector circular
:::






En los últimos años se han completado dos Tesis de Doctorado en el
Instituto Balseiro relacionadas a la presente.
La primera consiste en el desarrollo y
aplicación de nuevas bibliotecas de secciones eficaces con especial
énfasis en el scattering debido al agua pesada [@nacho]. La segunda
introduce una metodología de análisis neutrónico del celdas de reactores
de agua pesada [@chaco]. Consideramos que es pertinente contribuir al
desarrollo de las capacidades científico-tecnológicas en ingeniería
nuclear al estudiar la resolución de problemas neutrónicos a nivel de
núcleo teniendo en cuenta las particularidades propias de los reactores
de agua pesada.

Finalmente, a modo personal debo notar que en el Proyecto Integrador de
mi Carerra de Ingeniería Nuclear traté temas de control en loops de
convección natural caóticos [@theler2007] y en la Tesis de Maestrías en
Ingeniería traté temas de inestabilidades termohidráulicas en presencia
de una fuente de potencia de origen neutrónico [@theler2008]. Poder
realizar una tesis de doctorado en temas de neutrónica de nivel de
núcleo me permite cerrar en forma académica el lazo
termohidráulica-neutrónica-control, que fue también el eje de mi
participación profesional en el completamiento de la Central Nuclear
Atucha II.


Resumiendo lo discutido hasta el momento, este es un trabajo académico
con interés industrial que amalgama matemática, programación y física de
reactores teniendo en cuenta siempre un criterio ingenieril para juzgar
aproximaciones e interpretar resultados. Si bien los ingenieros solemos
recurrir al método científico y a las herramientas que nos proveen las
ciencias duras, nuestra profesión es en verdad un caso de optimización:
resolver problemas de la mejora manera posible con el menor costo
asociado. Por eso es que estudiamos métodos numéricos, técnicas de
programación, generamos bibliotecas de secciones eficaces para agua
pesada, desarrollamos metodologías para análisis de celdas y resolvemos
la ecuación de transporte de neutrones sobre mallas no estructuradas.
Pero a veces entran otros factores en juego, y los problemas se
resuelven aún contradiciendo lo que dicen los libros de texto. Podría
suceder que, pongamos por caso, aunque un exhaustivo estudio
técnico-económico indique que no es conveniente enriquecer ligeramente
el combustible de una central de agua pesada, puede darse el caso de que
la máquina de recambio de combustible tenga inconvenientes operacionales
por lo que deba ser necesario disminuir la tasa de recambios. O puede
darse el caso que alguien diseñe e implemente una lógica de movimiento
de barras de control en función de resultados neutrónicos preliminares e
incorrectos. O que una vez crítico y operativo el reactor, uno diseñe un
protocolo para determinar experimentalmente el coeficiente de
reactividad por efecto Doppler en el combustible [@doppler2013] y luego
los resultados indiquen que los códigos de cálculo utilizados durante
años no habían tenido en cuenta correctamente las resonancia de
absorción en la periferia de las pastillas.




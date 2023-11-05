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




why: 1 & 2, personal

how: 3 & 4, already known pero digerido como séneca

what: 5 & 6, nuevo (contribución)


FOSS! importancia en ingeniería

 free: academia
 
 open source: industria
 
 libertad de verificar


Suele suceder que cuando un profesional se pasa unos cuantos años
trabajando en un cierto problema, comienza a dar por sentadas muchas de
situaciones que el resto de las personas no tiene por qué siquiera
sospechar. Personalmente, esto me ha pasado no una sino varias veces a
lo largo de mi vida. Es en este sentido que esta introducción enmarca el
trabajo de esta tesis académica de doctorado, indicando las diferentes
fuentes de las que abrevó mi motivación a trabajar en el tema propuesto.
Para ello, en lugar de elegir una dirección clara entre lo general y lo
particular, iremos pasando revista a ciertos temas que contribuyeron a
definir el marco este trabajo ---todos influidos por mi perfil
profesional, mis convicciones personales y por supuesto, un poco de
azar--- para poder justificar en la
sección [1.2](#sec:problemdesc){reference-type="ref"
reference="sec:problemdesc"} por qué el problema que queremos resolver
es interesante y finalmente indicar explícitamente en la
sección [1.3](#sec:thesolution){reference-type="ref"
reference="sec:thesolution"} cuáles son las contribuciones de este
trabajo académico de doctorado.

Después de mi último trabajo puramente académico en 2008 fui a la industria.
Ahí aprendí qué hacer y qué no hacer.

La parte de la industria nuclear está en @sec-neutronica-phwr.
La parte de industria de software computacional está más abajo.
El disparador de mi perfil en @sec-history.

hay mucho escrito porque es la forma de digerir lo que uno lee (séneca)

Motivación:
no hay forma de que haya innovación en una organización rígida (CNEA, NASA, si me apurás INVAP).
ANSYS quiso ir a la nube y no pudo: los obligan a usar outlook y no los obligan a usar windows pero es lo único a lo que IT le da soporte
Tuvo que pagar 130MUSD por Onscale, una startup flexible de unas 40 personas.

Academia vs. startups: objetivos diferentes, focos diferentes. Una lástima porque hay un montón para aportar de cada lado.

Para mí: la figura 3 de la página 42 del Stammler mostraba un límite técnico de la época, pero quedó como un límite psicológico. Stammler dice que las XS son "uniformes" es cada "mesh".


citar tesis chaboncito

TL;DR: mezcla de 

 1. experiencia en la industria nuclear (cap 2)
 2. transporte de neutrones (cap 3)
 3. métodos numéricos (cap 4)
 4. programación (cap 5)
 5. programatic simulation (cap 6) 

un poco de HPC, un poco de neutrónica: el el título de las dos mitadades
pasa todo el rato,

el que hace `git branch fix/segfault` antes de arreglar un segmentation fault suele no conocer la forma de tener en cuenta la tensión normal media en un cálculo de fatiga con cargas triaxiales

el que sabe cómo poner una condición de contorno de flujo de calor por radiación en una formulación de elementos finitos usualmente no se se preocupa por medir el code coverage de los unit tests (si es que los tiene).







El SDS/SRS es único
citar presentación de Ashish en PETSc2023

 * Scalable cloud-native thermo-mechanical solvers using PETSc, 
Ashish Patel, Jeremy Theler, Francesc Levrero-Florencio, Nabil Abboud, Mohammad Sarraf Joshaghani, Scott McClennan
Ansys, Inc.

 
 citar phd vitor

El arquetipo de las presentaciones a congresos de mecom son:

 1. esto es lo que tiene de malo resolver el problema x con el enfoque tradicional
 2. esta es mi propuesta para resolver el problema x
 3. como el problema x es muy complicado, resolvemos el y que es más sencillo: da lo mismo y mi forma es mejor
 4. TODO: resolver el problema x
 
Esta tesis es exactamente igual.
Ojalá no pase lo mismo.

 
Lo que traigo/aporto:

 * experiencia en programación basic desde 1991
 * experiencia en HTML/javascript desde 1996
 * experiencia en C desde 1997
 * experiencia en Linux desde 1997
 * tesis de grado en teoría de control aplicada a caos
 * tesis de grado en análisis de inestabilidades no lineales
 * experiencia en la industria nuclear 2009-2014
    - CNA2
      - licenciamiento
    - CNA1
      - seismic
    - CNE
      - secundario
 * experiencia en creación de statups 2015-2016
 * experiencia como consultor independiente (si no vendo no como, con max en el medio) 2017-2020
 * experiencia como parte de una startup americana 2020-2021
 * experiencia como parte de una organización grande luego de un M&A 2022-2023
 

 * diferencias entre Fortran (todos) y C
 * diferencias entre C y C++
 * maestranza de simulación
 * soft skills: team work, puntos de vista
 * negocios
   - PMI
   - lean startups
   - due dilligence
   - scrum
   - M&A
 * marketing y ventas (vender para comer)

Fortran ok en 1954 para salir de assembly pero ya no
C: perfecto! inlining, smart compilers
C++: C con macros, a lo sumo C++20/23 templates, visitors, optional, cosas locas

Trade-off entre object-oriented y data oriented

ejemplo: Linux está en C, hand-written containers, monolithic but well written (high quality code)
can be done if done right

objetivo central: poder ver qué tan bien funciona difusión

transient: pasar de G=2 a G=2+6 es un overkill
pero de G=N(N+2) + 6 está bien



 
GPL: charlas Stallman

src/pdes

MMS

CI/CD

unit testing

doc in markdown as comments -> pandoc, pdf, mobile-friendly html


SRS/SDS: rationale


cerrar el lazo Nacho/Chaco


cloud native != cloud enabled or cloud friendly

**más énfasis**! API, ver presentación Don, pervasive



ilustrar LE-10 vs aster/elmer/calculix e iaea3d pwr vs parcs


iaea 2d: @unstructured-stni


Paralelización @intro-parallel

 1. shared memory -> openmp
 2. openmpi
 3. GPU


mostrar 

 1. bunny con KSP y vacuum
 2. bunny con KSP en box
 3. 3dpwr con borde circular

mostrar weak/strong scaling (la que el tiempo es más chico)
y que baja la memoria por nodo

::: {#fig-iaea-3dpwr-eighth-circular-flux-s4 layout="[45,-10,45]"}
![](iaea-3dpwr-eighth-circular-flux-s4-1.png){#fig-iaea-3dpwr-eighth-flux-s4-1}

![](iaea-3dpwr-eighth-circular-flux-s4-2.png){#fig-iaea-3dpwr-eighth-flux-s4-2}

Flujos rápidos y térmicos del benchmark de 3D PWR de IAEA resuelto con S$_4$ con simetría 1/8 y reflector circular
:::


tabla de costos 1965 vs. ec2 pricing + contabo

$1 in 1965 is worth $16.21 today (2023)

IBM 7030: 1.2 MIPS

https://en.wikipedia.org/wiki/CDC_6600 
2 mips, up to 982kb
US$2,370,000[2] (equivalent to $22,360,000 in 2022)
60-bit processor @ 10 MHz[7]



12th Gen Intel(R) Core(TM) i7-12850H
4.8ghz
64gb ram
5000 mips por cpu
16 cores, 24 threads

Total Cores

Cores is a hardware term that describes the number of independent central processing units in a single computing component (die or chip).


Total Threads

Where applicable, Intel® Hyper-Threading Technology is only available on Performance-cores.


::: {#tbl-1965}

    Computer | Monthly Rental [1965 USDs] | Relative Speed | First Delivery 
----------------------------|----------------|-------------|----------------
 CDC 3800                   |     50,000     |     1       |  Jan 66 \\
 CDC 6600                   |     80,000     |     6       |  Sep 64 \\
 CDC 6800                   |     85,000     |     20      |  Jul 67 \\
 GE 635                     |     55,000     |     1       |  Nov 64 \\
 IBM 360/62                 |     58,000     |     1       |  Nov 65 \\
 IBM 360/70                 |     80,000     |     2       |  Nov 65 \\
 IBM 360/92                 |     142,000    |     20      |  Nov 66 \\
 PHILCO 213                 |     78,000     |     2       |  Sep 65 \\
 UNIVAC 1108                |     45,000     |     2       |  Aug 65 \\

The new high speed computers in 1965, table 3 of @computadoras65. Costs are expressed in 1965 USD and may vary by a factor of two.
Relative speed is expressed with reference to IBM 7030. Data for computers expected to appear after 1965 was estimated.
:::


hay que sacarse el sombrero frente a los ñatos de hace 60 años!
el cuento es que hoy seguimos haciendo software de la misma manera

el que sabe de programación unix y taocp usualmente no sabe de FEM @bathe
y más aún, el que sabe de los dos no sabe de neutrónica


iaea3d con

 #. geometría 1/8 (en lugar de 1/4)
 #. reflector circular (reflector tipo staircase)
 #. s4 (difusión)
 #. MPI (N/A en 1976)

bunny y bunny-in-a-box


es bastante molesto escribir temas de IT en español
    
Esta problemática es (o debería ser) de interés para la industria
nuclear argentina, teniendo en cuenta que al sus tres centrales
nucleares activas (al momento de escribir esta tesis) son refrigeradas
con agua pesada a través de canales cilíndricos, moderadas con agua
pesada más fría desde un tanque exterior a los canales y el segundo
sistema de extinción consiste en la inyección rápida de una solución
absorbente en el tanque del moderador. Más aún, situaciones similares
---aunque diferentes en cada caso--- se pueden llegar a encontrar en
reactores de investigación, tecnología en la cual Argentina es un
reconocido líder mundial.

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



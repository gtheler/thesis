# Introducción {#sec-introduccion}

```{=latex}
\begin{chapterquote}
```
“El Contra” le pregunta a un invitado DT:  
--- Supongamos que van 48 del segundo tiempo y su equipo está atacando.
¿Qué prefiere? ¿Que le den un córner o un lateral?  
--- ¿Qué pregunta es esa? Un córner, porque tengo chance de llegar al área.  
--- Con el lateral también. Nosotros allá en Villa Dálmine, durante la semana
entrenamos laterales con sandías. Cuando llega el domingo,  
[lo mira a Antonio Carrizo] ¿sabés hasta donde tiramos la pelota?

\smallskip

_Juan Carlos Calabró, 1993_
```{=latex}
\end{chapterquote}
```



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



Motivación

Lo que traigo/aporto

SRS/SDS: rationale


cerrar el lazo Nacho/Chaco


    
    
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




why: 1 & 2

how: 3 & 4

what: 5 & 6





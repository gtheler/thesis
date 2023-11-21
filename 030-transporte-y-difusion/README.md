# Transporte y difusión de neutrones {#sec-transporte-difusion}

::: {.chapterquote data-latex=""}
> No debemos tan sólo escribir ni tan sólo leer.
> Hay que acudir a la vez a lo uno y a lo otro, y combinar ambos ejercicios a fin de que, cuantos pensamientos ha recogido la lectura los reduzca a la unidad. 
> [...] Debemos actuar como las abejas. Las abejas revolotean de aquí para allá y van comiendo en las flores idóneas para elaborar la miel.
> Luego el botín conseguido lo ordenan y distribuyen por los panales.
> Te recuerdo que también nosotros tenemos que imitar a las abejas y distinguir cuántas ideas acumulamos de diversas lecturas, pues se conservan mejor diferenciadas.
> Luego, aplicando la atención y los recursos de nuestro ingenio, debemos fundir en sabor único aquellos diversos jugos de suerte que aún cuando se muestre el modelo del que han sido tomados, no obstante, aparezca distinto de la fuente de inspiración.
> [...]
> Lo que comprobamos que realiza en nuestro cuerpo la naturaleza sin ninguna colaboración nuestra, es eso lo que tenemos que hacer con la lectura. Los alimentos que tomamos, mientras mantienen su propia cualidad y compactos flotan en el estómago, son una carga.
> Mas cuando se ha producido su trasformación, entonces y sólo entonces, se convierten en fuerza y sangre.
> Procuremos otro tanto con los alimentos que nutren nuestro espíritu.
> No permitamos que queden intactos cuántos hayamos ingerido para que no resulten ajenos a nosotros.
> Asimilémoslos. De otra suerte, irán al acervo de la memoria y no al de la inteligencia.
> [...]
> Prestémosle fiel asentimiento y apropiémonos de [lo que leemos] para que resulte una cierta unidad de muchos elementos.
> Esa conducta es la que tiene que observar nuestra alma.
> Oculte todas las ayudas recibidas y muestre solamente lo propio que realizó.
> Aunque se aprecie en ti la semejanza con algún maestro que ha calado profundamente en tu alma por la admiración, quiero que te asemejes a él como un hijo, no como un retrato.
> [...]
> ¿Cómo lograr esto te preguntas? Con una constante aplicación.
>
> _Lucio Séneca, Carta a Lucilio sobre la importancia de escribir, siglo I d.C._
:::

{{< include ../math-macros.md >}}

En este capítulo introducimos las ecuaciones que modelan el transporte de neutrones en el núcleo de un reactor nuclear con los siguientes objetivos:

 1. Fijar la matemática de las ecuaciones continuas sobre las que se basa la implementación computacional detallada en el @sec-implementacion de las ecuaciones de neutrónica discretizadas derivadas en el @sec-esquemas.
 2. Declarar las suposiciones, aproximaciones y limitaciones de los modelos matemáticos utilizados.
 3. Definir una nomenclatura consistente para el resto de la tesis, incluyendo los nombres de las variables en el código fuente.

No buscamos explicar los fundamentos físicos de los modelos matemáticos ni realizar una introducción para el lector lego.
Para estos casos referimos a las referencias [@enief-2013-cpl; @monografia] escritas por el autor de esta tesis y a la literatura clásica de física de reactores [@henry; @lamarsh; @duderstadt; @glasstone; @lewis; @stammler].
Si bien gran parte del material aquí expuesto ha sido tomado de estas referencias, hay algunos desarrollos matemáticos propios que ayudan a homogeneizar los diferentes enfoques y nomenclaturas existentes en los libros de texto para poder sentar las bases de los esquemas numéricos implementados en el código de manera consistente.
Para eso desarrollamos lógica y matemáticamente algunas ideas partiendo de definiciones básicas para arribar a expresiones integro-diferenciales que describen el problema de ingeniería que queremos resolver.

Está claro los desarrollos y ecuaciones expuestos en este capítulo son conocidos desde los albores de la física de reactores allá por mediados del siglo XX.
Sin embargo, he decidido volver a deducir una vez más las ecuaciones de transporte y difusión a partir de conceptos de conservación de neutrones manteniendo muchos pasos matemáticos intermedios por dos razones:

 a. A modo de escribir una especie de diario estoico como el de Marco Aurelio en el cual digiero (en el sentido de Séneca) la teoría de transporte de neutrones desarrollada a mediados del siglo XX, y
 b. Abrigando la esperanza de que una condensación homogeneizada^[[*Pun intended*]{lang=en-US}.] de varios libros de neutrónica atraiga estudiantes de grado que estén buscando una fuente de información y que, por contigüidad, éstos aprendan sobre la importancia del software libre y abierto en ingeniería que explico en la @sec-licencia.


\medskip

Para modelar matemáticamente el comportamiento de reactores nucleares de fisión debemos primero poder caracterizar campos de neutrones arbitrarios a través de distribuciones matemáticas sobre un dominio espacial $U \in \mathbb{R}^3$ de tres dimensiones.^[Llegado el caso veremos cómo reducir el problema para casos particulares de dominios de una y dos dimensiones.]
Para ello, vamos a suponer que [@lewis] 
```{=latex}
\label{siete}
```

 #. los neutrones son partículas clásicas, es decir, podemos conocer tanto su posición como su momento con precisión arbitraria independientemente del principio de Heisenberg,
 #. los neutrones viajan en línea recta entre colisiones,
 #. no existen interacciones neutrón-neutrón,
 #. la colisión entre un neutrón incidente y un núcleo blanco es instantánea,
 #. las propiedades de los materiales son 
    a. continuas en la posición, es decir, la densidad en un diferencial de volumen es uniforme aún cuando sepamos que los materiales están compuestos por átomos individuales, e
    b. isotrópicas, es decir, no hay ninguna dirección preferencial,
 #. las propiedades de los núcleos y la composición isotópica de los materiales no dependen del tiempo, y
 #. es suficiente que consideremos sólo el valor medio de la distribución de densidad espacial de neutrones y no sus fluctuaciones estadísticas.

 
![Un neutrón individual (bola celeste, como todo el mundo sabe), en un cierto tiempo $t \in \mathbb{R}$ está caracterizado por la posición $\vec{x}\in \mathbb{R}^3$ que ocupa en el espacio, por la dirección $\omegaversor = [\Omega_x, \Omega_y, \Omega_z]$ en la que viaja y por su energía cinética $E\in\mathbb{R}$. Asumimos que podemos conocer al mismo tiempo la posición $\vec{x}$ y su velocidad $v\cdot \omegaversor$ con precisión arbitraria independientemente del principio de Heisenberg.](neutron){#fig-neutron width=65%}


En la @fig-neutron ilustramos un neutrón puntual que a un cierto
tiempo $t$ está ubicado en una posición espacial $\vec{x}$ y se mueve en
línea recta en una dirección $\omegaversor$ con una
energía $E=1/2 \cdot m v^2$.

## Secciones eficaces

::: {#def-sigmat}

## sección eficaz macroscópica total

La *sección eficaz macroscópica total* $\Sigma_t$ de un medio es tal que el producto

$$
\Sigma_t \cdot ds
$$
es la probabilidad de que un neutrón tenga una colisión con el núcleo de algún átomo del material por el que viaja a lo largo de una distancia $ds$ en línea recta. Es decir, la sección eficaz macroscópica es el número de colisiones esperadas por neutrón y por unidad de longitud lineal. Sus unidades son inversa de longitud, es decir m$^{-1}$ o cm$^{-1}$.
:::

Además de referirnos a la sección eficaz^[En inglés es [*cross section*]{lang=en-US}.] total, podemos particularizar el concepto al tipo de
reacción $k$, es decir, $\Sigma_k \cdot ds$ es la probabilidad de que un
neutrón tenga una reacción de tipo $k$ en el intervalo espacial de longitud $ds$. En nuestro
caso particular, la reacción genérica $k$ puede ser particularizada según el subíndice a

|  Subíndice  | Reacción
|:-----------:|:--------------------------------------------------|
      $t$     | total
      $c$     | captura radiativa
      $f$     | fisión
      $a$     | absorción ($\Sigma_c + \Sigma_f$)
      $s$     | dispersión ([scattering]{lang=en-US})

Las secciones eficaces macroscópicas dependen de la energía $E$ del neutrón incidente y de las propiedades del medio que provee los núcleos blanco.
Como éstas dependen del espacio (usualmente a través de otras propiedades intermedias como por ejemplo temperaturas, densidades o concentraciones de impurezas), en general las secciones eficaces macroscópicas son funciones tanto del espacio $\vec{x}$ como de la energía $E$, es decir $\Sigma_k = \Sigma_k(\vec{x}, E)$.
En este trabajo no consideramos una dependencia explícita con el tiempo $t$.


Una forma de incorporar el concepto de sección eficaz macroscópica es
pensar que ésta proviene del producto de una sección eficaz
microscópica $\sigma_k$ (con unidades de área) y una densidad atómica $n$ (con unidades de inversa de volúmen) del medio

$$
\Sigma_k [\text{cm}^{-1}] = \sigma_k [\text{cm}^2] \cdot n [\text{cm}^{-3}]
$$

![Interpretación de la sección eficaz microscópica como el área asociada a un núcleo transversal a la dirección de viaje del neutrón incidente.](xsmicro){#fig-xsmicro width=80%}

![Dependencia de la sección eficaz microscópica de absorción $\sigma_a$ con respecto a la energía $E$ del neutrón incidente para diferentes isótopos blanco.](sigmas){#fig-sigmas}



La sección eficaz microscópica $\sigma_k$ tiene efectivamente unidades de área (típicamente del orden de
$10^{-24}~\text{cm}^2$, unidad que llamamos
[*barn*]{lang=en-US}^[Se dice que durante las primeras mediciones experimentales de
    secciones eficaces los físicos americanos esperaban encontrar
    resultados del orden de las áreas transversales asociadas a los
    tamaños geométricos de los núcleos. Pero encontraron valores mucho
    más grandes, por lo que decían a modo de broma [“this
    cross section is as big as a barn.”]{lang=en-US}]) y se interpreta
como el área asociada a un núcleo transversal a la dirección de viaje de
un neutrón tal que si este neutrón pasara a través de dicha área, se
llevaría a cabo una reacción de tipo $k$ (@fig-xsmicro).
Las secciones eficaces microscópicas dependen
no solamente de las propiedades nucleares de los núcleos blanco sino que
también dependen fuertemente de la energía $E$ del neutrón incidente,
llegando a cambiar varios órdenes de magnitud debido a efectos de
resonancias como podemos observar en la @fig-sigmas.
Además, $\sigma_k$ depende de la temperatura $T$ del medio que define la
forma en la cual los átomos se mueven por agitación térmica alrededor de
su posición de equilibrio ya que se produce un efecto tipo Doppler entre
el neutrón y el núcleo blanco que modifica la sección eficaz
microscópica [@aatn-doppler-2013; @aatn-doppler-2014]. Por lo tanto,
para un cierto isótopo, $\sigma_k = \sigma_k(E,T)$.

Por otro lado, la densidad atómica $n$ del medio depende de la densidad
termodinámica $\rho$, que a su vez depende de su estado termodinámico
usualmente definido por la presión $p$ y la temperatura $T$. Como estas
variables pueden depender de forma arbitraria del espacio $\vec{x}$,
podemos escribir efectivamente

$$
\Sigma_k = n \cdot \sigma_k = n \Big( p(\vec{x}), T(\vec{x}) \Big) \cdot \sigma_k \Big(E, T(\vec{x}) \Big) = \Sigma_k (\vec{x}, E)
$$

Las ideas presentadas son válidas para un único isótopo libre de cualquier influencia externa.
En los reactores nucleares reales, por un lado existen efectos no lineales como por ejemplo el hecho de los átomos de hidrógeno o deuterio y los de oxígeno no están libres en la molécula de agua.
Esto hace que las secciones eficaces del todo (i.e. de un conjunto de átomos enlazados covalentemente) no sean iguales a la suma algebraica de las partes y debamos calcular las secciones eficaces macroscópicas con una metodología más apropiada (ver @sec-evaluacionxs).
Por otro lado, justamente en los reactores nucleares las reacciones que interesan son las que dan como resultado la transmutación de materiales por lo que continuamente la densidad atómica $n$ de todos los isótopos varía con el
tiempo. En este trabajo, no vamos a tratar con la dependencia de las secciones eficaces con el tiempo explícitamente sino que llegado el caso, como discutimos en la @sec-multiescala, daremos la dependencia implícitamente a través de otras propiedades intermedias tales como la evolución del quemado del combustible y/o la concentración de xenón 135 en las pastillas de de dióxido de uranio en forma cuasi-estática.

::: {.remark}
Si bien la sección eficaz de un material que es combinación de otros no es la combinación lineal de los componentes,
es cierto que las sumas de secciones eficaces correspondientes a reacciones parciales dan como resultado la sección eficaz de la reacción total. Por ejemplo, $\Sigma_a = \Sigma_c + \Sigma_f$ y $\Sigma_t = \Sigma_a + \Sigma_s$.
:::

A partir de este momento suponemos que conocemos las secciones eficaces macroscópicas en función del vector posición $\vec{x}$ y de la energía $E$ para todos los problemas que planteamos, y que además éstas no dependen del tiempo $t$.

### Dispersión de neutrones {#sec-scattering}

Cuando un neutrón que viaja en una cierta dirección $\omegaversor$ con una energía $E$ colisiona con un núcleo blanco en una reacción de
dispersión o [*scattering*]{lang=en-US},^[El término español “dispersión” como traducción del concepto de “[scattering]{lang=en-US}” no es muy feliz. A partir este punto, durante el resto de esta tesis usamos solamente la palabra [*scattering*]{lang=en-US} para referirnos a este concepto.] tanto el neutrón como el núcleo blanco intercambian energía. En este caso podemos pensar que luego de la colisión, el neutrón incidente se ha transformado en otro neutrón emitido en una nueva dirección $\omegaprimaversor$ con una nueva energía $E^\prime$. Para tener este efecto en cuenta, utilizamos el concepto que sigue.

::: {#def-sigmasdif}

## sección eficaz de [scattering]{lang=en-US} diferencial

La *sección eficaz de [scattering]{lang=en-US} diferencial* $\Sigma_s$ tal que

$$
\Sigma_s(\vec{x}, \omegaversor \rightarrow \omegaprimaversor, E \rightarrow E^\prime) \, d\omegaprimaversor \, dE^\prime
$$
es la probabilidad por unidad de longitud lineal que un neutrón de energía $E$ viajando en la dirección $\omegaversor$ sea dispersado hacia un intervalo de energía entre $E^\prime$ y $E^\prime + dE^\prime$ y a un cono $d\omegaprimaversor$ alrededor de la dirección $\omegaprimaversor$. Sus unidades son inversa de longitud por inversa de ángulo sólido por inversa de energía.
:::

Utilizando argumentos de simetría, podemos mostrar que la sección eficaz diferencial de [scattering]{lang=en-US} $\Sigma_s$ sólo puede depender del producto interno $\mu = \omegaversor \cdot \omegaprimaversor$ y no separadamente de $\omegaversor$ y de $\omegaprimaversor$. En la @fig-omegamu ilustramos la idea.

![Debido a la simetría azimutal, el [scattering]{lang=en-US} no depende de las direcciones $\omegaversor$ y de $\omegaprimaversor$ en forma separada sino que depende del coseno del ángulo entre ellas $\mu = \omegaversor \cdot \omegaprimaversor$.](omegamu-nice){#fig-omegamu width=60%}

En general podemos separar a la sección eficaz diferencial (@def-sigmasdif) en una sección eficaz total $\Sigma_{s_t}$ y en una probabilidad de distribución angular y energética $\xi_s$ tal que

$$
 \Sigma_s(\vec{x}, \mu, E \rightarrow E^\prime) = \Sigma_{s_t}(\vec{x}, E) \cdot \xi_s(\mu, E \rightarrow E^\prime)
$$ {#eq-sigmasmu}
donde $\Sigma_{s_t}$ es la sección eficaz macroscópica *total* de [scattering]{lang=en-US}, que da la probabilidad por unidad de longitud de que un neutrón incidente de energía $E$ inicie un proceso de [scattering]{lang=en-US} y la función $\xi_s$ describe la distribución de neutrones emergentes.

Podemos integrar ambos miembros de la @eq-sigmasmu con respecto a $E^\prime$ y a $\mu$, y despejar $\Sigma_{s_t}$ para obtener su definición

$$
\Sigma_{s_t}(\vec{x}, E) =
\frac{\displaystyle \int_{0}^\infty \int_{-1}^{+1} \Sigma_s(\vec{x}, \mu, E \rightarrow E^\prime) \, d\mu \, dE^\prime}
{\displaystyle \int_{0}^\infty \int_{-1}^{+1} \xi_s(\mu, E \rightarrow E^\prime) \, d\mu \, dE^\prime}
$$

El denominador tiene que ser igual a uno ya que en la reacción de [scattering]{lang=en-US} el neutrón dispersado tiene que tener alguna dirección $\mu$ y alguna energía $E^\prime$.
Luego

$$
 \Sigma_{s_t}(\vec{x}, E) =
 \int_{0}^\infty \int_{-1}^{+1} \Sigma_s(\vec{x}, \mu, E \rightarrow E^\prime) \, d\mu \, dE^\prime
$$ {#eq-sigmast}

\medskip

### Expansión en polinomios de Legendre {#sec-legendre}

::: {#thm-legendre}

## expansión en polinomios de Legendre

Cualquier función $f(\mu) : \mu \in [-1,+1] \rightarrow \mathbb{R}^1$ de cuadrado integrable puede ser escrita como la suma infinita de un coeficiente $f_\ell$ por el _polinomio de Legendre_ $P_{\ell}(\mu)$ de grado $\ell \geq 0$

$$
f(\mu) = \sum_{\ell=0}^\infty f_\ell \cdot P_\ell(\mu)
$$

con la condición de normalización

$$
P_\ell(1) = 1
$$

:::

![Primeros seis polinomios de Legendre $P_\ell(\mu)$, $\ell = 1,\dots,6$.](legendre){#fig-legendre}

::: {#def-P0}
Los primeros polinomios de Legendre (@fig-legendre) son

$$
\begin{aligned}
P_0(\mu) &= 1 \\
P_1(\mu) &= \mu \\
P_2(\mu) &= \frac{1}{2}\left(3 \mu^2-1\right) \\
P_3(\mu) &= \frac{1}{2}\left(5 \mu^3- 3 \mu \right) \\
P_4(\mu) &= \frac{1}{8}\left(35 \mu^4 - 30 \mu^2 + 3 \right) \\
P_5(\mu) &= \frac{1}{8}\left(63 \mu^5 - 70 \mu^3 + 15 \mu \right) \\
P_6(\mu) &= \frac{1}{16}\left(231 \mu^6 - 315 \mu^4 + 105 \mu^2 - 5 \right)
\end{aligned}
$$
:::

::: {#def-kronecker}

## la delta de Kronecker

$$
\delta_{\ell \ell^\prime} =
\begin{cases}
 1 & \text{si $\ell = \ell^\prime$} \\
 0 & \text{si $\ell \neq \ell^\prime$} \\
\end{cases}
$$
:::


::: {#thm-legendre-orto}

## ortogonalidad de los polinomios de Legendre

Los polinomios de Legendre son ortogonales. Más aún, 

$$
\int_{-1}^{+1} P_\ell(\mu) \cdot P_{\ell^\prime}(\mu) \, d\mu = \frac{2}{2\ell + 1} \cdot \delta_{\ell \ell^\prime}
$$
:::
 
::: {#cor-Pell}
Los coeficientes $f_\ell$ de la expansión de $f(\mu)$ en polinomios de Legendre del @thm-legendre son iguales a 

$$
 f_\ell = \frac{2\ell + 1}{2} \cdot \int_{-1}^1 f(\mu) \cdot P_{\ell}(\mu) \, d\mu
$$
:::




Una forma de tener en cuenta la dependencia de $\Sigma_s$ con $\mu$ en la @eq-sigmasmu es recurrir a una expansión en polinomios de Legendre.
En efecto, para una cierta posición $\vec{x}$ y dos energías $E$ y $E^\prime$ fijas, la sección eficaz $\Sigma_s$ de la @eq-sigmasmu depende de un único escalar $-1 \leq \mu \leq 1$ sin presentar singularidades, es decir es una función de cuadrado integrable.
Entonces podemos escribir^[El coeficiente $(2\ell+1)/2$ aparace para que las expresiones que siguen sean consistentes con los usos y costumbres históricos de la evaluación de secciones eficaces (@sec-evaluacionxs) y de códigos de celda (@sec-celda). En particular, aparece para que en la @eq-sigmastys0 ambos miembros tengan coeficientes unitaros. Es posible dar otras definiciones y desarrollar consistentemente la matemática para llegar a expresiones finales igualmente válidas, pero ello modificaría la definición de los coeficientes de la expansión dados por el @cor-Pell y haría que las secciones eficaces calculadas a nivel de celda no puedan ser introducidas directamente en la entrada del código de núcleo que describimos en el @sec-implementacion. En particular, arribar a la @eq-sigmas0 es de interés para la consistencia de las secciones eficaces entre códigos de diferente nivel. La referencia [@lewis] utiliza otra forma de expandir el kernel de [scattering]{lang=en-US} que resulta en un factor dos de diferencia con respecto a la @eq-coeflegendre.]

$$
\Sigma_s(\vec{x}, \mu, E \rightarrow E^\prime) = \sum_{\ell=0}^{\infty} \frac{2\ell + 1}{2} \, \Sigma_{s_\ell}(\vec{x}, E \rightarrow E^{\prime}) \cdot P_\ell(\mu)
$$ {#eq-sigmas-legendre}
donde los coeficientes son

$$
\Sigma_{s_\ell}(\vec{x}, E\rightarrow E^{\prime}) =
\int_{-1}^{+1} \Sigma_s(\vec{x}, \mu, E\rightarrow E^\prime) \cdot P_\ell(\mu) \, d\mu
$$ {#eq-coeflegendre} 


::::: {#cor-sigma-s-t}
La sección eficaz de [scattering]{lang=en-US} total $\Sigma_{s_t}$ sólo depende de $\Sigma_{s_0}$.

::: {.proof}
Reemplazando la expansión dada por la @eq-sigmas-legendre en la @eq-sigmast tenemos

$$
\begin{aligned}
 \Sigma_{s_t}(\vec{x}, E) &=
 \int_{0}^{\infty} \int_{-1}^{+1} \sum_{\ell=0}^{\infty} \frac{2\ell + 1}{2} \, \Sigma_{s_\ell}(\vec{x}, E \rightarrow E^{\prime}) \cdot P_\ell(\mu) \, d\mu \, dE^\prime \\
 &= 
\bigintsss_{0}^{\infty} \left[ \sum_{\ell=0}^{\infty} \frac{2\ell + 1}{2} \, \Sigma_{s_\ell}(\vec{x}, E \rightarrow E^{\prime}) \cdot \int_{-1}^{+1} P_\ell(\mu) \, d\mu \right] \, dE^\prime 
\end{aligned}
$$

Según el @thm-legendre-orto, todos los polinomios de Legendre de orden $\ell \geq 1$ son ortogonales con respecto a $P_0(\mu) = 1$, por lo que

$$
\int_{-1}^{+1} P_\ell(\mu) \, d\mu
\begin{cases}
2 & \text{para $\ell = 0$} \\
0 & \text{para $\ell > 0$} \\
\end{cases}
$$

Luego la única contribución a la suma infinita diferente de cero es la correspondiente a $\ell=0$

$$
 \Sigma_{s_t}(\vec{x}, E) = 
\int_{0}^{\infty} \left[ \frac{2 \cdot 0 + 1}{2} \cdot \Sigma_{s_0}(\vec{x}, E \rightarrow E^{\prime}) \cdot 2 \right] dE^\prime
=
\int_{0}^{\infty} \Sigma_{s_0}(\vec{x}, E \rightarrow E^{\prime}) dE^\prime
$$ {#eq-sigmastys0}
:::
:::::


Recordando que $\mu = \omegaversor \cdot \omegaprimaversor$, debe cumplirse que

$$
\int_{4\pi} \Sigma_s(\vec{x}, \omegaversor \rightarrow \omegaprimaversor, E \rightarrow E^\prime) \, d\omegaprimaversor
=
\int_{-1}^{+1} \Sigma_s(\vec{x},\mu, E \rightarrow E^\prime) \, d\mu
$$ {#eq-isotropico1}

Si tenemos [scattering]{lang=en-US} isotrópico en el marco de referencia del laboratorio,^[Como ya dijimos, esta nomenclatura es puramente académica. Una expresión más apropiada según la potencial aplicación industrial de los conceptos desarrollados en esta tesis sería "marco de referencia de *la central nuclear*".] entonces

 a. el integrando del miembro izquierdo de la @eq-isotropico1 no depende de $\omegaprimaversor$ y puede salir fuera de la integral, y
 b. $\Sigma_s(\vec{x},\mu, E \rightarrow E^\prime)$ no depende de $\mu$ y el único coeficiente $\Sigma_{s_\ell}$ diferente de cero es el correspondiente a $\ell=0$ con lo que

$$
\int_{-1}^{+1} \Sigma_s(\vec{x},\mu, E \rightarrow E^\prime) \, d\mu
=
\int_{-1}^{+1} \frac{2\cdot 0 + 1}{2} \cdot  \Sigma_{s_0}(\vec{x}, E \rightarrow E^\prime) \, d\mu
=
\Sigma_{s_0}(\vec{x}, E \rightarrow E^\prime)
$$ {#eq-isotropico2}

Reemplazando la @eq-isotropico2 en la [-@eq-isotropico1] y sacando $\Sigma_s(\vec{x}, \omegaversor \rightarrow \omegaprimaversor, E \rightarrow E^\prime)$ fuera de la integral tenemos

$$
\Sigma_s(\vec{x}, \omegaversor \rightarrow \omegaprimaversor, E \rightarrow E^\prime) \cdot 4\pi = \Sigma_{s_0}(\vec{x}, E \rightarrow E^\prime)
$$
con lo que la sección eficaz diferencial (@def-sigmasdif) para [scattering]{lang=en-US} isotrópico en el sistema del reactor es igual al coeficiente $\Sigma_{s_0}$ dividido $4\pi$


$$
\Sigma_s(\vec{x}, \omegaversor \rightarrow \omegaprimaversor, E \rightarrow E^\prime)
=
\frac{1}{4\pi} \cdot \Sigma_{s_0}(\vec{x}, E\rightarrow E^\prime)
$$ {#eq-sigmas0}

::: {.remark}
Según el punto b y la @eq-sigmas-legendre,

$$
\begin{aligned}
\Sigma_s(\vec{x},\mu, E \rightarrow E^\prime) &= \frac{2\cdot 0 + 1}{2}\cdot  \Sigma_{s_0}(\vec{x}, E \rightarrow E^\prime) \cdot P_0(\mu) \\
&= \frac{1}{2} \cdot \Sigma_{s_0}(\vec{x}, E \rightarrow E^\prime)
\end{aligned}
$$

Comparando este resultado con la @eq-sigmas0 llegamos a la conclusión que

$$
\Sigma_s(\vec{x}, \omegaversor \rightarrow \omegaprimaversor, E \rightarrow E^\prime)
=
\frac{1}{2\pi} \cdot \Sigma_s(\vec{x},\mu, E \rightarrow E^\prime)
$$ {#eq-sigmas-from-omega-to-mu}

Este resultado se explica ya que dado un ángulo $\omegaversor$ fijo, para cada posible valor de $\mu$ hay $2\pi$ posibles valores de $\omegaprimaversor$ que pueden dar como resultado el mismo coseno.
:::

\medskip

Si en cambio el [scattering]{lang=en-US} resulta ser completamente elástico e isotrópico pero el marco de referencia del centro de masa del sistema compuesto por el neutrón incidente y el núcleo blanco (condición que se da si el blanco está fijo en el marco de referencia del reactor sin posibilidad de moverse por efectos térmicos), entonces a cada energía de salida $E^\prime$ le corresponde un único ángulo de [scattering]{lang=en-US} $\mu$ a través de las leyes clásicas de conservación de energía y momento lineal.
Siguiendo el desarrollo de la referencia [@stammler], la sección eficaz diferencial es

$$
\Sigma_s(\vec{x}, \mu, E \rightarrow E^\prime) =
\begin{cases}
 \displaystyle \Sigma_{s_t}(\vec{x}, E) \cdot \frac{\delta(\mu - \mu_0)}{(1-\alpha)E}  & \text{para}~\alpha E < E^\prime < E \\
\hfill 0 \hfil & \text{de otra manera}
\end{cases}
$$
donde ahora $\delta(x)$ es la distribución delta de Dirac (no confundir con la $\delta$ de Kronecker de la @def-kronecker) y

$$
 \alpha(A) = \frac{(A-1)^2}{(A+1)^2}
$$

$$
\mu_0(A,E,E^\prime) = \frac{1}{2} \left[ (A+1)\sqrt{\frac{E^\prime}{E}} - (A-1) \sqrt{\frac{E}{E^\prime}} \right]
$$ {#eq-mu0-isotropico-com}
siendo $A$ es el número de masa del núcleo blanco.
Llamamos a la magnitud $\mu_0$ coseno medio de [scattering]{lang=en-US}.

::: {.remark}
Esta nomenclatura para $\mu_0$ es general pero la expresión matemática dada por la @eq-mu0-isotropico-com es particular para el caso de [scattering]{lang=en-US} elástico e isotrópico en el marco de referencia del centro de masa.
En la @eq-mu0 generalizamos la definición para cualquier tipo de [scattering]{lang=en-US}.
:::

La expresión para el $\ell$-ésimo coeficiente de la expansión en polinomios de Legendre para $\alpha E < E^\prime < E$ según la @eq-coeflegendre es

$$
\Sigma_{s_\ell}(\vec{x}, E \rightarrow E^\prime) = \frac{\Sigma_{s_t}(\vec{x}, E)}{(1-\alpha) E} \int_{-1}^{+1} \delta(\mu - \mu_0) \cdot P_\ell(\mu) \, d\mu = \frac{\Sigma_{s_t}(\vec{x}, E) }{(1-\alpha) E} \cdot P_\ell(\mu_0)
$$
por lo que

$$\Sigma_s(\vec{x}, \mu, E \rightarrow E^\prime) =
\frac{\Sigma_{s_t}(\vec{x},E)}{(1 - \alpha) E} \cdot \sum_{\ell=0}^{\infty} \frac{2\ell + 1}{2} \cdot P_\ell(\mu_0) \cdot P_\ell(\mu)
$$

Tomando solamente los dos primeros términos y recordando que $P_1(\mu) = \mu$, podemos aproximar

$$
\Sigma_s(\vec{x}, \mu, E \rightarrow E^\prime) \approx
\begin{cases}
\frac{\Sigma_{s_t}(\vec{x},E)}{(1 - \alpha) E} \cdot \left(1 + \frac{3 \cdot \mu_0 \cdot \mu}{2}\right) & \text{para~$\alpha E < E^\prime < E$} \\
\hfill 0 \hfil & \text{para~$E^{\prime} < \alpha E$}
\end{cases}
$$

Estas dos ideas nos permiten introducir los siguientes conceptos.

::: {#def-scattering-isotropico}

## scattering isotrópico

Decimos que hay *[scattering]{lang=en-US} isotrópico* (a partir de ahora siempre nos
vamos a referir al marco de referencia del reactor) cuando los
coeficientes de la expansión de la sección eficaz diferencial de
[scattering]{lang=en-US} $\Sigma_s(\vec{x}, \mu,  E \rightarrow E^\prime)$ en
polinomios de Legendre son todos nulos excepto el correpondiente
a $\ell=0$. En este caso, la sección eficaz diferencial no depende del
ángulo y vale la [@eq-sigmas0]:

$$\tag{\ref{eq-sigmas0}}
 \Sigma_s(\vec{x}, \omegaversor \rightarrow \omegaprimaversor, E \rightarrow E^{\prime}) = \frac{1}{4\pi} \cdot \Sigma_{s_0}(\vec{x}, E \rightarrow E^{\prime})
$$
:::


::: {#def-scattering-linealmente-anisotropico}

## scattering linealmente anisotrópico

Si además de $\Sigma_{s_0}$ resulta que el único otro coeficiente diferente de cero es $\Sigma_{s_1}$
correspondiente a $\ell=1$ entonces decimos que el [scattering]{lang=en-US} es *linealmente anisotrópico*, y la
sección eficaz diferencial es la suma de la sección eficaz total más un
coeficiente multiplicado por el coseno del ángulo de [scattering]{lang=en-US}:

$$
\begin{aligned}
 \Sigma_s(\vec{x}, \omegaversor \rightarrow \omegaprimaversor, E \rightarrow E^{\prime}) &=
 \frac{1}{4\pi} \cdot \left[ \Sigma_{s_0}(\vec{x}, E \rightarrow E^{\prime}) + \left( 2 \cdot 1 + 1 \right) \cdot  \Sigma_{s_1}(\vec{x}, E \rightarrow E^{\prime}) \cdot P\left(\omegaversor \cdot \omegaprimaversor \right) \right] \\
 &= \frac{1}{4\pi} \cdot \left[ \Sigma_{s_0}(\vec{x}, E \rightarrow E^{\prime}) + 3 \cdot \Sigma_{s_1}(\vec{x}, E \rightarrow E^{\prime}) \cdot \left ( \omegaversor \cdot \omegaprimaversor \right) \right]
\end{aligned}
$$ {#eq-scatteringanisotropico}
:::

::: {#def-coseno-medio}

## coseno medio

Definimos el *coseno medio del ángulo de [scattering]{lang=en-US}* $\mu_0$ para una ley de dispersión general como

$$
 \mu_0(\vec{x}, E) =
\frac{\displaystyle \int_0^\infty \int_{-1}^{+1} \mu \cdot \Sigma_{s}(\vec{x}, \mu, E \rightarrow E^{\prime}) \, d\mu \, dE^\prime}
     {\displaystyle \int_0^\infty \int_{-1}^{+1}           \Sigma_{s}(\vec{x}, \mu, E \rightarrow E^{\prime}) \, d\mu \, dE^\prime}
=
\frac{\displaystyle \int_0^\infty           \Sigma_{s_1}(\vec{x}, E \rightarrow E^{\prime}) \, dE^\prime}
     {\displaystyle \int_0^\infty           \Sigma_{s_0}(\vec{x}, E \rightarrow E^{\prime}) \, dE^\prime}
$$ {#eq-mu0}
:::

En el caso de [scattering]{lang=en-US} general, i.e. no necesariamente isotrópico en algún marco de referencia y no necesarimente elástico, debemos conocer entonces

 a. la dependencia explícita de $\Sigma_s$ con $\omegaversor \rightarrow \omegaprimaversor$ (que puede ser aproximada
mediante evaluaciones discretas), o
 b. una cierta cantidad de coeficientes $\Sigma_{s_\ell}$ de su desarrollo en polinomios de Legendre sobre $\mu$.
 
En esta tesis trabajamos a lo más con [scattering]{lang=en-US} linealmente anisotrópico.
Esto es, suponemos que la sección eficaz diferencial de [scattering]{lang=en-US} está dada por la @eq-scatteringanisotropico y suponemos que conocemos tanto $\Sigma_{s_0}$ como $\Sigma_{s_1}$ en función del espacio y de los grupos de energías discretizados antes de resolver la ecuación de transporte a nivel de núcleo (ver @sec-multiescala).

### Fisión de neutrones {#sec-fision}

Cuando un núcleo pesado se fisiona en dos núcleos más pequeños, ya sea debido a una fisión espontánea o a una fisión inducida por la absorción
de un neutrón, se liberan además de los productos de fisión propiamente dichos y radiación $\gamma$ debida al reacomodamiento de los niveles
energéticos de los nucleones que intervienen en la reacción, entre dos y tres neutrones.
Llamamos $\nu(\vec{x}, E)$ a la cantidad promedio de neutrones liberados por cada fisión.
El valor numérico de $2 < \nu < 3$ depende de la energía $E$ del neutrón incidente y de la composición del material combustible el punto $\vec{x}$.

Tal como hicimos en la sección @sec-scattering, separamos la probabilidad $\Sigma_f$ de que un neutrón incidente de energía $E$ produzca una fisión unidad de longitud de viaje colisionando con un núcleo blanco en la posición $\vec{x}$ en una sección eficaz total $\Sigma_{f_t}$ y una distribución $\xi_f$ en ángulo y energía cada uno de los neutrones nacidos por la fisión

$$
\Sigma_f(\vec{x}, \omegaversor \rightarrow \omegaprimaversor, E \rightarrow E^\prime)
=
\Sigma_{f_t}(\vec{x}, E) \cdot \xi_f(\omegaversor \rightarrow \omegaprimaversor, E \rightarrow E^\prime)
$$

La distribución en energía de los neutrones nacidos por fisión está dada
por el espectro de fisión $\chi$, que definimos a continuación.

::: {#def-chi}

## espectro de fisión

El *espectro de fisión* $\chi(E)$ es tal que

$$
\chi(E) \, dE
$$
es la probabilidad de que un neutrón nacido en una fisión lo haga con una energía dentro del intervalo $[E,E+dE]$.
El espectro de fisión está normalizado de forma tal que

$$
 \int_{0}^{\infty} \chi(E) \, dE = 1
$$ {#eq-chinorm}
:::

Experimentalmente se encuentra que los neutrones de fisión nacen isotrópicamente en el marco de referencia del reactor independientemente de la energía $E$ del neutrón incidente que la provocó.
Además, la energía $E^\prime$ con la que emergen tampoco depende de la energía del $E$ neutrón incidente.
Luego $\xi_f$ no depende ni de $\omegaversor$ ni de $\omegaprimaversor$ y podemos separarla en una cierta dependencia de $\Xi(E)$ que da la probabilidad de generar una fisión, multiplicada por el espectro de fisión $\chi(E^\prime)$:

$$
\xi_f(\omegaversor \rightarrow \omegaprimaversor, E \rightarrow E^\prime) = \Xi(E) \cdot \chi(E^\prime)
$$

Como cada neutrón nacido por fisión tiene que tener alguna dirección de vuelo $\omegaprimaversor$ y alguna energía $E^\prime$, entonces la integral de $\xi_f$ sobre todas las posibles energías $E^\prime$ y ángulos $\omegaprimaversor$ debe ser igual a uno.
Entonces

$$
\int_0^\infty \int_{4\pi} \xi_f(\omegaversor \rightarrow \omegaprimaversor, E \rightarrow E^\prime) \, d\omegaprimaversor \, dE^\prime =
\Xi(E) \cdot \int_0^\infty \int_{4\pi} \chi(E^\prime) \, d\omegaprimaversor \, dE^\prime = 1
$$

Teniendo en cuenta la normalización de $\chi$ dada por la @eq-chinorm, resulta

$$
\Xi(E) = \frac{1}{4\pi}
$$
por lo que

$$
\Sigma_f(\vec{x}, \omegaversor \rightarrow \omegaprimaversor, E \rightarrow E^\prime) = \frac{\chi(E^\prime)}{4\pi} \cdot \Sigma_{f_t}(\vec{x}, E)
$$ {#eq-chisigmaf}


::: {.remark}

Dado que `en la página~\pageref{siete}`{=latex} hemos supuesto que la población neutrónica es igual al valor medio de la distribución naturalmente estocástica de los neutrones, desde el punto de vista del desarrollo matemático cada neutrón que produce una fisión genera exactamente $\nu(\vec{x},E)$ neutrones de fisión. Como la dependencia de $\nu$ es la misma que la de sección eficaz total de fisión $\Sigma_{f_t}$ entonces englobamos el producto $\nu\cdot\Sigma_f$ como una única función $\nu\Sigma_f(\vec{x},E)$.
:::


Durante la operación de un reactor, no todos los neutrones provenientes de la fisión aparecen en el mismo instante en el que se produce.
Una cierta fracción $\beta$ de todos los neutrones son producto del decaimiento radioactivo de

 a. los productos de fisión, o
 b. de los hijos de los productos de fisión.
 
En cualquier caso, en cálculos transitorios es necesario distinguir entre la fracción $1-\beta$ de neutrones instantáneos^[En el sentido del inglés [*prompt*]{lang=en-US}.] que aparecen en el mismo momento de la fisión y la fracción $\beta$ de neutrones retardados que aparecen más adelante.
Para ello dividimos a los neutrones retardados en $I$ grupos, les asignamos una fracción $\beta_i$ y una constante de tiempo $\lambda_i$, para $i=1,\dots,N$ y definimos un mecanismo de aparición exponencial para cada uno de ellos.

Como discutimos más adelante en la @sec-problemas-steady-state, en cálculos estacionarios no es necesario realizar esta división entre neutrones instantáneos y retardados ya que eventualmente todos los neutrones estarán contribuyendo a la reactividad neta del reactor.
En el caso particular en el que no haya una fuente externa de neutrones sino que todas las fuentes se deban a fisiones la probabilidad de que el
reactor esté exactamente crítico es cero.
Para poder realizar cálculos estacionarios y además tener una idea de la distancia a la criticidad debemos recurrir a un reactor crítico asociado, cuya forma más usual es el *reactor crítico asociado en $k$* introducido más adelante en la @def-keff.
En este caso, dividimos arbitrariamente las fuentes de fisión por un número real $k_\text{eff} \sim 1$ que pasa a ser una incógnita del problema y cuya diferencia relativa con respecto a la unidad da una idea de la distancia a la criticidad del reactor original.

## Flujos y ritmos de reacción

El problema central del cálculo de reactores es la determinación de la distribución espacial y temporal de los neutrones dentro del núcleo de
un reactor nuclear. En esta sección desarrollamos la matemática para el caso de $\vec{x} \in \mathbb{R}^3$. En casos particulares aclaramos cómo
debemos proceder para problemas en una y en dos dimensiones.

::: {#def-N}

## densidad de neutrones

La *distribución de densidad de neutrones* $N$ en un espacio de las fases de siete dimensiones $\vec{x} \in \mathbb{R}^3$, $\omegaversor \in \mathbb{R}^2$,^[Si bien la dirección $\omegaversor = [ \Omega_x \, \Omega_y \, \Omega_z]^T$ tiene tres componentes llamados *cosenos dirección*, sólo dos son independientes (por ejemplo las  coordenadas angulares cenital $\theta$ y azimutal $\varphi$) ya que  debe cumplirse que $\Omega_x^2 + \Omega_y^2 + \Omega_z^2 = 1$.] $E \in \mathbb{R}$ y $t \in \mathbb{R}$ tal que

$$
N(\vec{x}, \omegaversor, E, t) \, d^3\vec{x} \, d\omegaversor \, dE
$$

es el número de neutrones (en el sentido de la media estadística dada la naturaleza probabilística del comportamiento de los neutrones) en un elemento volumétrico $d^3\vec{x}$ ubicado alrededor del punto $\vec{x}$ del espacio viajando en el cono de direcciones de magnitud $d\omegaversor$ alrededor de la dirección $\omegaversor$ con energías entre $E$ y $E+dE$ en el tiempo $t$.^[Como ya hemos mencionado, ignoramos el principio de Heisenberg.]
:::

::: {#def-flujoangular}

## flujo angular

El *flujo angular* $\psi$ es el producto entre la velocidad $v$ y la distribución de densidad $N$ de los neutrones

$$
\begin{aligned}
 \psi(\vec{x}, \omegaversor, E, t) &= v(E) \cdot N(\vec{x}, \omegaversor, E, t)  \\
&= \sqrt{\frac{2E}{m}} \cdot N(\vec{x}, \omegaversor, E, t) 
\end{aligned}
$$ {#eq-flujoangular}
donde $v(E)$ es la velocidad clásica correspondiente a un neutrón de masa $m$ cuya energía cinética es $E = 1/2 \cdot mv^2$.
::: 

Esta magnitud es más útil para evaluar ritmos de colisiones y reacciones que la densidad de neutrones $N$.

::: {#cor-distancialineal}
Como $v \cdot dt$ es la distancia lineal $ds$ que viaja un neutrón de velocidad $v$, entonces

$$
\psi(\vec{x}, \omegaversor, E, t) \, d^3\vec{x} \, d\omegaversor \, dE \, dt = v(E) \cdot N(\vec{x}, \omegaversor, E, t) \, dt \,\,\, d^3\vec{x} \, d\omegaversor \, dE
$$
es el número total de longitudes lineales que los neutrones han viajado sobre un cono $d\omegaversor$ alrededor de la dirección $\omegaversor$ con energía en el intervalo $[E, E+dE]$ que estaban en un intervalo de tiempo $[t,t+dt]$ en un diferencial de volumen $d^3\vec{x}$ en la posición $\vec{x}$.
:::

::: {#cor-ritmoreaccion}
La probabilidad de que un neutrón tenga una reacción de tipo $k$ durante la distancia lineal de vuelo $ds$, según la @def-sigmat, es $\Sigma_k \cdot ds$. Entonces la expresión

$$
\Sigma_k(\vec{x}, E) \cdot \psi(\vec{x}, \omegaversor, E, t) \, d^3\vec{x} \, d\omegaversor \, dE \, dt
$$
es el número de reacciones de tipo $k$ en el diferencial de volumen de fases $d^3\vec{x} \, d\omegaversor \, dE \, dt$.
:::

Para obtener el número total de reacciones de todos los neutrones independientemente de la dirección $\omegaversor$ del neutrón incidente debemos integrar esta cantidad sobre todos los posibles ángulos de incidencia. Para ello utilizamos el concepto que sigue.

::: {#def-flujoescalar}

## flujo escalar

El *flujo escalar* $\phi$ es la integral del flujo angular sobre todas las posibles direcciones de viaje de los neutrones:

$$
\phi(\vec{x}, E, t) = \int_{4\pi} \psi(\vec{x}, \omegaversor, E, t) \, d\omegaversor
$$ {#eq-flujoescalar}
:::


::: {#cor-ritmo-de-reaccion}
Con estas definiciones, el ritmo $R_k$ de reacciones de tipo $k$ por unidad de tiempo en $d^3\vec{x}\,dE$ es

$$
R_k (\vec{x}, E, t) \, d^3\vec{x} \, dE = \Sigma_k(\vec{x}, E) \cdot \phi(\vec{x}, E, t) \, d^3\vec{x} \, dE
$$ {#eq-ritmo-de-reaccion}
con lo que el producto $R_t = \Sigma_t \phi$ da una expresión simple para la distribución del ritmo de reacciones totales por unidad de
volúmen y de energía.
:::

::: {#def-corriente}

## corriente

El *vector corriente* $\vec{J}$ es la integral del producto entre el flujo angular y el versor de dirección de viaje de los neutrones $\omegaversor$ sobre todas las direcciones de viaje:

$$
\vec{J}(\vec{x},E,t) = \int_{4\pi} \left[ \psi(\vec{x}, \omegaversor, E, t) \cdot \omegaversor \right] \, d\omegaversor
$$
:::

::: {.remark}
La corriente es una cantidad vectorial ya que el integrando es un vector cuya magnitud es igual al flujo angular y cuya dirección es la
del versor $\omegaversor$ sobre el cual estamos integrando.
:::


::: {.remark}
El producto escalar entre el vector corriente $\vec{J}$ y un cierto versor espacial $\hat{\vec{n}}$

$$
 J_n(\vec{x}, E, t) = \hat{\vec{n}} \cdot \vec{J}(\vec{x}, E, t) = \int_{4\pi} \psi(\vec{x}, \omegaversor, E, t) \cdot \left( \omegaversor \cdot \hat{\vec{n}} \right) \, d\omegaversor
$$ {#eq-jn}
es ahora un escalar que da el número neto de neutrones que cruzan un área unitaria perpendicular a $\hat{\vec{n}}$ en la dirección positiva (@fig-normal).
:::

::: {.remark}
La cantidad $J_n$ es la resta de dos contribuciones

$$
J_n(\vec{x}, E, t) = J_n^+(\vec{x}, E, t) - J_n^-(\vec{x}, E, t)
$$
donde

$$
\begin{aligned}
 J_n^+(\vec{x},E,t) &= + \int_{\omegaversor \cdot \hat{\vec{n}} > 0} \psi(\vec{x}, \omegaversor, E, t) \left(\omegaversor \cdot \hat{\vec{n}}\right) d\omegaversor \\
 J_n^-(\vec{x},E,t) &= - \int_{\omegaversor \cdot \hat{\vec{n}} < 0} \psi(\vec{x}, \omegaversor, E, t) \left(\omegaversor \cdot \hat{\vec{n}}\right) d\omegaversor
\end{aligned}
$$ {#eq-jnegativa}
:::

![Interpretación del producto del vector corriente $\vec{J}$ con el vector normal $\hat{\vec{n}}$ a una superficie como el número neto de neutrones que cruzan un área unitaria.](normal){#fig-normal width=50%}

## Transporte de neutrones

Habiendo introducido los conceptos básicos de “contabilidad” de neutrones, pasamos ahora a deducir las ecuaciones que gobiernan sus ritmos de 

 * aparición,
 * desaparición, y
 * transporte.


### Operador de transporte

Consideremos un volumen finito $U\in \mathbb{R}^3$ arbitrario fijo en el espacio y consideremos ahora otro volumen $U^{\prime}(t)\in \mathbb{R}^3$ que se mueve en una dirección fija $\omegaversor$ con una velocidad constante $v(E)$ correspondiente a una energía $E = 1/2 \cdot m v^2$ de un neutrón de masa $m$, de tal manera que en el instante $t$ ambos volúmenes coincidan. En ese momento, la cantidad de neutrones con dirección $\omegaversor$ en torno al cono definido por $d\omegaversor$ y con energías entre $E$ y $E+dE$ en el volumen $U \equiv U^{\prime}(t)$ es

$$
 N_U(\omegaversor, E, t) \, d\omegaversor \, dE = \left[ \int_{U \equiv U^{\prime}(t)} N(\vec{x}, \omegaversor, E, t) \, d^3\vec{x} \right] \, d\omegaversor \, dE
$$ {#eq-nv}

Dado que la posición del dominio de integración cambia con el tiempo, la derivada total de esta magnitud con respecto al tiempo es la suma de una derivada parcial y una derivada material:

$$
 \frac{dN_U}{dt} = \frac{\partial N_U}{\partial t} +
\lim_{\Delta t \rightarrow 0} \frac{1}{\Delta t} \left[ \int_{U^{\prime}(t+\Delta t)} N(\vec{x}, \omegaversor, E, t) \, d^3\vec{x}  - \int_{U^{\prime}(t)} N(\vec{x}, \omegaversor, E, t) \, d^3\vec{x} \right]
$$ {#eq-integral_dos_dominios}

Notamos que

$$
\lim_{\Delta t \rightarrow 0} U^{\prime}(t+\Delta t) = U^{\prime}(t) + v(E) \cdot \omegaversor \cdot \Delta t
$$
para cada punto $\vec{x} \in U^{\prime}(t)$. Además, como ni $v(E)$ ni $\hat{\Omega}_i$ dependen de $\vec{x}$ ya que la velocidad es constante y la dirección está fija, entonces el cambio de coordendas

$$
\vec{x}^\prime = \vec{x} + v(E) \cdot \omegaversor \cdot \Delta t
$$

es unitario ya que

$$
\begin{aligned}
\frac{\partial}{\partial x} \Big[ x + v(E) \, \hat{\Omega}_x \cdot \Delta t \Big] &= 1 \\
\frac{\partial}{\partial y} \Big[ y + v(E) \, \hat{\Omega}_y \cdot \Delta t \Big] &= 1 \\
\frac{\partial}{\partial z} \Big[ z + v(E) \, \hat{\Omega}_z \cdot \Delta t \Big] &= 1
\end{aligned}
$$
y entonces podemos hacer que el dominio de integración de ambas integrales de la @eq-integral_dos_dominios coincidan escribiendo

$$
\begin{aligned}
 \frac{dN_U}{dt} &=
 \frac{\partial N_U}{\partial t} +
\lim_{\Delta t \rightarrow 0} \frac{1}{\Delta t} \left[ \int_{U^{\prime}(t)} N(\vec{x}^\prime, \omegaversor, E, t) \, d^3\vec{x}  - \int_{U^{\prime}(t)} N(\vec{x}, \omegaversor, E, t) \, d^3\vec{x} \right] \\
&=
 \frac{\partial N_U}{\partial t} +
\lim_{\Delta t \rightarrow 0} \frac{1}{\Delta t} \left[ \int_{U^{\prime}(t)} N(\vec{x} + v(E) \cdot \omegaversor \cdot \Delta t, \omegaversor, E, t) - N(\vec{x}, \omegaversor, E, t) \, d^3\vec{x} \right] \\
\end{aligned}
$$

El segundo término del miembro derecho es igual a $v(E)$ veces la derivada espacial direccional de la función $N(\vec{x}, \omegaversor, E, t)$ en la dirección $\omegaversor$.
En efecto, para $\omegaversor$, $E$ y $t$ fijos,

$$
\begin{gathered}
\lim_{\Delta t \rightarrow 0}
N(x + v\cdot\Omega_x\cdot \Delta t, y + v\cdot\Omega_y\cdot \Delta t, z + v\cdot\Omega_y\cdot \Delta t) 
= \\
\lim_{\Delta t \rightarrow 0}
N(x,y,z) +
\frac{\partial N}{\partial x} \cdot v \cdot \Omega_x \cdot \Delta t +
\frac{\partial N}{\partial y} \cdot v \cdot \Omega_y \cdot \Delta t +
\frac{\partial N}{\partial z} \cdot v \cdot \Omega_z \cdot \Delta t
\end{gathered}
$$

Reordenando términos y diviendo por $\Delta t$

$$
\lim_{\Delta t \rightarrow 0} \frac{1}{\Delta t} 
\left[
N(\vec{x} + v \cdot \omegaversor \cdot \Delta t) 
-
N(\vec{x})
\right] =
\text{grad}\left[N(\vec{x})\right] \cdot v \cdot \omegaversor
$$

Como $U^{\prime}(t) \equiv U$ entonces podemos escribir la derivada total de la cantidad de neutrones en $U$ con respecto al tiempo como

$$
\frac{dN_U}{dt} = \frac{\partial N_U}{\partial t} + \int_{U} \omegaversor \cdot v(E) \cdot \text{grad} \left[ N(\vec{x}, \omegaversor, E, t) \right]  d^3\vec{x}
$$

Teniendo en cuenta la @eq-nv,

$$
N_U(\omegaversor, E, t) = \int_{U \equiv U^{\prime}(t)} N(\vec{x}, \omegaversor, E, t) \, d^3\vec{x}
$$
y la @def-flujoangular de flujo angular $\psi$


$$
 \psi(\vec{x}, \omegaversor, E, t) = v(E) \cdot N(\vec{x}, \omegaversor, E, t)
$$
tenemos

$$
\frac{d}{dt} \int_{U} N(\vec{x}, \omegaversor, E, t) \, d^3\vec{x}  = \int_{U} \left\{ \frac{1}{v(E)} \frac{\partial \psi}{\partial t} + \omegaversor \cdot \text{grad} \left[ \psi(\vec{x}, \omegaversor, E, t) \right] \right\}  d^3\vec{x}
$$

Como el dominio $U$ es arbitrario, entonces

$$
\frac{dN}{dt} = \frac{1}{v(E)} \frac{\partial \psi}{\partial t} + \omegaversor \cdot \text{grad} \left[ \psi(\vec{x}, \omegaversor, E, t) \right]
$$ {#eq-dNdt}

::: {.remark}
El operador gradiente se aplica sólo sobre las componentes espaciales, es decir

$$
\text{grad} \left[ \psi(\vec{x}, \omegaversor, E, t) \right] =
\begin{bmatrix}
 \displaystyle \frac{\partial \psi}{\partial x} \\ \\
 \displaystyle \frac{\partial \psi}{\partial y} \\ \\
 \displaystyle \frac{\partial \psi}{\partial z} \\
\end{bmatrix}
$$ {#eq-grad-solo-x}
:::

### Operador de desapariciones {#sec-desapariciones}

Cuando un neutrón reacciona con un núcleo blanco, el neutrón incidente puede...

 a. ser dispersado, o
 b. generar una fisión, o
 c. ser absorbido por el núcleo blanco.

En los últimos dos casos, el neutrón incidente realmente “desaparece” físicamente. En el caso b, vuelven a nacer $\nu(E)$ neutrones nuevos: una fracción $(1-\beta)$ instantáneamente y $\beta$ en forma retardada durante la cadena de decaimiento de los productos de fisión.
En el último caso, el neutrón incidente nunca desaparece sino que cambia su energía y su dirección de vuelo.
De todas maneras, conceptualmente es posible pensar que aún en un proceso de [scattering]{lang=en-US} el neutrón incidente de energía $E$ y dirección $\omegaversor$ desaparece y se emite exactamente un neutrón nuevo con una energía $E^\prime$ y una dirección $\omegaprimaversor$ según la ley de [scattering]{lang=en-US} de la sección eficaz diferencial $\Sigma_s(\vec{x},\omegaversor \rightarrow \omegaprimaversor, E \rightarrow E^\prime)$ dada por la @def-sigmasdif.

Con esta idea, cualquier reacción nuclear genera una desaparición del neutrón incidente al mismo tiempo que los casos a y b producen nuevos neutrones.
Recordando el @cor-ritmo-de-reaccion, la tasa o el ritmo de reacciones de cualquier tipo por unidad de volumen y unidad de tiempo es el producto de la sección eficaz total $\Sigma_t(\vec{x},E)$ por el flujo escalar $\phi(\vec{x},E,t)$.
Entonces la tasa de desaparición de neutrones por unidad de volumen y de tiempo es

$$
\Sigma_t(\vec{x},E) \cdot \phi(\vec{x},E,t) \, d^3\vec{x}
=
\Sigma_t(\vec{x},E) \cdot \int_{4\pi} \psi(\vec{x},\omegaversor,E,t) \, d\omegaversor \, d^3\vec{x}
$$ {#eq-desapariciones}


### Operador de producciones

Pasamos ahora a estudiar las posibles maneras en las que pueden aparecer neutrones.
Éstos pueden aparecer debido a uno de los siguiente tres mecanismos, que analizamos en las secciones que siguen:

 1. [scattering]{lang=en-US},
 2. fisión, o
 3. fuentes externas.

#### Fuentes por [scattering]{lang=en-US}

A la luz de la discusión de la @sec-desapariciones podemos decir que un neutrón que viajando con una energía $E$ y una dirección $\omegaversor$ sufre una colisión de [scattering]{lang=en-US} en el punto $\vec{x}$ es absorbido por el núcleo blanco. Al mismo tiempo, emerge como un nuevo neutrón con una energía $E^\prime$ y una dirección $\omegaprimaversor$.
Esta fuente $q_s$ debe ser entonces igual al producto de la probabilidad por unidad de longitud de recorrido de neutrones que viajando en con una energía $E$ en una dirección $\omegaversor$ colisionen con un núcleo blanco en el punto $\vec{x}$ y como resultado adquieren una dirección de viaje $\omegaprimaversor$ y una energía $E^\prime$ (recordar los conceptos introducidos en la @sec-scattering) por la cantidad de longitudes lineales viajadas, teniendo en cuenta todos los posibles valores de $\omegaversor$ y de $E$.
Es decir, teniendo en cuenta la @def-sigmasdif y el @cor-distancialineal, la fuente de neutrones debida [scattering]{lang=en-US} que da como resultado neutrones de energías $E^\prime$ y direcciones $\omegaprimaversor$ es

$$
q_s(\vec{x}, \omegaprimaversor, E^\prime, t) =
\int_{0}^{\infty} \int_{4\pi} \Sigma_s(\vec{x}, \omegaversor  \rightarrow \omegaprimaversor, E \rightarrow E^\prime) \cdot \psi(\vec{x}, \omegaversor, E, t) \, d\omegaversor \, dE
$$

Dado que en general estamos interesados en el ritmo en los que los neutrones _nacen_ con energía $E$ y dirección $\omegaversor$ en el dominio, podemos invertir las variables primadas para obtener la expresión de la fuente de neutrones debidas a [scattering]{lang=en-US} por unidad de volumen y de tiempo

$$
q_s(\vec{x}, \omegaversor, E, t) = 
 \int_{0}^{\infty} \int_{4\pi} \Sigma_s(\vec{x}, \omegaprimaversor  \rightarrow \omegaversor, E^\prime \rightarrow E) \cdot \psi(\vec{x}, \omegaprimaversor, E^\prime, t) \, d\omegaprimaversor \, dE^\prime
$$ {#eq-qs}



#### Fuentes por fisiones

Ya hemos discutido brevemente en la @sec-fision (y lo haremos más en detalle en la @sec-problemas-steady-state), debemos calcular la fuente de fisión ligeramente diferente si estamos resolviendo problemas

 a. transitorios
 b. estacionarios
     i. con fuentes independientes
     ii. sólo con fuentes de fisión


Sin pérdida de generalidad, para fijar ideas supongamos que desde el punto de vista de la fisión el problema es estacionario tanto con fuentes por fisión como con fuentes independientes.
De manera análoga a la fuente por [scattering]{lang=en-US}, la tasa de generación de neutrones debidas a fisión debido a un neutrón incidente con una dirección $\omegaversor$ y una energía $E$ es el producto del número probable de nacimientos $\nu(E)$ multiplicada por la probabilidad de que dicho neutrón incidente genere una fisión en el punto $\vec{x}$ por unidad de longitud de recorrido multiplicada por la cantidad de longitudes lineales viajadas, teniendo en cuenta todos los posibles valores de direcciones $\omegaversor$ y energías $E$ incidentes:

$$
q_f(\vec{x}, \omegaprimaversor, E^\prime, t)
= 
\nu(E) \cdot \int_{0}^{\infty} \int_{4\pi} \Sigma_f(\vec{x}, \omegaversor  \rightarrow \omegaprimaversor, E \rightarrow E^\prime) \cdot \psi(\vec{x}, \omegaversor, E, t) \, d\omegaversor \, dE
$$

Recordando la ecuación @eq-chisigmaf, invirtiendo las variables primadas y escribiendo el producto $\nu(E)\cdot\Sigma_{f_t}(\vec{x},E)$ como una única función $\nu\Sigma_f(\vec{x}.E)$, tenemos

$$
q_f(\vec{x}, \omegaversor, E, t)
= 
\frac{\chi(E)}{4\pi} \int_{0}^{\infty} \int_{4\pi} \nu\Sigma_f(\vec{x}, E^\prime) \cdot \psi(\vec{x}, \omegaprimaversor, E^\prime, t) \, d\omegaprimaversor \, dE^\prime
$$ {#eq-qf}

#### Fuentes independientes

Por último, para no perder generalidad tenemos que tener en cuenta las fuentes externas de neutrones, es decir aquellas que no provienen de la fisión de materiales presentes en el núcleo sino de otras fuentes totalmente independientes como por ejemplo una fuente de americio-berilio.
Matemáticamente, las modelamos como la integral sobre el volumen $U$ de una función arbitraria

$$
s(\vec{x}, \omegaversor, E, t)
$$ {#eq-s}


del espacio, la dirección, la energía y el tiempo que representa la cantidad de neutrones emitidos con energía $E$ en el punto $\vec{x}$ con dirección $\omegaversor$ en el instante $t$.

### La ecuación de transporte {#sec-ecuacion-transporte}

La conservación de neutrones implica que la derivada temporal total de la población de neutrones en la posición $\vec{x}$ viajando en la dirección $\omegaversor$ con una energía $E$ debe ser igual a la diferencia entre la tasa de producciones y la Igualando la derivada total de la @eq-dNdt a la diferencia entre la suma de las tres fuentes de las [@eq-qs,@eq-qf,@eq-s] y  la tasa de desapariciones @eq-desapariciones, tenemos

$$
\begin{gathered}
\frac{1}{v} \frac{\partial \psi}{\partial t} + \omegaversor \cdot \text{grad} \left[ \psi(\vec{x}, \omegaversor, E, t) \right]   = \\
q_s(\vec{x}, \omegaversor, E, t) + q_f(\vec{x},\omegaversor, E, t) + s(\vec{x}, \omegaversor, E, t) - 
\Sigma_t(\vec{x}, E) \cdot \psi(\vec{x}, \omegaversor, E, t) 
\end{gathered}
$$ {#eq-transporteq}

Escribiendo explícitamente los dos términos de fuente por [scattering]{lang=en-US} y fisión, pasando el término negativo de desapariciones al miembro izquierdo y teniendo en cuenta que la relación entre velocidad y energía es la clásica $E=1/2 \cdot mv^2$, llegamos a la famosa *ecuación de transporte de neutrones*

$$
\begin{gathered}
 \sqrt{\frac{m}{2E}} \frac{\partial}{\partial t} \Big[ \psi(\vec{x}, \omegaversor, E, t) \Big]
 + \omegaversor \cdot \text{grad} \left[ \psi(\vec{x}, \omegaversor, E, t) \right]
 + \Sigma_t(\vec{x}, E) \cdot \psi(\vec{x}, \omegaversor, E, t) = \\
 \int_{0}^{\infty} \int_{4\pi} \Sigma_s(\vec{x}, \omegaprimaversor \rightarrow \omegaversor, E^\prime \rightarrow E) \cdot \psi(\vec{x}, \omegaprimaversor, E^\prime, t) \, d\omegaprimaversor \, dE^\prime \\
+ \frac{\chi(E)}{4\pi} \int_{0}^{\infty} \int_{4\pi} \nu\Sigma_f(\vec{x}, E^\prime) \cdot \psi(\vec{x}, \omegaprimaversor, E^\prime, t) \, d\omegaprimaversor \, dE^\prime 
+ s(\vec{x}, \omegaversor, E, t)
\end{gathered}
$$ {#eq-transporte}
que es una ecuación integro-diferencial hiperbólica en derivadas parciales de primer orden tanto sobre el espacio (notar que el operador gradiente opera sólo sobre las coordenadas espaciales $\vec{x}$ según la @eq-grad-solo-x) como sobre el tiempo para la incógnita $\psi$ sobre un espacio de fases multidimensional que incluye

 1. un dominio espacial $U \in \mathbb{R}^3 / \vec{x} \in U$,
 2. el versor dirección $\omegaversor = [\Omega_x, \Omega_y, \Omega_z] / \Omega_x^2 + \Omega_y^2 + \Omega_z^2 = 1$,
 3. la energía $E \in (0,\infty)$, y
 4. el tiempo $t \in [0,\infty)$.
 
Los datos necesarios para resolver la ecuación de transporte de neutrones son:

 * Las secciones eficaces $\Sigma_t$ y $\nu\Sigma_f$ como función del espacio $\vec{x}$ y de la energía $E^\prime$ del neutrón incidente.
 * El espectro de fisión\ $\chi$ en función de la energía\ $E$ del neutrón emitido, en caso de que $\nu\Sigma_f \neq 0$.
 * La sección eficaz diferencial de [scattering]{lang=en-US} $\Sigma_s$ como función tanto de la energía $E^\prime$ del neutrón incidente como de la energía $E$ del neutrón saliente, y del ángulo de [scattering]{lang=en-US} entre la dirección entrante $\omegaprimaversor$ y la dirección saliente $\omegaversor$.
   - Esta dependencia es usualmente dada como coeficientes $\Sigma_{s_\ell}$ de la expansión en polinomios de Legendre para $\ell=0,\dots,L$ sobre el escalar $\mu = \omegaprimaversor \cdot \omegaversor$.
   - Para [scattering]{lang=en-US} isotrópico en el marco de referencia del reactor, el único coeficiente diferente de cero es $\Sigma_{s_0}$ correspondiente a $\ell = 0$.
 * La fuente independiente de neutrones $s$ como función del espacio $\vec{x}$, la energía $E$ y de la dirección $\omegaversor$.
   - Si no hay fuentes externas, este término es cero.
 * El parámetro constante $m$, que es la masa en reposo del neutrón
   - Este parámetro es sólo necesario en cálculos transitorios. Los cálculos estacionarios son independientes de $m$.

### Armónicos esféricos y polinomios de Legendre {#sec-armonicos}

Prestemos atención al término de fuente por [scattering]{lang=en-US} dado por la @eq-qs

$$ \tag{\ref{eq-qs}}
q_s(\vec{x}, \omegaversor, E, t) = 
 \int_{0}^{\infty} \int_{4\pi} \Sigma_s(\vec{x}, \omegaprimaversor  \rightarrow \omegaversor, E^\prime \rightarrow E) \cdot \psi(\vec{x}, \omegaprimaversor, E^\prime, t) \, d\omegaprimaversor \, dE^\prime
$$
y  supongamos que conocemos los coeficientes $\Sigma_{s_\ell}$ de la expansión en polinomios de Legendre de la sección eficaz diferencial de [scattering]{lang=en-US} sobre el coseno $\mu = \omegaversor \cdot \omegaprimaversor$ del ángulo de dispersión según la @eq-sigmas-legendre

$$ \tag{\ref{eq-sigmas-legendre}}
\Sigma_s(\vec{x}, \mu, E \rightarrow E^\prime) = \sum_{\ell=0}^{\infty} \frac{2\ell + 1}{2} \, \Sigma_{s_\ell}(\vec{x}, E \rightarrow E^{\prime}) \cdot P_\ell(\mu)
$$


Para poder usar estos coeficientes en la fuente de la @eq-qs debemos recordar el resultado de la @eq-sigmas-from-omega-to-mu, ya que para cada $\mu$ hay $2\pi$ posibles ángulos $\omegaprimaversor$:

$$
\begin{aligned}
\Sigma_s(\vec{x},\omegaprimaversor  \rightarrow \omegaversor, E^\prime \rightarrow E) &=
\frac{1}{2\pi} \cdot 
\Sigma_s(\vec{x},\mu,E^\prime \rightarrow E) \\
&=
\frac{1}{2\pi} \cdot \sum_{\ell=0}^{\infty} \frac{2\ell + 1}{2} \cdot \Sigma_{s_\ell}(\vec{x},E^\prime \rightarrow E) \cdot P_\ell(\mu)
\end{aligned}
$$

Ahora sí podemos reemplazar esta expansión de $\Sigma_s(\vec{x},\omegaprimaversor  \rightarrow \omegaversor, E^\prime \rightarrow E)$ en el término de fuentes de la @eq-qs,

$$
\begin{aligned}
q_s(\vec{x}, \omegaversor, E, t) &=
 \bigintsss_{0}^{\infty} \left[ \int_{4\pi} \frac{1}{2\pi} \sum_{\ell=0}^{\infty} \frac{2\ell + 1}{2} \cdot \Sigma_{s_\ell}(\vec{x},E^\prime \rightarrow E) \cdot P_\ell(\mu) \cdot \psi(\vec{x}, \omegaprimaversor, E^\prime, t) \, d\omegaprimaversor \right] dE^\prime\\
& = 
\bigintsss_{0}^{\infty}
 \sum_{\ell=0}^{\infty} \frac{ 2\ell + 1}{4\pi} \cdot
 \left[ \Sigma_{s_\ell}(\vec{x}, E^{\prime} \rightarrow E) \int_{4\pi} P_\ell(\omegaversor \cdot \omegaprimaversor) \cdot \psi(\vec{x}, \omegaprimaversor, E^\prime,t)\, d\omegaprimaversor \right] \, dE^{\prime}
\end{aligned}
$${#eq-qs1}

Si bien esta expresión ya es suficiente para evaluar el término de [scattering]{lang=en-US} cuando tenemos su desarrollo de Legendre, podemos

 1. ahondar un poco más en la estructura de la ecuación de transporte, y
 2. obtener una expresión computacionalmente más eficiente
 
expandiendo en una base apropiada el flujo angular $\psi$, de la misma manera en la que desarrollamos $\Sigma_s$ en una serie de polinomios de Legendre sobre el parámetro $\mu$.

Para ello, notamos que $\psi$ depende angularmente de un versor dirección $\omegaversor = [\hat{\Omega}_x \, \hat{\Omega}_y \, \hat{\Omega}_z]^T$ (u $\omegaprimaversor$ en el caso de la @eq-qs1).
Esta vez, la base de expansión apropiada no son los polinomios de Legrende (que toman un único argumento escalar $\mu$) sino la generada^[Del inglés [*spanned*]{lang=en-US}.] por los armónicos esféricos reales, ilustrados en la @fig-harmonics.


::: {#thm-harmonics}

## expansión en armónicos esféricos reales

Cualquier función $f(\hat{\Omega}_x, \hat{\Omega}_y, \hat{\Omega}_z)$ de cuadrado integrable con

$$\hat{\Omega}_x^2 + \hat{\Omega}_y^2 + \hat{\Omega}_z^2 = 1$$
puede ser escrita como la suma doble de un coeficiente $f_\ell^m$ por el armónico esférico normalizado real $Y_{\ell}^{m}\left(\omegaversor\right)$ de grado $\ell \geq 0$ y orden $m$:

$$
f(\hat{\Omega}_x, \hat{\Omega}_y, \hat{\Omega}_z) = \sum_{\ell=0}^\infty \sum_{m=-\ell}^\ell f_\ell^m \cdot Y_\ell^m(\hat{\Omega}_x, \hat{\Omega}_y, \hat{\Omega}_z)
$$
donde para cada grado $\ell$ el orden $m$ es tal que

$$
-\ell \leq m \leq \ell
$$
:::

::: {#def-y00}
Los primeros armónicos esféricos reales (@fig-harmonics) son

$$
\begin{aligned}
Y_0^0(\hat{\Omega}_x,\hat{\Omega}_y,\hat{\Omega}_z) &= \sqrt{\frac{1}{4\pi}} \\
\\
Y_1^{-1}(\hat{\Omega}_x,\hat{\Omega}_y,\hat{\Omega}_z) &= \sqrt{\frac{3}{4\pi}} \cdot \hat{\Omega}_y \\
Y_1^0(\hat{\Omega}_x,\hat{\Omega}_y,\hat{\Omega}_z)    &= \sqrt{\frac{3}{4\pi}} \cdot \hat{\Omega}_z \\
Y_1^{+1}(\hat{\Omega}_x,\hat{\Omega}_y,\hat{\Omega}_z) &= \sqrt{\frac{3}{4\pi}} \cdot \hat{\Omega}_x \\
\\
Y_2^{-2}(\hat{\Omega}_x,\hat{\Omega}_y,\hat{\Omega}_z)  &= \sqrt{\frac{15}{4\pi}} \cdot \hat{\Omega}_x\cdot\hat{\Omega}_y \\
Y_2^{-1}(\hat{\Omega}_x,\hat{\Omega}_y,\hat{\Omega}_z)  &= \sqrt{\frac{15}{4\pi}} \cdot \hat{\Omega}_y\cdot\hat{\Omega}_z \\
Y_2^0(\hat{\Omega}_x,\hat{\Omega}_y,\hat{\Omega}_z)     &= \sqrt{\frac{5}{16\pi}} \cdot \left(-\hat{\Omega}_x^2-\hat{\Omega}_y^2+2\cdot\hat{\Omega}_z^2\right) \\
Y_2^{+1}(\hat{\Omega}_x,\hat{\Omega}_y,\hat{\Omega}_z)  &= \sqrt{\frac{15}{4\pi}} \cdot \hat{\Omega}_z\cdot\hat{\Omega}_x \\
Y_2^{+2}(\hat{\Omega}_x,\hat{\Omega}_y,\hat{\Omega}_z)  &= \sqrt{\frac{15}{16\pi}} \cdot \left(\hat{\Omega}_x^2-\hat{\Omega}_y^2\right) 
\end{aligned}
$$
:::

::: {#thm-harmonic-orto}

## ortonormalidad de los armónicos esféricos reales

Los armónicos esféricos reales son ortonormales, es decir

$$
 \int_{4\pi} Y_{\ell}^{m}(\omegaversor) \cdot Y_{\ell^\prime}^{m^\prime}(\omegaversor) \, d\omegaversor =
\delta_{\ell \ell^{\prime}} \cdot \delta_{m m^{\prime}}
\begin{cases}
1 & \text{si $\ell=\ell^{\prime} \land m=m^{\prime}$} \\
0 & \text{si $\ell\neq\ell^{\prime} \lor m\neq m^{\prime}$}
\end{cases}
$$
:::
 
::: {#cor-fellm}
Los coeficientes $f_\ell^m$ son iguales a 

$$
f_\ell^m (\vec{x}, E, t) = \int_{4\pi} \psi(\vec{x}, \omegaversor, E, t) \cdot Y_{\ell}^{m}(\omegaversor) \, d\omegaversor
$$
:::

::: {#thm-adicion}

## de adición

Los armónicos esféricos se relacionan con los polinomios de Legendre como

$$
P_\ell(\omegaversor \cdot \omegaprimaversor) =
\frac{4\pi}{2\ell + 1} \sum_{m=-\ell}^{+\ell} Y_\ell^{m}(\omegaversor) \cdot Y_\ell^m(\omegaprimaversor)
$$
:::

![Representación gráfica de los primeros nueve armónicos esféricos reales (@def-y00). En la @sec-funciones-algebraicas explicamos cómo generamos esta figura.](harmonics.png){#fig-harmonics width=100%}


::: {.remark}
Para $\ell = 0$ tenemos $P_0(\mu) = 1$ e $Y_0^0(\omegaversor) = \sqrt{1/4\pi}$. En efecto,

$$
P_0(\mu) = 1 = \frac{4\pi}{2\cdot 0 + 1} \cdot \sqrt{\frac{1}{4\pi}} \cdot \sqrt{\frac{1}{4\pi}} = 1
$$
:::

Si en el @thm-harmonics hacemos $f$ igual al flujo angular $\psi$ entonces podemos escribirlo como una suma doble sobre $\ell$ y sobre $m$ del producto de un coeficiente que depende del espacio $\vec{x}$, de la energía $E$ y del tiempo $t$ (pero no de la dirección $\omegaversor$) por el armónico esférico de grado $\ell$ y orden $m$, que no depende ni del espacio $\vec{x}$ ni de la energía $E$ ni del tiempo $t$ (pero sí de la dirección $\omegaversor$):

$$
\psi(\vec{x}, \omegaversor, E, t) = \sum_{\ell=0}^{\infty} \sum_{m=-\ell}^{+\ell} \Psi_\ell^m (\vec{x}, E, t) \cdot Y_{\ell}^{m}\left(\omegaversor\right)
$$ {#eq-psiarmonicos}
 

Volvamos entonces al término de [scattering]{lang=en-US} $q_s$ dado por la @eq-qs1 y reemplacemos $P_\ell(\omegaversor \cdot \omegaprimaversor)$ en la integral sobre $\omegaprimaversor$ por el @thm-adicion:

$$
\begin{gathered}
q_s(\vec{x}, \omegaversor, E, t) = \\
\bigintsss_{0}^{\infty}
 \sum_{\ell=0}^{\infty} \frac{ 2\ell + 1}{4\pi}
 \left[ \Sigma_{s_\ell}(\vec{x}, E^{\prime} \rightarrow E) \int_{4\pi} \frac{4\pi}{2\ell + 1} \sum_{m=-\ell}^{+\ell} Y_\ell^m(\omegaversor) \cdot Y_\ell^m(\omegaprimaversor) \cdot \psi(\vec{x}, \omegaprimaversor, E^\prime,t)\, d\omegaprimaversor \right] dE^{\prime} \\
=
\bigintsss_{0}^\infty
\sum_{\ell=0}^\infty
\left[ \Sigma_{s_\ell}(\vec{x}, E^{\prime} \rightarrow E) 
\sum_{m=-\ell}^{+\ell} Y_\ell^{m}(\omegaversor) \int_{4\pi}
 Y_\ell^m(\omegaprimaversor) \cdot \psi(\vec{x}, \omegaprimaversor,E^\prime,t)\, d\omegaprimaversor \right] dE^{\prime}
\end{gathered}
$$

La integral sobre $d\omegaprimaversor$ dentro del corchete es justamente el coeficiente $\Psi_\ell^m$ de la expansión en armónicos esféricos del flujo angular $\psi$ dado por el @cor-fellm. Luego

$$
q_s(\vec{x}, \omegaversor, E, t) =
\bigintsss_{0}^{\infty} \sum_{\ell=0}^\infty  \left[ \Sigma_{s_\ell}(\vec{x}, E^{\prime} \rightarrow E) 
\sum_{m=-\ell}^{+\ell} \Psi_\ell^m (\vec{x}, E^{\prime}, t) \cdot Y_\ell^{m}(\omegaversor)  \right] \, dE^{\prime}
$${#eq-qs3}

Esta @eq-qs3 refleja la forma en la que incide la fuente de [scattering]{lang=en-US} en el balance global de neutrones: el modo $\ell$ de la expansión en polinomios de Legendre de la sección diferencial $\Sigma_s$ de [scattering]{lang=en-US} contribuye sólo a través de los modos de grado $\ell$ de la expansión en armónicos esféricos del flujo angular $\psi$. En particular, para [scattering]{lang=en-US} isotrópico sólo el término para $\ell=0$ y $m=0$ contribuye a la fuente de [scattering]{lang=en-US} $q_s$.
De la misma manera, para [scattering]{lang=en-US} linealmente anisotrópico además sólo contribuyen los tres términos
con $\ell=1$ y $m=-1,0,+1$.

\medskip

Prestemos atención ahora al coeficiente $\Psi_0^0$.
Ya que por un lado $Y_0^0 = \sqrt{1/4\pi}$ (@def-y00) mientras que por otro la integral del flujo angular $\psi$ con respecto a $\omegaversor$ sobre todas las direcciones es igual al flujo escalar (@def-flujoescalar),
entonces

$$
\Psi_0^0(\vec{x}, E, t) = \int_{4\pi} \psi(\vec{x}, \omegaversor, E,t) \cdot Y_0^0(\omegaversor) \, d\omegaversor = \sqrt{\frac{1}{4\pi}} \cdot \phi(\vec{x}, E, t)
$$

De esta manera, podemos escribir la suma de la @eq-psiarmonicos con el primer término de la expansión del flujo angular $\psi$ escrito explícitamente como

$$\begin{aligned}
\psi(\vec{x}, \omegaversor, E, t) &= \sum_{\ell=0}^{\infty} \sum_{m=-\ell}^{+\ell} \Psi_\ell^m (\vec{x}, E, t) \cdot Y_{\ell}^{m} ({\omegaversor}) \\
&=  \sqrt{\frac{1}{4\pi}} \cdot \phi(\vec{x}, E, t) \cdot  \sqrt{\frac{1}{4\pi}} + \sum_{\ell=1}^{\infty} \sum_{m=-\ell}^{+\ell} \Psi_\ell^m (\vec{x}, E, t) \cdot Y_{\ell}^{m} ({\omegaversor}) \\
&= \frac{\phi(\vec{x}, E, t)}{4\pi} + \sum_{\ell=1}^{\infty} \sum_{m=-\ell}^{+\ell} \Psi_\ell^m (\vec{x}, E, t) \cdot Y_{\ell}^{m} ({\omegaversor})
\end{aligned}$$

Más aún, según la @def-y00, los coeficientes de grado $\ell=1$ son

$$
\begin{aligned}
 \Psi_1^{-1}(\vec{x}, E, t) &= \int_{4\pi} \psi(\vec{x}, \omegaversor, E,t) \cdot \textstyle \sqrt{\frac{3}{4\pi}} \cdot \hat{\Omega}_y \, d\omegaversor = \sqrt{\frac{3}{4\pi}} \cdot J_y(\vec{x}, E, t) \\
 \Psi_1^{0}(\vec{x}, E, t) &= \int_{4\pi} \psi(\vec{x}, \omegaversor, E,t) \cdot \textstyle \sqrt{\frac{3}{4\pi}} \cdot \hat{\Omega}_z \, d\omegaversor = \sqrt{\frac{3}{4\pi}} \cdot J_z(\vec{x}, E, t) \\
 \Psi_1^{1+}(\vec{x}, E, t) &= \int_{4\pi} \psi(\vec{x}, \omegaversor, E,t) \cdot \textstyle \sqrt{\frac{3}{4\pi}} \cdot \hat{\Omega}_x \, d\omegaversor = \sqrt{\frac{3}{4\pi}} \cdot J_x(\vec{x}, E, t) \\
\end{aligned}
$$
donde en la última igualdad hemos empleado la @def-corriente del vector corriente

$$
\vec{J}(\vec{x},E,t) = \int_{4\pi} \left[ \psi(\vec{x}, \omegaversor, E, t) \cdot \omegaversor \right] \, d\omegaversor
=
\begin{bmatrix}
J_x \\ J_y \\ J_z
\end{bmatrix}
$$
y la @eq-jn.

::: {.remark}
El vector corriente $\vec{J}(\vec{x},E,t)$ depende del espacio $\vec{x}$, la energía $E$ y el tiempo $t$ pero *no* del ángulo $\omegaversor$.
:::

Podemos escribir también los tres términos correspondiente a $\ell=1$ de la expansión del flujo angular $\psi$ explícitamente como tres veces (sobre $4\pi$) el producto interno entre el vector corriente $\vec{J}(\vec{x},E,t)$ y la dirección $\omegaversor$ de forma tal que

$$
\begin{aligned}
\psi(\vec{x}, \omegaversor, E, t) &= \frac{\phi(\vec{x}, E, t)}{4\pi} + \sum_{\ell=1}^{\infty} \sum_{m=-\ell}^{+\ell} \Psi_\ell^m (\vec{x}, E, t) \cdot Y_{\ell}^{m} ({\omegaversor}) \\
&= \frac{1}{4\pi} \left[ \phi(\vec{x}, E, t) + 3 \cdot \left(\vec{J}(\vec{x}, E, t) \cdot \omegaversor \right) \right] + \sum_{\ell=2}^{\infty} \sum_{m=-\ell}^{+\ell} \Psi_\ell^m (\vec{x}, E, t) \cdot Y_{\ell}^{m} ({\omegaversor})
\end{aligned}
$${#eq-psi1}

Como comprobación, verificamos que a partir de esta expresión podemos recuperar el flujo escalar integrando con respecto a $\omegaversor$ sobre $4\pi$

$$
\begin{aligned}
 \phi(\vec{x},E,t) &= \int_{4\pi} \psi(\vec{x}, \omegaversor, E, t) \, d\omegaversor\\
&= \frac{1}{4\pi} \bigintsss_{4\pi} \left[ \phi(\vec{x},E,t) + \left( 3\cdot \vec{J}(\vec{x},E,t) \cdot \omegaversor \right) + \sum_{\ell=2}^{\infty} \sum_{m=-\ell}^{+\ell} \Psi_\ell^m (\vec{x}, E, t) \cdot Y_{\ell}^{m} ({\omegaversor}) \right] \, d\omegaversor
\end{aligned}
$$ {#eq-recuperacion-phi}

Por un lado, la integral del segundo término $3 (\vec{J} \cdot \omegaversor)$ sobre $d\omegaversor$ es cero.
En efecto,

$$
\int_{4\pi} 3 \cdot \vec{J}(\vec{x},E,t) \cdot \omegaversor \, d\omegaversor
=
3\cdot \vec{J}(\vec{x},E,t) \cdot \int_{4\pi} \omegaversor \, d\omegaversor
=
3\cdot \vec{J}(\vec{x},E,t) \bigintss_{4\pi} 
\begin{bmatrix} \Omega_x \\ \Omega_y \\ \Omega_z \end{bmatrix} \, d\omegaversor
= 0
$$


Para analizar los siguientes términos para $\ell \geq 2$ necesitamos tener en cuenta el siguiente teorema.

::::: {#thm-integrales-armonicas}
La integral sobre la esfera unitaria del armónico esférico $Y_\ell^m$ de grado $\ell$ y orden $m$ es

$$
\int_{4\pi} Y_\ell^m(\omegaversor) \, d\omegaversor =
\begin{cases}
\sqrt{4\pi} & \text{para $\ell=0 \land m=0$} \\
0           & \text{de otra manera}
\end{cases}
$$

::: {.proof}
Tomemos $\ell^\prime = 0$ y $m^\prime=0$ en el @thm-harmonic-orto y reemplacemos la @def-y00 para $Y_0^0 = 1/\sqrt{4\pi}$

$$
\begin{aligned}
\int_{4\pi} Y_{\ell}^{m}(\omegaversor) \cdot Y_{0}^{0}(\omegaversor) \, d\omegaversor &= \delta_{\ell 0} \delta_{m 0} \\
\int_{4\pi} Y_{\ell}^{m}(\omegaversor) \cdot \sqrt{\frac{1}{4\pi}}\, d\omegaversor &= \delta_{\ell 0} \delta_{m 0} \\
\int_{4\pi} Y_{\ell}^{m}(\omegaversor) \, d\omegaversor &= \sqrt{4\pi} \cdot \delta_{\ell 0} \cdot \delta_{m 0}
\end{aligned}
$$
:::
:::::


En virtud del @thm-integrales-armonicas, los términos de la sumatoria sobre $\ell \geq 2$ en la @eq-recuperacion-phi tampoco contribuyen a la integral por lo que

$$
\phi(\vec{x},E,t) = \int_{4\pi} \psi(\vec{x}, \omegaversor, E, t) \, d\omegaversor = 
\frac{1}{4\pi} \int_{4\pi} \phi(\vec{x},E,t) \, d\omegaversor = \phi(\vec{x},E,t)
$$


::: {#thm-omega-i-j}
La integral del producto de dos cosenos dirección individuales
$$
 \int_{4\pi} \hat{\Omega}_i \cdot \hat{\Omega}_j \, d\omegaversor = \frac{4\pi}{3} \cdot \delta_{ij}
$$
para $i=x,y,z$ y $j=x,y,z$.
:::

::: {#thm-omega-i-j-k}
La integral del producto de una cantidad impar de cosenos es cero
$$
 \int_{4\pi} \hat{\Omega}_x^r \cdot \hat{\Omega}_y^s \cdot \hat{\Omega}_z^t \, d\omegaversor = 0 \quad \text{si $r$, $s$ ó $t$ es impar}
$$
:::


Podemos demostrar entonces que con la @def-corriente recuperamos además el vector corriente.

::: {.proof}
En efecto,

$$
\begin{aligned}
 \vec{J}(\vec{x},E,t) &= \int_{4\pi} \left[ \psi(\vec{x}, \omegaversor, E, t) \cdot \omegaversor \right] \, d\omegaversor\\
&= \frac{1}{4\pi} \int_{4\pi} \Big\{ \phi(\vec{x}, E,t) \cdot \omegaversor + 3 \cdot \left[ \vec{J}(\vec{x},E,t) \cdot \omegaversor\right] \cdot \omegaversor \\
& \quad\quad\quad\quad\quad\quad\quad + \sum_{\ell=2}^{\infty} \sum_{m=-\ell}^{+\ell} \Psi_\ell^m (\vec{x}, E, t) \cdot 
\left[ Y_{\ell}^{m}(\omegaversor) \cdot \omegaversor \right]
 \Big\} \, d\omegaversor
\end{aligned}
$$ {#eq-recuperacion-j}

El primer término $\phi \cdot \omegaversor$ se anula porque por un lado $\phi$ no depende de $\omegaversor$ y por otro, como ya demostramos, $\int_{4\pi} \omegaversor\,d\omegaversor = 0$.
Pero además los factores $Y_\ell^m \cdot \omegaversor$ dentro de la sumatoria doble también se anulan porque cualquier armónico $Y_\ell^m$ con $\ell>1$ es ortogonal con respecto a los tres armónicos $Y_1^m$ de orden $\ell=1$, que a su vez son proporcionales a $\omegaversor$:

$$
\begin{bmatrix}
Y_1^{+1}(\omegaversor) \\
Y_1^{-1}(\omegaversor) \\
Y_1^{0}(\omegaversor) \\
\end{bmatrix}
=
\sqrt{\frac{3}{4\pi}} \cdot
\begin{bmatrix}
\hat{\Omega}_x \\
\hat{\Omega}_y \\
\hat{\Omega}_z \\
\end{bmatrix}
=
\sqrt{\frac{3}{4\pi}} \cdot
\omegaversor
$${#eq-omegapropy}

Entonces

$$
\begin{aligned}
\vec{J}(\vec{x},E,t) &= \frac{3}{4\pi} \bigintsss_{4\pi} \left( J_x \hat{\Omega}_x + J_y \hat{\Omega}_y + J_z \hat{\Omega}_z \right) \cdot
\begin{bmatrix}
 \hat{\Omega}_x \\ \hat{\Omega}_y \\ \hat{\Omega}_z
\end{bmatrix}
\, d\omegaversor \\
&= \frac{3}{4\pi} \bigintsss_{4\pi}
\begin{bmatrix}
 J_x \hat{\Omega}_x \hat{\Omega}_x +  J_y \hat{\Omega}_y \hat{\Omega}_x +  J_z \hat{\Omega}_z \hat{\Omega}_x \\
 J_x \hat{\Omega}_x \hat{\Omega}_y +  J_y \hat{\Omega}_y \hat{\Omega}_y +  J_z \hat{\Omega}_z \hat{\Omega}_y \\
 J_x \hat{\Omega}_x \hat{\Omega}_z +  J_y \hat{\Omega}_y \hat{\Omega}_z +  J_z \hat{\Omega}_z \hat{\Omega}_z
\end{bmatrix}
\, d\omegaversor \\
\end{aligned}
$$


Usando el @thm-omega-i-j,

$$
\begin{aligned}
\vec{J}(\vec{x},E,t)
&= \frac{3}{4\pi} \bigintsss_{4\pi}
\begin{bmatrix}
 J_x \cdot \frac{4\pi}{3} +  J_y \cdot 0 +  J_z \cdot 0 \\
 J_x \cdot 0 +  J_y \cdot \frac{4\pi}{3} +  J_z \cdot 0 \\
 J_x \cdot 0 +  J_y \cdot 0 + J_z \cdot \frac{4\pi}{3}
\end{bmatrix}
\, d\omegaversor \\
&=
\frac{3}{4\pi} \bigintsss_{4\pi}
\begin{bmatrix}
 \frac{4\pi}{3} J_x \\
 \frac{4\pi}{3} J_y \\
 \frac{4\pi}{3} J_z \\
\end{bmatrix}
\, d\omegaversor \\
&= \vec{J}(\vec{x},E,t)
\end{aligned}
$$
que es lo que queríamos demostrar.
:::


Volviendo a la evaluación del término de [scattering]{lang=en-US}, aprovechando el hecho de que la @eq-psi1 nos da una forma particular para el flujo angular en función de los dos modos $\ell=0$ y $\ell=1$, podemos calcular la fuente de [scattering]{lang=en-US} $q_s$ dada por la @eq-qs3 como

$$
\begin{gathered}
 q_s(\vec{x}, \omegaversor, E, t) =
\frac{1}{4\pi} \int_{0}^{\infty} \Sigma_{s_0}(\vec{x}, E^{\prime} \rightarrow E) \cdot \phi(\vec{x}, E^{\prime}, t) \, dE^\prime \\
+ \frac{3}{4\pi} \int_{0}^{\infty} \Sigma_{s_1}(\vec{x}, E^{\prime} \rightarrow E) \cdot \left(\vec{J}(\vec{x},E^{\prime},t) \cdot \omegaversor\right) \, dE^\prime  \\
+ \sum_{\ell=2}^\infty \bigintsss_{0}^{\infty}   \left[ \Sigma_{s_\ell}(\vec{x}, E^{\prime} \rightarrow E) 
\sum_{m=-\ell}^{+\ell} \Psi_\ell^m (\vec{x}, E^{\prime}, t) \cdot Y_\ell^{m}(\omegaversor)  \right] \, dE^{\prime}
\end{gathered}
$$ {#eq-qsfacil}
que es una ecuación mucho más útil---desde el punto de vista computacional---que la @eq-qs, que da un expresión demasiado general y muy difícil de evaluar.
Esto es especialmente importante si podemos despreciar los términos para $\ell>1$ y suponer a lo más [scattering]{lang=en-US} linealmente anisotrópico (@def-scattering-linealmente-anisotropico).
En este caso entonces

$$
\begin{gathered}
 q_s(\vec{x}, \omegaversor, E, t) =
\frac{1}{4\pi}
\left\{ \int_{0}^{\infty} \Sigma_{s_0}(\vec{x}, E^{\prime} \rightarrow E) \cdot \phi(\vec{x}, E^{\prime}, t) \, dE^\prime \right. \\
\left. + 3 \cdot \int_{0}^{\infty} \Sigma_{s_1}(\vec{x}, E^{\prime} \rightarrow E) \cdot \left[\vec{J}(\vec{x},E^{\prime},t) \cdot \omegaversor \right] \, dE^\prime \right\}
\end{gathered}
$${#eq-qslinealaniso}

Más aún, para el caso particular de [scattering]{lang=en-US} isotrópico (@def-scattering-isotropico), $q_s$ se reduce a

$$
\begin{gathered}
 q_s(\vec{x}, \omegaversor, E, t) =
\frac{1}{4\pi}
\int_{0}^{\infty} \Sigma_{s_0}(\vec{x}, E^{\prime} \rightarrow E) \cdot \phi(\vec{x}, E^{\prime}, t) \, dE^\prime
\end{gathered}
$${#eq-qsiso}


Para completar la sección, notamos que dado que la fuente de neutrones debida a fisiones se asume isotrópica en el marco de referencia del reactor, su evaluación es similar a esta última @eq-qsiso. En efecto, el término de fisiones de la ecuación de transporte @eq-transporte es

$$
q_f(\vec{x}, \omegaversor, E, t) = \frac{\chi(E)}{4\pi} \int_{0}^{\infty} \int_{4\pi} \nu\Sigma_f(\vec{x}, E^\prime) \cdot \psi(\vec{x}, \omegaprimaversor, E^\prime, t) \, d\omegaprimaversor \, dE^\prime 
$$

El coeficiente $\nu\Sigma_f$ no depende de $\omegaprimaversor$ por lo que puede salir fuera de la integral sobre $4\pi$. Recordando la @def-flujoescalar de $\phi$ resulta

$$
\begin{aligned}
q_f(\vec{x}, \omegaversor, E, t) &= \frac{\chi(E)}{4\pi} \int_{0}^{\infty} \nu\Sigma_f(\vec{x}, E^\prime) \cdot \int_{4\pi} \psi(\vec{x}, \omegaprimaversor, E^\prime, t) \, d\omegaprimaversor \, dE^\prime \\
&= \frac{\chi(E)}{4\pi} \int_{0}^{\infty} \nu\Sigma_f(\vec{x}, E^\prime) \cdot \phi(\vec{x}, E^\prime, t) \, dE^\prime 
\end{aligned}
$${#eq-qfiso}

::: {.remark}
Ni la @eq-qsiso ni la @eq-qfiso dependen de la dirección $\omegaversor$.
:::

### Ecuación de transporte linealmente anisotrópica en estado estacionario

En esta tesis hacemos foco en el caso

 1. estacionario, y
 2. con [scattering]{lang=en-US} linealmente anisotrópico (a lo más)

En estas condiciones, la ecuación de transporte queda
 
$$
\begin{gathered}
 \omegaversor \cdot \text{grad} \left[ \psi(\vec{x}, \omegaversor, E) \right]
 + \Sigma_t(\vec{x}, E) \cdot \psi(\vec{x}, \omegaversor, E) = \\
\frac{1}{4\pi} \cdot 
\int_{0}^{\infty} \Sigma_{s_0}(\vec{x}, E^{\prime} \rightarrow E) \cdot \int_{4\pi} \psi(\vec{x}, \omegaprimaversor, E^{\prime}) \, d\omegaprimaversor \, dE^\prime + \\
\frac{3 \cdot \omegaversor}{4\pi} \cdot
\int_{0}^{\infty} \Sigma_{s_1}(\vec{x}, E^{\prime} \rightarrow E) \cdot \int_{4\pi} \psi(\vec{x}, \omegaprimaversor, E^{\prime}) \cdot \omegaprimaversor \, d\omegaprimaversor \, dE^\prime  \\
+ \frac{\chi(E)}{4\pi} \int_{0}^{\infty} \nu\Sigma_f(\vec{x}, E^\prime) \cdot \phi(\vec{x}, E^\prime) \, dE^\prime 
+ s(\vec{x}, \omegaversor, E)
\end{gathered}
$$ {#eq-transporte-linealmente-anisotropica}


Si el scattering es isotrópico entonces $\Sigma_{s_1}=0$ y el segundo término del miembro derecho se anula.

### Condiciones iniciales y de contorno {#sec-bctransporte}

Como ya hemos mencionado en la @sec-ecuacion-transporte luego de introducir la @eq-transporte, la ecuación de transporte es una ecuación integro-diferencial en derivadas parciales de primer orden sobre las coordenadas espaciales $\vec{x}$ en un cierto dominio espacial $U \in \mathbb{R}^3$ y una derivada temporal de primer orden sobre $t \in [0,\infty]$.
Luego debemos dar

 1. un flujo escalar inicial $\psi(\vec{x},E,\omegaversor,t=0)$ para $\vec{x}\in U$ para todas las energías $E$ y para todas las direcciones $\omegaversor$, y
 2. condiciones de contorno $\psi(\vec{x}=\partial U,E,\omegaversor=\omegaversor^{*},t)$ sobre la frontera $\partial U$ del dominio $U$ también para todas las energías $E$ y tiempos $t$ pero no para todas las direcciones $\omegaversor$ sino para un subconjunto $\omegaversor^{*}$ ya que la ecuación es de primer orden. Esto es, para cada punto $\vec{x} \in \partial U$ sólo se debe fijar el flujo angular $\psi$ correspondiente a las direcciones $\omegaversor^{*}$ que _entren_ al dominio $U$, es decir tal que el producto interno $\omegaversor^{*} \cdot \hat{\vec{n}} < 0$, donde $\hat{\vec{n}}$ es el vector normal externo a la frontera $\partial U$ en el punto $\vec{x}$. En forma equivalente, se puede pensar como que el flujo angular $\psi$ puede estar fijado, para cada dirección, a lo más en un único punto del espacio ya que la ecuación es de primer grado. Si estuviese fijado en dos puntos, el problema matemático estaría mal definido, como ilustramos en la @fig-bc-1st-order.
 
![Para una dirección $\omegaversor$ fija, la ecuación de transporte es una ecuación diferencial de primer orden sobre el espacio. Matemáticamente, esta ecuación puede tener una única condición de contorno o bien en el punto $A$ o bien en el punto $B$, pero no en ambos. Físicamente, sólo tiene sentido que la condición esté sobre el punto $A$ ya que la dirección $\omegaversor$ entra al dominio $U$.](bc-1st-order){#fig-bc-1st-order width=50%}
 

::: {#def-ccvacuum}

## condición de contorno de vacío

Llamamos *condición de contorno de vacío* a la situación en la cual todos los flujos angulares entrantes a $U$ son nulos:

$$
\psi(\vec{x}, \omegaversor, E, t) = 0 \quad\quad \forall \vec{x} \in \Gamma_V \subset \partial U \land \omegaversor \cdot \hat{\vec{n}}(\vec{x}) < 0
$$

Para cada dirección entrante $\omegaversor / \omegaversor \cdot \hat{\vec{n}} < 0$ definimos el
conjunto $\Gamma_V \subset \partial U$ como el lugar geométrico de todos los puntos $\vec{x}$ donde imponemos esta condición de contorno.
:::

::: {#def-ccmirror}

## condición de contorno de espejo

Llamamos *condición de contorno de reflexión o de simetría o tipo espejo* cuando el flujo angular entrante en el
punto $\vec{x} \in \partial U$ es igual al flujo angular saliente en la dirección reflejada

$$
\omegaprimaversor = \omegaversor - 2 \left( \omegaversor \cdot \hat{\vec{n}} \right) \hat{\vec{n}}
$${#eq-reflexion}

con respecto a la normal exterior $\hat{\vec{n}}(\vec{x})$ (@fig-reflejado)


$$
\psi(\vec{x}, \omegaversor, E, t) =
\psi\left[\vec{x}, \omegaversor - 2 \left( \omegaversor \cdot \hat{\vec{n}} \right) \hat{\vec{n}}, E, t\right]  \quad\quad \forall \vec{x} \in \Gamma_M \subset \partial U \land \omegaversor \cdot \hat{\vec{n}}(\vec{x}) < 0$$

Definimos el conjunto $\Gamma_M \subset \partial U$ como el lugar geométrico de todos los puntos $\vec{x}$ donde imponemos esta condición de contorno.
:::

![La dirección reflejada $\omegaprimaversor$ de la dirección incidente con respecto a la normal exterior $\hat{\vec{n}}$ al dominio $U$ en el punto de la frontera $\vec{x} \in \partial U$. Se cumple que $\omegaversor \cdot \hat{\vec{n}} = -\omegaprimaversor \cdot \hat{\vec{n}}$.](reflejado){#fig-reflejado width=60%}

Las dos condiciones de contorno dadas en la @def-ccvacuum y en la @def-ccmirror son de tipo Dirichlet ya que se fija el valor de la incógnita $\psi$. Además ambas son homogéneas porque el valor fijado es igual a cero.

::: {#def-ccinhomogenea}
Si

 a. las fuentes de fisión son idénticamente nulas, o
 b. las fuentes de fisión son no nulas *y* las fuentes independientes también son no nulas

entonces es posible tener una _condición de contorno general_ de Dirichlet no homogénea

$$
\psi(\vec{x}, \omegaversor, E, t) = \psi_\Gamma(\vec{x}, \omegaversor, E, t) \neq 0 \quad\quad \forall \vec{x} \in \Gamma_{I} \not\subset \left(\Gamma_V \cup \Gamma_M\right) \land \omegaversor \cdot \hat{\vec{n}}(\vec{x}) < 0
$$

Definimos el conjunto $\Gamma_I \subset \partial U$ como el lugar geométrico de todos los puntos $\vec{x}$ donde imponemos esta condición de contorno.
:::

::: {.remark}
Los problemas en los cuales la única fuente de neutrones proviene de fisiones no admiten condiciones de contorno inhomogéneas.
:::

## Aproximación de difusión {#sec-difusion}

La ecuación de difusión de neutrones es una aproximación muy útil que permite 

 a. obtener soluciones analíticas aproximadas en algunas geometrías simples, y
 b. transformar una ecuación diferencial hiperbólica de primer orden en una elíptica de segundo orden sin dependencia angular explícita, simplificando sensiblemente las soluciones numéricas debido a que
    i. la ecuación de difusión discretizada presenta mucho menos grados de libertad que otras formulaciones, tales como ordenadas discretas, y
    ii. la discretización numérica del operador elíptico deviene en matrices simétricas y definidas positivas que permiten la aplicación de algoritmos de resolución muy eficientes, tales como los métodos multi-grid [@brandt;@nachogatech].
 
En esta sección derivamos la ecuación de difusión a partir de la ecuación de transporte. La segunda puede ser considerada _exacta_ en el sentido de que todas las deducciones lógicas e igualdades entre miembros han sido estrictas, si damos por cierto las siete suposiciones` de la página~\pageref{siete}`{=latex}. La primera es una aproximación que, como mostramos en esta sección, proviene de igualar la corriente $\vec{J}$ en forma aproximada a un coeficiente negativo por el gradiente $\nabla \phi$ del flujo escalar despreciando la contribución de los términos con $\ell \geq 2$ en la expansión en armónicos esféricos del flujo angular $\psi$.
 
### Momento de orden cero

Comenzamos integrando la ecuación de transporte de neutrones [-@eq-transporteq] sobre todas los direcciones $\omegaversor$ para obtener

$$
\begin{gathered}
\int_{4\pi} \frac{1}{v} \frac{\partial}{\partial t} \Big[ \psi(\vec{x}, \omegaversor, E, t) \Big] \, d\omegaversor
 + \int_{4\pi} \omegaversor \cdot \text{grad} \left[ \psi(\vec{x}, \omegaversor, E, t) \right] \, d\omegaversor \\
 + \int_{4\pi} \Sigma_t(\vec{x}, E) \cdot \psi(\vec{x}, \omegaversor, E, t) \, d\omegaversor
 = \int_{4\pi} q(\vec{x}, \omegaversor, E, t)  \, d\omegaversor
\end{gathered}
$${#eq-transporte-integrada}

::: {#thm-div-inner}

## extensión de la regla de la derivada del producto

La divergencia del producto entre el escalar $a(\vec{x})$ y el vector $\vec{b(\vec{x})}$ es

$$
\mathrm{div} \big[ a(\vec{x}) \cdot \vec{b}(\vec{x}) \big ] = a(\vec{x}) \cdot \mathrm{div} \left[\vec{b}(\vec{x})\right] + \vec{b}(\vec{x}) \cdot \mathrm{grad}\left[a(\vec{x})\right]
$$
:::

::: {#cor-div0}
Para $a=\psi$ y $\vec{b} =\omegaversor$ y el escalar $\psi$,

$$
\mathrm{div} \left(\omegaversor \cdot \psi \right) = \omegaversor \cdot \mathrm{grad} \left( \psi \right) + \psi \cdot \mathrm{div} ( \omegaversor )
$$

Por la @eq-grad-solo-x el operador diferencial actúa sólo sobre las coordenadas espaciales, entonces $\text{div} ( \omegaversor ) = 0$. Luego

$$
\mathrm{div}\left(\omegaversor \cdot \psi \right) = \omegaversor \cdot \mathrm{grad} \left( \psi \right)
$$
:::


El segundo término de la @eq-transporte-integrada queda entonces como la divergencia de la integral sobre $\omegaversor$ del producto escalar entre la dirección $\omegaversor$ por el flujo angular $\psi$

$$
\begin{gathered}
 \frac{1}{v} \frac{\partial}{\partial t} \left[ \int \psi(\vec{x}, \omegaversor, E, t) \, d\omegaversor \right]
 + \text{div} \left [ \int \left( \omegaversor  \cdot \psi(\vec{x}, \omegaversor, E, t)\right)\, d\omegaversor \right] \\
 + \Sigma_t(\vec{x}, E) \cdot \left[ \int \psi(\vec{x}, \omegaversor, E, t) \, d\omegaversor \right]
 = \int q(\vec{x}, \omegaversor, E, t) \, d\omegaversor
\end{gathered}
$$

Recordando una vez más la @def-flujoescalar del flujo escalar $\phi$ y @def-corriente del vector corriente $\vec{J}$,

$$
\begin{aligned}
\phi(\vec{x}, E, t) &= \int_{4\pi} \psi(\vec{x}, \omegaversor, E, t) \, d\omegaversor  \\
\vec{J}(\vec{x},E,t) &= \int_{4\pi} \left[ \psi(\vec{x}, \omegaversor, E, t) \cdot \omegaversor \right] \, d\omegaversor
\end{aligned}
$$
y definiendo una fuente de neutrones escalar que incluya [scattering]{lang=en-US}, fisiones y/o fuentes independientes integrada sobre $4\pi$

$$
 Q(\vec{x}, E, t)
=
\int_{4\pi} q_s(\vec{x}, \omegaversor, E, t) \, d\omegaversor
 + \int_{4\pi} q_f(\vec{x}, \omegaversor, E, t) \, d\omegaversor
 + \int_{4\pi} s(\vec{x}, \omegaversor, E, t) \, d\omegaversor
$$
podemos escribir

$$
 \frac{1}{v} \frac{\partial}{\partial t} \Big[ \phi(\vec{x}, E, t) \Big]
 + \text{div} \Big[ \vec{J}(\vec{x}, E, t) \Big]
 + \Sigma_t(\vec{x}, E) \cdot \phi(\vec{x}, E, t)
 = Q(\vec{x}, E, t)
$${#eq-conservacion}

::: {.remark}
La @eq-conservacion refleja la conservación del momento de orden cero del flujo angular $\psi$ de neutrones con respecto a las direcciones $\omegaversor$, es decir la conservación de neutrones totales.
Dado que proviene de integrar la ecuación de transporte sobre todas las direcciones posible, es tan exacta como la propia ecuación de transporte.
:::

#### Producciones

El miembro derecho de la @eq-conservacion representa las producciones de neutrones integradas sobre todas las direcciones y es igual a la integral de las tres contribuciones individuales debidas a [scattering]{lang=en-US}, fisión y fuentes
independientes:

$$
\begin{aligned}
 Q(\vec{x}, E, t) &=
   \int_{4\pi} q_s(\vec{x}, \omegaversor, E, t) \, d\omegaversor
 + \int_{4\pi} q_f(\vec{x}, \omegaversor, E, t) \, d\omegaversor
 + \int_{4\pi} s(\vec{x}, \omegaversor, E, t) \, d\omegaversor \\
&= Q_s(\vec{x}, E, t) + Q_f(\vec{x}, E, t) + S(\vec{x}, E, t)
\end{aligned}
$$

##### Fuente por [scattering]{lang=en-US}

Para evaluar la contribución debida al [scattering]{lang=en-US} de neutrones podemos integrar la @eq-qsfacil sobre todas las direcciones emergentes $\omegaversor$:

$$
\begin{gathered}
 Q_s(\vec{x}, E, t) = \bigintsss_{4\pi} \Bigg\{
\frac{1}{4\pi} \int_{0}^{\infty} \Sigma_{s_0}(\vec{x}, E^{\prime} \rightarrow E) \cdot \phi(\vec{x}, E^{\prime}, t) \, dE^\prime \\
+ \frac{3}{4\pi} \int_{0}^{\infty} \Sigma_{s_1}(\vec{x}, E^{\prime} \rightarrow E) \cdot \left(\vec{J}(\vec{x},E^{\prime},t) \cdot \omegaversor\right) \, dE^\prime  \\
+ \sum_{\ell=2}^\infty \bigintsss_{0}^{\infty}   \left[ \Sigma_{s_\ell}(\vec{x}, E^{\prime} \rightarrow E) 
\sum_{m=-\ell}^{+\ell} \Psi_\ell^m (\vec{x}, E^{\prime}, t) \cdot Y_\ell^{m}(\omegaversor)  \right] \, dE^{\prime} \Bigg\} \, d\omegaversor
\end{gathered}
$$

Por la mismas razones que las esgrimidas al analizar la @eq-recuperacion-phi, solamente el primer término del integrando sobre $\omegaversor$ resulta en una contribución diferente de cero. Luego la fuente de neutrones debido a [scattering]{lang=en-US} integrada en $4\pi$ se simplifica a

$$
Q_s(\vec{x}, E, t) = \int_{0}^{\infty} \Sigma_{s_0}(\vec{x}, E^{\prime} \rightarrow E)  \cdot \phi(\vec{x}, E^\prime, t) \, dE^\prime
$${#eq-Qs}

##### Fuente por fisión

El término que representa la fuente por fisión es la integral sobre todas las posibles direcciones del término de fuentes de fisión $q_f$. Para el caso de la @eq-qfiso, tenemos

$$
\begin{aligned}
Q_f(\vec{x},E,t) &= \bigintsss_{4\pi} \left[ \frac{\chi(E)}{4\pi} \int_{0}^{\infty} \nu\Sigma_f(\vec{x}, E^\prime) \cdot \phi(\vec{x}, E^\prime, t) \, dE^\prime \right] \, d\omegaversor  \\
&= \chi(E) \int_{0}^{\infty} \nu\Sigma_f(\vec{x}, E^\prime) \cdot \phi(\vec{x}, E^\prime, t) \, dE^\prime
\end{aligned}
$${#eq-Qf}

##### Fuente independiente

La fuente independiente integrada es directamente la integral sobre $\omegaversor$
de la fuente independiente angular $s(\vec{x}, \omegaversor, E, t)$:

$$
 S(\vec{x},E,t) = \int_{4\pi} s(\vec{x}, \omegaversor, E, t) \,  d\omegaversor
  = s_0(\vec{x},E,t)
$${#eq-S}
es decir, el momento de orden cero de la distribución angular de la fuente $s$.

### Momento de orden uno {#sec-fick}

Comencemos esta sección recordando la @eq-transporteq, explicitando los términos de fuentes por [scattering]{lang=en-US} (@eq-qs3),
fisión (@eq-qf) y fuentes independientes:

$$
\begin{gathered}
 \frac{1}{v} \frac{\partial}{\partial t} \left[ \psi(\vec{x}, \omegaversor, E, t) \right]
 + \omegaversor \cdot \text{grad} \left[ \psi(\vec{x}, \omegaversor, E, t) \right]
 + \Sigma_t(\vec{x}, E) \cdot \psi(\vec{x}, \omegaversor, E, t)
 = \\
\bigintsss_{0}^{\infty} \sum_{\ell=0}^\infty \left[ \Sigma_{s_\ell}(\vec{x}, E^{\prime} \rightarrow E) 
\sum_{m=-\ell}^{+\ell} \Psi_\ell^m (\vec{x}, E^{\prime}, t) \cdot Y_\ell^{m}(\omegaversor)  \right] \, dE^{\prime}
\\
+ \frac{\chi(E)}{4\pi} \int_{0}^{\infty} \nu\Sigma_f(\vec{x}, E^\prime) \cdot \phi(\vec{x}, E^\prime, t) \, dE^\prime
+ s(\vec{x}, \omegaversor, E, t)
\end{gathered}
$${#eq-orden1}

Multipliquemos esta ecuación escalar por el versor $\omegaversor$ e integremos sobre todas las posibles direcciones para obtener una ecuación vectorial de dimensión tres:

$$
\begin{gathered}
\underbrace{\int_{4\pi} \left( \frac{1}{v} \frac{\partial}{\partial t} \left[ \psi(\vec{x}, \omegaversor, E, t) \right] \cdot  \omegaversor \right) \, d\omegaversor}_\text{derivada temporal}
 +
\underbrace{\int_{4\pi} \left( \omegaversor \cdot \text{grad} \left[ \psi(\vec{x}, \omegaversor, E, t) \right] \cdot  \omegaversor \right) \, d\omegaversor}_\text{advección}
\\
 +
\underbrace{\int_{4\pi} \left( \Sigma_t(\vec{x}, E) \cdot \psi(\vec{x}, \omegaversor, E, t) \cdot  \omegaversor \right) \, d\omegaversor}_\text{absorción total}
 = 
\\
\underbrace{\bigintsss_{4\pi} \left( \int_{0}^{\infty} \sum_{\ell=0}^\infty  \left[ \Sigma_{s_\ell}(\vec{x}, E^{\prime} \rightarrow E) 
\sum_{m=-\ell}^{+\ell} \Psi_\ell^m (\vec{x}, E^{\prime}, t) \cdot Y_\ell^{m}(\omegaversor)  \right] \, dE^{\prime}  \cdot  \omegaversor \right) \, d\omegaversor}_\text{scattering}
\\
+
\underbrace{\int_{4\pi} \left( \frac{\chi(E)}{4\pi} \int_{0}^{\infty} \nu\Sigma_f(\vec{x}, E^\prime) \cdot \phi(\vec{x}, E^\prime, t) \, dE^\prime  \cdot  \omegaversor \right) \, d\omegaversor}_\text{fisión}
+
\underbrace{\int_{4\pi} \left( s(\vec{x}, \omegaversor, E, t)  \cdot  \omegaversor \right) \, d\omegaversor}_\text{fuentes independientes}
\end{gathered}
$${#eq-difusionporomega}

Analicemos en las seis subsecciones que siguen los términos de esta expresión un por uno, teniendo en cuenta los desarrollos matemáticos que hemos realizado a lo largo de todo el capítulo.

#### Derivada temporal

El primer término corresponde a la derivada temporal de la corriente.
En efecto

$$
\begin{aligned}
\int_{4\pi} \left( \frac{1}{v} \frac{\partial}{\partial t} \left[ \psi(\vec{x}, \omegaversor, E, t) \right] \cdot  \omegaversor \right) \, d\omegaversor
& =
\frac{1}{v(E)} \frac{\partial}{\partial t}\left[ \int_{4\pi} \left( \psi(\vec{x}, \omegaversor, E, t) \cdot  \omegaversor \right) \, d\omegaversor \right] \\
& = \sqrt{\frac{m}{2E}} \frac{\partial}{\partial t}\Big[ \vec{J}(\vec{x}, E, t) \Big]
\end{aligned}
$$ {#eq-difusion1}


#### Advección

El término de advección parece el más sencillo pero de hecho es el más difícil de analizar.
Es más, es tan complicado que es aquí donde necesitamos hacer la aproximación más importante de la formulación de difusión.
Tenemos que suponer que los coeficientes $\Psi_\ell^m$ de la expansión del flujo angular $\psi$ en armónicos esféricos dado en la @eq-psi1 son cero para $\ell \geq 2$, es decir

$$
\psi(\vec{x}, \omegaversor, E, t) \simeq \frac{1}{4\pi} \left[ \phi(\vec{x}, E, t) + 3 \cdot \left(\vec{J}(\vec{x}, E, t) \cdot \omegaversor \right) \right]
$$

Con esta suposición, el término de advección queda aproximadamente igual a

$$
\begin{gathered}
\int_{4\pi} \left( \omegaversor \cdot \text{grad} \left[ \psi(\vec{x}, \omegaversor, E, t) \right] \cdot  \omegaversor \right) \, d\omegaversor \simeq \\
\frac{1}{4\pi} \cdot \left\{ \int_{4\pi} \left( \omegaversor \cdot \text{grad}\left(\phi\right) \right) \cdot \omegaversor \, d\omegaversor
+ 3 \cdot \int_{4\pi} \left[ \omegaversor \cdot \text{grad}\left( \vec{J} \cdot \omegaversor \right) \right] \cdot \omegaversor \, d\omegaversor \right\}
\end{gathered}
$$ {#eq-adveccion}

La integral sobre el gradiente flujo escalar $\nabla \phi$ es

$$
\begin{aligned}
\int_{4\pi} \left[\omegaversor \cdot \text{grad}\left(\phi\right) \right] \cdot \omegaversor \, d\omegaversor
&=
\bigintss_{4\pi} \left(
\begin{bmatrix} \hat{\Omega}_x & \hat{\Omega}_y & \hat{\Omega}_z \end{bmatrix}
\begin{bmatrix} \frac{\partial \phi}{\partial x} \\ \frac{\partial \phi}{\partial y} \\ \frac{\partial \phi}{\partial z} \end{bmatrix}  \right) \cdot
\begin{bmatrix} \hat{\Omega}_x \\ \hat{\Omega}_y \\ \hat{\Omega}_z \end{bmatrix} \, d\omegaversor
\\
&=
\bigintss_{4\pi} \left(
\hat{\Omega}_x \cdot \frac{\partial \phi}{\partial x} + \hat{\Omega}_y \cdot \frac{\partial \phi}{\partial y} + \hat{\Omega}_z \cdot \frac{\partial \phi}{\partial z} \right) \cdot
\begin{bmatrix} \hat{\Omega}_x \\ \hat{\Omega}_y \\ \hat{\Omega}_z \end{bmatrix} \, d\omegaversor
\\
&=
\bigints_{4\pi}
\begin{bmatrix}
\hat{\Omega}_x \hat{\Omega}_x \cdot \frac{\partial \phi}{\partial x} + \hat{\Omega}_x \hat{\Omega}_y \cdot \frac{\partial \phi}{\partial y} + \hat{\Omega}_x \hat{\Omega}_z \cdot \frac{\partial \phi}{\partial z} \\
\hat{\Omega}_y \hat{\Omega}_x \cdot \frac{\partial \phi}{\partial x} + \hat{\Omega}_y \hat{\Omega}_y \cdot \frac{\partial \phi}{\partial y} + \hat{\Omega}_y \hat{\Omega}_z \cdot \frac{\partial \phi}{\partial z} \\
\hat{\Omega}_z \hat{\Omega}_x \cdot \frac{\partial \phi}{\partial x} + \hat{\Omega}_z \hat{\Omega}_y \cdot \frac{\partial \phi}{\partial y} + \hat{\Omega}_z \hat{\Omega}_z \cdot \frac{\partial \phi}{\partial z}
\end{bmatrix}
\, d\omegaversor
\\
&=
\left(
\bigintss_{4\pi} 
\begin{bmatrix}
\hat{\Omega}_x^2 & \hat{\Omega}_x \hat{\Omega}_y & \hat{\Omega}_x \hat{\Omega}_z \\
\hat{\Omega}_y \hat{\Omega}_x & \hat{\Omega}_y^2 & \hat{\Omega}_y \hat{\Omega}_z \\
\hat{\Omega}_z \hat{\Omega}_x & \hat{\Omega}_z \hat{\Omega}_y & \hat{\Omega}_z^2
\end{bmatrix}
\, d\omegaversor
\right)
\cdot
\text{grad}\left[ \phi(\vec{x}, E, t) \right]
\end{aligned}
$$

Recordando el @thm-omega-i-j, los elementos de la diagonal dan como resultado $4\pi/3$ mientras que el resto se anulan:

$$
\begin{aligned}
\int_{4\pi} \left[\omegaversor \cdot \text{grad}\left(\phi\right) \right] \cdot \omegaversor \, d\omegaversor
&=
\frac{4\pi}{3}
\begin{bmatrix}
1 & 0 & 0 \\
0 & 1 & 0 \\
0 & 0 & 1 \\
\end{bmatrix}
\cdot
\begin{bmatrix} \frac{\partial \phi}{\partial x} \\ \frac{\partial \phi}{\partial y} \\ \frac{\partial \phi}{\partial z} \end{bmatrix}
\\
&=
\frac{4\pi}{3}
\cdot
\begin{bmatrix} \frac{\partial \phi}{\partial x} \\ \frac{\partial \phi}{\partial y} \\ \frac{\partial \phi}{\partial z} \end{bmatrix}
= 4\pi \cdot \left[ \frac{1}{3} \cdot \text{grad}\left[ \phi(\vec{x}, E, t) \right] \right]
\end{aligned}
$$

Por otro lado, el segundo término de la @eq-adveccion se anula. En efecto,


$$
\int_{4\pi} \left[ \omegaversor \cdot \text{grad}\left( \vec{J} \cdot \omegaversor \right) \right] \cdot \omegaversor \, d\omegaversor
$$

$$
=
\bigintss_{4\pi}
\left\{
\begin{bmatrix} \hat{\Omega}_x & \hat{\Omega}_y & \hat{\Omega}_z \end{bmatrix}
\cdot
\text{grad} \left( J_x \cdot \hat{\Omega}_x + J_y \cdot \hat{\Omega}_y + J_z \cdot \hat{\Omega}_z \right)
\right\}
\cdot
\begin{bmatrix} \hat{\Omega}_x \\ \hat{\Omega}_y \\ \hat{\Omega}_z \end{bmatrix}
\, d\omegaversor 
$$

$$
=
\bigintss_{4\pi}
\left\{
\begin{bmatrix} \hat{\Omega}_x & \hat{\Omega}_y & \hat{\Omega}_z \end{bmatrix}
\cdot
\begin{bmatrix}
\frac{\partial J_x}{\partial x} \cdot \hat{\Omega}_x + \frac{\partial J_y}{\partial x} \cdot \hat{\Omega}_y + \frac{\partial J_z}{\partial x} \cdot \hat{\Omega}_z \\
\frac{\partial J_x}{\partial y} \cdot \hat{\Omega}_x + \frac{\partial J_y}{\partial y} \cdot \hat{\Omega}_y + \frac{\partial J_z}{\partial y} \cdot \hat{\Omega}_z \\
\frac{\partial J_x}{\partial z} \cdot \hat{\Omega}_x + \frac{\partial J_y}{\partial z} \cdot \hat{\Omega}_y + \frac{\partial J_z}{\partial z} \cdot \hat{\Omega}_z
\end{bmatrix}
\right\}
\cdot
\begin{bmatrix} \hat{\Omega}_x \\ \hat{\Omega}_y \\ \hat{\Omega}_z \end{bmatrix}
\, d\omegaversor
$$

$$
\begin{aligned}
= \int_{4\pi}
\Bigg( &
\frac{\partial J_x}{\partial x} \cdot \hat{\Omega}_x^2 + \frac{\partial J_y}{\partial x} \cdot \hat{\Omega}_y \hat{\Omega}_x + \frac{\partial J_z}{\partial x} \cdot \hat{\Omega}_z \hat{\Omega}_x + \\
&
\frac{\partial J_x}{\partial y} \cdot \hat{\Omega}_x \hat{\Omega}_y + \frac{\partial J_y}{\partial y} \cdot \hat{\Omega}_y^2 + \frac{\partial J_z}{\partial y} \cdot \hat{\Omega}_z \hat{\Omega}_y + \\
&
\frac{\partial J_x}{\partial z} \cdot \hat{\Omega}_x \hat{\Omega}_z + \frac{\partial J_y}{\partial z} \cdot \hat{\Omega}_y \hat{\Omega}_z + \frac{\partial J_z}{\partial z} \cdot \hat{\Omega}_z^2
\Bigg)
\cdot
\begin{bmatrix} \hat{\Omega}_x \\ \hat{\Omega}_y \\ \hat{\Omega}_z \end{bmatrix}
\, d\omegaversor
\end{aligned}
$$

El integrando es un vector $\vec{v} \in \mathbb{R}^3$ cuyos tres elementos son

$$
\begin{aligned}
v_1 =&
\frac{\partial J_x}{\partial x} \cdot \hat{\Omega}_x^3 +
\frac{\partial J_y}{\partial x} \cdot \hat{\Omega}_y \hat{\Omega}_x^2 +
\frac{\partial J_z}{\partial x} \cdot \hat{\Omega}_z \hat{\Omega}_x^2 +
\\ &
\frac{\partial J_x}{\partial y} \cdot \hat{\Omega}_x^2 \hat{\Omega}_y +
\frac{\partial J_y}{\partial y} \cdot \hat{\Omega}_y^2 \hat{\Omega}_x +
\frac{\partial J_z}{\partial y} \cdot \hat{\Omega}_z \hat{\Omega}_y \hat{\Omega}_x +
\\ &
\frac{\partial J_x}{\partial z} \cdot \hat{\Omega}_x^2 \hat{\Omega}_z +
\frac{\partial J_y}{\partial z} \cdot \hat{\Omega}_y \hat{\Omega}_z \hat{\Omega}_x +
\frac{\partial J_z}{\partial z} \cdot \hat{\Omega}_z^2 \hat{\Omega}_x
\end{aligned}
$$


$$
\begin{aligned}
v_2 =&
\frac{\partial J_x}{\partial x} \cdot \hat{\Omega}_x^2 \hat{\Omega}_y +
\frac{\partial J_y}{\partial x} \cdot \hat{\Omega}_y^2 \hat{\Omega}_x +
\frac{\partial J_z}{\partial x} \cdot \hat{\Omega}_z \hat{\Omega}_x \hat{\Omega}_y +
\\ &
\frac{\partial J_x}{\partial y} \cdot \hat{\Omega}_x \hat{\Omega}_y^2 +
\frac{\partial J_y}{\partial y} \cdot \hat{\Omega}_y^3 +
\frac{\partial J_z}{\partial y} \cdot \hat{\Omega}_z \hat{\Omega}_y^2 + 
\\ &
\frac{\partial J_x}{\partial z} \cdot \hat{\Omega}_x \hat{\Omega}_z \hat{\Omega}_y +
\frac{\partial J_y}{\partial z} \cdot \hat{\Omega}_y^2 \hat{\Omega}_z +
\frac{\partial J_z}{\partial z} \cdot \hat{\Omega}_z^2 \hat{\Omega}_y
\end{aligned}
$$

y

$$
\begin{aligned}
v_3 =&
\frac{\partial J_x}{\partial x} \cdot \hat{\Omega}_x^2 \hat{\Omega}_z +
\frac{\partial J_y}{\partial x} \cdot \hat{\Omega}_y \hat{\Omega}_x \hat{\Omega}_z +
\frac{\partial J_z}{\partial x} \cdot \hat{\Omega}_z^2 \hat{\Omega}_x +
\\ &
\frac{\partial J_x}{\partial y} \cdot \hat{\Omega}_x \hat{\Omega}_y \hat{\Omega}_z +
\frac{\partial J_y}{\partial y} \cdot \hat{\Omega}_y^2 \hat{\Omega}_z +
\frac{\partial J_z}{\partial y} \cdot \hat{\Omega}_z^2 \hat{\Omega}_y + 
\\ &
\frac{\partial J_x}{\partial z} \cdot \hat{\Omega}_x \hat{\Omega}_z^2  +
\frac{\partial J_y}{\partial z} \cdot \hat{\Omega}_y \hat{\Omega}_z^2 +
\frac{\partial J_z}{\partial z} \cdot \hat{\Omega}_z^3
\end{aligned}
$$

Los veintisiete términos tienen al menos un coseno dirección elevado a un potencia impar, por lo que por el @thm-omega-i-j-k su integral sobre $4\pi$ es igual a cero.
Entonces, podemos aproximar el término de advección bajo la suposición de que el flujo angular es linealmente anisotrópico como


$$
\int_{4\pi} \left( \omegaversor \cdot \text{grad} \left[ \psi(\vec{x}, \omegaversor, E, t) \right] \cdot  \omegaversor \right) \, d\omegaversor \simeq  \frac{1}{3} \cdot \text{grad} \left[ \phi(\vec{x}, E,t ) \right]
$$ {#eq-difusion2}

::::: {.remark}
La referencia [@beckurts, p. 88] indica

::: {lang=en-US}
> If one keeps the higher terms in the Legendre polynomial expansion of $\psi$, there then results, as can be shown by an easy calculation, the exact expression
>
> $$
> J = - \frac{1}{3 \left( \Sigma_{tr} + \Sigma_a \right)} \frac{d}{dx} \left[ \phi(x) \left(1 + 2 \frac{\psi_2(x)}{\phi(x)} \right)  \right]
> $$
:::
:::::

#### Absorción total

El siguiente es el término de absorciones totales escrito en forma vectorial con respecto a la corriente

$$
\begin{aligned}
\int_{4\pi} \left( \Sigma_t(\vec{x}, E) \cdot \psi(\vec{x}, \omegaversor, E, t) \cdot  \omegaversor \right) \, d\omegaversor
& =
\Sigma_t(\vec{x}, E) \cdot \int_{4\pi} \left( \psi(\vec{x}, \omegaversor, E, t) \cdot  \omegaversor \right) \, d\omegaversor \\
& =
\Sigma_t(\vec{x}, E) \cdot \vec{J}(\vec{x}, E, t)
\end{aligned}
$${#eq-difusion3}

#### [Scattering]{lang=en-US}

El término de [scattering]{lang=en-US} parece complicado, pero en realidad ya lo hemos resuelto al derivar la ecuación @eq-recuperacion-j.
En primer lugar, partamos de la ecuación @eq-qsfacil multiplicada por $\omegaversor$ e integrada
en $4\pi$:

$$\begin{gathered}
\bigintsss_{4\pi} \left[ \frac{1}{4\pi} \int_{0}^{\infty} \Sigma_{s_0}(\vec{x}, E^{\prime} \rightarrow E) \cdot \phi(\vec{x}, E^{\prime}, t) \cdot \omegaversor  \, dE^\prime \right] \, d\omegaversor \\
+ \bigintsss_{4\pi} \left[ \frac{3}{4\pi} \int_{0}^{\infty} \Sigma_{s_1}(\vec{x}, E^{\prime} \rightarrow E) \cdot \left(\vec{J}(\vec{x},E^{\prime},t) \cdot \omegaversor\right) \cdot \omegaversor\, dE^\prime \right] \, d\omegaversor  \\
+ \bigintsss_{4\pi}  \left\{ \sum_{\ell=2}^\infty \bigintsss_{0}^{\infty}   \left[ \Sigma_{s_\ell}(\vec{x}, E^{\prime} \rightarrow E) 
\sum_{m=-\ell}^{+\ell} \Psi_\ell^m (\vec{x}, E^{\prime}, t) \cdot Y_\ell^{m}(\omegaversor) \cdot \omegaversor \right] \, dE^{\prime} \right\} \, d\omegaversor
\end{gathered}$$

En forma similar al argumento planteado en la @eq-recuperacion-phi, el primer término se anula.
Los términos de la sumatoria para $\ell \geq 2$ también se anulan por la propiedad
de ortogonalidad de los armónicos esféricos (@thm-harmonic-orto) y la @eq-omegapropy que indica que $\omegaversor$ es proporcional a $Y_1^m(\omegaversor)$.
Entonces el término de [scattering]{lang=en-US} queda

$$\begin{aligned}
&= \frac{3}{4\pi} \bigintsss_{4\pi} \left\{ \int_0^\infty \Sigma_{s_1}(\vec{x},E^\prime \rightarrow E) \cdot \left( J_x \hat{\Omega}_x + J_y \hat{\Omega}_y + J_z \hat{\Omega}_z \right) \cdot
\begin{bmatrix}
 \hat{\Omega}_x \\ \hat{\Omega}_y \\ \hat{\Omega}_z
\end{bmatrix}
\, dE^\prime \right\}  \, d\omegaversor \\
&= \frac{3}{4\pi} \bigintsss_{4\pi}
\left\{ \int_0^\infty \Sigma_{s_1}(\vec{x},E^\prime \rightarrow E) \cdot
\begin{bmatrix}
 J_x \hat{\Omega}_x \hat{\Omega}_x +  J_y \hat{\Omega}_y \hat{\Omega}_x +  J_z \hat{\Omega}_z \hat{\Omega}_x \\
 J_x \hat{\Omega}_x \hat{\Omega}_y +  J_y \hat{\Omega}_y \hat{\Omega}_y +  J_z \hat{\Omega}_z \hat{\Omega}_y \\
 J_x \hat{\Omega}_x \hat{\Omega}_z +  J_y \hat{\Omega}_y \hat{\Omega}_z +  J_z \hat{\Omega}_z \hat{\Omega}_z
\end{bmatrix}
\, dE^\prime \right\}  \, d\omegaversor
\end{aligned}
$$

Teniendo además en cuenta el @thm-omega-i-j, el término de [scattering]{lang=en-US} toma la inocua forma de

$$
 \int_0^\infty \Sigma_{s_1}(\vec{x},E^\prime \rightarrow E) \cdot \vec{J}(\vec{x}, E^\prime,t) \, dE^\prime
$${#eq-difusion4}

#### Fisiones

El siguiente es el término de fisiones, cuya integral se anula.
En efecto,

$$
\bigintsss_{4\pi} \left( \frac{\chi(E)}{4\pi} \int_{0}^{\infty} \nu\Sigma_f(\vec{x}, E^\prime) \cdot \phi(\vec{x}, E^\prime, t) \, dE^\prime  \cdot  \omegaversor \right) \, d\omegaversor = 0
$$ {#eq-difusion5}
ya que el integrando es el producto de una factor que no depende del ángulo por el versor ${\omegaversor}$.
En forma equivalente, estamos evaluando el momento de orden $\ell=1$ de una fuente de fisión.
Dado que ésta es isotrópica, el único momento diferente de cero es el de orden $\ell=0$.

#### Fuentes independientes

El término de fuentes independientes es igual a un vector cuyas componentes son los tres coeficientes correspondientes a $\ell=1$ en la expansión en armónicos esféricos sobre el ángulo $\omegaversor$ de la fuente $s$:

$$\begin{aligned}
\int_{4\pi} s(\vec{x}, \omegaversor, E, t)  \cdot  \omegaversor \, d\omegaversor
& =
\sqrt{\frac{3}{4\pi}} \cdot 
\begin{bmatrix}
s_1^{+1}(\vec{x},E,t) \\
s_1^{-1}(\vec{x},E,t) \\
s_1^{0}(\vec{x},E,t) \\
\end{bmatrix} \\
& =
\sqrt{\frac{3}{4\pi}} \cdot \vec{s}_1(\vec{x},E,t)
\end{aligned}
$$ {#eq-difusion6}

Si las fuentes independientes son isotrópicas en el marco de referencia del reactor, los tres coeficientes son cero y la integral es nula.

### Ley de Fick

Estamos entonces en condiciones de volver a reunir los seis términos de la @eq-difusionporomega que analizamos por separado en las ecuaciones

 * [-@eq-difusion1] (derivada temporal),
 * [-@eq-difusion2] (advección),
 * [-@eq-difusion3] (absorciones totales),
 * [-@eq-difusion4] (scattering),
 * [-@eq-difusion5] (fisiones), y
 * [-@eq-difusion6] (fuentes)

y concluir que al multiplicar la @eq-orden1 por $\omegaversor$ e integrar en todas las
posibles direcciones, obtenemos

$$
\begin{gathered}
\frac{1}{v(E)} \frac{\partial \vec{J}}{\partial t} + 
\frac{1}{3} \cdot \text{grad} \big[ \phi(\vec{x}, E,t ) \big] +
\Sigma_t(\vec{x}, E) \cdot \vec{J}(\vec{x}, E, t)
= \\
\int_0^\infty \Sigma_{s_1}(\vec{x},E^\prime \rightarrow E) \cdot \vec{J}(\vec{x}, E^\prime,t) \, dE^\prime +
\sqrt{\frac{3}{4\pi}} \cdot \vec{s}_1(\vec{x},E,t)
\end{gathered}
$${#eq-fick1}

Para arribar finalmente a la ecuación de difusión necesitamos tres nuevas suposiciones:

 i. Que
    
    a. el problema sea estacionario, o
    
    b. que
 
    $$
    \frac{3}{v}  \frac{\partial \vec{J}}{\partial t} \ll \text{grad} \left[ \phi(\vec{x}, E,t ) \right]
    $$

 ii. Que
 
     a. no haya fuentes independientes, o
     
     b. que la fuente independiente sea isotrópica de forma tal que los tres coeficientes\ $s_\ell^m$ de la\ @eq-difusion5 sean iguales a cero.

 iii. Que
 
      a. el scattering sea isotrópico (en el marco de referencia del reactor), o
      b. que 

         $$
         \int_0^\infty \Sigma_{s_1}(\vec{x}, E^\prime \rightarrow E) \cdot \vec{J}(\vec{x}, E^\prime, t) \, dE^\prime
         \simeq
         \int_0^\infty \Sigma_{s_1}(\vec{x}, E \rightarrow E^\prime) \cdot \vec{J}(\vec{x}, E, t) \, dE^\prime
         $$ {#eq-suposicionscattering}

         El miembro izquierdo representa el in-[scattering]{lang=en-US} de neutrones de todas las energías mientras que el miembro derecho es el     out-[scattering]{lang=en-US} de neutrones de energía $E$ hacia todas las otras energías $E^\prime$.
         Si la absorción es pequeña, estas dos expresiones se deberían balancear aproximadamente.


Si al menos una de las dos condiciones a ó b de cada una de las tres suposiciones i, ii y iii son ciertas (o razonables), entonces volviendo a la @eq-fick1, tenemos 

$$
\begin{aligned}
\frac{1}{3}  \cdot \text{grad} \left[ \phi(\vec{x}, E,t ) \right] +
\Sigma_t(\vec{x}, E) \cdot \vec{J}(\vec{x}, E, t)
& \simeq
\int_0^\infty \Sigma_{s_1}(\vec{x}, E \rightarrow E^\prime) \cdot \vec{J}(\vec{x}, E, t) \, dE^\prime  \\
& \simeq
\int_0^\infty \Sigma_{s_1}(\vec{x}, E \rightarrow E^\prime) \, dE^\prime \cdot \vec{J}(\vec{x}, E, t)  \\
& \simeq
\mu_0(\vec{x}, E) \int_0^\infty \Sigma_{s_0}(\vec{x}, E \rightarrow E^\prime) \, dE^\prime \cdot \vec{J}(\vec{x}, E, t)  \\
& \simeq
\mu_0(\vec{x}, E) \cdot \Sigma_{s_t}(\vec{x}, E) \cdot \vec{J}(\vec{x}, E, t)
\end{aligned}
$$
donde en los últimos dos pasos hemos utilizado la @def-coseno-medio y la sección eficaz *total* de [scattering]{lang=en-US} $\Sigma_s(\vec{x}, E)$ de la @eq-sigmast evaluada en función del coeficiente $\Sigma_{s_0}$ según la @eq-sigmastys0.
Con esta expresión podemos relacionar el vector corriente $\vec{J}$ con el gradiente del flujo escalar $\phi$ como

$$\vec{J}(\vec{x}, E, t) = -\frac{1}{3 \left[ \Sigma_t(\vec{x}, E) - \mu_0(\vec{x}, E) \cdot \Sigma_{s_t}(\vec{x},E) \right] } \cdot \text{grad} \left[ \phi(\vec{x}, E,t ) \right]$$

::: {#def-D}
El *coeficiente de difusión* $D$ definido como

$$
D(\vec{x}, E) = \frac{1}{3 \left[ \Sigma_t(\vec{x}, E) - \mu_0(\vec{x}, E) \cdot \Sigma_{s_t}(\vec{x},E) \right]}
$$ {#eq-D}
es tal que, si

 #. el flujo angular es linealmente anisotrópico $\psi \simeq (\phi + 3\vec{J})/4\pi$
 #. el problema es estacionario o $3/v  \cdot \partial \vec{J}/\partial t \ll \nabla \phi$
 #. no hay fuentes independientes o éstas son isotrópicas
 #. el scattering es isotrópico o el in-[scattering]{lang=en-US} es similar al out-[scattering]{lang=en-US} $\int \Sigma_{s_1}(E^\prime \rightarrow E) \cdot \vec{J}(E^\prime) \, dE^\prime \simeq  \int \Sigma_{s_1}(E \rightarrow E^\prime) \cdot \vec{J}(E) \, dE^\prime$
 
entonces se cumple la *Ley de Fick*

$$
 \vec{J}(\vec{x}, E, t) \simeq - D(\vec{x}, E) \cdot \text{grad} \left[ \phi(\vec{x}, E, t) \right]
$$ {#eq-fick}
según la cual el vector corriente $\vec{J}$ es proporcional a menos el gradiente del flujo escalar $\phi$ a través de un coeficiente de difusión $D$ dado por la\ @eq-D.

:::

::: {.remark}
La ley de Fick refleja, en forma aproximada, la conservación del momento de orden uno del flujo angular\ $\psi$ con respecto a todas las direcciones de vuelo $\omegaversor$.
:::

::: {.remark}
Dado que las secciones eficaces macroscópicas tienen unidades de inversa de longitud (@def-sigmat), el coeficiente de difusión $D$ tiene unidades de longitud.
:::

### La ecuación de difusión

Podemos combinar los dos resultados de la conservación de momentos de orden cero y uno desarrollados en las secciones anteriores teniendo en cuenta las expresiones dadas por las ecuaciones

 * [-@eq-conservacion] (conservación),
 * [-@eq-Qs] (scattering),
 * [-@eq-Qf] (fisión),
 * [-@eq-S] (fuentes), y
 * [-@eq-fick] (ley de Fick)

para obtener finalmente la celebrada *ecuación de difusión de neutrones*

$$
\begin{gathered}
 \sqrt{\frac{m}{2E}} \frac{\partial}{\partial t} \Big[ \phi(\vec{x}, E, t) \Big]
 - \text{div} \Big[ D(\vec{x}, E) \cdot \text{grad} \left[ \phi(\vec{x}, E, t) \right] \Big]
 + \Sigma_t(\vec{x}, E) \cdot \phi(\vec{x}, E, t)
 = \\
\int_{0}^{\infty} \Sigma_{s_0}(\vec{x}, E^{\prime} \rightarrow E)  \cdot \phi(\vec{x}, E^\prime, t) \, dE^\prime +
\chi(E) \int_{0}^{\infty} \nu\Sigma_f(\vec{x}, E^\prime) \cdot \phi(\vec{x}, E^\prime, t) \, dE^\prime
+ s_0(\vec{x}, E, t)
\end{gathered}
$${#eq-difusion}
que es una ecuación integro-diferencial elíptica en derivadas parciales de segundo orden sobre el espacio (los operadores divergencia y gradiente operan sólo sobre las coordenadas espaciales), y de primer orden sobre el tiempo para la incógnita $\phi$ definida sobre

 1. el espacio $\vec{x}$,
 3. la energía $E$, y
 4. el tiempo $t$.

::: {.remark}
La incógnita de la ecuación de difusión es el fujo escalar\ $\phi$ que no depende de\ $\omegaversor$.
:::

Los datos de entrada para la ecuación de difusión de neutrones son:

 * Las secciones eficaces $\Sigma_t$ y $\nu\Sigma_f$ como función del espacio $\vec{x}$ y de la energía $E$.
 * El espectro de fisión $\chi$ en función de la energía $E$.
 * El coeficiente de difusión\ $D$ como función del espacio $\vec{x}$ y de la energía $E$.
 * La fuente independiente de neutrones $s$, que debe ser isotrópica.
 * El parámetro constante $m$, que es la masa en reposo del neutrón.

::: {.remark}
En estado estacionario, la ecuación de difusión de neutrones es

$$
\begin{gathered}
 - \text{div} \Big[ D(\vec{x}, E) \cdot \text{grad} \left[ \phi(\vec{x}, E) \right] \Big]
 + \Sigma_t(\vec{x}, E) \cdot \phi(\vec{x}, E)
 = \\
\int_{0}^{\infty} \Sigma_{s_0}(\vec{x}, E^{\prime} \rightarrow E)  \cdot \phi(\vec{x}, E^\prime) \, dE^\prime +
\chi(E) \int_{0}^{\infty} \nu\Sigma_f(\vec{x}, E^\prime) \cdot \phi(\vec{x}, E^\prime) \, dE^\prime
+ s_0(\vec{x}, E)
\end{gathered}
$${#eq-difusion-ss}
:::


### Condiciones de contorno {#sec-bcdifusion}

La ecuación de difusión es elíptica sobre las coordenadas espaciales por lo que debemos especificar, además de las condiciones iniciales
apropiadas en el caso transitorio, condiciones de contorno en toda la frontera $\partial U$ del dominio espacial.
Para el caso de una ecuación elíptica, éstas pueden ser de tipo

 a. Dirichlet donde especificamos el valor del flujo escalar $\phi$ en $\Gamma_D \subset \partial U$; o
 b. Neumann donde fijamos el valor de la derivada normal $\partial \phi/\partial n$ en $\Gamma_N \subset \partial U$; o
 c. Robin donde damos una combinación lineal del flujo y de la derivada normal en $\Gamma_R \subset \partial U$.

::: {.remark}
 Debe cumplirse que $\Gamma_D \cap \Gamma_N \cap \Gamma_R = \emptyset$ y que $\Gamma_D \cup \Gamma_N \cup \Gamma_R = \partial U$.
:::

Dada una superficie diferencial $dA$ cuya normal exterior es $\hat{\vec{n}}$,
la tasa de neutrones entrante por unidad de área a través de dicha superficie $dA$ está dada por la @eq-jnegativa de la @def-corriente:

$$\tag{\ref{eq-jnegativa}}
\ J_n^-(\vec{x},E,t) = \int_{\omegaversor \cdot \hat{\vec{n}} < 0} \psi(\vec{x}, \omegaversor, E, t) \left(\omegaversor \cdot \hat{\vec{n}}\right) d\omegaversor
$$

Despreciando los términos para $\ell \geq 2$ de la expansión de la @eq-psi1 podemos estimar esta corriente como

$$
\begin{aligned}
J_n^-(\vec{x},E,t) & \simeq \int_{\omegaversor \cdot \hat{\vec{n}} < 0} \frac{1}{4\pi} \left [ \phi(\vec{x}, E, t) + 3 \, \vec{J}(\vec{x}, E, t) \cdot \omegaversor \right] \cdot \left(\omegaversor \cdot \hat{\vec{n}}\right) d\omegaversor
\\
& \simeq \frac{1}{4\pi} \phi(\vec{x}, E, t) \int_{0}^{-1} \mu^\prime \cdot 2\pi\, d\mu^\prime + 
\frac{3}{4\pi}  \int_{\omegaversor \cdot \hat{\vec{n}} < 0} \Big[ \vec{J}(\vec{x}, E, t) \cdot \omegaversor \Big] \cdot \left(\omegaversor \cdot \hat{\vec{n}}\right) d\omegaversor \\
& \simeq \frac{1}{4\pi} \phi(\vec{x}, E, t) \cdot 2\pi \cdot \frac{1}{2} + \frac{3}{4\pi} \cdot \Big[ \vec{J}(\vec{x}, E, t) \cdot \hat{\vec{n}} \Big] \cdot \left(- \frac{2}{3} \pi \right)  \\
& \simeq \frac{1}{4} \phi(\vec{x}, E, t) - \frac{1}{2} \Big[ \vec{J}(\vec{x}, E, t) \cdot \hat{\vec{n}} \Big]
\end{aligned}
$$
donde hemos usado el @thm-omega-i-j sobre una semi-esfera unitaria para resolver la segunda integral del miembro derecho.
A la luz de la ley de Fick dada por la @def-D, podemos escribir

$$
\begin{aligned}
J_n^-(\vec{x},E,t) & \simeq \frac{1}{4} \cdot \phi(\vec{x}, E, t) + \frac{1}{2} \cdot D(\vec{x}, E) \cdot \left\{ \text{grad} \big[ \phi(\vec{x}, E, t)\big]  \cdot \hat{\vec{n}} \right\} \\
& \simeq \frac{\phi(\vec{x}, E, t)}{4}  + \frac{D(\vec{x}, E)}{2}  \cdot \frac{\partial \phi}{\partial n}
\end{aligned}$$ lo que nos da una expresión para definir la condición de contorno de vacío para la ecuación de difusión.

::: {#def-ccvacuum-dif}
En forma análoga a la @def-ccvacuum, llamamos *condición de contorno de vacío* a la situación en la cual la corriente entrante a través de una porción de la frontera $\partial U$ es cero, con lo que se debe cumplir:

$$
\phi(\vec{x}, E, t)  + 2 \cdot D(\vec{x}, E) \cdot \frac{\partial \phi}{\partial n} = 0 \quad\quad \forall \vec{x} \in \Gamma_V \subset \partial U
$$

Definimos el conjunto $\Gamma_V \subset \partial U$ como el lugar geométrico de todos los puntos $\vec{x} \in \partial U$ donde imponemos esta
condición de contorno. Esta condición es de tipo Robin ya que se da el valor de una combinación lineal de la incógnita $\phi$ y de su derivada
normal $\partial \phi/\partial n$.
:::

::: {#def-ccmirror-dif}
En forma análoga a la @def-ccmirror, llamamos *condición de contorno de reflexión o de simetría* cuando la corriente neta entrante en el
punto $\vec{x} \in \partial U$ es igual a cero.
En este caso, por la ley de Fick debe anularse la derivada normal del flujo escalar evaluada en $\vec{x}$:

$$
\text{grad} \big[ \phi(\vec{x}, E, t)\big]  \cdot \hat{\vec{n}} = \frac{\partial \phi}{\partial n} = 0
\quad\quad \forall \vec{x} \in \Gamma_M \subset \partial U
$$

Esta es una condición de tipo Neumann homogénea.
Definimos el conjunto $\Gamma_M \subset U$ como el lugar geométrico de todos los puntos $\vec{x} \in \partial U$ donde imponemos esta condición de contorno.
:::

Para el problema de difusión, a veces se suele utilizar una tercera condición de contorno basada en la idea que sigue.
Si extrapolamos linealmente el flujo escalar $\phi$ una distancia $\zeta$ (que depende de la posición $\vec{x}$ y de la energía $E$) en la dirección de la normal externa $\hat{\vec{n}}$ en la frontera $\partial U$ mediante una expansión de Taylor a primer orden, tenemos

$$
\phi \big(\vec{x} + \zeta(\vec{x}, E) \cdot \hat{\vec{n}}, E, t \big) \Big|_{\vec{x} \in \partial U} \approx \phi(\vec{x}, E, t) + \frac{\partial \phi}{\partial n} \cdot \zeta(\vec{x}, E)
$$

Si se cumple la condición de contorno de vacío dada por la @def-ccvacuum-dif

$$
\phi(\vec{x}, E, t)  + 2 \cdot D(\vec{x}, E) \cdot \frac{\partial \phi}{\partial n} = 0
$$
entonces el flujo escalar extrapolado se anula en el punto

$$
\vec{x}^* = \vec{x} + 2 \cdot D(\vec{x}, E) \cdot \hat{\vec{n}}
$$
como ilustramos en la @fig-cc.

![El flujo escalar $\phi(\vec{x}, E,t)$ extrapolado linealmente se anula a una distancia $\zeta(\vec{x},E)= 2D(\vec{x},E)$ en una condición de contorno tipo vacío de la ecuación de difusión.](cc){#fig-cc}


Si el valor numérico del coeficiente de difusión $D(\vec{x}, E)$ (que tiene unidades de longitud) es mucho menor que el tamaño característico del dominio $U$ entonces podemos aproximar $\zeta \approx 0$.

::: {#def-cc-nulldif}
Llamamos *condición de contorno de flujo nulo* cuando el flujo escalar $\phi$ se anula un punto $\vec{x} \in \partial U$:

$$
\phi(\vec{x}, E, t) = 0 \quad\quad \forall \vec{x} \in \Gamma_N \subset \partial U
$$

Definimos el conjunto $\Gamma_N \subset \partial U$ como el lugar geométrico de todos los puntos $\vec{x} \in \partial U$ donde imponemos esta condición de contorno. Matemáticamente esta condición es de tipo Dirichlet homogénea.
:::




## Esquema de solución multi-escala {#sec-multiescala}

La ecuación de transporte @eq-transporte describe completamente la interacción de neutrones con la materia y es exacta mientras
 
 a. la población neutrónica sea lo suficientemente grande como para que podamos asumir que el flujo angular $\psi$ es determinista, y
 a. se cumplan las siete suposiciones listadas al comienzo del capítulo` (página~\pageref{siete})`{=latex}.

Los coeficientes tanto de la ecuación de transporte como de la ecuación de difusión son las secciones eficaces macroscópicas de los materiales presentes en el dominio $U$, que en principio son el producto de la sección eficaz microscópica por la densidad volumétrica de cada uno de los isótopos que component dichos materiales.

Un neutrón nacido por fisión tiene una energía de aproximadamente 2 MeV, y cuando llega al equilibrio térmico con el medio puede alcanzar una energía de 0.02 eV. Esto es, la variable independiente $E$ usualmente abarca ocho órdenes de magnitud.
Recordando la @fig-sigmas, las secciones eficaces microscópicas pueden cambiar cinco o incluso seis órdenes de magnitude en este rango de energías, abarcando resonancias extremadamente difíciles de modelar matemáticamente.

Estas variaciones hace que sea prácticamente imposible resolver directamente la ecuación de transporte para obtener la dependencia del flujo angular $\psi$ con el espacio, la dirección, la energía y eventualmente el tiempo sobre el dominio $U$ a partir de las secciones eficaces microscópicas y de las concentraciones volumétricas de los isótopos.
En la práctica se recurre a un esquema multi-escala, donde primero se evalúan y procesan las secciones eficaces microscópicas experimentales. Luego se evalúan celdas típicas de los componentes de los reactores nucleares (elementos combustibles, barras de control, etc.) para obtener secciones eficaces condensadas que finalmente son los coeficientes de la ecuación de transporte (o difusión) utilizada para realizar un cálculo a nivel de núcleo.^[En el sentido del inglés [*core*]{lang=en-US}.]
 

### Evaluación y procesamiento de secciones eficaces {#sec-evaluacionxs}

Este nivel de cálculo es el punto central del trabajo de doctorado de la referencia @nacho.
A partir de mediciones experimentales, los datos se procesan de forma tal de que puedan ser evaluados y utilizados como bibliotecas de secciones eficaces microscópicas con las cuales realizar cálculos a nivel de celda.


### Cálculo a nivel celda {#sec-celda}

Este nivel de cálculo es el punto central del trabajo de doctorado de la referencia @chaco.
A partir de biblioctecas de secciones eficaces microscópica se procede a realizar cálculos de transporte de forma tal de calcular secciones eficaces macroscópicas a pocos grupos de energía que puedan ser usadas como los coeficientes de las ecuaciones de transporte utilizadas en el cálculo a nivel de núcleo.

### Cálculo a nivel núcleo

Este nivel de cálculo es el punto central de esta tesis, especialmente en el @sec-esquemas y en el @sec-resultados.
Las secciones eficaces macroscópicas que son los coeficientes de las ecuaciones de ordenadas discretas y difusión de neutrones multigrupo se suponene funciones conocidas del espacio.


# Esquemas de discretización numérica {#sec-esquemas}


::::: {lang=en-US}
::: {.chapterquote data-latex=""}
> | Para una inteligencia que conociera en un momento dado
> | todas las fuerzas que actúan en la naturaleza y la situación de
> | los seres de que se compone [...] nada le sería incierto y
> | tanto el futuro como el pasado estarían presentes ante su vista.
> |
> | _Pierre de Simon Laplace, Teoría Analítica de las Probabilidades, 1812_
:::
:::::

En el capitulo anterior hemos arribado a formulaciones matemáticas que modelan los procesos físicos de transporte y difusión de neutrones en estado estacionario mediante ecuaciones integro-diferenciales.
Bajo las suposiciones que explicitamos al comienzo del @sec-transporte-difusion y asumiendo que las secciones eficaces macroscópicas son funciones del espacio y de la energía conocidas, estas ecuaciones son _exactas_.
Para la ecuación de difusión, que es de segundo orden pero más sencilla de resolver, llegamos a

$$ \tag{\ref{eq-difusion-ss}}
\begin{gathered}
 - \text{div} \Big[ D(\vec{x}, E) \cdot \text{grad} \left[ \phi(\vec{x}, E) \right] \Big]
 + \Sigma_t(\vec{x}, E) \cdot \phi(\vec{x}, E)
 = \\
\int_{0}^{\infty} \Sigma_{s_0}(\vec{x}, E^{\prime} \rightarrow E)  \cdot \phi(\vec{x}, E^\prime) \, dE^\prime +
\chi(E) \int_{0}^{\infty} \nu\Sigma_f(\vec{x}, E^\prime) \cdot \phi(\vec{x}, E^\prime) \, dE^\prime
+ s_0(\vec{x}, E)
\end{gathered}
$$


y para la ligeramente más compleja ecuación de transporte linealmente anisotrópica obtuvimos

$$ \tag{\ref{eq-transporte-linealmente-anisotropica}}
\begin{gathered}
 \omegaversor \cdot \text{grad} \left[ \psi(\vec{x}, \omegaversor, E) \right]
 + \Sigma_t(\vec{x}, E) \cdot \psi(\vec{x}, \omegaversor, E) = \\
\frac{1}{4\pi} \cdot 
\int_{0}^{\infty} \Sigma_{s_0}(\vec{x}, E^{\prime} \rightarrow E) \cdot \int_{4\pi} \psi(\vec{x}, \omegaprimaversor, E^{\prime}) \, d\omegaprimaversor \, dE^\prime + \\
\frac{3 \cdot \omegaversor}{4\pi} \cdot
\int_{0}^{\infty} \Sigma_{s_1}(\vec{x}, E^{\prime} \rightarrow E) \cdot \int_{4\pi} \psi(\vec{x}, \omegaprimaversor, E^{\prime}) \cdot \omegaprimaversor \, d\omegaprimaversor \, dE^\prime  \\
+ \frac{\chi(E)}{4\pi} \int_{0}^{\infty} \nu\Sigma_f(\vec{x}, E^\prime) \cdot \int_{4\pi} \psi(\vec{x}, \omegaprimaversor, E^{\prime}) \, d\omegaprimaversor \, dE^\prime 
+ s(\vec{x}, \omegaversor, E)
\end{gathered}
$$ 

sobre un espacio de fases generado^[Del ingés [*spanned*]{lang=en-US}.] por seis escalares independientes:

 * tres para el espacio $\vec{x}$,
 * dos para la dirección $\omegaversor$ y
 * uno para la energía $E$.

 
El objetivo de este capítulo es transformar estas dos ecuaciones diferenciales en derivadas parciales en sistemas de ecuaciones algebraicas de tamaño finito de forma tal que las podamos resolver con una herramienta computacional, cuya implementación describimos en el @sec-implementacion.
Este proceso involucra inherentemente aproximaciones relacionadas a la discretización de la energía\ $E$, la dirección\ $\omegaversor$ y el espacio\ $\vec{x}$, por lo que las soluciones a las ecuaciones diferenciales que podamos encontrar numéricamente serán solamente aproximaciones a las soluciones matemáticas reales.
Según discutimos en la @sec-metodos-numericos, estas aproximaciones serán mejores a medida que aumentemos la cantidad de entidades discretas. Pero al mismo tiempo aumentan los recursos y costos de ingeniería asociados.

Comenzamos primero entonces introduciendo algunas propiedades matemáticas de los métodos numéricos y discutiendo cuestiones a tener en cuenta para analizarlos desde el punto de vista del gerenciamiento de proyectos de ingeniería.
Pasamos luego a la discretización de las ecuaciones propiamente dicha.
Primeramente discretizamos la dependencia en energía aplicando la idea de grupos discretos de energías para obtener las llamadas “ecuaciones multigrupo”.
Continuamos luego por la dependencia angular de la ecuación de transporte aplicando el método de ordenadas discretas S$_N$.
Esencialmente la idea es transformar las integrales sobre $E^\prime$ y sobre $\omegaprimaversor$ en las dos ecuaciones [-@eq-difusion-ss] y [-eq-transporte-linealmente-anisotropica] del principio del capítulo por sumatorias finitas.

El grueso del capítulo lo dedicamos a la discretización espacial de ambas ecuaciones, que es el aporte principal de esta tesis al problema de la resolución de las ecuaciones de transporte de neutrones a nivel de núcleo utilizando mallas no estructuradas y técnicas de descomposición de dominio para permitir la resolución de problemas de tamaño arbitrario.
En la referencia @monografia se muestra, para la ecuación de difusión, una derivación similar a la formulación propuesta en esta tesis basada en elementos finitos. Pero también se incluye una formulación espacial basada en volúmenes finitos. Por cuestiones de longitud, hemos decidido enfocarnos solamente en elementos finitos en esta tesis.
Dejamos la extensión a volúmenes finitos y su comparación con otros esquemas como trabajos futuros.

Finalmente analizamos la forma matricial/vectorial de los tres casos de problemas de estado estacionario que resolvemos en esta tesis según el medio se multiplicativo o no y según haya fuentes externas o no.


## Métodos numéricos {#sec-metodos-numericos}
 
En forma general, las ecuaciones [-@eq-difusion-ss] y [-@eq-transporte-linealmente-anisotropica] que derivamos en el capítulo anterior a partir de primeros principios están expresadas en una formulación fuerte y exacta

$$
\mathcal{F}(\varphi, \Sigma) = 0
$$
denotando con
  
 * $\varphi$ el flujo incógnita ($\psi$ o $\phi$) “exacto”^[En el sentido matemático de satisfacer exactamente la ecuación diferencial. El análisis de la exactitud física queda fuera del alcance de esta tesis.] que depende continuamente de $\vec{x}$, $E$ y $\omegaversor$,
 * $\Sigma$ todos los datos de entrada, incluyendo el dominio espacial continuo $U$ y las secciones eficaces con sus dependencias continuas de $\vec{x}$, $E$ y $\omegaversor$,
 * $\mathcal{F}$ un operador integral sobre $E^\prime$ y $\omegaprimaversor$ y diferencial sobre $\vec{x}$
 
Esencialmente, en este capítulo aplicamos métodos numéricos @quarteroni para obtener una formulación débil y aproximada

$$
\mathcal{F}_N(\varphi_N, \Sigma_N) = 0
$$ {#eq-generica-numerica}
donde ahora

 * $\varphi_N$ es una aproximación discreta de tamaño $N$ del flujo incógnita,
 * $\Sigma_N$ es una aproximación de los datos de entrada, incluyendo una discretización $U_N$ del dominio espacial
 * $\mathcal{F}_N$ es un operador discreto de tamaño $N$
 
El tamaño $N$ del operador discreto $\mathcal{F}_N$ es el producto de

 a. la cantidad $G$ de grupos de energías (@sec-multigrupo),
 b. la cantidad $M$ de direcciones de vuelo discretas (@sec-sn), y
 c. la cantidad $J$ de incógnitas espaciales (@sec-discretizacion_espacial).
 

::: {#def-convergencia}
## Convergencia

Un método numérico es _convergente_ si

$$
\lim_{N\rightarrow \infty} || \varphi - \varphi_N || = 0
$$
para alguna norma apropiada $||\cdot||$.
Por ejemplo, para la norma\ $L_2$:

$$
\lim_{N\rightarrow \infty} \sqrt{\int_U \int_{4\pi} \int_{0}^{\infty} 
\left[ \varphi(\vec{x},\omegaversor,E) - \varphi_N(\vec{x},\omegaversor,E) \right]^2
\, dE \, d\omegaversor \, d^3\vec{x} }  = 0
$$
:::

La convergencia y, más aún, el orden con el cual el error\ $|| \varphi - \varphi_N ||$ converge a cero es importante al verificar la implementación computacional de un método numérico. Tanto es así que para que una herramienta computacional sea verificada en el sentido de “verificación y validación” de software, no sólo se tiene que mostrar que $\lim_{N\rightarrow \infty} || \varphi - \varphi_N || = 0$ sino que la tasa de disminución de este error con $1/N$ tiene que coincidir con el orden del método numérico (ver\ @sec-mms).
De todas maneras, demostrar que un método numérico genérico es convergente no es sencillo y ni siquiera posible en la mayoría de los casos.
En forma equivalente, se prueban los conceptos de consistencia y estabilidad definidos a continuación y luego se utiliza el teorema de equivalencia.

::: {#def-consistencia}
## Consistencia

Un método numérico es _consistente_ si

$$
\lim_{N\rightarrow \infty} \mathcal{F}_N(\varphi, \Sigma) =
\lim_{N\rightarrow \infty} \left[ \mathcal{F}_N(\varphi, \Sigma) - \mathcal{F}(\varphi, \Sigma) \right] = 0
$$

Es decir, si el operador discreto $\mathcal{F}_N$ tiende al operador continuo $\mathcal{F}$ para $N\rightarrow \infty$.
Más aún, si

$$
\mathcal{F}_N(\varphi, \Sigma) =
\left[ \mathcal{F}_N(\varphi, \Sigma) - \mathcal{F}(\varphi, \Sigma) \right] = 0 \quad \forall N \geq 1
$$
entonces decimos que el método numérico es _fuertemente_^[Del inglés [*strongly*]{lang=en-US}.] o _completamente_^[Del inglés [*fully*]{lang=en-US}.] consistente.
:::


::: {#def-estabilidad}
## Estabilidad

Un método numérico es _estable_ si dada una perturbación pequeña $\delta \Sigma_N$ en los datos de entrada tal que

$$
\mathcal{F}_N(\varphi_N + \delta \varphi_N, \Sigma_N + \delta \Sigma_N) = 0
$$
entonces la perturbación $\delta \varphi_N$ causada en la solución también es pequeña.
Formalmente, un método numérico es estable si

$$
\forall \epsilon > 0, \exists \delta(\epsilon) > 0 : \forall \delta \Sigma_N~/~ || \delta \Sigma_N || < \delta(\epsilon) \Rightarrow || \delta \varphi_N || < \epsilon \quad \forall N \geq 1
$$
:::

La consistencia es relativamente sencilla de demostrar. La estabilidad es un poco más compleja, pero posible.
Finalmente, la convergencia queda demostrada a partir del siguiente resultado.

::: {#thm-lax}
##  de equivalencia de Lax-Richtmyer

Si un método numérico es consistente, entonces es convergente si y sólo si es estable.
Más aún, cualesquiera dos propiedades implica la tercera.
:::





### Comparaciones y evaluaciones económicas

Suponiendo que disponemos de varios métodos numéricos que nos permitan calcular $\varphi_N$ a partir de un conjunto de datos de entrada $\Sigma_N$ sobre un cierto espacio de fases discretizado, cabría preguntarnos cuál es el más eficiente para resolver un cierto problema de ingeniería nuclear. Está claro que en este sentido, la eficiencia depende de

 1. la exactitud de la solución $\varphi_N$ obtenida
 2. los recursos computacionales necesarios para obtener $\varphi_N$, medidos en
 
     a. tiempo total de procesamiento (CPU, GPU y/o APU)
     b. tiempo de pared,^[En el sentido del inglés [*wall time*]{lang=en-US}.] que es igual al del punto a en serie pero debería ser menor en cálculos en paralelo,
     c. memoria RAM,
     d. necesidades de almacenamiento, etc.
    
 3. los recursos humanos necesarios para 
 
     a. preparar $\Sigma_N$ (pre-procesar),
     b. analizar $\varphi_N$ (post-procesar), y
     c. llegar a conclusiones útiles.
     
    
     
Si bien con esta taxonomía parecería que comparar métodos numéricos no debería ser muy difícil, hay detalles que deben ser tenidos en cuenta y que de hecho complican la evaluación.
Por ejemplo, dado un cierto problema de análisis de reactores a nivel de núcleo, el punto 1 incluye las siguiente preguntas:

 * ¿Es necesario resolver la ecuación de transporte o la ecuación de difusión es suficiente?
 * ¿Cuántas direcciones discretas hay que tener en cuenta para obtener una exactitud apropiada?
 
Por otro lado, el punto 2 abarca cuestiones como

 * ¿Es más eficiente discretizar el espacio con una formulación precisa como Galerkin que da lugar a matrices no simétricas usando pocos grados de libertad o conviene utilizar una formulación menos precisa como cuadrados mínimos que da lugar a matrices simétricas pero empleando más incógnitas espaciales?
 * ¿Es preferible usar métodos directos que son robustos pero poco escalables o métodos iterativos que son escalables pero sensibles a perturbaciones?

La determinación del valor de $N$ necesario para contar con una cierta exactitud apropiada para cada método numérico no es trivial e involucra estudios paramétricos para obtener $\varphi_N$ vs. $N$. Este proceso puede necesitar barrer valores de $N$ suficientemente grandes para los cuales haya discontinuidades en la evaluación. Por ejemplo, si se debe pasar de una sola computadora a más de una por limitaciones de recursos (usualmente memoria RAM) o si se debe pasar de una infra-estructura *on-premise* a una basada en la nube en un eventual caso donde se necesiten más nodos ([*hosts*]{lang=en-US}) de cálculo que los disponibles.
 
Finalmente, como en cualquier evaluación técnico-económica, intervienen situaciones particulares más blandas relacionadas al gerenciamiento de proyectos y a la tensión de los tres vértices del triángulo alcance-costos-tiempo, como por ejemplo:

 * ¿Se necesitan resultados precisos (caros y lentos) o resultados aproximados (baratos y rápidos) son suficientes?
 * ¿Se prioriza disminuir los costos (como en la mayoría de los proyectos de ingeniería) o se prioriza tener resultados en poco tiempo (e.g. Proyecto Manhattan @making)?
 * ¿Cómo dependen los tiempos y los costos de la infra-estructura de los recursos computacionales? 
   - Si es *on-premise*:
     * amortización de hardware
     * mantenimiento de hardware
     * licencias de software
     * administración de software
     * energía eléctrica
   - Si es *cloud*: 
     * alquiler de instancias
     * suscripciones a servicios
     * orquestación
 * ¿Cómo son los costos asociados a la capacitación de los ingenieros que tienen que obtener $\varphi$ con cada método numérico?

Está claro que el análisis de todas estas combinaciones están fuera del alcance de esta tesis.
De todas maneras, la herramienta computacional cuya implementación describimos en detalle en el @sec-implementacion permite evaluar todos estos aspectos y muchos otros ya que, en forma resumida

 1. Está diseñado para ser ejecutado nativamente en la nube.^[Del inglés [*cloud native*]{lang=en-US} como contrapartida a  [*cloud friendly*]{lang=en-US} o [*cloud enabled*]{lang=en-US}.]
 2. Permite discretizar el dominio espacial utilizando mallas no estructuradas.^[Del inglés [*unstructured grids*]{lang=en-US}.]
 3. Puede correr en paralelo en una cantidad arbitraria de computadoras.^[Del inglés [*hosts*]{lang=en-US}.]

En particular, permite a los ingenieros nucleares comparar las soluciones obtenidas con las formulaciones $S_N$ de difusión al resolver un mismo problema de tamaño arbitrario.
De esta forma, es posible justificar ante gerencias superiores o entes regulatorios la factibilidad (o no) de encarar un proyecto para analizar un reactor nuclear con la ecuación de difusión utilizando

 a. datos objetivos, y
 b. juicio de ingeniería.






## Discretización en energía {#sec-multigrupo}

Vamos a discretizar el dominio de la energía $E \in \mathbb{R}$ utilizando el concepto clásico de física de reactores de *grupos de energías*, que llevado a conceptos más generales de matemática discreta es equivalente a integrar sobre volúmenes (intervalos en $\mathbb{R}$) de control y utilizar el valor medio sobre cada volumen como el valor discretizado.

En efecto, tomemos el intervalo de energías $[0,E_0]$ donde $E_0$ es la mayor energía esperada de un neutrón individual.
Como ilustramos en la @fig-multigroup, dividamos dicho intervalo en $G$ grupos (volúmenes) no necesariamente iguales, cada uno definido por energías de corte $0=E_G < E_{G-1} < \dots < E_2 < E_1 < E_0$, de forma tal que el grupo $g$ es el intervalo $[E_g,E_{g-1}]$.

::: {.remark}
Con esta notación, el grupo número uno siempre es el de mayor energía.
A medida que un neutrón va perdiendo energía, va aumentando el número de su grupo de energía.
:::~

![Discretización del dominio energético en grupos (volúmenes) de energía. Tomamos la mayor energía esperada $E_0$ y dividimos el intervalo $[0,E_0]$ en $G$ grupos, no necesariamente iguales. El grupo uno es el de mayor energía.](multigroup-energy){#fig-multigroup width=95%}


::: {#def-psig}
El flujo angular $\psi_g$ del grupo $g$ es

$$
\psi_g(\vec{x}, \omegaversor) = \int_{E_g}^{E_{g-1}} \psi(\vec{x}, \omegaversor, E) \, dE
$$
:::

::: {#def-phig}
El flujo escalar $\phi_g$ del grupo $g$ es

$$
\phi_g(\vec{x}) = \int_{E_g}^{E_{g-1}} \phi(\vec{x}, E) \, dE
$$
:::

::: {#def-Jg}
El vector corriente $\vec{J}_g$  del grupo $g$ es

$$
\vec{J}_g(\vec{x}) =
\int_{E_g}^{E_{g-1}} \vec{J}(\vec{x},E) \, dE =
\int_{E_g}^{E_{g-1}} \int_{4\pi} \psi(\vec{x}, \omegaversor, E) \cdot \omegaversor \, d\omegaversor \, dE =
\int_{4\pi} \psi_g(\vec{x}, \omegaversor) \cdot \omegaversor \, d\omegaversor =
$$
:::


::: {.remark}
Los flujos $\psi(\vec{x}, \omegaversor, E)$ y $\psi_g(\vec{x}, \omegaversor)$ no tienen las mismas unidades.
La primera magnitud tiene unidades de inversa de área por inversa de ángulo sólido por inversa de energía por inversa de tiempo (por ejemplo $\text{cm}^{-2} \cdot \text{eV}^{-1} \cdot \text{s}^{-1}$), mientras que la segunda es un flujo integrado por lo que sus unidades son inversa de área por inversa de ángulo sólido por inversa de tiempo (por ejemplo $\text{cm}^{-2} \cdot \text{s}^{-1}$).
La misma idea aplica a $\phi(\vec{x}, E)$ y a $\phi_g(\vec{x})$.
:::

Los tres objetivos de discretizar la energía en $G$ grupos son

 1. transformar la dependencia continua del flujo angular $\psi(\vec{x}, \omegaversor, E)$ con la energía $E$ en $G$ funciones $\psi_g(\vec{x},\omegaversor)$ y del flujo escalar $\phi(\vec{x}, E)$ en $G$ funciones $\phi_g(\vec{x})$,
 2. reemplazar las integrales sobre la variable continua $E^\prime$ por sumatorias finitas sobre el índice $g^\prime$, y
 3. re-escribir las ecuaciones de difusión y transporte en función de los flujos de grupo ($\psi_g(\vec{x},\omegaversor)$ en transporte y $\phi_g(\vec{x})$ en difusión)
 
 
Para ilustrar la idea, prestemos atención al término de absorción total de la ecuación de transporte $\Sigma_t \cdot \psi$.
El objetivo es integrarlo con respecto a $E$ entre $E_g$ y $E_{g-1}$ y escribirlo como el producto de una sección eficaz total asociada al grupo $g$ por el flujo angular $\psi_g$ de la @def-psig:

$$
\int_{E_g}^{E_{g-1}} \Sigma_t(\vec{x}, E) \cdot \psi(\vec{x}, \omegaversor, E) \, dE =
\Sigma_{t g}(\vec{x}) \cdot \psi_g(\vec{x}, \omegaversor)
$$ {#eq-sigmatg-psig}

De la misma manera, para la ecuación de difusión quisiéramos que 

$$
\int_{E_g}^{E_{g-1}} \Sigma_t(\vec{x}, E) \cdot \phi(\vec{x}, E) \, dE =
\Sigma_{t g}(\vec{x}) \cdot \phi_g(\vec{x})
$$

Según la @def-psig, la sección eficaz total $\Sigma_{t g}$ media en el grupo $g$ debe ser

$$
\Sigma_{t g}(\vec{x}) =
\frac{\displaystyle \int_{E_g}^{E_{g-1}} \Sigma_t(\vec{x}, E) \cdot \phi(\vec{x}, E) \, dE}{\displaystyle \int_{E_g}^{E_{g-1}} \phi(\vec{x}, E) \, dE}
$$ 
con lo que no hemos ganado nada ya que llegamos a una condición tautológica donde el parámetro que necesitamos para no tener que conocer la dependencia explícita del flujo con la energía depende justamente de dicha dependencia.
Sin embargo ---y es ésta una de las ideas centrales del cálculo y análisis de reactores--- podemos suponer que el cálculo de celda (@sec-celda) es capaz de proveernos las secciones eficaz macroscópicas multigrupo para el reactor que estamos modelando de forma tal que, desde el punto de vista del cálculo de núcleo, $\Sigma_{t g}$ y todas las demás secciones eficaces macroscópicas son distribuciones conocidas del espacio $\vec{x}$.

Para analizar la sección eficaz de $\nu$-fisiones, integremos el término de fisión de la ecuación de transporte entre las energías $E_{g-1}$ y $E_g$ e igualémoslo a una sumatoria de productos $\nu\Sigma_{fg^\prime} \cdot \phi_{g^\prime}$^[Podríamos haber integrado la ecuación de difusión, en cuyo caso no tendríamos el denominador $4\pi$ en ambos miembros. En cualquier caso, el resultado sería el mismo.]


$$
\int_{E_{g-1}}^{E_g} \frac{\chi(E)}{4\pi} \cdot
\int_0^\infty \nu\Sigma_f(\vec{x},E^\prime) \cdot \phi(\vec{x}, E^\prime) \, dE^\prime \, dE
=
\frac{\chi_g}{4\pi} \cdot
\sum_{g^\prime=1}^G \nu\Sigma_{fg^\prime}(\vec{x}) \cdot \phi_{g^\prime}(\vec{x})
$$ {#eq-nusigmaf-phig}

entonces

$$
\chi_g = \int_{E_{g-1}}^{E_g} \chi(E) \, dE
$$ {#eq-chig}
y

$$
\nu\Sigma_{f g}(\vec{x}) = \frac{\displaystyle \int_{E^\prime_g}^{E^\prime_{g-1}} \nu\Sigma_f(\vec{x}, E^\prime) \cdot \phi(\vec{x}, E^\prime) \, dE^\prime}{\displaystyle \int_{E^\prime_g}^{E^\prime_{g-1}} \phi(\vec{x}, E^\prime) \, dE^\prime}
$$ 


Para el término de [scattering]{lang=en-US} isotrópico, requerimos que

$$
\int_{E_{g-1}}^{E_g} \frac{1}{4\pi} \cdot 
\int_{0}^{\infty} \Sigma_{s_0}(\vec{x}, E^{\prime} \rightarrow E) \cdot \phi(\vec{x},E^\prime) \, dE^\prime \, dE
=
\frac{1}{4\pi} \cdot \sum_{g=1}^G \Sigma_{s_0 g^\prime \rightarrow g}(\vec{x}) \cdot \phi_{g^\prime}(\vec{x})
$$ {#eq-sigmas0-phig}
entonces

$$
\Sigma_{s_0 g^\prime \rightarrow g}(\vec{x}) =
\frac{\displaystyle \int_{E_{g-1}}^{E_g} \int_{E^\prime_{g-1}}^{E^\prime_g} \Sigma_{s_0}(\vec{x}, E^{\prime} \rightarrow E) \cdot \phi(\vec{x},E^\prime) \,dE}{\displaystyle \int_{E^\prime_{g-1}}^{E^\prime_g} \phi(\vec{x},E^\prime) \, dE^\prime}
$$

::: {.remark}
Necesitamos una doble integral sobre $E$ y sobre $E^\prime$ porque $\Sigma_{s_0}(\vec{x}, E^{\prime} \rightarrow E)$ es una sección eficaz diferencial y tiene unidades de inversa de longitud por inversa de ángulo sólido por inversa de energía.
:::

Un análisis similar para el término de [scattering]{lang=en-US} linealmente anisotrópico

$$
\int_{E_{g-1}}^{E_g} \frac{3 \cdot \omegaversor}{4\pi} \cdot 
\int_{0}^{\infty} \Sigma_{s_0}(\vec{x}, E^{\prime} \rightarrow E) \cdot \vec{J}(\vec{x},E^\prime) \, dE^\prime \, dE
=
\frac{3 \cdot \omegaversor}{4\pi} \cdot \sum_{g=1}^G \Sigma_{s_1 g^\prime \rightarrow g}(\vec{x}) \cdot \vec{J}_{g^\prime}(\vec{x})
$$ {#eq-sigmas1-Jg}
arrojaría la necesidad de pesar la sección eficaz diferencial con la corriente $\vec{J}$ en lugar de con el flujo escalar $\phi$, dejando una expresión sin sentido matemático como

$$
\Sigma_{s_1 g^\prime \rightarrow g}(\vec{x}) =
\frac{\displaystyle \int_{E_{g-1}}^{E_g} \int_{E^\prime_{g-1}}^{E^\prime_g} \Sigma_{s_1}(\vec{x}, E^{\prime} \rightarrow E) \cdot \vec{J}(\vec{x},E^\prime) \,dE}{\displaystyle \int_{E^\prime_{g-1}}^{E^\prime_g} \vec{J}(\vec{x},E^\prime) \, dE^\prime}
$$
a menos que tanto numerador como denominador tengan sus elementos proporcionales entre sí y la división se tome como elemento a elemento.
Usualmente se desprecia la diferencia entre corriente y flujo y podemos utilizar el flujo para pesar el término de [scattering]{lang=en-US} anisotrópico:

$$
\Sigma_{s_1 g^\prime \rightarrow g}(\vec{x}) \approx
\frac{\displaystyle \int_{E_{g-1}}^{E_g} \int_{E^\prime_{g-1}}^{E^\prime_g} \Sigma_{s_1}(\vec{x}, E^{\prime} \rightarrow E) \cdot \phi(\vec{x},E^\prime) \,dE}{\displaystyle \int_{E^\prime_{g-1}}^{E^\prime_g} \phi(\vec{x},E^\prime) \, dE^\prime}
$$



Integremos ahora la ecuación de transporte @eq-transporte-linealmente-anisotropica con respecto a $E$ entre $E_g$ y $E_{g-1}$:

$$
\begin{gathered}
 \omegaversor \cdot \text{grad} \left[ \int_{E_g}^{E_{g-1}} \psi(\vec{x}, \omegaversor, E) \, dE \right]  +
 \int_{E_g}^{E_{g-1}} \Sigma_t(\vec{x}, E) \cdot \psi(\vec{x}, \omegaversor, E) \, dE = \\
 \int_{E_g}^{E_{g-1}} \frac{1}{4\pi} \cdot \int_{0}^{\infty} \Sigma_{s_0}(\vec{x}, E^{\prime} \rightarrow E) \cdot \phi(\vec{x}, E^{\prime}) \, dE^\prime + \\
 \int_{E_g}^{E_{g-1}} \frac{3 \cdot \omegaversor}{4\pi} \cdot \int_{0}^{\infty} \Sigma_{s_1}(\vec{x}, E^{\prime} \rightarrow E) \cdot \vec{J}(\vec{x}, E^{\prime}) \, dE^\prime + \\
 \int_{E_g}^{E_{g-1}} \frac{\chi(E)}{4\pi} \int_{0}^{\infty} \int_{4\pi} \nu\Sigma_f(\vec{x}, E^\prime) \cdot \phi(\vec{x}, E^\prime) \, dE^\prime \, dE +
 \int_{E_g}^{E_{g-1}} s(\vec{x}, \omegaversor, E) \, dE
\end{gathered}
$$

::: {#def-s-g}
Definimos la fuente de neutrones independientes del grupo $g$ como

$$
s_g(\vec{x}, \omegaversor) = \int_{E_g}^{E_{g-1}} s(\vec{x}, \omegaversor, E) \, dE
$$
:::

::: {#def-s0-g}
Definimos el momento de orden cero de las fuentes independentes del grupo $g$ como

$$
s_{0g}(\vec{x}) = \int_{E_g}^{E_{g-1}} s_0(\vec{x}, E) \, dE
$$
:::

Teniendo en cuenta las definiciones

 * [-@def-psig]
 * [-@def-phig]
 * [-@def-Jg]
 * [-@def-s-g]
 
y las ecuaciones

 * [-@eq-sigmatg-psig]
 * [-@eq-nusigmaf-phig]
 * [-@eq-chig]
 * [-@eq-sigmas0-phig]
 * [-@eq-sigmas1-Jg]

obtenemos las $G$ ecuaciones de transporte multigrupo

$$
\begin{gathered}
 \omegaversor \cdot \text{grad} \left[ \psi_g(\vec{x}, \omegaversor) \right]  +
 \Sigma_{t g}(\vec{x}) \cdot \psi_g(\vec{x}, \omegaversor) = 
 \frac{1}{4\pi} \cdot \sum_{g=1}^G \Sigma_{s_0 g^\prime \rightarrow g}(\vec{x}) \cdot \phi_{g^\prime}(\vec{x}) + \\
 \frac{3 \cdot \omegaversor}{4\pi} \cdot \sum_{g=1}^G \Sigma_{s_1 g^\prime \rightarrow g}(\vec{x}) \cdot \vec{J}_{g^\prime}(\vec{x}) + 
 \frac{\chi_g}{4\pi} \sum_{g^\prime=1}^G \nu\Sigma_{fg^\prime}(\vec{x}) \cdot \phi_{g^\prime}(\vec{x})
+ s_g(\vec{x}, \omegaversor)
\end{gathered}
$$ {#eq-transportemultigrupo}
donde las incógnitas son $\psi_g(\vec{x}, \omegaversor)$ para $g=1,\dots,G$


Procediendo de forma análoga para la ecuación de difusión @eq-difusion-ss, primero integrándola con respecto a $E$ entre $E_{g-1}$ y $E_g$ y luego teniendo en cuenta las definiciones

 * [-@def-psig]
 * [-@def-phig]
 * [-@def-s0-g]
 
podemos obtener la ecuación de difusión multigrupo

$$
\begin{gathered}
 - \text{div} \Big[ D_g(\vec{x}) \cdot \text{grad} \left[ \phi_g(\vec{x}) \right] \Big]
 + \Sigma_{t g}(\vec{x}) \cdot \phi_g(\vec{x})
 = \\
\sum_{g^\prime = 1}^G \Sigma_{s_0 g^\prime \rightarrow g}(\vec{x})  \cdot \phi_{g^\prime}(\vec{x}) +
\chi_g \sum_{g^\prime = 1}^G \nu\Sigma_{fg^\prime}(\vec{x}) \cdot \phi_{g^\prime}(\vec{x})+ s_{0g}(\vec{x})
\end{gathered}
$$ {#eq-difusionmultigrupo}
donde ahora las incógnitas son $\phi_g(\vec{x})$ para $g=1,\dots,G$, 



::: {.remark}
El coeficiente de difusión $D_g$ del grupo $g$ proviene de calcular las secciones eficaces $\Sigma_{tg}$, $\Sigma_{st}$ y el coseno medio de [scattering]{lang=en-US} $\mu_{0g}$ del grupo $g$ y reemplazar la @def-D por

$$
D_g(\vec{x}) = \frac{1}{3 \left[ \Sigma_{tg}(\vec{x}) - \mu_{0g}(\vec{x}) \cdot \Sigma_{s_t g}(\vec{x}) \right]}
$$ {#eq-D}
:::

::: {.remark}
Matemáticamente, la aproximación multigrupo es equivalente a discretizar el dominio de la energía con un esquema de volúmenes finitos con la salvedad de que no hay operadores diferenciales con respecto a la variable $E$ sino que el acople entre volúmenes se realiza en forma algebraica. Dicho acople no es necesariamente entre primeros vecinos solamente sino que es arbitrario, i.e. un neutrón puede pasar del grupo 1 al $G$, o viceversa, o de un grupo arbitrario $g^\prime$ a otro grupo $g$.
:::


::: {.remark}
Dado que en las ecuaciones multigrupo [-@eq-transportemultigrupo] y [-@eq-difusionmultigrupo] la discretización es estrictamente algebraica y deliberamente tautológica, la consistencia es teóricamente fuerte ya que el operador discretizado coincide con el operador continuo incluso para un único grupo de energías $G=1$.
De hecho las ecuaciones multigrupo se basan solamente en _definiciones_.
En la práctica, la consistencia depende del cálculo a nivel de celda de la\ @sec-celda.
:::

## Discretización en ángulo {#sec-sn}

Para discretizar la dependencia espacial de la ecuación de transporte multigrupo [-@eq-transportemultigrupo] aplicamos el método de ordenadas discretas o S$_N$, discutido en la literatura tradicional de física de reactores pero derivado al integrar las ecuaciones multigrupo continuas en\ $\omegaversor$ sobre volumenes de control finitos como si fuese un esquema numerico basado en el metodo de volumenes finitos.
De hecho los volumenes finitos son areas\ $\Delta \omegaversor_m$ discretas de la esfera unitaria donde cada una de ellas tiene asociada una dirección particular $\omegaversor_m$ y un peso $w_m$ asociado a una fracción de total de área unitaria $4\pi$ según sea el orden $N$ de la aproximación $S_N$.
Nuevamente el acople entre volumenes de control es algebraico y no necesariamente a primeros vecinos.


::::: {#thm-cuadratura}

## de cuadratura sobre la esfera unitaria

La integral de una función escalar $f(\omegaversor)$ de cuadrado integrable sobre todas las direcciones $\omegaversor$ es igual a $4\pi$ veces la suma de un conjunto de $M$ pesos $w_m$ normalizados tal que $\sum w_m = 1$ mutiplicados por $M$ valores medios $\left\langle f(\omegaversor)\right\rangle_m$ asociados a $M$ direcciones $\omegaversor_m$ donde cada una de las cuales tiene asociado una porción $\Delta \omegaversor_m$ de la esfuera unitaria tal que su unión es $4\pi$ y su intersección es cero:

$$
\int_{4\pi} f(\omegaversor) \, d\omegaversor = 4\pi \cdot \sum_{w=1}^M w_m \cdot \left\langle f(\omegaversor)\right\rangle_m
$$

El peso $w_m$ es

$$
w_m = \frac{1}{4\pi} \cdot \int_{\Delta \omegaversor_m} d\omegaversor =
\frac{\Delta \omegaversor_m}{4\pi}
$$

::: {.proof}
Comenzamos escribiendo la integral sobre $4\pi$ como una suma para $m=1,\dots,M$

$$
 \int_{4\pi} f(\omegaversor) \, d\omegaversor = \sum_{m=1}^M \int_{\Delta \omegaversor_m} f(\omegaversor) \, d\omegaversor
$$

Multiplicamos y dividimos por $\int_{\Delta \omegaversor_m} d\omegaversor = 4\pi \cdot w_m$

$$
\sum_{m=1}^M \int_{\Delta \omegaversor_m} f(\omegaversor) \, d\omegaversor
= \sum_{m=1}^M \frac{ \displaystyle \int_{\Delta \omegaversor_m} f(\omegaversor) \, d\omegaversor}{ \displaystyle \int_{\Delta \omegaversor_m} d\omegaversor} \cdot \int_{\Delta \omegaversor_m} d\omegaversor
= \sum_{m=1}^M \frac{ \displaystyle \int_{\Delta \omegaversor_m} f(\omegaversor) \, d\omegaversor}{ \displaystyle \int_{\Delta \omegaversor_m} d\omegaversor} \cdot 4\pi \, w_m
$$


Si llamamos\ $\left\langle f(\omegaversor)\right\rangle_{\omegaversor_m}$ al valor medio de\ $f$ en\ $\Delta \omegaversor_m$

$$
\left\langle f(\omegaversor)\right\rangle_{\omegaversor_m} = \frac{ \displaystyle \int_{\Delta \omegaversor_m} f(\omegaversor) \, d\omegaversor}{ \displaystyle \int_{\Delta \omegaversor_m} d\omegaversor}
$$
entonces se sigue la tesis del teorema.
:::
:::::


::: {#def-psi-mg}
El flujo angular $\psi_{mg}$ del grupo $g$ asociado a la ordenada discreta $m$ es igual al valor medio del flujo angular $\psi_g$ del grupo $g$ (definido en la @def-psig) alrededor de la dirección $\omegaversor_m$:

$$
\psi_{mg}(\vec{x}) = \left\langle \psi_g(\vec{x},\omegaversor)\right\rangle_{\omegaversor_m} = \frac{ \displaystyle \int_{\Delta \omegaversor_m} \psi_g(\vec{x},\omegaversor) \, d\omegaversor}{ \displaystyle \int_{\Delta \omegaversor_m} d\omegaversor}
$$
por lo que

$$
\int_{\Delta \omegaversor_m} \psi_g(\vec{x},\omegaversor) \, d\omegaversor
=
\psi_{mg}(\vec{x}) \cdot \Delta \omegaversor_m 
=
4\pi \cdot w_m \cdot \psi_{mg}(\vec{x})
$$
:::

::: {.remark}
Esta vez $\psi_{mg}$ sí tiene la mismas unidades que $\psi_{g}$.
:::

::: {#cor-phig-sum-psimg}
El flujo escalar $\phi_g$ del grupo $g$ es igual a

$$
\phi_g(\vec{x}) = \int_{4\pi} \psi_g(\vec{x}, \omegaversor) \, d\omegaversor =
4\pi \sum_{m=1}^M w_m \cdot \psi_{mg}(\vec{x})
$$
:::

Re-escribamos primero la @eq-transportemultigrupo de transporte multigrupo
$$\tag{\ref{eq-transportemultigrupo}}
\begin{gathered}
 \omegaversor \cdot \text{grad} \left[ \psi_g(\vec{x}, \omegaversor) \right]  +
 \Sigma_{t g}(\vec{x}) \cdot \psi_g(\vec{x}, \omegaversor) = 
 \frac{1}{4\pi} \cdot \sum_{g=1}^G \Sigma_{s_0 g^\prime \rightarrow g}(\vec{x}) \cdot \phi_{g^\prime}(\vec{x}) + \\
 \frac{3 \cdot \omegaversor}{4\pi} \cdot \sum_{g=1}^G \Sigma_{s_1 g^\prime \rightarrow g}(\vec{x}) \cdot \vec{J}_{g^\prime}(\vec{x}) + 
 \frac{\chi_g}{4\pi} \sum_{g^\prime=1}^G \nu\Sigma_{fg^\prime}(\vec{x}) \cdot \phi_{g^\prime}(\vec{x})
+ s_g(\vec{x}, \omegaversor)
\end{gathered}
$$

en función de los flujos angulares $\psi_{mg}$ usando la\ @def-psi-mg y explicitando el termino de la corriente como la integral del producto $\psi_{g^\prime} \cdot \omegaversor$ segun la\ @def-Jg

$$
\begin{gathered}
 \omegaversor \cdot \text{grad} \left[ \psi_g(\vec{x}, \omegaversor) \right]  +
 \Sigma_{t g}(\vec{x}) \cdot \psi_g(\vec{x}, \omegaversor) = \\
 \frac{1}{4\pi} \cdot \sum_{g=1}^G \Sigma_{s_0 g^\prime \rightarrow g}(\vec{x}) \cdot 4\pi \cdot \sum_{m^\prime=1} w_{m^\prime} \cdot \psi_{m^\prime g^\prime}(\vec{x}) + \\
 \frac{3 \cdot \omegaversor}{4\pi} \cdot \sum_{g=1}^G \Sigma_{s_1 g^\prime \rightarrow g}(\vec{x}) \cdot \sum_{m^\prime=1} \int_{\omegaversor_{m^\prime}} \psi_{g^\prime}(\vec{x},\omegaversor) \cdot \omegaversor \, d\omegaversor +\\
 \frac{\chi_g}{4\pi} \sum_{g^\prime=1}^G \nu\Sigma_{fg^\prime}(\vec{x})\cdot 4\pi \cdot \sum_{m^\prime=1} w_{m^\prime} \cdot \psi_{m^\prime g^\prime}(\vec{x})
+ s_g(\vec{x}, \omegaversor)
\end{gathered}
$$

Ahora cancelamos los factores\ $4\pi$, integramos todos los terminos con respecto a\ $\omegaversor$ sobre\ $\Delta \omegaversor_m$ y los analizamos uno por uno:

$$
\begin{gathered}
 \underbrace{\int_{\omegaversor_m} \left\{ \omegaversor \cdot \text{grad} \left[ \psi_g(\vec{x}, \omegaversor) \right] \right\} \, d\omegaversor}_\text{advección} +
 \underbrace{\int_{\omegaversor_m} \left\{ \Sigma_{t g}(\vec{x}) \cdot \psi_g(\vec{x}, \omegaversor)  \right\} \, d\omegaversor}_\text{absorción total} = \\
 \underbrace{\bigintsss_{\omegaversor_m} \left\{ \sum_{g=1}^G \Sigma_{s_0 g^\prime \rightarrow g}(\vec{x})  \cdot \sum_{m^\prime=1} w_{m^\prime} \cdot \psi_{m^\prime g^\prime}(\vec{x}) \right\}  \, d\omegaversor}_\text{scattering isotropico} + \\
 \underbrace{\bigintsss_{\omegaversor_m} \left\{ \frac{3 \cdot \omegaversor}{4\pi} \cdot \sum_{g=1}^G \Sigma_{s_1 g^\prime \rightarrow g}(\vec{x}) \cdot \sum_{m^\prime=1} \int_{\omegaversor_{m^\prime}} \psi_{g^\prime}(\vec{x},\omegaversor^\prime) \cdot \omegaversor^\prime \, d\omegaversor^\prime   \right\} \, d\omegaversor}_\text{scattering linealmente anisotropico} +\\
 \underbrace{\bigintsss_{\omegaversor_m} \left\{ \chi_g \cdot \sum_{g^\prime=1}^G \nu\Sigma_{fg^\prime}(\vec{x}) \cdot   \sum_{m^\prime=1} w_{m^\prime} \cdot \psi_{m^\prime g^\prime}(\vec{x}) \right\}  \, d\omegaversor}_\text{fision} +
 \underbrace{\int_{\omegaversor_m} \left\{ s_g(\vec{x}, \omegaversor)  \right\} \, d\omegaversor  }_\text{fuentes independientes}
\end{gathered}
$$ {#eq-trasporte-integrado-omegam}

Comencemos por el termino de adveccion, revirtiendo el\ @thm-div-inner

$$
\begin{aligned}
\int_{\omegaversor_m} \left\{ \omegaversor \cdot \text{grad} \left[ \psi_g(\vec{x}, \omegaversor) \right] \right\} \, d\omegaversor
&=
\int_{\omegaversor_m}  \text{div} \left[ \omegaversor \cdot \psi_g(\vec{x}, \omegaversor) \right] \, d\omegaversor
\\
&=
\text{div} \left[ \int_{\omegaversor_m} \omegaversor \cdot \psi_g(\vec{x}, \omegaversor) \, d\omegaversor \right]
\end{aligned}
$$

Prestemos atencion a la integral. Supongamos que el flujo angular es constante a trozos^[Del ingles [*piecewise constant*]{lang=en-US}.] dentro de cada area\ $\Delta \omegaversor_m$. Entonces este valor constante es igual al valor medio de\ $\psi$ en\ $\Delta \omegaversor_m$

$$
\psi_g(\vec{x}, \omegaversor) = \left\langle \psi_g(\vec{x}, \omegaversor) \right\rangle_{\omegaversor_m} = \psi_{mg}(\vec{x})
\quad \text{si $\omegaversor \in \Delta \omegaversor_m$}
$$

En estas condiciones, $\psi$ puede salir de la integral

$$
\int_{\omegaversor_m} \omegaversor \cdot \psi_g(\vec{x}, \omegaversor) \, d\omegaversor
\approx
\psi_{mg}(\vec{x}) \cdot \int_{\omegaversor_m} \omegaversor \, d\omegaversor
$$

::: {#def-mean-omega}
Llamamos\ $\omegaversor_m$ a la direccion que resulta ser el valor medio\ $\left\langle \omegaversor \right\rangle_{\omegaversor_m}$ de todas las direcciones integradas en el area\ $\Delta \omegaversor_m$ sobre la esfera unitaria, es decir

$$
\omegaversor_m = \left\langle \omegaversor \right\rangle_{\omegaversor_m} =
\frac{ \displaystyle \int_{\Delta \omegaversor_m} \omegaversor \, d\omegaversor}{ \displaystyle \int_{\Delta \omegaversor_m} d\omegaversor}
$$
por lo que

$$
\int_{\Delta \omegaversor_m} \omegaversor \, d\omegaversor
=
\omegaversor_m \cdot \Delta \omegaversor_m 
$$
:::

Con esta\ @def-mean-omega, la integral queda

$$
\int_{\omegaversor_m} \omegaversor \cdot \psi_g(\vec{x}, \omegaversor) \, d\omegaversor
\approx
\omegaversor_m \cdot \psi_{mg}(\vec{x}) \cdot  \Delta \omegaversor_m 
$$ {#eq-int-psi-omega}

y podemos volver a aplicar el\ @thm-div-inner para escribir el termino de adveccion como

$$
\begin{aligned}
\text{div} \left[ \int_{\omegaversor_m} \omegaversor \cdot \psi_g(\vec{x}, \omegaversor) \, d\omegaversor \right]
& \approx
\text{div} \left[ \omegaversor_m \cdot \psi_{mg}(\vec{x}) \cdot  \Delta \omegaversor_m  \right] \\
& \approx
\omegaversor_m \cdot \text{grad} \left[ \psi_{mg}(\vec{x}) \right]  \cdot \Delta \omegaversor_m \\
\end{aligned}
$$ {#eq-sn-adveccion}

Pasemos ahora al termino de absorciones totales de la\ @{eq-trasporte-integrado-omegam}.
La seccion eficaz no depende de\ $\omegaversor$ por lo que puede salir fuera de la integral

$$
\int_{\omegaversor_m} \left\{ \Sigma_{t g}(\vec{x}) \cdot \psi_g(\vec{x}, \omegaversor)  \right\} \, d\omegaversor = \Sigma_{t g}(\vec{x}) \cdot
\int_{\omegaversor_m} \psi_g(\vec{x}, \omegaversor) \, d\omegaversor
$$

Por la\ @def-psi-mg la ultima integral es\ $\psi_{mg} \cdot \Delta \omegaversor_m$

$$
\int_{\omegaversor_m} \left[ \Sigma_{t g}(\vec{x}) \cdot \psi_g(\vec{x}, \omegaversor)  \right] \, d\omegaversor = \left[ \Sigma_{t g}(\vec{x}) \cdot \psi_{mg}(\vec{x}) \right] \cdot \Delta \omegaversor_m
$$ {#eq-sn-absorciones}

El termino de scattering isotropico queda

$$
\bigintsss_{\omegaversor_m} \sum_{g=1}^G \Sigma_{s_0 g^\prime \rightarrow g}(\vec{x})  \cdot \sum_{m^\prime=1} w_{m^\prime} \cdot \psi_{m^\prime g^\prime}(\vec{x}) \, d\omegaversor
=
\left[ \sum_{g=1}^G \Sigma_{s_0 g^\prime \rightarrow g}(\vec{x})  \cdot \sum_{m^\prime=1} w_{m^\prime} \cdot \psi_{m^\prime g^\prime}(\vec{x}) \right] \cdot \Delta \omegaversor_m
$$ {#eq-sn-scattering-isotropico}
ya que el integrando no depende de\ $\omegaversor$.

El integrando del termino de scattering linealmente anisotrópico si depende de\ $\omegaversor$.

$$
\bigintsss_{\omegaversor_m} \left[ \frac{3 \cdot \omegaversor}{4\pi} \cdot \sum_{g=1}^G \Sigma_{s_1 g^\prime \rightarrow g}(\vec{x}) \cdot \sum_{m^\prime=1} \int_{\omegaversor_{m^\prime}} \psi_{g^\prime}(\vec{x},\omegaversor^\prime) \cdot \omegaversor^\prime \, d\omegaversor^\prime   \right] \, d\omegaversor
$$

Primero notamos que la integral sobre\ $\omegaversor_{m^\prime}$ ya la hemos resuelto (en forma aproximada) en la\ @eq-int-psi-omega, y es\ $\omegaversor_{m^\prime} \psi_{m^\prime g^\prime} \Delta\omegaversor_{m^\prime}$. A su vez, $\Delta\omegaversor_{m^\prime} = 4\pi w_{m^\prime}$:

$$
\begin{gathered}
\bigintsss_{\omegaversor_m} \left[ \frac{3 \cdot \omegaversor}{4\pi} \cdot \sum_{g=1}^G \Sigma_{s_1 g^\prime \rightarrow g}(\vec{x}) \cdot \sum_{m^\prime=1} 4\pi \cdot w_{m^\prime} \cdot \psi_{m^\prime g^\prime}(\vec{x}) \cdot \omegaversor_{m^\prime} \right] \, d\omegaversor
= \\
3 \sum_{g=1}^G \Sigma_{s_1 g^\prime \rightarrow g}(\vec{x}) \cdot \sum_{m^\prime=1} w_{m^\prime} \cdot \psi_{m^\prime g^\prime}(\vec{x}) \cdot \omegaversor_{m^\prime} \int_{\omegaversor_m} \omegaversor \, d\omegaversor
\end{gathered}
$$

Una vez mas, la integral sobre\ $\omegaversor_m$ ya la hemos resuelto (exactamente) en la\ @def-mean-omega, y es igual a\ $\omegaversor_m \cdot \Delta \omegaversor_m$. Entonces el termino de scattering linealmente anisotropico es aproximadamente

$$
\begin{gathered}
\bigintsss_{\omegaversor_m} \left[ \frac{3 \cdot \omegaversor}{4\pi} \cdot \sum_{g=1}^G \Sigma_{s_1 g^\prime \rightarrow g}(\vec{x}) \cdot \sum_{m^\prime=1} \int_{\omegaversor_{m^\prime}} \psi_{g^\prime}(\vec{x},\omegaversor^\prime) \cdot \omegaversor^\prime \, d\omegaversor^\prime   \right] \, d\omegaversor
\approx \\
\left[ 3 \cdot \sum_{g=1}^G \Sigma_{s_1 g^\prime \rightarrow g}(\vec{x}) \cdot \sum_{m^\prime=1} w_{m^\prime} \cdot \left( \omegaversor_{m} \cdot \omegaversor_{m^\prime} \right) \cdot \psi_{m^\prime g^\prime}(\vec{x}) \right] \cdot  \Delta \omegaversor_m
\end{gathered}
$$ {#eq-sn-scattering-anisotropico}

El termino de fisiones es similar al de scattering isotropico en el sentido de que el integrando no depende de\ $\omegaversor$ entonces su integral sobre\ $\Delta \omegaversor_m$ es directamente

$$
\bigintsss_{\omegaversor_m} \chi_g \sum_{g^\prime=1}^G \nu\Sigma_{fg^\prime}(\vec{x}) \cdot   \sum_{m^\prime=1} w_{m^\prime} \cdot \psi_{m^\prime g^\prime}(\vec{x}) \, d\omegaversor
=
\left[ \chi_g \sum_{g^\prime=1}^G \nu\Sigma_{fg^\prime}(\vec{x}) \cdot   \sum_{m^\prime=1} w_{m^\prime} \cdot \psi_{m^\prime g^\prime}(\vec{x}) \right] \cdot \Delta \omegaversor_m
$$ {#eq-sn-fisiones}

Para completar el analisis de la\ @eq-trasporte-integrado-omegam, en el termino de las fuentes independentes usamos el concepto de valor medio

$$
\int_{\omegaversor_m} s_g(\vec{x}, \omegaversor) \, d\omegaversor
=
\left\langle s_g(\vec{x}, \omegaversor)  \right\rangle_{\omegaversor_m} \cdot \Delta \omegaversor
$$

::: {#def-s-mg}
En forma analoga a la\ @def-psi-mg, definimos a la fuente independiente del grupo\ $g$ en la direccion\ $m$ como

$$
s_{mg}(\vec{x}) = \left\langle s(\vec{x},\omegaversor)\right\rangle_{\omegaversor_m} = \frac{ \displaystyle \int_{\Delta \omegaversor_m} s_g(\vec{x},\omegaversor) \, d\omegaversor}{ \displaystyle \int_{\Delta \omegaversor_m} d\omegaversor}
$$
:::

El termino de fuentes independentes es entonces

$$
\int_{\omegaversor_m} s_g(\vec{x}, \omegaversor) \, d\omegaversor
=
s_{mg}(\vec{x}) \cdot \Delta \omegaversor_m
$$ {#eq-sn-fuentes}

Juntemos ahora las ecuaciones

 * [-@eq-sn-adveccion]
 * [-@eq-sn-absorciones]
 * [-@eq-sn-scattering-isotropico]
 * [-@eq-sn-scattering-anisotropico]
 * [-@eq-sn-fisiones]
 * [-@eq-sn-fuentes]
 
para re-escribir la\ @eq-trasporte-integrado-omegam como

$$
\begin{gathered}
\left[ \omegaversor_m \cdot \text{grad} \left[ \psi_{mg}(\vec{x}) \right] \right]  \cdot \Delta \omegaversor_m +
\left[ \Sigma_{t g}(\vec{x}) \cdot \psi_{mg}(\vec{x}) \right] \cdot \Delta \omegaversor_m = \\
\left[ \sum_{g=1}^G \Sigma_{s_0 g^\prime \rightarrow g}(\vec{x})  \cdot \sum_{m^\prime=1} w_{m^\prime} \cdot \psi_{m^\prime g^\prime}(\vec{x}) \right] \cdot \Delta \omegaversor_m + \\
\left[ 3 \sum_{g=1}^G \Sigma_{s_1 g^\prime \rightarrow g}(\vec{x}) \cdot \sum_{m^\prime=1} w_{m^\prime} \cdot \left( \omegaversor_{m} \cdot \omegaversor_{m^\prime} \right) \cdot \psi_{m^\prime g^\prime}(\vec{x}) \right] \cdot  \Delta \omegaversor_m + \\
\left[ \chi_g \sum_{g^\prime=1}^G \nu\Sigma_{fg^\prime}(\vec{x}) \cdot   \sum_{m^\prime=1} w_{m^\prime} \cdot \psi_{m^\prime g^\prime}(\vec{x}) \right] \cdot \Delta \omegaversor_m + 
s_{mg}(\vec{x}) \cdot \Delta \omegaversor_m
\end{gathered}
$$

Dividiendo ambos miembros por\ $\Delta \omegaversor$ obtenemos las $MG$ ecuaciones diferenciales de transporte en\ $G$ grupos de energias y\ $M$ direcciones angulares, segun la discretizacion angular llamada "ordenadas discretas"

$$
\begin{gathered}
 \omegaversor_m \cdot \text{grad} \left[ \psi_{mg}(\vec{x}) \right]  +
 \Sigma_{t g}(\vec{x}) \cdot \psi_{mg}(\vec{x}) = 
 \sum_{g=1}^G \Sigma_{s_0 g^\prime \rightarrow g}(\vec{x})  \sum_{m^\prime=1} w_{m^\prime} \psi_{m^\prime g^\prime}(\vec{x})  + \\
 3  \sum_{g=1}^G \Sigma_{s_1 g^\prime \rightarrow g}(\vec{x}) \sum_{m^\prime=1} w_{m^\prime} \left( \omegaversor_{m} \cdot \omegaversor_{m^\prime} \right) \psi_{m^\prime g^\prime}(\vec{x}) + 
 \chi_g \sum_{g^\prime=1}^G \nu\Sigma_{fg^\prime}(\vec{x})   \sum_{m^\prime=1} w_{m^\prime} \psi_{m^\prime g^\prime}(\vec{x}) + 
s_{mg}(\vec{x})
\end{gathered}
$$ {#eq-transporte-sn}

::: {.remark}
El unico operador diferencial que aparece en la\ @eq-transporte-sn es el gradiente espacial del flujo angular\ $\psi_{mg}$ del grupo\ $g$ en la direccion\ $m$.
:::

::: {.remark}
Todos los operadores integrales que estaban presentes en la\ @eq-transporte-linealmente-anisotropica han sido reemplazados por sumatorias finitas.
:::

:::  {.remark}
La unica aproximacion numerica que tuvimos que hacer para obtener la\ @eq-transporte-sn a partir de la @eq-transportemultigrupo fue suponer que el flujo angular\ $\psi_g$ era uniforme a trozos en cada segmento de area\ $\Delta \omegaversor_m$ en los terminos de

 a. absorciones totales (@eq-sn-absorciones), y
 b. scattering linealmente anisotropico (@eq-sn-scattering-anisotropico).
 
Esta suposicion es usual en los esquemas basados en el metodo de volumenes finitos.
El esquema numerico es consistente ya que en el limite\ $\Delta \omegaversor_m \rightarrow d\omegaversor_m$ la suposicion es exacta y el operador discretizado coincide con el operador continuo.
:::

### Conjuntos de cuadraturas en tres dimensiones {#sec-cuadraturas}

Para completar el método de las ordenadas discretas debemos
especificar $M$ pares de direcciones y
pesos $(\boldsymbol{\hat\Omega}_m, w_m)$ para $m=1,\dots,M$. Las
direcciones $\boldsymbol{\hat\Omega}_m = [\hat{\Omega}_{mx} \, \hat{\Omega}_{my} \, \hat{\Omega}_{mz}]^T$
deben ser versores unitarios tales que

$$\label{eq:normalizaciondirecciones}
 \hat{\Omega}_{mx}^2 + \hat{\Omega}_{my}^2 + \hat{\Omega}_{mz}^2 = 1$$ y
los pesos $w_m$ deben estar normalizados a uno, es decir

$$\label{eq:normalizacionpesos}
 \sum_{m=1}^M w_m = 1$$

Existen varias maneras de elegir los $M$ pares de forma tal de cumplir
estas dos condiciones. En este trabajo utilizamos la cuadratura de nivel
simétrico [@lewis] o de simetría completa [@stammler] en la que las
direcciones son simétricas por octante. En un espacio de tres
dimensiones, el orden $N$ de la aproximación S$_N$ se relaciona con la
cantidad de direcciones $M$ como

$$M = N\cdot(N+2)$$

En este caso, en cada octante tomamos los cosenos
directores $\hat{\Omega}_{mx}$, $\hat{\Omega}_{my}$
y $\hat{\Omega}_{mz}$ de un conjunto de $N/2$ valores positivos y los
permutamos de todas las maneras posibles para obtener $N(N+2)/8$
combinaciones en el primer octante para luego reflejar estas direcciones
hasta completar los ocho octantes. De esta forma las $M$ direcciones son
simétricas con respecto a rotaciones de noventa y ciento ochenta grados
sobre cualesquiera de los ejes $x$, $y$ ó $z$.

Debido a estas restricciones de simetría, no todos los $N/2$ posibles
cosenos directores son independientes. De hecho, en el caso general sólo
podemos elegir un único valor. En efecto,
sean $\mu_1 < \mu_2 < \dots < \mu_{N/2}$ los posibles cosenos directores
del conjunto. Supongamos que $\hat{\Omega}_{mx} = \mu_i$,
$\hat{\Omega}_{my} = \mu_j$ y $\hat{\Omega}_{mz} = \mu_k$. Entonces

$$\label{eq:omega1}
 \mu_i^2 + \mu_j^2 + \mu_k^2 = 1$$

Tomemos ahora otra dirección diferente $m^\prime$ pero manteniendo el
primer componente $\hat{\Omega}_{m^\prime x} = \mu_i$ y
haciendo $\hat{\Omega}_{m^\prime y} = \mu_{j+1}$. Para poder satisfacer
la condición de magnitud unitaria y debido a que $\mu_{j+1}>\mu{j}$
entonces $\hat{\Omega}_{m^\prime z} = \mu_{k-1}$ ya
que $\mu_{k-1}<\mu_k$. Entonces

$$\label{eq:omega2}
 \mu_i^2 + \mu_{j+1}^2 + \mu_{k-1}^2 = 1$$

De [\[eq:omega1\]](#eq:omega1){reference-type="eqref"
reference="eq:omega1"}
y [\[eq:omega2\]](#eq:omega2){reference-type="eqref"
reference="eq:omega2"} obtenemos

$$\mu_{j+1}^2 - \mu_{j} = \mu_{k}^2 - \mu_{k-1}^2$$

Como esta ecuación debe cumplirse para todo $j$ y para todo $k$,
entonces debe ser

$$\mu_i^2 = \mu_{i-1} + C$$ para todo $1 < i \leq N/2$, con $C$ una
constante a determinar. Luego

$$\mu_i^2 = \mu_{1} + C(i-1)$$

Si tomamos $\hat{\Omega}_{mx} = \hat{\Omega}_{my} = \mu_1$
y $\hat{\Omega}_{mz}=\mu_{N/2}$, por la condición de magnitud unitaria
debe ser $2\mu_1^2 + \mu_{N/2}^2 = 1$ por lo que podemos determinar la
constante $C$ como

$$C = \frac{2 (1 - 3\mu_1^2)}{N-2}$$

Finalmente, una vez seleccionado el coseno director $\mu_1$, podemos
calcular el resto de los $N/2-1$ valores como

$$\label{eq:cosenos}
 \mu_{i} = \sqrt{\mu_1^2 + (2 - 6\mu_1^2) \cdot \frac{(i-1)}{N-2}}$$
para $i=2,\dots,N/2$.

Las condiciones de simetría requieren que los pesos $w_m$
y $w_{m^\prime}$ asociados a dos direcciones $\boldsymbol{\hat\Omega}_m$
y $\boldsymbol{\hat\Omega}_{m^\prime}$ cuyos cosenos directores son
permutaciones entre sí deben ser iguales. Además es deseable que los
pesos $w_m$ sean tales que la cuadratura ilustrada en la
ecuación [\[eq:cuadratura\]](#eq:cuadratura){reference-type="eqref"
reference="eq:cuadratura"} sea lo más aproximada posible. El cálculo
detallado de los pesos está fuera del alcance de este trabajo y nos
limitamos a reportar los valores utilizados por el código computacional
desarrollado para esta tesis y descripto en el
capítulo [\[cap:implementacion\]](#cap:implementacion){reference-type="ref"
reference="cap:implementacion"}.

::: {#tbl-quadratureset}
               $\mu_1$       $m$      $8 \cdot w_i$
  ------- -- ----------- -- ----- -- ---------------
   S$_4$      0.3500212       1            1/3
   S$_6$      0.2666355       1         0.1761263
                              2         0.1572071
   S$_8$      0.2182179       1         0.1209877
                              2         0.0907407
                              3         0.0925926

: Set de cuadraturas para S$_N$ de nivel simétrico. Para cada $N$
  mostramos el primer coseno director (el resto se calcula con la
  ecuación [\[eq:cosenos\]](#eq:cosenos){reference-type="eqref"
  reference="eq:cosenos"}) y ocho veces el peso asociado a cada
  permutación, de forma tal que se puedan utilizar los mismos valores
  para dos dimensiones dividiendo por cuatro en lugar de por ocho (ver
  @sec-dosdimensiones. Datos tomados de la
  referencia [@lewis Tabla 4-1 pág. 162].
:::

::: {#tbl-mus}
           $m$   $\hat{\Omega}_{mx}$   $\hat{\Omega}_{my}$   $\hat{\Omega}_{mz}$   $i$
  ------- ----- --------------------- --------------------- --------------------- -----
   S$_4$    1          $\mu_1$               $\mu_1$               $\mu_2$          1
            2          $\mu_1$               $\mu_2$               $\mu_1$          1
            3          $\mu_2$               $\mu_1$               $\mu_1$          1
   S$_6$    1          $\mu_1$               $\mu_1$               $\mu_3$          1
            2          $\mu_1$               $\mu_2$               $\mu_2$          2
            3          $\mu_2$               $\mu_1$               $\mu_2$          2
            4          $\mu_2$               $\mu_2$               $\mu_1$          2
            5          $\mu_3$               $\mu_1$               $\mu_1$          1
            6          $\mu_1$               $\mu_3$               $\mu_1$          1

: Combinaciones de cosenos directores positivos que forman las
  direcciones en el primer cuadrante ($m=1,\dots,N(N+2)/8$) para S$_4$
  y S$_2$. El índice $i$ indica el peso $w_i$ de la @tbl-quadratureset aplicable a la dirección $m$.
:::

Para obtener entonces un conjunto de cuadraturas aplicable a S$_N$ de
nivel simétrico, para cada $N$ primero seleccionamos un valor apropiado
de $\mu_1 > 0$. Para S$_2$ el único valor posible es $\mu_1=1/\sqrt{3}$.
Para otro valores de $N$ hay varias opciones. En la tabla la
tabla [1.1](#tab:quadratureset){reference-type="ref"
reference="tab:quadratureset"} mostramos los valores de $\mu_1$
para S$_4$, S$_6$ y S$_8$ para la cuadratura de nivel simétrico y en la
tabla [1.2](#tab:mus){reference-type="ref" reference="tab:mus"}
indicamos las combinaciones que dan las $N(N+2)/8$ direcciones en el
primer octante. Para extender estas direcciones a los demás cuadrantes,
notamos que si asignamos un índice $n$ a cada octantes de la siguiente
manera:

 0.  $x>0$, $y>0$, $z>0$
 1.  $x<0$, $y>0$, $z>0$
 2.  $x>0$, $y<0$, $z>0$
 3.  $x<0$, $y<0$, $z>0$
 4.  $x>0$, $y>0$, $z<0$
 5.  $x<0$, $y>0$, $z<0$
 6.  $x>0$, $y<0$, $z<0$
 7.  $x<0$, $y<0$, $z<0$

![image](axes-with-octs){width=70%}


Notamos que el desarrollo binario del índice $n$ tiene tres bits y éstos
indican si hubo un cambio de signo o no en cada uno de los tres ejes con
respecto al primer cuadrante, que corresponde a $n=0$. De esta manera,
podemos generar las direcciones $\boldsymbol{\hat{\Omega}}_m$
para $m=N(N+2)/8+1, N(N+2)$ a partir de las direcciones del primer
cuadrante $\boldsymbol{\hat{\Omega}}_j$ para $j=1,N(N+2)/8$ con el
algoritmo de la
figura [\[alg:extension\]](#alg:extension){reference-type="ref"
reference="alg:extension"}, donde el símbolo ampersand `&` indica el
operador binario `AND` y el signo de pregunta `?` el operador ternario
de decisión. La figura [1.2](#fig:latsn){reference-type="ref"
reference="fig:latsn"} muestra el detalle de las latitudes y longitudes
en la esfera unitaria del primer cuadrante y el conjunto resultante de
las $N(N+2)$ direcciones para S$_2$, S$_4$ y $S_6$ que resultan de
aplicar este desarrollo.

::: algorithm
:::

<figure id="fig:latsn">
<div class="center">

</div>
<figcaption><span id="fig:latsn" label="fig:latsn"></span>Latitudes y
longitudes en el primer cuadrante (izquierda) y conjunto de las <span
class="math inline"><em>N</em>(<em>N</em>+2)</span> direcciones de la
cuadratura de nivel simétrico para S<span
class="math inline"><sub>2</sub></span>, S<span
class="math inline"><sub>4</sub></span> y <span
class="math inline"><em>S</em><sub>6</sub></span> generadas a partir de
un único coseno director positivo <span
class="math inline"><em>μ</em><sub>1</sub></span> de la tabla <a
href="#tab:quadratureset" data-reference-type="ref"
data-reference="tab:quadratureset">1.1</a>, aplicando con la ecuación <a
href="#eq:cosenos" data-reference-type="eqref"
data-reference="eq:cosenos">[eq:cosenos]</a> para obtener el resto de
los cosenos positivos, permutándolos según la tabla <a href="#tab:mus"
data-reference-type="ref" data-reference="tab:mus">1.2</a> y
extendiéndolos al resto de los octantes con el algoritmo <a
href="#alg:extension" data-reference-type="ref"
data-reference="alg:extension">[alg:extension]</a>. Las figuras son
reproducciones tridimensionales realizadas con la herramienta Gmsh a
partir de la información calculada y que realmente utiliza milonga
(capítulo <a href="#cap:implementacion" data-reference-type="ref"
data-reference="cap:implementacion">[cap:implementacion]</a>) para
realizar cálculos de transporte con el método de las ordenadas
discretas.</figcaption>
</figure>

### Dos dimensiones {#sec-dosdimensiones}

El caso bidimensional en realidad es un problema en tres dimensiones
pero sin dependencia de los parámetros del problema en una de las
variables espaciales, digamos $z$. De esta manera, el dominio $U$ de la
geometría está definido sólo sobre el plano $x$-$y$ y las direcciones de
vuelo $\omegaversor$ de los neutrones son simétricas con respecto a este
plano ya que por cada
dirección $\omegaversor = [\hat{\Omega}_x \, \hat{\Omega}_y \, \hat{\Omega}_z]$
con $\hat{\Omega}_z>0$ hay una dirección
simétrica $\omegaprimaversor = [\hat{\Omega}_x \, \hat{\Omega}_y \, -\hat{\Omega}_z]$
(figura [1.3](#fig:symmetry2d){reference-type="ref"
reference="fig:symmetry2d"}). Luego, las posibles direcciones se reducen
a la mitad, es decir $N(N+2)/2$.

<figure id="fig:symmetry2d">
<div class="center">
<img src="esquemas/symmetry2d" />
</div>
<figcaption><span id="fig:symmetry2d"
label="fig:symmetry2d"></span>Simetría con respecto al plano <span
class="math inline"><em>x</em></span>-<span
class="math inline"><em>y</em></span> en un problema bi-dimensional. Por
cada dirección <span class="math inline">$\omegaversor$</span> con
componente <span class="math inline"><em>z</em></span> positiva (línea
llena) hay una dirección <span
class="math inline">$\omegaprimaversor$</span> simétrica e igualmente
posible con <span
class="math inline"><em>Ω̂</em><sub><em>z</em></sub> &lt; 0</span> (línea
de trazos).</figcaption>
</figure>

Como la derivada espacial del flujo angular con respecto a $z$ es cero
entonces por un lado podemos escribir el término de transporte en la
ecuación [\[eq:transportesngeneral\]](#eq:transportesngeneral){reference-type="eqref"
reference="eq:transportesngeneral"} como

$$\hat{\Omega}_{mx} \cdot \frac{\partial{\psi_{mg}}(x,y)}{\partial x} + \hat{\Omega}_{my} \cdot \frac{\partial{\psi_{mg}(x,y)}}{\partial y}$$
donde ahora $m=1,\dots,M = N(N+2)/2$. La componente ${\Omega}_{mz}$ no
aparece explícitamente en las ecuaciones pero sí lo hace implícitamente
en la elección de las direcciones, ya que siguen siendo válidas las
ecuaciones [\[eq:normalizaciondirecciones\]](#eq:normalizaciondirecciones){reference-type="eqref"
reference="eq:normalizaciondirecciones"}
y [\[eq:normalizacionpesos\]](#eq:normalizacionpesos){reference-type="eqref"
reference="eq:normalizacionpesos"}. Esto implica que en cada cuadrante
tenemos nuevamente $N(N+2)/8$ direcciones posibles, que luego debemos
rotar para obtener las $M$ direcciones en los cuatro cuadrantes. Dado
que por un lado los pesos deben estar normalizados a uno y por otro para
cada dirección con $\hat{\Omega}_z>0$ hay otra dirección simétrica
con $\hat{\Omega}_z<0$, entonces el conjunto de cuadraturas de nivel
simétrico para el primer cuadrante de un dominio de dos dimensiones
consiste en las mismas $N(N+2)/8$ direcciones correspondientes a tres
dimensiones definidas en las
tablas [1.1](#tab:quadratureset){reference-type="ref"
reference="tab:quadratureset"} y [1.2](#tab:mus){reference-type="ref"
reference="tab:mus"}, cada una con el doble de peso. En forma
equivalente, podemos concluir que las
tablas [1.1](#tab:quadratureset){reference-type="ref"
reference="tab:quadratureset"} y [1.2](#tab:mus){reference-type="ref"
reference="tab:mus"} valen para dos dimensiones con la salvedad de que
el título de la tercera columna de la
tabla [1.1](#tab:quadratureset){reference-type="ref"
reference="tab:quadratureset"} debe ser $4\cdot w_i$ en lugar
de $8\cdot w_i$ y debemos reemplazar la palabra "octante" por
"cuadrante." En la figura [1.4](#fig:direcciones2d){reference-type="ref"
reference="fig:direcciones2d"} mostramos las direcciones para la
cuadratura de nivel simétrico utilizado en este trabajo para problemas
de dos dimensiones espaciales.

<figure id="fig:direcciones2d">
<div class="center">
<p><br />
<br />
</p>
</div>
<figcaption><span id="fig:direcciones2d"
label="fig:direcciones2d"></span>Direcciones para el conjunto de
cuadraturas de nivel simétrico en dos dimensiones.</figcaption>
</figure>

### Una dimensión

El caso unidimensional es radicalmente diferente a los otros dos. Si
tomamos al eje $x$ como la dirección de dependencia espacial, las
posibles direcciones de viaje pueden depender sólo del ángulo
cenital $\theta$ ya que la simetría implica que todas las posibles
direcciones azimutales con respecto al eje $x$ son igualmente posibles.

<figure id="fig:symmetry1d">
<div class="center">
<img src="esquemas/symmetry1d" />
</div>
<figcaption><span id="fig:symmetry1d"
label="fig:symmetry1d"></span>Simetría con respecto al eje <span
class="math inline"><em>x</em></span> en un problema unidimensional. Por
cada dirección <span class="math inline">$\omegaversor$</span> (línea
llena) hay infinitas direcciones simétricas e igualmente posibles
apuntando en la dirección del círculo subtendido por el ángulo <span
class="math inline"><em>θ</em> = arctan (<em>Ω̂</em><sub><em>z</em></sub>/<em>Ω̂</em><sub><em>x</em></sub>)</span>,
representadas por las tres direcciones primadas (líneas de
trazos).</figcaption>
</figure>

El término de transporte de la
ecuación [\[eq:transportesngeneral\]](#eq:transportesngeneral){reference-type="eqref"
reference="eq:transportesngeneral"} es entonces

$$\hat{\Omega}_{mx} \cdot \frac{\partial{\psi_{mg}}(x)}{\partial x}$$

El hecho de que no una sino dos componentes de $\omegaversor$ no
aparezcan explícitamente relaja mucho más las condiciones para la
elección de las $M=N$ direcciones. En efecto, la única condición es
simetría completa entre el semieje $x>0$ y el semieje $x<0$, lo que nos
deja con $N/2$ direcciones en cada semieje, todas ellas libres e
independientes.

Para seleccionar las $N/2$ direcciones y sus pesos asociados, notamos
que en una dimensión

$$\label{eq:1dgauss}
 \int_{4\pi} f(\omegaversor) \, d\omegaversor = 2\pi \int_{-1}^{1} f(\hat{\Omega}_x) \, d\hat{\Omega}_x \simeq 
2\pi \sum_{m=1}^N w_m \cdot f_m =
4\pi \sum_{m=1}^N \frac{w_m}{2} \cdot f_m =
4\pi \sum_{m=1}^N w_m \cdot f_m$$

Si los puntos $\hat{\Omega}_{xm}$ y los pesos $w_m=2\cdot w_m$ son
los asociados a la integración de Gauss y $f(\hat{\Omega}_x)$ es un
polinomio de orden $2N-1$ o menos, entonces la integración es exacta
(ver @sec-gauss) y la
ecuación @eq-1dgauss deja de ser una aproximación para transformarse
en una igualdad. En la tabla @tbl-gauss1d mostramos el conjunto de cuadraturas utilizadas
para una dimensión, que contiene esencialmente las abscisas y los pesos
de la cuadratura de Gauss.

::: center
::: {#tab:gauss1d}
           $m$                  $\hat{\Omega}_{mx}$                   $w_m = 2 \cdot w_m$
  ------- ----- ---------------------------------------------------- --------------------------
   S$_2$    1                   $\sqrt{\frac{1}{3}}$                             1
   S$_4$    1    $\sqrt{\frac{3}{7}-\frac{2}{7}\sqrt{\frac{6}{5}}}$         0.6521451549
            2    $\sqrt{\frac{3}{7}+\frac{2}{7}\sqrt{\frac{6}{5}}}$         0.3478548451
   S$_6$    1                       0.2386191860                            0.4679139346
            2                       0.6612093864                            0.3607615730
            3                       0.9324695142                            0.1713244924
   S$_8$    1                       0.1834346424                            0.3626837834
            2                       0.5255324099                            0.5255324099
            3                       0.7966664774                            0.2223810344
            4                       0.9602898564                            0.1012285363

  : Conjuntos de cuadratura para problemas unidimensionales. Las
  direcciones $\hat{\Omega}_{mx}$ coinciden con las abscisas de la
  cuadratura de Gauss. Los pesos $w_m$ de ordenadas discretas son la
  mitad de los pesos $w_m$ de la cuadratura de Gauss. Las
  direcciones $m=N/2+1,\dots,N$ no se muestran pero se obtienen
  como $\hat{\Omega}_{N/2+m \, x} = -\hat{\Omega}_{mx}$
  y $w_{N/2+m} = w_m$.
:::
:::

## Formulaciones de ecuaciones en derivadas parciales

Antes de comenzar a discutir las discretizaciones espaciales tanto de la
ecuación de transporte multigrupo con ordenadas discretas como de la
ecuación de difusión multigrupo, introducimos las ideas de formulaciones
fuertes, integrales y débiles sobre las que se basan los esquemas de
discretización numérica basados en diferencias finitas, en volúmenes
finitos y en elementos finitos respectivamente. De esta forma, además,
resumimos las ecuaciones en derivadas parciales con respecto a las
coordenadas espaciales que debemos resolver para obtener la distribución
de flujo neutrónico de estado estacionario en un reactor nuclear.

### Formulaciones fuertes {#sec-fuertes}

La formulación fuerte de un problema de derivadas parciales consiste en
escribir directamente las ecuaciones diferenciales y sus condiciones de
contorno. Más específicamente:

::: definicion
Decimos que un problema en derivadas parciales está escrito en su
formulación fuerte cuando en el sistema de ecuaciones diferenciales y
sus condiciones de contorno el orden de las derivadas es igual al orden
del problema. Es decir, en la formulación fuerte no hay operadores
integrales que no son esenciales para la definición del problema.
:::

Hasta este momento, en esta tesis hemos escrito ecuaciones diferenciales
que son la formulación fuerte tanto del problema de transporte como del
problema de difusión de neutrones. Si bien matemáticamente el desarrollo
fue lógico y correcto, hay salvedades que tenemos que notar. Por
ejemplo, el término de fugas de la ecuación de difusión de neutrones
multigrupo [\[eq:difusionmultigrupo\]](#eq:difusionmultigrupo){reference-type="eqref"
reference="eq:difusionmultigrupo"} es

$$- \text{div} \Big[ D_g(\vec{x}) \cdot \text{grad} \left[ \phi_g(\vec{x}) \right] \Big]$$

Si el coeficiente de difusión $D_g$ presenta una discontinuidad
en $\vec{x}$, por ejemplo debido a que hay una interfaz entre dos
materiales diferentes, entonces este término no está definido y no puede
ser evaluado. Este es uno de los varios inconvenientes que tiene esta
formulación a la hora de utilizarla para resolver numéricamente los
problemas planteados en esta tesis.

#### Operador de Laplace escalar

#### Ordenadas discretas

La formulación fuerte del problema de transporte de neutrones
discretizado en energía mediante el método multigrupo y en ángulo
mediante ordenadas discretas es la ecuación
diferencial [\[eq:transportesngeneral\]](#eq:transportesngeneral){reference-type="eqref"
reference="eq:transportesngeneral"}

$$\begin{gathered}
 \omegaversor_m \cdot \text{grad} \left[ \psi_{mg}(\vec{x}) \right]
 + \Sigma_{t g}(\vec{x}) \cdot \psi_{mg}(\vec{x}) = \\
  \sum_{g^\prime=1}^G \sum_{m^\prime=1}^M w_{m^\prime} \cdot
\left[  \sum_{\ell=0}^\infty (2\ell+1) \cdot \Sigma_{s_\ell \,g^\prime \rightarrow g}(\vec{x}) \cdot P_\ell (\omegaversor_m \cdot \boldsymbol{\hat{\Omega}^\prime}_{m^\prime}) \right]
 \cdot \psi_{m^\prime g^\prime}(\vec{x}) \\
+ \chi_g \sum_{g^\prime=1}^G \nu\Sigma_{fg^\prime}(\vec{x}) \sum_{m^\prime=1}^M w_{m^\prime} \cdot \psi_{m^\prime g^\prime}(\vec{x})
+ s_{mg}(\vec{x})
\end{gathered}$$ sobre el dominio espacial $U \in \mathbb{R}^n$
($n=1,2,3$) para el grupo de energía $g=1,\dots,G$ y para la
dirección $m=1,\dots,M$ con las condiciones de contorno de Dirichlet
discutidas en la
sección @sec-bctransporte:

$$\label{eq:transportesncc}
\psi_{mg}^{ij} =
 \begin{cases}
  \psi_{mg}(\vec{x}) = 0 
&\quad\quad \forall \vec{x} \in \Gamma_V \wedge \omegaversor_m \cdot \hat{\vec{n}}(\vec{x}) < 0 \\
  \psi_{mg}(\vec{x}) = \psi_{mg^\prime} \quad / \quad \omegaversor_{g^\prime} = \omegaversor_m - 2 \left( \omegaversor_m \cdot \hat{\vec{n}} \right) \hat{\vec{n}}
&\quad\quad \forall \vec{x} \in \Gamma_M \wedge \omegaversor_m \cdot \hat{\vec{n}}(\vec{x}) < 0 \\
  \psi_{mg}(\vec{x}) = f_{mg}(\vec{x})
&\quad\quad \forall \vec{x} \notin \Gamma_V \bigcup \Gamma_M \wedge \omegaversor_m \cdot \hat{\vec{n}}(\vec{x}) < 0 \\
 \end{cases}$$

Si el término de fuentes independientes $s_{mg}$ en la
ecuación [\[eq:transportesngeneral\]](#eq:transportesngeneral){reference-type="eqref"
reference="eq:transportesngeneral"} es nulo, entonces las condiciones de
contorno deben ser homogénes, es
decir $\Gamma_V \bigcup \Gamma_M = \partial U$ (recordar las
deficiones [\[def:ccvacuum\]](#def:ccvacuum){reference-type="ref"
reference="def:ccvacuum"}
y [\[def:ccmirror\]](#def:ccmirror){reference-type="ref"
reference="def:ccmirror"}). Además debemos incluir el factor de
multiplicación efectivo $k_\text{eff}$ dividiendo al término de fisiones
de la
ecuación [\[eq:transportesngeneral\]](#eq:transportesngeneral){reference-type="eqref"
reference="eq:transportesngeneral"}:

$$\begin{gathered}
\label{eq:transportesnkeff}
 \omegaversor_m \cdot \text{grad} \left[ \psi_{mg}(\vec{x}) \right]
 + \Sigma_{t g}(\vec{x}) \cdot \psi_{mg}(\vec{x}) = \\
  \sum_{g^\prime=1}^G \sum_{m^\prime=1}^M w_{m^\prime} \cdot
\left[  \sum_{\ell=0}^\infty (2\ell+1) \cdot \Sigma_{s_\ell \,g^\prime \rightarrow g}(\vec{x}) \cdot P_\ell (\omegaversor_m \cdot \boldsymbol{\hat{\Omega}^\prime}_{m^\prime}) \right]
 \cdot \psi_{m^\prime g^\prime}(\vec{x}) \\
+ \frac{\chi_g}{k_\text{eff}} \sum_{g^\prime=1}^G \nu\Sigma_{fg^\prime}(\vec{x}) \sum_{m^\prime=1}^M w_{m^\prime} \cdot \psi_{m^\prime g^\prime}(\vec{x})
\end{gathered}$$

#### Difusión de neutrones

La formulación fuerte del problema de difusión de neutrones discretizado
en energía mediante el método multigrupo es la
ecuación [\[eq:difusionmultigrupo\]](#eq:difusionmultigrupo){reference-type="eqref"
reference="eq:difusionmultigrupo"}

$$\begin{gathered}
 - \text{div} \Big[ D_g(\vec{x}) \cdot \text{grad} \left[ \phi_g(\vec{x}) \right] \Big]
 + \Sigma_{t g}(\vec{x}) \cdot \phi_g(\vec{x})
 = \\
\sum_{g^\prime = 1}^G \Sigma_{s_0 g^\prime \rightarrow g}(\vec{x})  \cdot \phi_{g^\prime}(\vec{x}) +
\chi_g \sum_{g^\prime = 1}^G \nu\Sigma_{fg^\prime}(\vec{x}) \cdot \phi_{g^\prime}(\vec{x})+ s_{0_g}(\vec{x})
\end{gathered}$$ sobre el dominio espacial $U \in \mathbb{R}^n$
($n=1,2,3$) para el grupo de energía $g=1,\dots,G$ con las condiciones
de contorno discutidas en la
sección @sec-bcdifusion:

$$\label{eq:difusioncc}
 \begin{cases}
  \phi_g(\vec{x}) = 0 
&\quad\quad \forall \vec{x} \in \Gamma_N \\
  \displaystyle \frac{\partial \phi_g}{\partial n} = 0
&\quad\quad \forall \vec{x} \in \Gamma_M \\
  \phi_g(\vec{x}) + 2\cdot D_g(\vec{x}) \cdot \displaystyle \frac{\partial \phi_g}{\partial n} = 0
&\quad\quad \forall \vec{x} \in \Gamma_V \\
  a_g(\vec{x} \cdot \phi_g(\vec{x}) + b_g(\vec{x}) \cdot \displaystyle \frac{\partial \phi_g}{\partial n} = c_g(\vec{x}
&\quad\quad \forall \vec{x} \notin \Gamma_N \bigcup \Gamma_M \bigcup \Gamma_V \\
 \end{cases}$$

Nuevamente, si el término de fuentes independientes $s_{0g}$ es nulo
entonces las condiciones de contorno deben ser homogéneas,
i.e. $\Gamma_N \bigcup \Gamma_M \bigcup \Gamma_V = \partial U$
(definiciones [\[def:ccvacuumdif\]](#def:ccvacuumdif){reference-type="ref"
reference="def:ccvacuumdif"},
[\[def:ccmirrordif\]](#def:ccmirrordif){reference-type="ref"
reference="def:ccmirrordif"}
y [\[def:ccnulldif\]](#def:ccnulldif){reference-type="ref"
reference="def:ccnulldif"}). Además debemos dividir el término de
fuentes por el factor de multiplicación efectivo $k_\text{eff}$:

$$\begin{gathered}
\label{eq:difusionmultigrupokeff}
 - \text{div} \Big[ D_g(\vec{x}) \cdot \text{grad} \left[ \phi_g(\vec{x}) \right] \Big]
 + \Sigma_{t g}(\vec{x}) \cdot \phi_g(\vec{x})
 = \\
\sum_{g^\prime = 1}^G \Sigma_{s_0 g^\prime \rightarrow g}(\vec{x})  \cdot \phi_{g^\prime}(\vec{x}) +
\frac{\chi_g}{k_\text{eff}} \sum_{g^\prime = 1}^G \nu\Sigma_{fg^\prime}(\vec{x}) \cdot \phi_{g^\prime}(\vec{x})
\end{gathered}$$

### Formulaciones integrales {#sec-integrales}

Dado que las ecuaciones de la sección anterior se cumplen punto a punto,
podemos operar lógica y matemáticamente sobre ellas para obtener otras
formulaciones más adecuadas para ser atacadas por esquemas de
discretización espacial. Las formulaciones integrales son la base de los
métodos basdos en volúmenes finitos y consisten en integrar las
ecuaciones sobre volúmenes de control.

#### Operador de Laplace escalar

#### Ordenadas discretas

Tomemos la
ecuación [\[eq:transportesngeneral\]](#eq:transportesngeneral){reference-type="eqref"
reference="eq:transportesngeneral"} e integrémosla en un cierto
volumen $V \subset U \subset \mathbb{R}^n$:

$$\begin{gathered}
 \int_V \omegaversor_m \cdot \text{grad} \left[ \psi_{mg}(\vec{x}) \right] \, d^n\vec{x}
 +
 \int_V \Sigma_{t g}(\vec{x}) \cdot \psi_{mg}(\vec{x}) \, d^n\vec{x} = \\
 \bigintsss_V \sum_{g^\prime=1}^G \sum_{m^\prime=1}^M w_{m^\prime} \cdot
\left[  \sum_{\ell=0}^\infty (2\ell+1) \cdot \Sigma_{s_\ell \,g^\prime \rightarrow g}(\vec{x}) \cdot P_\ell (\omegaversor_m \cdot \boldsymbol{\hat{\Omega}^\prime}_{m^\prime}) \right]
 \cdot \psi_{m^\prime g^\prime}(\vec{x}) \, d^n\vec{x} \\
+
 \int_V \chi_g \sum_{g^\prime=1}^G \nu\Sigma_{fg^\prime}(\vec{x}) \sum_{m^\prime=1}^M w_{m^\prime} \cdot \psi_{m^\prime g^\prime}(\vec{x}) \, d^n\vec{x}
+
 \int_V s_{mg}(\vec{x}) \, d^n\vec{x}
\end{gathered}$$

Dado que $\omegaversor_m$ no depende de $\vec{x}$, podemos evaluar el
primer término como

$$\begin{aligned}
 \int_V \omegaversor_m \cdot \text{grad} \left[ \psi_{mg}(\vec{x}) \right] \, d^n\vec{x} &=
 \int_V \text{div} \left[ \omegaversor_m \cdot \psi_{mg}(\vec{x}) \right] \, d^n\vec{x} \\
&=
 \int_S \left[ \omegaversor_m \cdot \psi_{mg}(\vec{x}) \right] \cdot \hat{\vec{n}}(\vec{x}) \, d^{n-1}\vec{x} \\
&=
 \int_S \psi_{mg}(\vec{x}) \cdot \left[ \omegaversor_m \cdot \hat{\vec{n}}(\vec{x})\right]  \, d^{n-1}\vec{x}
\end{aligned}$$ donde hemos utilizado el teorema de la divergencia, $S$
es la superficie del volúmen $V$ y $\hat{\vec{n}}$ es el versor normal a
la superficie $S$ en el punto $\vec{x}$ orientado hacia la dirección
exterior al volumen $V$. Es justamente esta operación, que reduce en uno
el orden del operador diferencia, la que hace que la formulación
integral sea de utilidad para la discretización espacial. De hecho en el
caso de la ecuación de transporte, este operador diferencial se
transforma en algebraico. En cualquier caso, la formulación integral de
la ecuación de transporte con ordenadas discretas es

$$\begin{gathered}
\label{eq:transportesnintegral}
 \int_S \psi_{mg}(\vec{x}) \cdot \left[ \omegaversor_m \cdot \hat{\vec{n}}(\vec{x})\right]  \, d^{n-1}\vec{x}
 +
 \int_V \Sigma_{t g}(\vec{x}) \cdot \psi_{mg}(\vec{x}) \, d^n\vec{x} = \\
 \sum_{g^\prime=1}^G \sum_{m^\prime=1}^M  w_{m^\prime} \cdot  \sum_{\ell=0}^\infty 
\int_V \Sigma_{s_\ell \,g^\prime \rightarrow g}(\vec{x}) \cdot (2\ell+1) \cdot P_\ell (\omegaversor_m \cdot \boldsymbol{\hat{\Omega}^\prime}_{m^\prime}) \cdot \psi_{m^\prime g^\prime}(\vec{x}) \, d^n\vec{x} \\
+
 \chi_g  \sum_{g^\prime=1}^G \sum_{m^\prime=1}^M  w_{m^\prime} \cdot \int_V \nu\Sigma_{fg^\prime}(\vec{x}) \cdot \psi_{m^\prime g^\prime}(\vec{x}) \, d^n\vec{x}
+
 \int_V s_{mg}(\vec{x}) \, d^n\vec{x}
\end{gathered}$$ sobre el dominio espacial $U \in \mathbb{R}^n$
($n=1,2,3$) para el grupo de energía $g=1,\dots,G$ con las mismas
condiciones de contorno de la formulación fuerte de la
ecuación [\[eq:transportesncc\]](#eq:transportesncc){reference-type="eqref"
reference="eq:transportesncc"}. Debemos notar que un conjunto de
funciones solución $\psi_{mg}$ que satisfaga la formulación débil
entonces también va a satisfacer la formulación integral. Sin embargo,
podemos encontrar otro conjunto de funciones solución $\psi_{mg}^\prime$
que satisfaga la formulación integral pero que no satisfaga la
formulación débil. De hecho, justamente las soluciones encontradas con
el método de volúmenes finitos satisfacen la formulación integral pero
no la formulación débil para volúmenes de control $V$ de tamaño finito.

#### Difusión de neutrones

Procediendo en forma análoga, integramos la formulación
fuerte [\[eq:difusionmultigrupo\]](#eq:difusionmultigrupo){reference-type="eqref"
reference="eq:difusionmultigrupo"} sobre un volúmen de
control $V \subset U \subset \mathbb{R}^n$:

$$\begin{gathered}
 - \int_V \text{div} \Big[ D_g(\vec{x}) \cdot \text{grad} \left[ \phi_g(\vec{x}) \right] \Big] \, d^n \vec{x}
 + \int_V \Sigma_{t g}(\vec{x}) \cdot \phi_g(\vec{x}) \, d^n \vec{x}
 = \\
 \int_V \sum_{g^\prime = 1}^G \Sigma_{s_0 g^\prime \rightarrow g}(\vec{x})  \cdot \phi_{g^\prime}(\vec{x}) \, d^n \vec{x}
+
 \int_V \chi_g \sum_{g^\prime = 1}^G \nu\Sigma_{fg^\prime}(\vec{x}) \cdot \phi_{g^\prime}(\vec{x}) \, d^n \vec{x}
 +
\int_V s_{0_g}(\vec{x}) \, d^n \vec{x}
\end{gathered}$$ sobre el dominio espacial $U \in \mathbb{R}^n$
($n=1,2,3$) para el grupo de energía $g=1,\dots,G$. Aplicando nuevamente
el teorema de la divergencia al primer término, tenemos

$$\int_V \text{div} \Big[ D_g(\vec{x}) \cdot \text{grad} \left[ \phi_g(\vec{x}) \right] \Big] \, d^n \vec{x} =
\int_S D_g(\vec{x}) \cdot \Big[ \text{grad} \left[ \phi_g(\vec{x}) \right] \cdot \hat{\vec{n}}(\vec{x}) \Big] \, d^{n-1} \vec{x}$$
donde nuevamente $S$ es la superficie del volúmen $V$ y $\hat{\vec{n}}$
es el versor normal exterior a la superficie $S$. De esta manera hemos
reducido el orden de la ecuación de dos a uno para obtener la
formulación integral como

$$\begin{gathered}
\label{eq:difusionintegral}
 - \int_S D_g(\vec{x}) \cdot \Big[ \text{grad} \left[ \phi_g(\vec{x}) \right] \cdot \hat{\vec{n}}(\vec{x}) \Big] \, d^{n-1} \vec{x}
 + \int_V \Sigma_{t g}(\vec{x}) \cdot \phi_g(\vec{x}) \, d^n \vec{x}
 = \\
 \sum_{g^\prime = 1}^G \int_V \Sigma_{s_0 g^\prime \rightarrow g}(\vec{x})  \cdot \phi_{g^\prime}(\vec{x}) \, d^n \vec{x}
+
 \chi_g \sum_{g^\prime = 1}^G \int_V  \nu\Sigma_{fg^\prime}(\vec{x}) \cdot \phi_{g^\prime}(\vec{x}) \, d^n \vec{x}
 +
\int_V s_{0_g}(\vec{x}) \, d^n \vec{x}
\end{gathered}$$ con las condiciones de contorno descriptas en la
ecuación [\[eq:difusioncc\]](#eq:difusioncc){reference-type="eqref"
reference="eq:difusioncc"}.

### Formulaciones débiles {#sec-debiles}

TO BE DONE

#### Operador de Laplace escalar


#### Ordenadas discretas

TO BE DONE

#### Difusión

TO BE DONE

## Discretización espacial por elementos finitos {#sec-discretizacion_espacial}


### Operador de Laplace escalar


El objetivo de la discretización espacial es obtener a partir de
ecuaciones que sólo dependen de la coordenada espacial $\vec{x}$ un
sistema de ecuaciones algebraicas cuyas incógnitas sean los valores que
toma el flujo ($\psi$ angular para transporte y escalar $\phi$ para
difusión) en una cierta cantidad $T$ finita de puntos del espacio: el
centro de las celdas para volúmenes finitos y los nodos para elementos
finitos, como mostramos a continuación. Para simplificar la notación,
utilizamos el concepto de *vector incógnita*.

::: definicion
Sea $\boldsymbol{\xi} \in \mathbb{R}^{TGM}$ un vector cuyos elementos
son los flujos incógnita $\psi_{mg}^t$ para las $m=1,\dots,M$
direcciones discretas, los $g=1,\dots,G$ grupos de energía evaluado en
los $t=1,\dots,T$ puntos $\vec{x}_t$ del espacio, ordenados de alguna
cierta manera. Para el caso de difusión tomamos $M=1$
y $\psi_{1g}^t = \phi_{g}^t$. Llamamos a $\boldsymbol{\xi}$ el *vector
incógnita*.
:::

Si las secciones eficaces sólo dependen de la posición $\vec{x}$ y no
del nivel de flujo de neutrones, entonces la ecuación de transporte---y
por lo tanto también la de difusión---es lineal sobre el flujo. Como
demostramos en lo que resta del capítulo, resulta entonces que la
formulación del problema discretizado puede ser escrita en forma
matricial.

::: definicion
Sean $R$ y $F$ son matrices de tamaño $TGM \times TGM$ y $\vec{S}$ un
vector de tamaño $IGM$. Llamamos *matriz de remoción* a $R$, *matriz de
fisión* a $F$ y *vector de fuentes* a $\vec{S}$. Los elementos de estos
objetos dependen de la formulación (ordenadas discretas o difusión) y
del esquema de discretización espacial (volúmenes o elementos finitos).
:::

Tenemos entonces dos casos que conducen a problemas matemáticos
diferentes. El primero consiste en aquellos problemas en los que la
fuente independiente $s$ es diferente de cero en el dominio
(multiplicativo o no), o bien en los que las condiciones de contorno son
no homogéneas (por ejemplo debido a una corriente entrante no nula). El
segundo es el caso de fuente independiente idénticamente nula y
condiciones de contorno homogéneas en presencia de un medio
multiplicativo. Este caso recibe el nombre de *cálculo de criticidad*,
donde además de una distribución espacial de flujo obtenemos un escalar
que indica qué tan lejos de la criticidad está la geometría propuesta.
En este trabajo utilizamos el concepto de *reactor crítico asociado
en $k$* [@duderstadt; @henry] en el cual dividimos a los términos de
fisión por un escalar $k_\text{eff}$. Matemáticamente, veremos más
adelante en este capítulo que podemos escribir

-   Problema con fuente independiente no nula o con condiciones de
    contorno no homogéneas:

    $$\begin{aligned}
     R \cdot \boldsymbol{\xi} = F \cdot \boldsymbol{\xi} + \vec{S} \\
     (R-F) \cdot \boldsymbol{\xi} = \vec{S} \\
    \end{aligned}$$

-   Problema sin fuente independiente con condiciones de contorno
    homogéneas:

    $$\begin{aligned}
     R \cdot \boldsymbol{\xi} = \frac{1}{k_\text{eff}} F \cdot \boldsymbol{\xi} \\
     k_\text{eff} \cdot R \cdot \boldsymbol{\xi} = F \cdot \boldsymbol{\xi} \\
    \end{aligned}$$


cuatro figuras: un cuadrado uniforme, un cuadrado con deltas x e y no
uniformes, un circulo con cosas radiales y un paralelogramo o algo curvo
con elementos que se van curvando. El último es estructurado pero
conviene tratarlo como no estructurado.

lo mismo no estructurado pero sobre algo que no sea un cuadrado (un
cuadrado con un pedazo redondo?): es una generalización, el estrucutrado
está contenido en el no estructurado.

ilustrar el efecto staircase, cuando realmente los elementos
combustibles son cuadrados zafa, pero el reflector radial siempre es
cilíndrico.

Definición de nodo: lo que tiene dimensión cero Definición de celda: lo
que tiene dimensión igual a la del problema

Todo lo demás, incluyendo nodos y celdas son elementos.

figuras de dmplex?


### Ecuación de difusión de neutrones

### Ordenadas discretas

## Problemas de estado estacionario {#sec-problemas-steady-state}

Si bien en el @sec-transporte-difusion hemos mantenido por completitud la dependencia temporal explícitamente en los flujos y corrientes, en esta tesis resolvemos solamente problemas de estado estacionario.
Al eliminar el término de la temporada con respecto al tiempo, las propiedades matemáticas de las ecuaciones cambian y por lo tanto debemos resolverlas en forma diferente según tengamos alguno de los siguientes tres casos:

 #. Medio no multiplicativo con fuentes independientes,
 #. Medio multiplicativo con fuentes independientes, y
 #. Medio multiplicativo sin fuentes independientes.

### Medio no multiplicativo con fuentes independientes

Un medio no multiplicativo es aquel que no contiene núcleos capaces de fisionar.
Cada neutrón que encontremos en el medio debe entonces provenir de una fuente externa $s$.
Para estudiar este tipo de problemas, además de eliminar la derivada temporal y la dependencia con el tiempo, tenemos que hacer cero el término de fisión.
Luego la ecuación de difusión queda

$$
\begin{gathered}
 - \text{div} \Big[ D(\vec{x}, E) \cdot \text{grad} \left[ \phi(\vec{x}, E) \right] \Big]
 + \Sigma_t(\vec{x}, E) \cdot \phi(\vec{x}, E)
 = \\
\int_{0}^{\infty} \Sigma_{s_0}(\vec{x}, E^{\prime} \rightarrow E)  \cdot \phi(\vec{x}, E^\prime) \, dE^\prime
+ s_0(\vec{x}, E)
\end{gathered}
$$ {#eq-difusionnmfi}
y la de transporte

$$ 
\begin{gathered}
 \omegaversor \cdot \text{grad} \left[ \psi(\vec{x}, \omegaversor, E) \right]
 + \Sigma_t(\vec{x}, E) \cdot \psi(\vec{x}, \omegaversor, E) = \\
\frac{1}{4\pi} \cdot 
\int_{0}^{\infty} \Sigma_{s_0}(\vec{x}, E^{\prime} \rightarrow E) \cdot \int_{4\pi} \psi(\vec{x}, \omegaprimaversor, E^{\prime}) \, d\omegaprimaversor \, dE^\prime + \\
\frac{3 \cdot \omegaversor}{4\pi} \cdot
\int_{0}^{\infty} \Sigma_{s_1}(\vec{x}, E^{\prime} \rightarrow E) \cdot \int_{4\pi} \psi(\vec{x}, \omegaprimaversor, E^{\prime}) \cdot \omegaprimaversor \, d\omegaprimaversor \, dE^\prime
+ s(\vec{x}, \omegaversor, E)
\end{gathered}
$$ {#eq-transportenmfi}


Para que la solución sea no trivial,

 a. la fuente no se debe anular idénticamente en el dominio, y/o
 b. las condiciones de contorno deben ser no homogéneas.
 
Si las secciones eficaces (incluyendo el coeficiente de difusión) dependen explícitamente de la posición $\vec{x}$ pero no dependen del flujo $\psi$ o $\phi$, entonces tanto la @eq-difusionnmfi como la [-@eq-transportenmfi] son lineales.
En las secciones siguientes discretizamos el problema para obtener un sistema de ecuaciones algebraicas lineales que puede ser escrito en forma matricial como

$$
\mat{A}_N(\Sigma_N) \cdot \symbf{\varphi}_N = \vec{b}_N(\Sigma_N)
$$ {#eq-Aub}
donde

 * $\symbf{\varphi}_N$ es un vector de tamaño $N \in \mathbb{N}$ que contiene la incógnita (flujo angular $\psi$ en transporte y flujo escalar $\phi$ en difusión) asociada a cada uno de los grados de libertad del problema discretizado (cantidad de incógnitas espaciales, grupos de energía y/o direcciones),
 * $\mat{A}_N(\Sigma_N) \in \mathbb{R}^{N \times N}$ es una matriz rala^[Del inglés [*sparse*]{lang=en-US}.] cuadrada que contiene información sobre
   a. las secciones eficaces macroscópicas, es decir los coeficientes de la ecuacion que estamos resolviendo, y
   b. la discretización de los operadores diferenciales e integrales,
 * $\vec{b}_N(\Sigma_N) \in \mathbb{R}^N$ es un vector que contiene
   a. la versión discretizada de la fuente independiente $s$, y/o
   b. las condiciones de contorno no homogéneas
 * $N$ es el tamaño del problema discretizado, que es el producto de 
   a. la cantidad de incógnitas espaciales (cantidad de nodos en elementos finitos y cantidad de celdas en volúmenes finitos),
   b. la cantidad de grupos de energía, y
   c. la cantidad de direcciones discretas (sólo para el método de ordenadas discetas).

 
El vector $\symbf{\varphi}_N \in \mathbb{R}^N$ es la incógnita, que luego de resolver el sistema permitirá estimar la función $\psi$ ó $\phi$ en función
de $\vec{x}$, $E$ y eventualmente $\omegaversor$ para todo punto del espacio $\vec{x}$ dependiendo de la discretización espacial.
Como ya mencionamos, en esta tesis utilizamos

 * el método multi-grupo de energías para discretizar $E$ y $E^\prime$,
 * el método de ordenadas discretas para discretizar $\omegaversor$ y $\omegaprimaversor$, y
 * el método de elementos finitos para discretizar el espacio $\vec{x}$.

**TODO** ejemplos de problemas del @sec-resultados

Si las secciones eficaces dependen directa o indirectamente del flujo, por ejemplo a través de concentraciones de venenos o de la temperatura de los materiales (que a su vez puede depender de la potencia disipada, que depende del flujo neutrónico) entonces el problema es no lineal.
En este caso, tenemos que volver a escribir la versión discretizada en forma genérica\ [-@eq-generica-numerica]

$$ \tag{\ref{eq-generica-numerica}}
\mathcal{F}_N(\symbf{\varphi}_N, \Sigma_N) = 0
$$
para alguna función vectorial $\mathcal{F}_N : [\mathbb{R}^{N} \times \mathbb{R}^{N^\prime}] \rightarrow \mathbb{R}^{N}$.^[El tamaño\ $N^\prime$ de la información relacionada con los datos de entrada\ $\Sigma_N$ no tiene por que ser igual al tamaño\ $N$ del vector solución.]
La forma más eficiente de resolver estos problemas es utilizar variaciones del esquema de Newton @petsc-user-ref, donde la incógnita $\symbf{\varphi}_N$ se obtiene iterando a partir de una solución inicial^[El término correcto es [*initial guess*]{lang=en-US}.] $\symbf{\varphi}_{N0}$

$$
\symbf{\varphi}_{Nk+1} = \symbf{\varphi}_{Nk} - \mat{J}_N(\symbf{\varphi}_{Nk}, \Sigma_{Nk})^{-1} \cdot \mathcal{F}_N(\symbf{\varphi}_{Nk}, \Sigma_{Nk})
$$
para los pasos $k=0,1,\dots$, donde $\mat{J}_N$ es la matrix jacobiana de la función $\mathcal{F}_N$.
Dado que la inversa de una matriz rala es densa, es prohibitivo evaluar (¡y almacenar!) explícitamente\ $\mat{J}_N^{-1}$.
En la práctica, la iteración de Newton se implementa mediante los siguientes dos pasos:

 1. Resolver $\mat{J}(\symbf{\varphi}_{Nk}, \Sigma_{Nk}) \cdot \Delta \symbf{\varphi}_{Nk} = -\mathcal{F}_N(\symbf{\varphi}_{Nk}, \Sigma_{Nk})$
 2. Actualizar $\symbf{\varphi}_{Nk+1} \leftarrow \symbf{\varphi}_{Nk} + \Delta \symbf{\varphi}_{Nk}$

Es por eso que  la formulación discreta de la @eq-Aub es central tanto para problemas lineales como no lineales.


### Medio multiplicativo con fuentes independientes {#sec-multiplicativoconfuente}

Si además de contar con fuentes independientes de fisión el medio contiene material multiplicativo, entonces los neutrones pueden provenir tanto de las fuentes independientes como de las fisiones.
En este caso, tenemos que tener en cuenta la fuente de fisión, cuyo valor en la posición $\vec{x}$ es proporcional al flujo escalar $\phi(\vec{x})$.
En la @sec-fision indicamos que debemos utilizar expresiones diferentes para la fuente de fisión dependiendo de si estamos resolviendo un problema transitorio o estacionario.
Si bien solamente una fracción $\beta$ de todos los neutrones nacidos por fisión se generan en forma instantánea, en el estado estacionario debemos también sumar el resto de los $(1-\beta)$ como fuente de fisión ya que suponemos el estado encontrado es un equilibrio instante a instante dado por los $\beta$ neutrones [prompt]{lang=en-US} y $(1-\beta)$ neutrones retardados que provienen de fisiones operando desde un tiempo $t=-\infty$.

En este caso, las ecuaciones apropiadas son las que ya hemos reproducido al comienzo del capítulo:

$$ \tag{\ref{eq-difusion}}
\begin{gathered}
 - \text{div} \Big[ D(\vec{x}, E) \cdot \text{grad} \left[ \phi(\vec{x}, E) \right] \Big]
 + \Sigma_t(\vec{x}, E) \cdot \phi(\vec{x}, E)
 = \\
\int_{0}^{\infty} \Sigma_{s_0}(\vec{x}, E^{\prime} \rightarrow E)  \cdot \phi(\vec{x}, E^\prime) \, dE^\prime +
\chi(E) \int_{0}^{\infty} \nu\Sigma_f(\vec{x}, E^\prime) \cdot \phi(\vec{x}, E^\prime) \, dE^\prime
+ s_0(\vec{x}, E)
\end{gathered}
$$

y

$$ \tag{\ref{eq-transporte-linealmente-anisotropica}}
\begin{gathered}
 \omegaversor \cdot \text{grad} \left[ \psi(\vec{x}, \omegaversor, E) \right]
 + \Sigma_t(\vec{x}, E) \cdot \psi(\vec{x}, \omegaversor, E) = \\
\frac{1}{4\pi} \cdot 
\int_{0}^{\infty} \Sigma_{s_0}(\vec{x}, E^{\prime} \rightarrow E) \cdot \int_{4\pi} \psi(\vec{x}, \omegaprimaversor, E^{\prime}) \, d\omegaprimaversor \, dE^\prime + \\
\frac{3 \cdot \omegaversor}{4\pi} \cdot
\int_{0}^{\infty} \Sigma_{s_1}(\vec{x}, E^{\prime} \rightarrow E) \cdot \int_{4\pi} \psi(\vec{x}, \omegaprimaversor, E^{\prime}) \cdot \omegaprimaversor \, d\omegaprimaversor \, dE^\prime  \\
+ \frac{\chi(E)}{4\pi} \int_{0}^{\infty} \nu\Sigma_f(\vec{x}, E^\prime) \cdot \int_{4\pi} \psi(\vec{x}, \omegaprimaversor, E^{\prime}) \, d\omegaprimaversor \, dE^\prime 
+ s(\vec{x}, \omegaversor, E)
\end{gathered}
$$ 


El tipo de problema discretizado es esencialmente similar al caso del medio no multiplicativo con fuentes de la sección anterior, sólo que ahora la matriz $\mat{A}_N(\Sigma_N)$ contiene información sobre las fuentes de fisión, que son lineales con la incógnita $\symbf{\varphi}_N$.
Estos casos se encuentran al estudiar sistemas subcríticos como por ejemplo piletas de almacenamiento de combustibles gastados o procedimientos de puesta a crítico de reactores.

### Medio multiplicativo sin fuentes independientes

En ausencia de fuentes independientes, las ecuación de transporte y difusión continuas se pueden escribir genéricamente como @stammler

$$
\frac{\partial \varphi}{\partial t} = \mathcal{L}\left[\varphi(\vec{x},\omegaversor, E,t)\right]
$$ {#eq-psi-L}
donde $\varphi = \psi$ para transporte y $\varphi = \phi$ para difusión (sin dependencia de $\omegaversor$), y $\mathcal{L}$ es un operador lineal homogéneo de primer orden en el espacio para transporte y de segundo orden para difusión.
Esta formulación tiene infinitas soluciones de la forma

$$
\varphi(\vec{x},\omegaversor, E,t) = \varphi_n(\vec{x},\omegaversor, E) \cdot e^{\alpha_n \cdot t}
$$
que al insertarlas en la @eq-psi-L definen un problema de autovalores ya que

$$
\begin{aligned}
\frac{\partial}{\partial t} \left[ \varphi_n(\vec{x},\omegaversor, E) \cdot e^{\alpha_n \cdot t} \right] 
&=
\mathcal{L}\left[\varphi_n(\vec{x},\omegaversor, E) \cdot e^{\alpha_n\cdot t} \right] \\
\alpha_n \cdot \varphi_n(\vec{x},\omegaversor, E) \cdot e^{\alpha_n\cdot t}
&=
\mathcal{L}\left[\varphi_n(\vec{x},\omegaversor, E) \cdot e^{\alpha_n\cdot t} \right] \\
\alpha_n \cdot \varphi_n(\vec{x},\omegaversor, E)
&=
\mathcal{L}\left[\varphi_n(\vec{x},\omegaversor, E)\right]
\end{aligned}
$$
donde ni $\alpha_n$ ni $\varphi_n$ dependen del tiempo $t$.

La solución general de la @eq-psi-L es entonces

$$
\varphi(\vec{x},\omegaversor, E,t) = \sum_{n=0}^\infty C_n \cdot \varphi_n(\vec{x},\omegaversor,E) \cdot \exp(\alpha_n \cdot t)
$$
donde los coeficientes $C_n$ son tales que satisfagan las condiciones iniciales y de contorno.

Si ordenamos los autovalores $\alpha_n$ de forma tal que $\text{Re}(\alpha_n) \ge \text{Re}(\alpha_{n+1})$ entonces para tiempos $t\gg 1$ todos los términos para $n \neq 0$ serán despreciables frente al término de $\varphi_0$.
El signo de $\alpha_0$ determina si la población neutrónica

 a. disminuye con el tiempo ($\alpha_0 < 0$),
 b. permanece constante ($\alpha_0 = 0$), o
 c. aumenta con el tiempo ($\alpha_0 > 0$).
 
La probabilidad de que en un sistema multiplicativo sin una fuente independiente (es decir, un reactor nuclear de fisión) el primer autovalor $\alpha_0$ sea exactamente cero para poder tener una solución de estado estacionario no trivial es cero.
Para tener una solución matemática no trivial, debemos agregar al menos un parámetro real que permita ajustar uno o más términos en forma continua para lograr ficticiamente que $\alpha_0 = 0$.
Por ejemplo podríamos escribir las secciones eficaces en función de un parámetro $\xi$ que podría ser

 a. geométrico (por ejemplo la posición de una barra de control), o
 b. físico (por ejemplo la concentración media de boro en el moderador).
 
De esta forma, podríamos encontrar un valor de $\xi$ que haga que $\alpha_0 = 0$ y haya una solución de estado estacionario.

Hay un parámetro real que, además de permitir encontrar una solución no trivial para cualquier conjunto físicamente razonable de geometrías y secciones eficaces, nos da una idea de qué tan lejos se encuentra el modelo de la criticidad.
El procedimiento consiste en dividir el término de fisiones por un número real $k_\text{eff} > 0$, para obtener la ecuación de difusión como

$$\begin{gathered}
 - \text{div} \Big[ D(\vec{x}, E) \cdot \text{grad} \left[ \phi(\vec{x}, E) \right] \Big]
 + \Sigma_t(\vec{x}, E) \cdot \phi(\vec{x}, E)
 = \\
\int_{0}^{\infty} \Sigma_{s_0}(\vec{x}, E^{\prime} \rightarrow E)  \cdot \phi(\vec{x}, E^\prime) \, dE^\prime +
\frac{1}{k_\text{eff}} \cdot \chi(E) \int_{0}^{\infty} \nu\Sigma_f(\vec{x}, E^\prime) \cdot \phi(\vec{x}, E^\prime) \, dE^\prime
\end{gathered}
$$
y la de transporte como

$$
\begin{gathered}
 \omegaversor \cdot \text{grad} \left[ \psi(\vec{x}, \omegaversor, E) \right]
 + \Sigma_t(\vec{x}, E) \cdot \psi(\vec{x}, \omegaversor, E) = \\
\frac{1}{4\pi} \cdot 
\int_{0}^{\infty} \Sigma_{s_0}(\vec{x}, E^{\prime} \rightarrow E) \cdot \int_{4\pi} \psi(\vec{x}, \omegaprimaversor, E^{\prime}) \, d\omegaprimaversor \, dE^\prime + \\
\frac{3 \cdot \omegaversor}{4\pi} \cdot
\int_{0}^{\infty} \Sigma_{s_1}(\vec{x}, E^{\prime} \rightarrow E) \cdot \int_{4\pi} \psi(\vec{x}, \omegaprimaversor, E^{\prime}) \cdot \omegaprimaversor \, d\omegaprimaversor \, dE^\prime  \\
+ \frac{1}{k_\text{eff}} \cdot \frac{\chi(E)}{4\pi} \int_{0}^{\infty} \nu\Sigma_f(\vec{x}, E^\prime) \cdot \int_{4\pi} \psi(\vec{x}, \omegaprimaversor, E^{\prime}) \, d\omegaprimaversor \, dE^\prime
\end{gathered}
$$ 


La utilidad del factor $k_\text{eff}$ queda reflejada en la siguiente definición.

::: {#def-keff}
Llamamos *factor de multiplicación efectivo* al número real $k_\text{eff}$ por el cual dividimos la fuente de fisiones de las
ecuaciones que modelan un medio multiplicativo sin fuentes externas.
Al nuevo medio al cual se le han dividido sus fuentes de fisión por $k_\text{eff}$ lo denominamos *reactor crítico asociado en $k$*.
Si $k_\text{eff}>1$ entonces el reactor original estaba supercrítico ya que hubo que disminuir sus fisiones para encontrar una solución no
trivial, y viceversa.
El flujo solución de las ecuaciones es el flujo del reactor crítico asociado en $k$ y no del original, ya que si el original no estaba crítico entonces éste no tiene solución estacionaria no trivial.
:::

Al no haber fuentes independientes, todos los términos están multiplicados por la incógnita y la ecuación es homogénea.
Sin embargo, ahora habrá algunos términos multiplicados por el coeficiente $1/k_\text{eff}$ y otros no.
Una vez más, si las secciones eficaces dependen sólo de la posición $\vec{x}$ en forma explícita y no a través del flujo, entonces el problema es lineal y al separar en ambos miembros estos dos tipos de términos obtendremos una formulación discretizada de la forma

$$
\mat{A}_N(\Sigma_N) \cdot \symbf{\varphi}_N = \lambda_N \cdot \mat{B}(\Sigma_N) \cdot \symbf{\varphi}_N
$$ {#eq-eigen}
conformando un problema de autovalores generalizado, donde el autovalor $\lambda_N$ dará una idea aproximada de la criticidad del reactor y el autovector $\symbf{\varphi}_N$ la distribución de flujo del reactor crítico asociado en $k$.
Si $\mat{B}(\Sigma_N)$ contiene los términos de fisión entonces $\lambda_N = 1/k_{\text{eff}N}$ y si $\mat{A}_N(\Sigma_N)$ es la que contiene los términos de fisión, entonces $\lambda = k_{\text{eff}N}$.

En general, para matrices de $N \times N$ habrá $N$ pares autovalor-autovector.
Más aún, tanto el autovalor $\lambda_n$ como los elementos del autovector $\symbf{\varphi}_n$ en general serán complejos.
Sin embargo se puede probar [@henry] que, para el caso $\lambda=1/k_{\text{eff}N}$ ($\lambda=k_{\text{eff}N}$),

 #. hay un único autovalor positivo real que es mayor (menor) en magnitud que el resto de los autovalores,
 #. todos los elementos del autovector correspondiente a dicho autovalor son reales y tienen el mismo signo, y
 #. todos los otros autovectores o bien tienen al menos un elemento igual a cero o tienen elementos que difieren en su signo

Tanto el problema continuo como el discretizado en la @eq-eigen son matemáticamente homogéneos.
Esta característica define dos propiedades importantes:

 1. El autovector $\symbf{\varphi}_N$ (es decir el flujo neutronico) está definido a menos de una constante multiplicativa y es independiente del factor de multiplicación $k_{\text{eff}N}$. Para poder comparar soluciones debemos normalizar el flujo de alguna manera. Usualmente se define la potencia térmica total $P$ del reactor y se normaliza el flujo de forma tal que
    
    $$
    P = \int_{U} \int_0^\infty e\Sigma_f(\vec{x}, E) \cdot \phi(\vec{x}, E) \, dE \, d^3\vec{x}
    $$
    donde $e\Sigma_f$ es el producto entre la la energía liberada en una fisión individual y la sección eficaz macroscópica de fisión.
    Si $P$ es la potencia térmica instantánea, entonces $e\Sigma_f$ debe incluir sólo las contribuciones energéticas de los productos de fisión instantáneos.
    Si $P$ es la potencia térmica total, entonces $e\Sigma_f$ debe tener en cuenta todas las contribuciones, incluyendo aquellas debidas a efectos retardados de los productos de fisión.

 2. Las condiciones de contorno también deben ser homogéneas. Es decir, no es posible fijar valores de flujo o corrientes diferentes de cero. 

Si, en cambio, las secciones eficaces macroscópicas dependen directa o indirectamente del flujo neutrónico (por ejemplo a través de la concentración de venenos hijos de fisión o de la temperatura de los componentes del reactor a través de la potencia disipada) entonces el problema de autovalores toma la forma no lineal

$$
\mat{A}_N(\symbf{\varphi}_N,\Sigma_N) \cdot \symbf{\varphi}_N = \lambda_N \cdot \mat{B}(\symbf{\varphi}_N,\Sigma_N) \cdot \symbf{\varphi}_N
$$

Existen esquemas numéricos eficientes para resolver problemas de autovalores generalizados no lineales donde la no linealidad es con respecto al autovalor $\lambda_N$ @slepc-user-ref. Pero como en este caso la no linealidad es con el autovector\ $\symbf{\varphi}_N$ (es decir, con el flujo) y no con el autovalor (es decir el factor de multiplicación efectivo), no son aplicables.

En el caso no lineal resolvemos iterativamente

$$
\mat{A}(\symbf{\varphi}_{Nk},\Sigma_{Nk}) \cdot \symbf{\varphi}_{Nk+1} = \lambda_{Nk+1} \cdot \mat{B}(\symbf{\varphi}_{Nk},\Sigma_{Nk}) \cdot \symbf{\varphi}_{Nk+1}
$$
a partir de una solución inicial $\symbf{\varphi}_{N0}$.
En este caso el flujo está completamente determinado por la dependencia (explícita o implícita) de $\mat{A}$ y $\mat{B}$ con $\symbf{\varphi}_N$ y no hay ninguna constante multiplicativa arbitraria.



Terminada la explicación del _cómo_ ([how]{lang=en-US}), pasemos entonces al _qué_ ([what]{lang=en-US}).

# Esquemas de discretización numérica {#cap:esquemas}

::: chapterquote
*CITA DE PIAGET - RUBBER DUCK DEBUGGING*
:::

Las formulaciones de los modelos matemáticos del transporte y difusión
de neutrones en estado estacionario desarrollados en el capítulo
anterior arrojan expresiones integro-diferenciales sobre seis escalares
independientes: tres para el espacio $\vec{x}$, dos para la
dirección $\omegaversor$ y uno para la energía $E$. En este capítulo
vamos a ir transformando estas dependencias y operadores continuos a
versiones discretas para poder ser resueltas con computadoras digitales.
Comenzamos primero por la energía aplicando la idea de grupos discretos
de energías y continuamos por la dependencia angular con el método de
ordenadas discretas S$_N$, que sólo aplica a la formulación de
transporte. Finalmente prestamos atención a la discretización espacial,
que es el aporte principal de esta tesis al problema del análisis de
reactores nucleares de potencia moderados por auga pesada. En este
trabajo desarrollamos dos esquemas: uno basado en volúmenes finitos y
otro basado en elementos finitos. Dejamos fuera de toda discusión a los
esquemas basados en diferencias finitas porque si bien son los más
sencillos de todoss, estos esquemas no pueden manejar discontinudades en
las propiedades materiales ni mallas no estructuradas, que es el tema
central de esta tesis.

Este capítulo podríamos haberlo organizado de dos maneras diferentes. La
primera es desarrollar completamente S$_N$, primero discertizando en
energía, luego en ángulo y finalmente en el espacio, primero con
volúmenes finitos y luego en elementos, para después pasar a estudiar
completamente difusión comenzando con la energía y continuado con el
espacio primero en volúmenes y finalmente en elementos finitos. La
segunda es estudiar primero la discretización en energía para tanto para
transporte como para difusión, luego analizar la discretización angular
de transporte y pasar finalmente a la discretización espacial tanto de
ordenadas discretas como de difusión primero con volúmenes finitos y
luego terminar con transporte y difusión formuladas con elementos
finitos. Elegimos la segunda organización.

## Discretización en energía

Vamos a discretizar el dominio de la energía $E$ utilizando el concepto
clásico de física de reactores de *grupos de energías*, que llevado a
conceptos más generales de matemática discreta es equivalente a aplicar
el método de volúmenes finitos, sólo que esta vez los volúmenes son
volúmenes de energía. En efecto, tomemos el intervalo de
energías $[0,E_0]$ donde $E_0$ es la mayor energía esperada de un
neutrón individual. Como ilustramos en la
figura [1.1](#fig:multigroup){reference-type="ref"
reference="fig:multigroup"}, dividamos dicho intervalo en $G$ grupos
(volúmenes) no necesariamente iguales cada uno definido por energías de
corte $0=E_G < E_{G-1} < \dots < E_2 < E_1 < E_0$, de forma tal que el
grupo $g$ es el intervalo $[E_g,E_{g-1}]$. Notamos que con esta
notación, el grupo número uno siempre es el de mayor energía. A medida
que un neutrón va perdiendo energía, va aumentando el número de su grupo
de energía.

<figure id="fig:multigroup">
<div class="center">
<img src="esquemas/multigroup-energy" />
</div>
<figcaption><span id="fig:multigroup"
label="fig:multigroup"></span>Discretización del dominio energético en
grupos (volúmenes) de energía. Tomamos la mayor energía esperada <span
class="math inline"><em>E</em><sub>0</sub></span> y divididmos el
intervalo <span class="math inline">[0,<em>E</em><sub>0</sub>]</span>
en <span class="math inline"><em>G</em></span> grupos, no necesariamente
iguales. El esquema matemático es equivalente a una discretización por
volúmenes finitos. El grupo uno es el de mayor energía.</figcaption>
</figure>

El objetivo de discretizar la energía en $G$ grupos es transformar la
dependencia continua del flujo $\psi(\vec{x}, \omegaversor, E)$ por $G$
funciones $\psi_g(\vec{x}, \omegaversor)$. De la misma manera, pasar
de $\phi(\vec{x}, E)$ a $G$ funciones $\phi_g(\vec{x})$.

::: definicion
[]{#def:flujogrupo label="def:flujogrupo"} El flujo angular del
grupo $g$ es

$$\psi_g(\vec{x}, \omegaversor) = \int_{E_g}^{E_{g-1}} \psi(\vec{x}, \omegaversor, E) \, dE$$
y el flujo escalar del grupo $g$ es

$$\phi_g(\vec{x}) = \int_{E_g}^{E_{g-1}} \phi(\vec{x}, E) \, dE$$

Notamos que $\psi(\vec{x}, \omegaversor, E$
y $\psi_g(\vec{x}, \omegaversor)$ no tienen las mismas unidades. La
primera magnitud tiene unidades de inversa de área por inversa de ángulo
sólido por inversa de energía por inversa de tiempo (i.e.
$\text{cm}^{-2} \cdot \text{eV}^{-1} \cdot \text{s}^{-1}$, mientras que
la segunda es un flujo integrado por lo que sus unidades son inversa de
área por inversa de ángulo sólido por inversa de tiempo (i.e.
$\text{cm}^{-2} \cdot \text{s}^{-1}$). La misma idea aplica
a $\phi(\vec{x}, E)$ y a $\phi_g(\vec{x})$.
:::

La idea de la discretización es re-escribir las ecuaciones de transporte
y/o difusión en función de los flujos de grupo. Para fijar ideas,
prestemos atención al término de absorción total de la ecuación de
transporte $\Sigma_t \cdot \psi$, e integrémoslo entre $E_g$
y $E_{g-1}$. Quisiéramos que esta integral sea igual al producto entre
el flujo $\psi_g$ y el valor medio de la sección eficaz total en dicho
grupo:

$$\int_{E_g}^{E_{g-1}} \Sigma_t(\vec{x}, E) \cdot \psi(\vec{x}, \omegaversor, E) \, dE =
\Sigma_{t g}(\vec{x}) \cdot \psi_g(\vec{x}, \omegaversor)$$

Está claro que para que esto sea posible, la sección eficaz
total $\Sigma_{t g}$ media en el grupo $g$ debe ser

$$\label{eq:sigmatg}
\Sigma_{t g}(\vec{x}) = \frac{\displaystyle \int_{E_g}^{E_{g-1}} \Sigma_t(\vec{x}, E) \cdot \psi(\vec{x}, \omegaversor, E) \, dE}{\displaystyle \int_{E_g}^{E_{g-1}} \psi(\vec{x}, \omegaversor, E) \, dE}$$
con lo que no hemos ganado nada ya que llegamos a una condición
tautológica donde el parámetro que necesitamos para no necesitar la
dependencia explícita del flujo con la energía depende justamente de
dicha dependencia. Sin embargo, y es ésta una de las ideas centrales del
cálculo y análisis de reactores, podemos suponer que el cálculo de celda
es capaz de proveernos las secciones eficaz macroscópicas multigrupo
para el reactor que estamos modelando de forma tal que, desde el punto
de vista del cálculo de núcleo, $\Sigma_{t g}$ y todas las demás
secciones eficaces son distribuciones conocidas del espacio $\vec{x}$.

Procediendo en forma análoga con la sección eficaz de fisión, tenemos
que

$$\label{eq:nusigmafg}
\nu\Sigma_{f g}(\vec{x}) = \frac{\displaystyle \int_{E_g}^{E_{g-1}} \nu\Sigma_f(\vec{x}, E) \cdot \psi(\vec{x}, \omegaversor, E) \, dE}{\displaystyle \int_{E_g}^{E_{g-1}} \psi(\vec{x}, \omegaversor, E) \, dE}$$

Para el caso del término de scattering, la sección eficaz de scattering
desde el ángulo $\omegaprimaversor$ hacia el ángulo $\omegaversor$ y
desde el grupo de energía $g^\prime$ hacia el grupo $g$ es

$$\label{eq:sigmasggprima}
\Sigma_{s g^\prime \rightarrow g}(\vec{x}, \omegaprimaversor \rightarrow \omegaversor) =
\frac{\displaystyle \int_{E_g}^{E_{g-1}} \int_{E^\prime_{g^\prime}}^{E^\prime_{g^\prime -1}}
\Sigma_{s}(\vec{x}, \omegaprimaversor \rightarrow \omegaversor, E^\prime \rightarrow E) \cdot \psi(\vec{x}, \omegaprimaversor, E^\prime) \, dE^\prime \, dE }
{\displaystyle \int_{E_g}^{E_{g-1}} \int_{E^\prime_{g^\prime}}^{E^\prime_{g^\prime -1}} \psi(\vec{x}, \omegaprimaversor, E^\prime) \, dE^\prime \, dE}$$

Tomemos entonces el caso de medio multiplicativo con fuente de la
sección [\[sec:multiplicativoconfuente\]](#sec:multiplicativoconfuente){reference-type="ref"
reference="sec:multiplicativoconfuente"} e integremos la ecuación de
transporte [\[eq:transportemmfi\]](#eq:transportemmfi){reference-type="eqref"
reference="eq:transportemmfi"} sobre la energía $E$ en el grupo $g$, es
decir en el intervalo $E_g < E < E_{g-1}$:

$$\begin{gathered}
 \int_{E_g}^{E_{g-1}} \omegaversor \cdot \text{grad} \left[ \psi(\vec{x}, \omegaversor, E) \right] \, dE
 + \int_{E_g}^{E_{g-1}}  \Sigma_t(\vec{x}, E) \cdot \psi(\vec{x}, \omegaversor, E) \, dE = \\
 \int_{E_g}^{E_{g-1}}  \int_{0}^{\infty} \int_{4\pi} \Sigma_s(\vec{x}, \boldsymbol{\hat{\Omega}^\prime} \rightarrow \omegaversor, E^\prime \rightarrow E) \cdot \psi(\vec{x}, \boldsymbol{\hat{\Omega}^\prime}, E^\prime) \, d\boldsymbol{\hat{\Omega}^\prime} \, dE^\prime \, dE \\
+ \int_{E_g}^{E_{g-1}}  \frac{\chi(E)}{4\pi} \int_{0}^{\infty} \int_{4\pi} \nu\Sigma_f(\vec{x}, E^\prime) \cdot \psi(\vec{x}, \boldsymbol{\hat{\Omega}^\prime}, E^\prime) \, d\boldsymbol{\hat{\Omega}^\prime} \, dE^\prime \, dE
+ \int_{E_g}^{E_{g-1}}  s(\vec{x}, \omegaversor, E) \, dE
\end{gathered}$$

Utilizando la
definición [\[def:flujogrupo\]](#def:flujogrupo){reference-type="ref"
reference="def:flujogrupo"} y reemplazando las
ecuaciones [\[eq:sigmatg\]](#eq:sigmatg){reference-type="eqref"
reference="eq:sigmatg"},
[\[eq:nusigmafg\]](#eq:nusigmafg){reference-type="eqref"
reference="eq:nusigmafg"}
y [\[eq:sigmasggprima\]](#eq:sigmasggprima){reference-type="eqref"
reference="eq:sigmasggprima"}, obtenemos a las $G$ ecuaciones de
transporte multigrupo

$$\begin{gathered}
\label{eq:transportemultigrupo}
 \omegaversor \cdot \text{grad} \left[ \psi_g(\vec{x}, \omegaversor) \right]
 + \Sigma_{t g}(\vec{x}) \cdot \psi_g(\vec{x}, \omegaversor) = \\
 \sum_{g^\prime=1}^G \int_{4\pi} \Sigma_{sg^\prime \rightarrow g}(\vec{x}, \boldsymbol{\hat{\Omega}^\prime} \rightarrow \omegaversor) \cdot \psi_{g^\prime}(\vec{x}, \boldsymbol{\hat{\Omega}^\prime}) \, d\boldsymbol{\hat{\Omega}^\prime} \\
+ \frac{\chi_g}{4\pi} \sum_{g^\prime=1}^G \int_{4\pi} \nu\Sigma_{fg^\prime}(\vec{x}) \cdot \psi_{g^\prime}(\vec{x}, \boldsymbol{\hat{\Omega}^\prime}) \, d\boldsymbol{\hat{\Omega}^\prime}
+ s_g(\vec{x}, \omegaversor)
\end{gathered}$$ donde hemos definido implícitamente

$$\begin{aligned}
\chi_g &= \int_{E_g}^{E_{g-1}} \chi(E) \, dE\\
s_g(\vec{x}, \omegaversor) &= \int_{E_g}^{E_{g-1}} s(\vec{x}, \omegaversor, E) \, dE
\end{aligned}$$

Podemos generalizar la expansión en polinomios de Legendre del kernel de
scattering multigrupo basándonos en la expansión doble diferencial
introducida en la
ecuación [\[eq:sigmalegendreomega\]](#eq:sigmalegendreomega){reference-type="eqref"
reference="eq:sigmalegendreomega"} como

$$\label{eq:sigmasgprimeglegendre}
 \Sigma_{sg^\prime \rightarrow g}(\vec{x}, \omegaprimaversor\rightarrow \omegaversor) = \sum_{\ell=0}^{\infty} \frac{2\ell + 1}{4\pi} \cdot \Sigma_{s_\ell g^\prime \rightarrow g}(\vec{x}) \cdot P_\ell(\omegaversor \cdot \omegaprimaversor)$$
donde los coeficientes son

$$\label{eq:sigmasgprimegcoef}
 \Sigma_{s_\ell g^\prime \rightarrow g}(\vec{x}) =
 2\pi \int_{4\pi} \Sigma_{s g^\prime \rightarrow g}(\vec{x}, \omegaprimaversor \rightarrow \omegaversor) \cdot P_\ell(\omegaversor \cdot \omegaprimaversor) \, d\omegaprimaversor$$

Análogamente a la obtención de la ecuación de transporte
multigrupo [\[eq:transportemultigrupo\]](#eq:transportemultigrupo){reference-type="eqref"
reference="eq:transportemultigrupo"}, podemos integrar la ecuación de
difusión [\[eq:difusionmmfi\]](#eq:difusionmmfi){reference-type="eqref"
reference="eq:difusionmmfi"} sobre la energía en el
intervalo $E_g < E < E_{g-1}$ para obtener la ecuación de difusión
multigrupo:

$$\begin{gathered}
\label{eq:difusionmultigrupo}
 - \text{div} \Big[ D_g(\vec{x}) \cdot \text{grad} \left[ \phi_g(\vec{x}) \right] \Big]
 + \Sigma_{t g}(\vec{x}) \cdot \phi_g(\vec{x})
 = \\
\sum_{g^\prime = 1}^G \Sigma_{s_0 g^\prime \rightarrow g}(\vec{x})  \cdot \phi_{g^\prime}(\vec{x}) +
\chi_g \sum_{g^\prime = 1}^G \nu\Sigma_{fg^\prime}(\vec{x}) \cdot \phi_{g^\prime}(\vec{x})+ s_{0g}(\vec{x})
\end{gathered}$$

Matemáticamente, la aproximación multigrupo es equivalente a discretizar
el dominio de la energía con un esquema de volúmenes finitos con la
salvedad de que no hay operadores diferenciales con respecto a la
variable $E$.

comentarios sobre el coeficiente de difusión

## Discretización en ángulo

Para discretizar la dependencia espacial de la ecuación de transporte
multigrupo [\[eq:transportemultigrupo\]](#eq:transportemultigrupo){reference-type="eqref"
reference="eq:transportemultigrupo"} aplicamos el método de ordenadas
discretas o S$_N$ que también podemos ver como una mezcla de dos métodos
tradicionales. Por un lado, un esquema de volúmenes finitos con la
particularidad que los volúmenes de control pertenecen a la esfera
unitaria y tienen ubicaciones y áreas particulares según sea el
orden $N$ de la aproximación. Y por otro lado un método de colocación
con deltas de Dirac como pesos.

Comenzamos notando que la integral de cierta función escalar $f$ que
depende de la variable angular $\omegaversor$ sobre todas las
direcciones puede ser aproximada como $4\pi$ veces la suma de un
conjunto de $M$ pesos $w_m$ normalizados tal que $\sum w_m=1$
multiplicados por la función $f$ evaluada en $M$
direcciones $\omegaversor_m$. En efecto,

$$\begin{aligned}
 \int_{4\pi} f(\omegaversor) \, d\omegaversor &=
\sum_{m=1}^M \int_{\Omega_m} f(\omegaversor) \, d\omegaversor
= \sum_{m=1}^M \frac{\int_{\Omega_m} f(\omegaversor) \, d\omegaversor}{\int_{\Omega_m} d\omegaversor} \cdot \int_{\Omega_m} d\omegaversor \nonumber \\
&= \sum_{m=1}^M \langle f(\omegaversor) \rangle_m \cdot \Delta \Omega_m
= 4\pi  \sum_{m=1}^M w_m \cdot \langle f(\omegaversor) \rangle_m \nonumber \\
&\simeq 4\pi  \sum_{m=1}^M w_m \cdot f(\omegaversor_m) = 4\pi \sum_{m=1}^M w_m \cdot f_m \label{eq:cuadratura}
\end{aligned}$$ donde hemos notado que $\sum \Delta \Omega_m = 4\pi$ y
denotamos con un subíndice $m$ (¡otro más!) la evaluación de la
función $f$ en $\omegaversor_m$.

::: definicion
El flujo angular $\psi_{mg}$ del grupo $g$ en la ordenada discreta $m$
es igual al flujo angular $\psi_g$ del grupo $g$ (definido
en [\[def:flujogrupo\]](#def:flujogrupo){reference-type="ref"
reference="def:flujogrupo"}) evaluado en la dirección $\omegaversor_m$:

$$\psi_{mg}(\vec{x}) = \psi_{g}(\vec{x}, \omegaversor_m)$$

Esta vez $\psi_{mg}$ sí tiene la mismas unidades que $\psi_{g}$. Notamos
que que el flujo escalar $\phi_g$ del grupo $g$ es aproximadamente igual
a

$$\label{eq:phig_4pi_psimg}
\phi_g(\vec{x}) = \int_{4\pi} \psi_g(\vec{x}, \omegaversor) \, d\omegaversor 
\simeq 4\pi \sum_{m=1}^M w_m \cdot \psi_{mg}(\vec{x})$$
:::

Tomemos primero la integral de la segunda sumatoria del miembro derecho
de la
ecuación [\[eq:transportemultigrupo\]](#eq:transportemultigrupo){reference-type="eqref"
reference="eq:transportemultigrupo"}, i.e. el término de fisión, por ser
más sencilla de aproximar. En efecto, reemplacemos la integral por una
sumatoria sobre $M$ flujos discretos $\psi_{m^\prime g^\prime}$
evaluados en $\boldsymbol{\hat{\Omega}^\prime}$ y pesados con un cierto
peso $w_{m^\prime}$ asociado a cada una $M$ direcciones, en principio
arbitrarias:

$$\int_{4\pi} \nu\Sigma_{fg^\prime}(\vec{x}) \cdot \psi_{g^\prime}(\vec{x}, \boldsymbol{\hat{\Omega}^\prime}) \, d\boldsymbol{\hat{\Omega}^\prime}
\simeq 4\pi \cdot \nu\Sigma_{fg^\prime}(\vec{x}) \sum_{m^\prime=1}^M w_{m^\prime} \cdot \psi_{m^\prime g^\prime}(\vec{x})$$

Para evaluar el término de scattering hacemos lo mismo que para el
término de fisión, teniendo en cuenta que la variable a discretizar
es $\boldsymbol{\hat{\Omega}^\prime}$, que es sobre la cual integramos.
Dejamos sin discretizar---por ahora---la
variable $\boldsymbol{\hat{\Omega}}$) para obtener esta vez

$$\begin{aligned}
\int_{4\pi} \Sigma_{sg^\prime \rightarrow g}(\vec{x}, \boldsymbol{\hat{\Omega}^\prime} \rightarrow \omegaversor) \cdot \psi_{g^\prime}(\vec{x}, \boldsymbol{\hat{\Omega}^\prime}) \, d\boldsymbol{\hat{\Omega}^\prime}
& \simeq 4\pi  \sum_{m^\prime=1}^M w_{m^\prime} \cdot \Sigma_{sg^\prime \rightarrow g}(\vec{x}, \boldsymbol{\hat{\Omega}^\prime}_{m^\prime} \rightarrow \omegaversor) \cdot \psi_{m^\prime g^\prime}(\vec{x})
\end{aligned}$$

Expandiendo la sección eficaz de scattering multigrupo en polinomios de
Legendre utilizando la
ecuación [\[eq:sigmasgprimeglegendre\]](#eq:sigmasgprimeglegendre){reference-type="eqref"
reference="eq:sigmasgprimeglegendre"}, tenemos una aproximación de la
ecuación de transporte

$$\begin{gathered}
\label{eq:transporteapprox}
 \omegaversor \cdot \text{grad} \left[ \psi_g(\vec{x}, \omegaversor) \right]
 + \Sigma_{t g}(\vec{x}) \cdot \psi_g(\vec{x}, \omegaversor) = \\
 \sum_{g^\prime=1}^G 4\pi  \sum_{m^\prime=1}^M w_{m^\prime} \cdot 
\left[  \sum_{\ell=0}^\infty \frac{2\ell+1}{4\pi} \cdot \Sigma_{s_\ell \,g^\prime \rightarrow g}(\vec{x}) \cdot P_\ell (\omegaversor \cdot \boldsymbol{\hat{\Omega}^\prime}_{m^\prime}) \right]
\cdot \psi_{m^\prime g^\prime}(\vec{x}) 
 \\
+ \frac{\chi_g}{4\pi} \sum_{g^\prime=1}^G 4\pi \cdot \nu\Sigma_{fg^\prime}(\vec{x}) \sum_{m^\prime=1}^M w_{m^\prime} \cdot \psi_{m^\prime g^\prime}(\vec{x})
+ s_g(\vec{x}, \omegaversor)
\end{gathered}$$

Esta ecuación está discretizada en $\omegaprimaversor$ con un esquema
basado en volúmenes finitos sin operadores diferenciales sobre la
variable discretizada, pero aun es continua en $\omegaversor$. Para
discretizar esta variable, requerimos que la
ecuación [\[eq:transporteapprox\]](#eq:transporteapprox){reference-type="eqref"
reference="eq:transporteapprox"} se cumpla para las $M$
direcciones---aún arbitrarias. Es decir, la ecuación de transporte
multigrupo discretizada en ángulo según el método de ordenadas
discretas S$_N$ es el sistema de $M \times G$ ecuaciones

$$\begin{gathered}
\label{eq:transportesngeneral}
 \omegaversor_m \cdot \text{grad} \left[ \psi_{mg}(\vec{x}) \right]
 + \Sigma_{t g}(\vec{x}) \cdot \psi_{mg}(\vec{x}) = \\
  \sum_{g^\prime=1}^G \sum_{m^\prime=1}^M w_{m^\prime} \cdot
\left[  \sum_{\ell=0}^\infty (2\ell+1) \cdot \Sigma_{s_\ell \,g^\prime \rightarrow g}(\vec{x}) \cdot P_\ell (\omegaversor_m \cdot \boldsymbol{\hat{\Omega}^\prime}_{m^\prime}) \right]
 \cdot \psi_{m^\prime g^\prime}(\vec{x}) \\
+ \chi_g \sum_{g^\prime=1}^G \nu\Sigma_{fg^\prime}(\vec{x}) \sum_{m^\prime=1}^M w_{m^\prime} \cdot \psi_{m^\prime g^\prime}(\vec{x})
+ s_{mg}(\vec{x})
\end{gathered}$$ para $g=1,\dots,G$ y $m=1,\dots,M$. El hecho de
requerir que la ecuación
continua [\[eq:transporteapprox\]](#eq:transporteapprox){reference-type="eqref"
reference="eq:transporteapprox"} se satisfaga en un número finito de
puntos discretos es equivalente a aplicar un esquema de diferencias
finitas. Tal como en el caso de la aproximación multigrupo, y la
discretización sobre $\omegaprimaversor$, no hay operadores
diferenciales actuando sobre la variable $\omegaversor$.

Si el scattering es isotrópico, podemos simplificar el término de
scattering en la
ecuación [\[eq:transportesngeneral\]](#eq:transportesngeneral){reference-type="eqref"
reference="eq:transportesngeneral"} para obtener

$$\begin{gathered}
 \omegaversor_m \cdot \text{grad} \left[ \psi_{mg}(\vec{x}) \right]
 + \Sigma_{t g}(\vec{x}) \cdot \psi_{mg}(\vec{x}) = 
 \sum_{g^\prime=1}^G \sum_{m^\prime=1}^M w_{m^\prime} \cdot \Sigma_{s_0 \, g^\prime \rightarrow g}(\vec{x}) \cdot \psi_{m^\prime g^\prime}(\vec{x}) \\
+ \chi_g \sum_{g^\prime=1}^G \nu\Sigma_{fg^\prime}(\vec{x}) \sum_{m^\prime=1}^M w_{m^\prime} \cdot \psi_{m^\prime g^\prime}(\vec{x})
+ s_{mg}(\vec{x})
\end{gathered}$$

Si el scattering es linealmente anisotrópico, debemos agregar el término
correspondiente a $\ell=1$:

$$\begin{gathered}
 \omegaversor_m \cdot \text{grad} \left[ \psi_{mg}(\vec{x}) \right]
 + \Sigma_{t g}(\vec{x}) \cdot \psi_{mg}(\vec{x}) = \\
 \sum_{g^\prime=1}^G \sum_{m^\prime=1}^M w_{m^\prime} \cdot \left[ \Sigma_{s_0 \, g^\prime \rightarrow g}(\vec{x}) + 3 \cdot \Sigma_{s_1 \, g^\prime \rightarrow g}(\vec{x}) \cdot \left( \boldsymbol{\hat{\Omega}^\prime}_{m^\prime} \cdot \omegaversor_m \right) \right] \cdot \psi_{m^\prime g^\prime}(\vec{x}) \\
+ \chi_g \sum_{g^\prime=1}^G \nu\Sigma_{fg^\prime}(\vec{x}) \sum_{m^\prime=1}^M w_{m^\prime} \cdot \psi_{m^\prime g^\prime}(\vec{x})
+ s_{mg}(\vec{x})
\end{gathered}$$

Recordando la
ecuación [\[eq:qsfacil\]](#eq:qsfacil){reference-type="eqref"
reference="eq:qsfacil"}

$$\begin{gathered}
\tag{\ref{eq:qsfacil}}
 q_s(\vec{x}, \omegaversor, E, t) =
\frac{1}{4\pi} \int_{0}^{\infty} \Sigma_{s_0}(\vec{x}, E^{\prime} \rightarrow E) \cdot \phi(\vec{x}, E^{\prime}, t) \, dE^\prime \\
+ \frac{3}{4\pi} \int_{0}^{\infty} \Sigma_{s_1}(\vec{x}, E^{\prime} \rightarrow E) \cdot \left(\vec{J}(\vec{x},E^{\prime},t) \cdot \boldsymbol{\hat\Omega}\right) \, dE^\prime  \\
+ \sum_{\ell=2}^\infty \bigintsss_{0}^{\infty}   \left[ \Sigma_{s_\ell}(\vec{x}, E^{\prime} \rightarrow E) 
\sum_{m=-\ell}^{\ell} \Psi_\ell^m (\vec{x}, E^{\prime}, t) \cdot Y_\ell^{m}(\omegaversor)  \right] \, dE^{\prime}
\end{gathered}$$ y en virtud de la
ecuación [\[eq:phig_4pi_psimg\]](#eq:phig_4pi_psimg){reference-type="eqref"
reference="eq:phig_4pi_psimg"} también podemos escribir el término de
scattering $q_s\,mg$ en función del flujo escalar $\phi$ y de la
corriente $\vec{J}$ como

$$q_{s \, mg} =
\frac{1}{4\pi} \left[ \sum_{g^\prime=1}^{G} \Sigma_{s_0 \, g^\prime \rightarrow g}(\vec{x}) \cdot \phi_{g^\prime}(\vec{x})
+ 3 \cdot \Sigma_{s_1 \, g^\prime \rightarrow g}(\vec{x}) \cdot \left( \vec{J}_{g^\prime}(\vec{x}) \cdot \boldsymbol{\hat\Omega}_m  \right) \right]$$
y la ecuación de transporte multigrupo en ordenadas discretas para
scattering linealmente anisitrópico en función de ambos flujos $\phi$
y $\psi$ y de la corriente $\vec{J}$ como

$$\begin{gathered}
\label{eq:transporte_mgx}
 \omegaversor_m \cdot \text{grad} \left[ \psi_{mg}(\vec{x}) \right]
 + \Sigma_{t g}(\vec{x}) \cdot \psi_{mg}(\vec{x}) = \nonumber \\
 \sum_{g^\prime=1}^G \sum_{m^\prime=1}^M \Sigma_{s_0 \, g^\prime \rightarrow g}(\vec{x}) \cdot \phi_{g^\prime}(\vec{x})
+ 3 \cdot \Sigma_{s_1 \, g^\prime \rightarrow g}(\vec{x}) \cdot \left( \vec{J}_{g^\prime}(\vec{x}) \cdot \boldsymbol{\hat\Omega}_m  \right) \nonumber \\
+ \frac{\chi_g}{4\pi} \sum_{g^\prime=1}^G \nu\Sigma_{fg^\prime}(\vec{x}) \cdot \phi_{g^\prime}(\vec{x})
+ s_{mg}(\vec{x})
\end{gathered}$$

### Conjuntos de cuadraturas {#sec:cuadraturas}

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

::: center
::: {#tab:quadratureset}
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
  sección [1.2.2](#sec:dosdimensiones){reference-type="ref"
  reference="sec:dosdimensiones"}). Datos tomados de la
  referencia [@lewis Tabla 4-1 pág. 162].
:::
:::

::: center
::: {#tab:mus}
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
  y S$_2$. El índice $i$ indica el peso $w_i$ de la
  tabla [1.1](#tab:quadratureset){reference-type="ref"
  reference="tab:quadratureset"} aplicable a la dirección $m$.
:::
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

::: center
![image](esquemas/axes-with-octs){width="0.7\\linewidth"}
:::

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

### Dos dimensiones {#sec:dosdimensiones}

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
2\pi \sum_{m=1}^N \omega_m \cdot f_m =
4\pi \sum_{m=1}^N \frac{\omega_m}{2} \cdot f_m =
4\pi \sum_{m=1}^N w_m \cdot f_m$$

Si los puntos $\hat{\Omega}_{xm}$ y los pesos $\omega_m=2\cdot w_m$ son
los asociados a la integración de Gauss y $f(\hat{\Omega}_x)$ es un
polinomio de orden $2N-1$ o menos, entonces la integración es exacta
(ver apéndice [\[sec:gauss\]](#sec:gauss){reference-type="ref"
reference="sec:gauss"}) y la
ecuación [\[eq:1dgauss\]](#eq:1dgauss){reference-type="eqref"
reference="eq:1dgauss"} deja de ser una aproximación para transformarse
en una igualdad. En la tabla [1.3](#tab:gauss1d){reference-type="ref"
reference="tab:gauss1d"} mostramos el conjunto de cuadraturas utilizadas
para una dimensión, que contiene esencialmente las abscisas y los pesos
de la cuadratura de Gauss.

::: center
::: {#tab:gauss1d}
           $m$                  $\hat{\Omega}_{mx}$                   $\omega_m = 2 \cdot w_m$
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
  mitad de los pesos $\omega_m$ de la cuadratura de Gauss. Las
  direcciones $m=N/2+1,\dots,N$ no se muestran pero se obtienen
  como $\hat{\Omega}_{N/2+m \, x} = -\hat{\Omega}_{mx}$
  y $w_{N/2+m} = w_m$.
:::
:::

## Formulaciones fuertes, integrales y débiles

Antes de comenzar a discutir las discretizaciones espaciales tanto de la
ecuación de transporte multigrupo con ordenadas discretas como de la
ecuación de difusión multigrupo, introducimos las ideas de formulaciones
fuertes, integrales y débiles sobre las que se basan los esquemas de
discretización numérica basados en diferencias finitas, en volúmenes
finitos y en elementos finitos respectivamente. De esta forma, además,
resumimos las ecuaciones en derivadas parciales con respecto a las
coordenadas espaciales que debemos resolver para obtener la distribución
de flujo neutrónico de estado estacionario en un reactor nuclear.

### Formulaciones fuertes {#sec:fuertes}

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

#### Ordenadas discretas

La formulación fuerte del problema de transporte de neutrones
discretizado en energía mediante el método multigrupo y en ángulo
mediante ordenadas discretas es la ecuación
diferencial [\[eq:transportesngeneral\]](#eq:transportesngeneral){reference-type="eqref"
reference="eq:transportesngeneral"}

$$\begin{gathered}
\tag{\ref{eq:transportesngeneral}}
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
sección [\[sec:bctransporte\]](#sec:bctransporte){reference-type="ref"
reference="sec:bctransporte"}:

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

#### Difusión

La formulación fuerte del problema de difusión de neutrones discretizado
en energía mediante el método multigrupo es la
ecuación [\[eq:difusionmultigrupo\]](#eq:difusionmultigrupo){reference-type="eqref"
reference="eq:difusionmultigrupo"}

$$\begin{gathered}
\tag{\ref{eq:difusionmultigrupo}}
 - \text{div} \Big[ D_g(\vec{x}) \cdot \text{grad} \left[ \phi_g(\vec{x}) \right] \Big]
 + \Sigma_{t g}(\vec{x}) \cdot \phi_g(\vec{x})
 = \\
\sum_{g^\prime = 1}^G \Sigma_{s_0 g^\prime \rightarrow g}(\vec{x})  \cdot \phi_{g^\prime}(\vec{x}) +
\chi_g \sum_{g^\prime = 1}^G \nu\Sigma_{fg^\prime}(\vec{x}) \cdot \phi_{g^\prime}(\vec{x})+ s_{0_g}(\vec{x})
\end{gathered}$$ sobre el dominio espacial $U \in \mathbb{R}^n$
($n=1,2,3$) para el grupo de energía $g=1,\dots,G$ con las condiciones
de contorno discutidas en la
sección [\[sec:bcdifusion\]](#sec:bcdifusion){reference-type="ref"
reference="sec:bcdifusion"}:

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

### Formulaciones integrales {#sec:integrales}

Dado que las ecuaciones de la sección anterior se cumplen punto a punto,
podemos operar lógica y matemáticamente sobre ellas para obtener otras
formulaciones más adecuadas para ser atacadas por esquemas de
discretización espacial. Las formulaciones integrales son la base de los
métodos basdos en volúmenes finitos y consisten en integrar las
ecuaciones sobre volúmenes de control.

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

#### Difusión

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

### Formulaciones débiles {#sec:debiles}

TO BE DONE

#### Ordenadas discretas

TO BE DONE

#### Difusión

TO BE DONE

## Discretización espacial {#sec:discretizacion_espacial}

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

### Mallas estructuradas y no estructuradas

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

## Volúmenes finitos

El método de volúmenes finitos se basa en la formulación integral
discutida en la sección [1.3.2](#sec:integrales){reference-type="ref"
reference="sec:integrales"}. Los términos integrados sobre volúmenes son
aproximados por un valor medio del integrando multiplicado por el
volúmen de la celda. Los términos integrados sobre superficies son
reemplazados por aproximaciones de los integrandos sobre las superficies
a partir de los valores medios de las celdas adyacentes. Estos esquemas
se basan más en un enfoque geométrico que en un formalismo matemático
(al contrario de lo que sucede con el método de elementos finitos que
discutimos en la sección [1.6](#sec:elementos){reference-type="ref"
reference="sec:elementos"}), aunque es posible estudiar su errores y sus
propiedades de convergencia [@bookevol].

### Ordenadas discretas en volúmenes

En el método de los volúmenes finitos que proponemos, las incógnitas del
problema son los valores medios de los flujos en las $I$ celdas, a
diferencia de lo que sucede en diferencias o elementos finitos donde las
incógnitas son los valores que toman los flujos sobre los $K$ nodos.

::: definicion
El flujo angular del grupo $g=1,\dots,G$ en la dirección $m=1,\dots,M$
en la celda $i=1,\dots,I$ es

$$\label{eq:flujo-medio}
 \psi_{mg}^i = \frac{\displaystyle \int_{V_i} \psi_{mg}(\vec{x}) \, d^n\vec{x}}{\displaystyle \int_{V_i} \, d^n\vec{x}}$$
donde $V_i \in \mathbb{R}^n$ es el volumen del dominio $U$ ocupado por
la celda $i$.
:::

De esta manera, el problema consiste en encontrar
los $I \cdot G \cdot M$ valores $\psi_{mg}^i$, que son los elementos del
vector incógnita $\boldsymbol{\xi} \in \mathbb{R}^{IGM}$ definido en la
ecuación [\[eq:incognita\]](#eq:incognita){reference-type="eqref"
reference="eq:incognita"}. Para ello, tomamos la formulación integral
del problema de ordenadas discretas dada por la
ecuación [\[eq:transportesnintegral\]](#eq:transportesnintegral){reference-type="eqref"
reference="eq:transportesnintegral"} introducida en la
sección [1.3.2](#sec:integrales){reference-type="ref"
reference="sec:integrales"}

$$\begin{gathered}
\tag{\ref{eq:transportesnintegral}}
 \int_S \psi_{mg}(\vec{x}) \cdot \left[ \omegaversor_m \cdot \hat{\vec{n}}(\vec{x})\right]  \, d^{n-1}\vec{x}
 +
 \int_V \Sigma_{t g}(\vec{x}) \cdot \psi_{mg}(\vec{x}) \, d^n\vec{x} = \\
 \sum_{g^\prime=1}^G \sum_{m^\prime=1}^M  w_{m^\prime} \cdot  \sum_{\ell=0}^\infty 
\int_V \Sigma_{s_\ell \,g^\prime \rightarrow g}(\vec{x}) \cdot (2\ell+1) \cdot P_\ell (\omegaversor_m \cdot \boldsymbol{\hat{\Omega}^\prime}_{m^\prime}) \cdot \psi_{m^\prime g^\prime}(\vec{x}) \, d^n\vec{x} \\
+
 \chi_g  \sum_{g^\prime=1}^G \sum_{m^\prime=1}^M  w_{m^\prime} \cdot \int_V \nu\Sigma_{fg^\prime}(\vec{x}) \cdot \psi_{m^\prime g^\prime}(\vec{x}) \, d^n\vec{x}
+
 \int_V s_{mg}(\vec{x}) \, d^n\vec{x}
\end{gathered}$$ y analizamos cómo podemos aproximar cada término en
función de las incógnitas del problema, que son los flujos medios el las
celdas dados por la
ecuación [\[eq:flujo-medio\]](#eq:flujo-medio){reference-type="eqref"
reference="eq:flujo-medio"}.

#### Términos volumétricos

Exceptuando el primer y el último término de la
ecuación [\[eq:transportesnintegral\]](#eq:transportesnintegral){reference-type="eqref"
reference="eq:transportesnintegral"}, todos los demás tienen la forma

$$\label{eq:snvol1}
\int_{V} f(\vec{x}) \cdot \psi_{mg}(\vec{x}) \, d^n\vec{x}$$

Como la
ecuación [\[eq:transportesnintegral\]](#eq:transportesnintegral){reference-type="eqref"
reference="eq:transportesnintegral"} vale para cualquier volumen $V$
arbitrario, entonces deberá valer para cada volumen $V_i$ de las $I$
celdas que aproximan el dominio $U \in \mathbb{R}^n$. En particular,
podemos evaluar la
ecuación [\[eq:snvol1\]](#eq:snvol1){reference-type="eqref"
reference="eq:snvol1"} para la celda $i$-ésima multiplicando y
dividiendo por $\int_{V_i} \, d^n\vec{x}$ y
por $\int_{V_i} \psi_{mg}(\vec{x}) d^n\vec{x}$ y recordando la
definición [\[eq:flujo-medio\]](#eq:flujo-medio){reference-type="eqref"
reference="eq:flujo-medio"} de $\psi_{mg}^i$

$$\begin{aligned}
\label{eq:snvol2}
\int_{V_i} f(\vec{x}) \cdot \psi_{mg}(\vec{x}) \, d^n\vec{x} &=
\int_{V_i} f(\vec{x}) \cdot \psi_{mg}(\vec{x}) \, d^n\vec{x} \cdot
\frac{\displaystyle \int_{V_i} \, d^n\vec{x}}{\displaystyle \int_{V_i} \, d^n\vec{x}} \cdot
\frac{\displaystyle \int_{V_i} \psi_{mg}(\vec{x}) \, d^n\vec{x}}{\displaystyle \int_{V_i} \psi_{mg}(\vec{x}) \, d^n\vec{x}} \nonumber \\
&=
\frac{\displaystyle \int_{V_i} f(\vec{x}) \cdot \psi_{mg}(\vec{x}) \, d^n\vec{x}}{\displaystyle \int_{V_i} \psi_{mg}(\vec{x}) \, d^n\vec{x}} \cdot
\int_{V_i} \, d^n\vec{x} \cdot \psi_{mg}^i
\end{aligned}$$

Podemos aproximar la
ecuación [\[eq:snvol2\]](#eq:snvol2){reference-type="eqref"
reference="eq:snvol2"} como

$$\label{eq:snvol3}
  \int_{V_i} f(\vec{x}) \cdot \psi_{mg}(\vec{x}) \, d^n\vec{x} \approx
  \left[ \int_{V_i} f(\vec{x}) \, d^n\vec{x} \right] \cdot \psi_{mg}^i
=
 f^i \cdot V_i \cdot \psi_{mg}^i$$ donde directamente denotamos con la
variable $V_i$ al volumen $\int_{V_i} \, d^n\vec{x}$ de la celda.
Si $f(\vec{x})$ es idénticamente igual a una constante $f^i$ para
todo $\vec{x} \in V_i$, entonces debemos reemplazar el signo de
aproximación de la
ecuación [\[eq:snvol3\]](#eq:snvol3){reference-type="eqref"
reference="eq:snvol3"} por un signo de igualdad. Si $f(\vec{x})$ no es
uniforme dentro de la celda $i$, entonces debemos utilizar nuestro
juicio de ingeniería para evaluar qué tan válida es esta aproximación en
función del tamaño $V_i$ de la celda y de la magnitud del cambio
de $f(\vec{x}$) dentro de la misma.

#### Término de fugas {#sec:snvolfugas}

Por otro lado, el primer término de la formulación
integral [\[eq:transportesnintegral\]](#eq:transportesnintegral){reference-type="eqref"
reference="eq:transportesnintegral"} es el término que da la tasa neta
de fugas a través de la superficie externa del volumen $V$. En
particular, para la celda $i$, tenemos

$$\int_{S_i} \psi_{mg}(\vec{x}) \cdot \left[ \omegaversor_m \cdot \hat{\vec{n}}(\vec{x})\right]  \, d^{n-1}\vec{x}
= \sum_{j~\text{vecinos}} \int_{S_{ij}} \psi_{mg}(\vec{x}) \cdot \left( \omegaversor_m \cdot \hat{\vec{n}}_{ij}\right)  \, d^{n-1}\vec{x}$$
donde $J$ es la cantidad de caras planas que definen a la celda $i$
y $S_{ij}$ es la superficie que separa a la celda $i$ de la celda $j$
adyacente. En este caso, $\hat{\vec{n}}_{ij}$ es el versor normal a la
superficie $S_{ij}$ en la dirección externa a la celda $i$
(figura [1.6](#fig:nij){reference-type="ref" reference="fig:nij"}).
Decimos que las celdas $i$ y $j$ son *vecinos*. Como las superficies son
planas, entonces $\hat{\vec{n}}_{ij}$ no depende de $\vec{x}$ y el
producto escalar puede salir fuera de la integral

<figure id="fig:nij">
<div class="center">
<img src="esquemas/nij" />
</div>
<figcaption><span id="fig:nij" label="fig:nij"></span>Ilustración de la
superficie <span
class="math inline"><em>S</em><sub><em>i</em><em>j</em></sub></span> que
separada las celdas vecinas <span class="math inline"><em>i</em></span>
y <span class="math inline"><em>j</em></span> en una malla no
estructurada bidimensional. Los baricentros de las celdas son <span
class="math inline"><em>x⃗</em><sub><em>i</em></sub></span> y <span
class="math inline"><em>x⃗</em><sub><em>j</em></sub></span>
respectivamente. El baricentro de la superficie <span
class="math inline"><em>S</em><sub><em>i</em><em>j</em></sub></span>
es <span
class="math inline"><em>x⃗</em><sub><em>i</em><em>j</em></sub></span> y
la normal externa con respecto a <span
class="math inline"><em>i</em></span> es <span
class="math inline">$\hat{\vec{n}}_{ij}$</span>. </figcaption>
</figure>

$$\label{eq:snvol5}
 \int_{S_i} \psi_{mg}(\vec{x}) \cdot \left[ \omegaversor_m \cdot \hat{\vec{n}}(\vec{x})\right]  \, d^{n-1}\vec{x}
= \sum_{j~\text{vecinos}} \left( \omegaversor_m \cdot \hat{\vec{n}}_{ij}\right) \cdot \int_{S_{ij}} \psi_{mg}(\vec{x})  \, d^{n-1}\vec{x}$$

Ahora nos queda aproximar la integral del flujo escalar $\psi_{mg}$
sobre la superficie $S_{ij}$ en función de los valores
medios $\psi_{mg}^i$ y $\psi_{mg}^j$. Proponemos aproximar este término
como

$$\label{eq:snvol4}
 \int_{S_i} \psi_{mg}(\vec{x}) \cdot \left[ \omegaversor_m \cdot \hat{\vec{n}}(\vec{x})\right]  \, d^{n-1}\vec{x}
\approx \sum_{j~\text{vecinos}} \left( \omegaversor_m \cdot \hat{\vec{n}}_{ij}\right) \cdot  \left[ \omega_{ij} \cdot \psi_{mg}^i + (1-\omega_{ij}) \cdot \psi_{mg}^j \right] \cdot S_{ij}$$
siendo $S_{ij}$ el área de la cara que separa la celda $i$ de la
celda $j$ y donde hemos introducido un peso $0 \leq \omega_{ij} \leq 1$
que depende en principio de la geometrías de las celdas $i$ y $j$. En
efecto, siguiendo la idea de la interpolación de Shepard [@shepard] en
la cual un valor interpolado es la suma de los valores cercanos pesados
con alguna potencia $p$ de la distancia al punto de interpolación,
podemos plantear que si $x_i$ es el baricentro de la celda $i$, $x_j$ es
el baricentro de la celda $j$ y $x_{ij}$ es el baricentro de la
superficie que separa ambas celdas, entonces

$$\psi_{mg}^{ij} = \frac{\displaystyle \frac{\psi_{mg}^i}{|\vec{x}_{ij} - \vec{x}_i|^p} + \frac{\psi_{mg}^j}{|\vec{x}_{ij} - \vec{x}_j|^p}}
{\displaystyle \frac{1}{|\vec{x}_{ij} - \vec{x}_i|^p} + \frac{1}{|\vec{x}_{ij} - \vec{x}_j|^p}}$$
que podemos escribir en la forma que propusimos en la
ecuación [\[eq:snvol4\]](#eq:snvol4){reference-type="eqref"
reference="eq:snvol4"}

$$\psi_{mg}^{ij} = \tilde{\omega}_{ij} \cdot \psi_{mg}^i + (1-\tilde{\omega}_{ij}) \cdot \psi_{mg}^j$$
eligiendo como peso puramente geométrico

$$\label{eq:wij}
 \tilde{\omega}_{ij} = \frac{|\vec{x}_{ij} - \vec{x}_j|^p}{|\vec{x}_{ij} - \vec{x}_i|^p + |\vec{x}_{ij} - \vec{x}_j|^p}$$

<figure id="fig:shepard">
<div class="center">
<img src="esquemas/shepard" />
</div>
<figcaption><span id="fig:shepard"
label="fig:shepard"></span>Interpolación de dos puntos mediante su suma
pesada con la inversa de la distancia al punto de interpolación elevado
a una potencia <span class="math inline"><em>p</em></span> (método de
Shepard <span class="citation"
data-cites="shepard"></span>).</figcaption>
</figure>

En la figura [1.7](#fig:shepard){reference-type="ref"
reference="fig:shepard"} podemos observar que para $p=1$ recuperamos la
interpolación lineal tradicional. Para valores de $p>1$ se le da más
peso al punto más cercano, y viceversa. De hecho para $p=\infty$ la
interpolación arroja un resultado constante por trozos equivalente a la
interpolación constante a primeros vecinos. El caso $p=1$ es importante
porque es el único esquema de interpolación que da una estricta
conservación de neutrones. En efecto, según la
ecuación [\[eq:snvol5\]](#eq:snvol5){reference-type="eqref"
reference="eq:snvol5"} de la formulación integral continua tenemos que
para una cara plana que separa dos celdas se debe cumplir

$$\left( \omegaversor_m \cdot \hat{\vec{n}}_{ij}\right) \cdot \int_{S_{ij}} \psi_{mg}(\vec{x})  \, d^{n-1}\vec{x}
=
- \left( \omegaversor_m \cdot \hat{\vec{n}}_{ji}\right) \cdot \int_{S_{ji}} \psi_{mg}(\vec{x})  \, d^{n-1}\vec{x}$$

Con la aproximación de la
ecuación [\[eq:snvol4\]](#eq:snvol4){reference-type="eqref"
reference="eq:snvol4"}, se cumple que

$$\begin{gathered}
  \left( \omegaversor_m \cdot \hat{\vec{n}}_{ij}\right) \cdot  \left[ \tilde{\omega}_{ij} \cdot \psi_{mg}^i + (1-\tilde{\omega}_{ij}) \cdot \psi_{mg}^j \right] \cdot S_{ij} 
= \\
- \left( \omegaversor_m \cdot \hat{\vec{n}}_{ji}\right) \cdot  \left[ \tilde{\omega}_{ji} \cdot \psi_{mg}^j + (1-\tilde{\omega}_{ji}) \cdot \psi_{mg}^i \right] \cdot S_{ji} 
\end{gathered}$$ sólo si

$$\tilde{\omega}_{ji} = 1 - \tilde{\omega}_{ij}$$

Para cumplir esta condición de conservatividad hacemos entonces $p=1$ en
la definición del peso $\omega_{ij}$ de la
ecuación [\[eq:wij\]](#eq:wij){reference-type="eqref"
reference="eq:wij"}.

Independientemente de la formulación, la ecuación de transporte plantea
un problema hiperbólico que presenta dificultades para ser resuelto
numéricamente sin términos especiales para estabilizar la solución.
Efectivamente, los problemas de transporte inducen oscilaciones espurias
en las soluciones numéricas cuando son discretizados con esquemas
centrados. Dejamos una breve introducción y discusión del tema para el
apéndice [\[ap:oscilaciones\]](#ap:oscilaciones){reference-type="ref"
reference="ap:oscilaciones"}. Para evitar que aparezcan estas
oscilaciones que eventualmente pueden hacer que la solución diverja
debemos recurrir a esquemas con *upwinding* en la dirección del
transporte. Para el caso de neutrones sobre celdas, esto implica que en
una interfaz entre dos celdas debe tener más peso la celda que está
aguas abajo en la dirección de viaje del neutrón. Para ello introducimos
un factor $\alpha$ y definimos en peso $\omega_{ij}$ que utilizamos en
la ecuación [\[eq:snvol4\]](#eq:snvol4){reference-type="eqref"
reference="eq:snvol4"} como sigue.

::: definicion
El peso $\omega_{ij}$ estabilizado con upwinding para aproximar el flujo
escalar $\psi_{mg}^{ij}$ en la superficie plana $S_{ij}$ que separa las
celdas $i$ y $j$ en la
expresión [\[eq:snvol4\]](#eq:snvol4){reference-type="eqref"
reference="eq:snvol4"}

$$\tag{\ref{eq:snvol4}}
 \int_{S_i} \psi_{mg}(\vec{x}) \cdot \left[ \omegaversor_m \cdot \hat{\vec{n}}(\vec{x})\right]  \, d^{n-1}\vec{x}
\approx \sum_{j~\text{vecinos}} \left( \omegaversor_m \cdot \hat{\vec{n}}_{ij}\right) \cdot  \left[ \omega_{ij} \cdot \psi_{mg}^i + (1-\omega_{ij}) \cdot \psi_{mg}^j \right] \cdot S_{ij}$$
es

$$\label{eq:wij_estabilizado}
 \omega_{ij} =
\begin{cases}
 \tilde{\omega}_{ij} + \alpha \cdot (1 - \tilde{\omega}_{ij}) & \text{si $\omegaversor_m \cdot \hat{\vec{n}}_{ij} \ge 0$}\\
 \tilde{\omega}_{ij} - \alpha \cdot \tilde{\omega}_{ij}       & \text{si $\omegaversor_m \cdot \hat{\vec{n}}_{ij} < 0$}\\
\end{cases}$$ donde $\tilde{\omega}_{ij}$ es un peso geométrico, por
ejemplo el propuesto en la
ecuación [\[eq:wij\]](#eq:wij){reference-type="eqref"
reference="eq:wij"}

$$\tag{\ref{eq:wij}}
 \tilde{\omega}_{ij} = \frac{|\vec{x}_{ij} - \vec{x}_j|^p}{|\vec{x}_{ij} - \vec{x}_i|^p + |\vec{x}_{ij} - \vec{x}_j|^p}$$

Si el peso geométrico cumple que $\omega_{ji} = 1-\omega_{ij}$, entonces
el peso estabilizado $\omega_{ij}$ definido en la
ecuación [\[eq:wij_estabilizado\]](#eq:wij_estabilizado){reference-type="eqref"
reference="eq:wij_estabilizado"} también lo cumple. Luego el esquema de
volúmenes finitos es conservativo en el sentido de que la cantidad total
de neutrones se conserva en el problema discretizado.
:::

#### Condiciones de contorno

Si la celda $i$ está en el borde del dominio, entonces al menos una de
sus caras no tendrá una celda vecina $j$. Pero la superficie libre de la
celda deberá estar asociada a alguna condición de contorno, que para el
caso de la ecuación de transporte debe ser de tipo Dirichlet. Por lo
tanto, para aquellas direcciones $\omegaversor_m$ tales
que $\omegaversor_m \cdot \hat{\vec{n}}_{ij} < 0$ conocemos el valor del
flujo escalar $\phi_{mg}(\vec{x})$ en dicha superficie, que es
justamente lo que necesitamos para evaluar el término de fugas. Más aún,
si la condición de contorno es de flujo entrante nulo, el término
correspondiente a $S_{ij}$ para
$\omegaversor_m \cdot \hat{\vec{n}}_{ij} < 0$. Para las direcciones
salientes no conocemos el flujo en la cara. Pero adoptando un esquema de
upwinding completo, podemos decir que el flujo
escalar $\psi_{mg}(\vec{x}_{ij})$ es igual al flujo
escalar $\psi_{mg}^i$ para valores de $m$ tales que
$\omegaversor_m \cdot \hat{\vec{n}}_{ij} > 0$. Luego

$$\label{eq:snvolcc}
 \int_{S_{ij}} \psi_{mg}(\vec{x}) \cdot \left[ \omegaversor_m \cdot \hat{\vec{n}}(\vec{x})\right]  \, d^{n-1}\vec{x}
\approx 
\begin{cases}
\left( \omegaversor_m \cdot \hat{\vec{n}}_{ij}\right) \cdot S_{ij}  \cdot \psi_{mg}(\vec{x}_{ij}) & \text{si $\omegaversor_m \cdot \hat{\vec{n}}_{ij} < 0$} \\
\left( \omegaversor_m \cdot \hat{\vec{n}}_{ij}\right) \cdot S_{ij}  \cdot \psi_{mg}^i & \text{si $\omegaversor_m \cdot \hat{\vec{n}}_{ij} \geq 0$} \\
\end{cases}$$ donde $\psi_{mg}(\vec{x}_{ij})$ es el tipo de condición de
contorno de acuerdo a la
ecuación [\[eq:transportesncc\]](#eq:transportesncc){reference-type="eqref"
reference="eq:transportesncc"} evaluado en $\vec{x}_{ij}$

$$\tag{\ref{eq:transportesncc}}
\psi_{mg}(\vec{x}_{ij}) =
 \begin{cases}
  \psi_{mg}(\vec{x}) = 0 
& \forall \vec{x} \in \Gamma_V \wedge \omegaversor_m \cdot \hat{\vec{n}}(\vec{x}) < 0 \\
  \psi_{mg}(\vec{x}) = \psi_{mg^\prime} / \omegaversor_{g^\prime} = \omegaversor_m - 2 \left( \omegaversor_m \cdot \hat{\vec{n}} \right) \hat{\vec{n}}
& \forall \vec{x} \in \Gamma_M \wedge \omegaversor_m \cdot \hat{\vec{n}}(\vec{x}) < 0 \\
  \psi_{mg}(\vec{x}) = f_{mg}(\vec{x})
& \forall \vec{x} \notin \Gamma_V \bigcup \Gamma_M \wedge \omegaversor_m \cdot \hat{\vec{n}}(\vec{x}) < 0 \\
 \end{cases}$$ según lo discutido en la
sección [\[sec:bctransporte\]](#sec:bctransporte){reference-type="ref"
reference="sec:bctransporte"}.

#### Formulación matricial

Volviendo una vez más a la formulación integral

$$\begin{gathered}
\tag{\ref{eq:transportesnintegral}}
 \int_S \psi_{mg}(\vec{x}) \cdot \left[ \omegaversor_m \cdot \hat{\vec{n}}(\vec{x})\right]  \, d^{n-1}\vec{x}
 +
 \int_V \Sigma_{t g}(\vec{x}) \cdot \psi_{mg}(\vec{x}) \, d^n\vec{x} = \\
 \sum_{g^\prime=1}^G \sum_{m^\prime=1}^M  w_{m^\prime} \cdot  \sum_{\ell=0}^\infty 
\int_V \Sigma_{s_\ell \,g^\prime \rightarrow g}(\vec{x}) \cdot (2\ell+1) \cdot P_\ell (\omegaversor_m \cdot \boldsymbol{\hat{\Omega}^\prime}_{m^\prime}) \cdot \psi_{m^\prime g^\prime}(\vec{x}) \, d^n\vec{x} \\
+
 \chi_g  \sum_{g^\prime=1}^G \sum_{m^\prime=1}^M  w_{m^\prime} \cdot \int_V \nu\Sigma_{fg^\prime}(\vec{x}) \cdot \psi_{m^\prime g^\prime}(\vec{x}) \, d^n\vec{x}
+
 \int_V s_{mg}(\vec{x}) \, d^n\vec{x}
\end{gathered}$$ podemos ahora escribir los términos volumétricos en la
forma [\[eq:snvol3\]](#eq:snvol3){reference-type="eqref"
reference="eq:snvol3"} y el término de fugas según lo discutido en la
sección [1.5.1.2](#sec:snvolfugas){reference-type="ref"
reference="sec:snvolfugas"} para obtener un sistema de $I\cdot G\cdot M$
ecuaciones algebraicas como sigue

$$\begin{gathered}
\label{eq:snvolalgebraica}
\sum_{j~\text{vecinos}} \left( \omegaversor_m \cdot \hat{\vec{n}}_{ij}\right) \cdot S_{ij} \cdot \psi_{mg}^{ij}
+
 \left[ \int_{V_i} \Sigma_{tg}(\vec{x}) \, d^n\vec{x} \right] \cdot \psi_{mg}
= \\
 \sum_{g^\prime=1}^G \sum_{m^\prime=1}^M  \sum_{\ell=0}^\infty
 w_{m^\prime} \cdot \left[ \int_{V_i} \Sigma_{s_\ell \,g^\prime \rightarrow g}(\vec{x}) \, d^n\vec{x} \right]  \cdot (2\ell+1) \cdot  P_\ell (\omegaversor_m \cdot \boldsymbol{\hat{\Omega}^\prime}_{m^\prime}) \cdot \psi_{m^\prime g^\prime}^i \\
+
 \sum_{g^\prime=1}^G \sum_{m^\prime=1}^M  \chi_g \cdot w_{m^\prime}  \cdot \left[ \int_{V_i} \nu\Sigma_{fg^\prime}(\vec{x}) \, d^n\vec{x} \right] \cdot \psi_{m^\prime g^\prime}^i
+
 \int_{V_i} s_{mg}(\vec{x}) \, d^n\vec{x}
\end{gathered}$$ para la celda $i=1,\dots,I$, el grupo de
energía $g=1,\dots,g$ y la dirección $m=1,\dots,M$, donde introducios el
factor $\psi_{mg}^{ij}$ que depende del vecino $j$

$$\psi_{mg}^{ij} =
\begin{cases}
\left[ \omega_{ij} \cdot \psi_{mg}^i + (1-\omega_{ij}) \cdot \psi_{mg}^j \right] & \text{si~$\exists$ celda~$j$} \\
\psi_{mg}(\vec{x}_{ij}) & \text{si~$\nexists$ celda~$j$ $\wedge$ $\omegaversor \cdot \hat{\vec{n}}_{ij} < 0$} \\
\psi_{mg}^i             & \text{si~$\nexists$ celda~$j$ $\wedge$ $\omegaversor \cdot \hat{\vec{n}}_{ij} \geq 0$} \\
\end{cases}$$

El peso $\omega_{ij}$ es el desarrollado en la
sección [1.5.1.2](#sec:snvolfugas){reference-type="ref"
reference="sec:snvolfugas"} con $p=1$ que involucra el factor $\alpha$
que puede ir entre cero (sin upwinding) y uno (upwinding completo):

$$\begin{aligned}
\tilde{\omega}_{ij} &= \frac{|\vec{x}_{ij} - \vec{x}_j|}{|\vec{x}_{ij} - \vec{x}_i| + |\vec{x}_{ij} - \vec{x}_j|} \tag{\ref{eq:wij}} \\
 \omega_{ij} &=
\begin{cases}
 \tilde{\omega}_{ij} + \alpha \cdot (1 - \tilde{\omega}_{ij}) & \text{si $\omegaversor_m \cdot \hat{\vec{n}}_{ij} \ge 0$}\\
 \tilde{\omega}_{ij} - \alpha \cdot \tilde{\omega}_{ij}       & \text{si $\omegaversor_m \cdot \hat{\vec{n}}_{ij} < 0$}\\
\end{cases}
\tag{\ref{eq:wij_estabilizado}}
\end{aligned}$$

Es interesante notar que el término de fugas acopla las celdas
vecinas $j$ a la celda $i$ pero sobre el mismo grupo $g$ y
dirección $m$. Por otro lado, los términos de scattering y de fisión
acoplan diferentes grupos $g^\prime$ y direcciones $m^\prime$ a $g$ y
a $m$ pero sobre la misma celda $i$. El coeficiente $s_{mg}^i$ del
término de fuente independiente es el valor medio de la fuente en la
celda $i$. Si este término es cero y hay fisiones entonces debemos
dividir $\chi_g$ por $k_\text{eff}$ en la
ecuación [\[eq:snvolalgebraica\]](#eq:snvolalgebraica){reference-type="eqref"
reference="eq:snvolalgebraica"}.

Utilizando la notación de la
sección [1.4](#sec:discretizacion_espacial){reference-type="ref"
reference="sec:discretizacion_espacial"}, definamos el vector
incógnita $\boldsymbol{\xi}$ como

$$\boldsymbol{\xi} =
\left[
\psi_{1 1}^{1} ~~
\psi_{2 1}^{1} ~~
\psi_{3 1}^{1} ~~
\dots          ~~
\psi_{M 1}^{1} ~~
\psi_{1 2}^{1} ~~
\psi_{2 2}^{1} ~~
\dots          ~~
\psi_{M G}^{1} ~~
\psi_{1 1}^{2} ~~
\psi_{2 1}^{2} ~~
\dots          ~~
\psi_{m g}^{I} ~~
\dots          ~~
\psi_{M G}^{I}
\right]^T$$ es decir, ordenamos primero las incógnitas por
celda $i=1,\dots,I$, después dentro de cada celda por grupo de
energía $g=1,\dots,G$ y, finalmente, dentro de cada grupo por
dirección $m=1,\dots,M$. Con este ordenamiento propuesto, el índice $p$
del flujo angular en la celda $i$ en el grupo $g$ y en la dirección $m$
es

$$\label{eq:orden_snvol}
 p = i \cdot MG + g \cdot M + m$$

::: algorithm
inicializar $R \gets 0, F \gets 0, \vec{S} \gets 0$
:::

Podríamos haber planteado otro ordenamiento, como por ejemplo primero
ordenar por dirección, después por grupo y finalmente por celda. Esta
elección cambia luego las propiedades numéricas de las matrices
asociadas al problema. En cualquier caso, podemos construir el
vector $S$ y las matrices $R$ y $F$ con el
algoritmo [\[fig:snvol-matrices\]](#fig:snvol-matrices){reference-type="ref"
reference="fig:snvol-matrices"}. En dicho listado hacemos referencias a
algunas ecuaciones que desarrollamos a lo largo de este capítulo, que a
su vez se refieren a la teoría introducida en el capitulo anterior. Sólo
mostramos la inclusión de fuentes independientes isotrópicas y scatterig
linealmente anisotrópico, casos que se pueden generalizar fácilmente
pero que complicarían la presentación del algoritmo. Debemos remarcar la
diferencia caligráfica entre el peso $w_m$ asociado a la dirección $m$
utilizado para integrar sobre $\omegaversor$ el peso $\omega_{ij}$
asociado a la superficie $S_{ij}$ para estimar el flujo en las caras de
la celdas.

### Difusión en volúmenes

Para formular el problema de difusión de neutrones con un esquema basado
en el método de volúmenes finitos procedemos en forma similar a la
sección anterior definiendo el flujo escalar en cada celda.

::: definicion
[]{#def:flujoescalarcelda label="def:flujoescalarcelda"} El flujo
escalar del grupo $g=1,\dots,G$ en la celda $i=1,\dots,I$ es

$$\phi_{g}^i = \frac{\displaystyle \int_{V_i} \phi_{g}(\vec{x}) \, d^n\vec{x}}{\displaystyle \int_{V_i} \, d^n\vec{x}}$$
donde $V_i \in \mathbb{R}^n$ es el volumen del dominio $U$ ocupado por
la celda $i$.
:::

De la misma manera que en la sección anterior, el problema consiste en
encontrar los $I \cdot G$ valores $\phi_{g}^i$, que son los elementos
del vector incógnita $\boldsymbol{\xi} \in \mathbb{R}^{IG}$ definido en
la ecuación [\[eq:incognita\]](#eq:incognita){reference-type="eqref"
reference="eq:incognita"}. Para ello, tomamos la formulación integral
del problema de difusión dada por la
ecuación [\[eq:difusionintegral\]](#eq:difusionintegral){reference-type="eqref"
reference="eq:difusionintegral"} introducida en la
sección [1.3.2](#sec:integrales){reference-type="ref"
reference="sec:integrales"}

$$\begin{gathered}
\tag{\ref{eq:difusionintegral}}
 - \int_S D_g(\vec{x}) \cdot \Big[ \text{grad} \left[ \phi_g(\vec{x}) \right] \cdot \hat{\vec{n}}(\vec{x}) \Big] \, d^{n-1} \vec{x}
 + \int_V \Sigma_{t g}(\vec{x}) \cdot \phi_g(\vec{x}) \, d^n \vec{x}
 = \\
 \sum_{g^\prime = 1}^G \int_V \Sigma_{s_0 g^\prime \rightarrow g}(\vec{x})  \cdot \phi_{g^\prime}(\vec{x}) \, d^n \vec{x}
+
 \chi_g \sum_{g^\prime = 1}^G \int_V  \nu\Sigma_{fg^\prime}(\vec{x}) \cdot \phi_{g^\prime}(\vec{x}) \, d^n \vec{x}
 +
\int_V s_{0_g}(\vec{x}) \, d^n \vec{x}
\end{gathered}$$ estudiando cada uno de sus términos para escribirlos en
función de los flujos en las celdas introducidos en la
definición [\[def:flujoescalarcelda\]](#def:flujoescalarcelda){reference-type="ref"
reference="def:flujoescalarcelda"}.

#### Términos volumétricos

El segundo término del miembro izquierdo y los dos primeros del miembro
derecho de la
ecuación [\[eq:difusionintegral\]](#eq:difusionintegral){reference-type="eqref"
reference="eq:difusionintegral"} tienen la forma

$$\int_{V_i} f(\vec{x}) \cdot \phi_g(\vec{x}) \, d^n\vec{x}$$ que, de la
misma forma que en la
ecuación [\[eq:snvol3\]](#eq:snvol3){reference-type="eqref"
reference="eq:snvol3"}, sabemos que podemos aproximar como

$$\label{eq:difvol3}
  \int_{V_i} f(\vec{x}) \cdot \phi_g(\vec{x}) \, d^n\vec{x} \approx \left[ \int_{V_i} f(\vec{x}) \, d^n\vec{x} \right] \cdot \phi_{g}^i = \hat{f}^i \cdot V_i \cdot \hat{\phi}_g^i$$
donde la aproximación es exacta si $f(\vec{x})$ es uniforme dentro de la
celda.

#### Término de fugas {#término-de-fugas}

El primer término del miembro izquierdo de la
ecuación [\[eq:difusionintegral\]](#eq:difusionintegral){reference-type="eqref"
reference="eq:difusionintegral"} representa, a menos de un signo
negativo, el ritmo neto de fugas de neutrones de energía $g$ a través de
la superficie que delimita el volumen $V_i$ según la teoría de difusión
de neutrones. Es en este término donde aparece el acople entre celdas
espaciales y cobra importancia el método de volúmenes finitos.
Utilizando el teorema de la divergencia, podemos escribir

$$\label{eq:difvol4}
 \int_{V_i} \text{div} {\Big[ D_g(\vec{x}) \cdot \text{grad} {\big[\phi_g(\vec{x})\big]} \Big]} d^n\vec{x} =
\int_{S_i} \Big[ D_g(\vec{x}) \cdot \text{grad} {\big[\phi_g(\vec{x})\big]} \Big] \cdot \hat{\vec{n}}(\vec{x}) \, d^{n-1} \vec{x}$$
donde $S_i$ representa la superficie que delimita el volumen $V_i$
y $\hat{\vec{n}}$ es el vector unitario normal a la superficie $S_i$ que
apunta en en sentido externo al volumen $V_i$. Para una celda de la
malla, la superficie $S_i$ está compuesta por una cantidad finita de
superficies planas $S_{ij}$ tal que, al igual que en la sección
anterior, $S_{ij}$ separa a la celda $i$ de la celda $j$ como ya
ilustramos en la figura [1.6](#fig:nij){reference-type="ref"
reference="fig:nij"}. Entonces el miembro derecho de la
ecuación [\[eq:difvol4\]](#eq:difvol4){reference-type="eqref"
reference="eq:difvol4"} es la suma de las integrales sobre cada $S_{ij}$

$$\int_{S_i} \Big[ D_g(\vec{x}) \cdot \text{grad} {\big[\phi_g(\vec{x})\big]} \Big] \cdot \hat{\vec{n}}(\vec{x}) \, d^{n-1} \vec{x} =
\sum_{j \text{vecinos}}
\int_{S_{ij}} D_g(\vec{x}) \cdot \Big[ \text{grad} {\big[\phi_g(\vec{x})\big]}  \cdot \hat{\vec{n}}_{ij} \Big] \, d^{n-1} \vec{x}$$
donde además hemos asociado el producto
escalar $\nabla \phi_g \cdot \hat{\vec{n}}_{ij}$, que está evaluado
sobre la cara $S_{ij}$.

<figure id="fig:gradiente">
<div class="center">
<img src="esquemas/gradiente" />
</div>
<figcaption><span id="fig:gradiente"
label="fig:gradiente"></span>Estimación del gradiente del flujo campo
escalar <span
class="math inline"><em>ϕ</em><sub><em>g</em></sub>(<em>x⃗</em>)</span>
en una interfaz <span
class="math inline"><em>S</em><sub><em>i</em><em>j</em></sub></span> que
separa dos celdas del mismo material.</figcaption>
</figure>

Si las celdas $i$ y $j$ están compuestas del mismo material entonces el
coeficiente de difusión $D_g(\vec{x})$ es continuo en la
dirección $\hat{\vec{n}}_{ij}$ normal a la cara. En efecto, aunque las
celdas podrían tener diferentes propiedades termohidráulicas---digamos
diferentes temperaturas---esperamos que estas propiedades sean continuas
en el espacio. Entonces asumimos que el módulo del gradiente del flujo
escalar es aproximadamente igual a la diferencia entre los
flujos $\phi_g^j$ y $\phi_g^i$ dividido la distancia entre los
baricentros de las celdas $i$ y $j$

$$\label{eq:vol_mod_grad_hom}
\Big| \Dgrad {\big[ \phi_g(\vec{x}) \big]} \Big|_{\vec{x} \in S_{ij}} \approx \frac{\phi_g^j - \phi_g^i}{ | \vec{x}_j - \vec{x}_i |}$$
y que el vector gradiente apunta en la dirección del
vector $\vec{x}_j-\vec{x}_i$ que une los baricentros $\vec{x}_j$
y $\vec{x}_i$ de las celdas $j$ e $i$ respectivamente
(figura [1.8](#fig:gradiente){reference-type="ref"
reference="fig:gradiente"}). Esta dirección forma un cierto
ángulo $\theta_{ij}$ con la normal $\hat{\vec{n}}_{ij}$, que podemos
calcular geométricamente a partir de las coordenadas de los nodos que
definen la superficie $S_{ij}$ y de las coordenadas de los
baricentros $\vec{x}_i$ y $\vec{x}_j$ como

$$\cos \theta_{ij} = \frac{(\vec{x}_j - \vec{x}_i) \cdot \hat{\vec{n}}_{ij}}{| \vec{x}_j - \vec{x}_i |}$$

Luego la tasa neta de neutrones de energía $g$ que cruzan cada una de
las superficies $S_{ij}$ de la
ecuación [\[eq:difvol4\]](#eq:difvol4){reference-type="eqref"
reference="eq:difvol4"} es

$$\label{eq:vol-tasa-cruce-hom}
\int_{S_{ij}} D_g(\vec{x}) \cdot \Big[ \text{grad} {\big[\phi_g(\vec{x})\big]}  \cdot \hat{\vec{n}}_{ij} \Big] \, d^{n-1} \vec{x}
\approx
\left( \int_{S_{ij}} D_g(\vec{x}) \, d^{n-1} \vec{x} \right) \cdot \frac{(\vec{x}_j - \vec{x}_i) \cdot \hat{\vec{n}}_{ij}}{| \vec{x}_j - \vec{x}_i |^2}  \cdot \Big[ \phi_g^j - \phi_g^i\Big]$$

Podemos calcular la integral del coeficiente de difusión numéricamente a
partir de la distribución $D_g(\vec{x})$ dada como dato, ya que hemos
supuesto que $D_g(\vec{x})$ es continua en $S_{ij}$ y por lo tanto su
integral está bien definida.

Notar que estimar el módulo del gradiente del flujo en el borde del
volumen según la
ecuación [\[eq:vol_mod_grad_hom\]](#eq:vol_mod_grad_hom){reference-type="eqref"
reference="eq:vol_mod_grad_hom"} es equivalente a suponer que, dada una
función continua $\phi(x)$, el punto $c$ que cumple el teorema del valor
medio

$$\phi^{\prime}(c) = \frac{\phi(b) - \phi(a)}{b - a}$$ es
$c \approx (b-a)/2$. Esta aproximación es un orden $\Delta x^2$---i.e.
es exacta para una parábola---mientras que la aproximación

<figure id="fig:continuo">
<div class="center">
<img src="esquemas/continuo" style="width:12cm" />
</div>
<figcaption><span id="fig:continuo"
label="fig:continuo"></span>Representación unidimensional de una función
continua <span class="math inline"><em>ϕ</em>(<em>x</em>)</span>, con
valores medios de volúmenes (cuadrados) y valores estimados en border
(cruces). La estimación de la derivada en los bordes a primeros vecinos
es de orden superior a la estimación del valor de la
función.</figcaption>
</figure>

$$\phi\left( \frac{b-a}{2} \right) \approx \frac{1}{2} \big[ \phi(a) + \phi(b) \big]$$
es de orden $\Delta x$ (es exacta para una recta). Ilustramos la
situación en la figura [1.9](#fig:continuo){reference-type="ref"
reference="fig:continuo"}, donde los cuadrados representan los valores
medios en los volúmenes y las cruces los valores que tomaría el flujo en
los bordes con una interpolación lineal. Aproximar las derivadas en los
bordes con los valores medios es más preciso que aproximar los flujos en
los bordes con los valores medios de los volúmenes vecinos.

Si las celdas $i$ y $j$ están compuestas de materiales diferentes es de
esperar que el coeficiente de difusión $D_g(\vec{x})$ no sea continuo
sobre la superficie $S_{ij}$ en la dirección
normal $\hat{\vec{n}}_{ij}$. En este caso, la integral de la
ecuación [\[eq:vol-tasa-cruce-hom\]](#eq:vol-tasa-cruce-hom){reference-type="eqref"
reference="eq:vol-tasa-cruce-hom"} no está bien definida y no podemos
evaluarla. Más aún, el flujo escalar $\phi_g$ debe tener derivada
primera discontinua de forma tal de que las corrientes evaluadas en
ambas caras de la interfaz mediante la ley de Fick de la
ecuación [\[eq:fick\]](#eq:fick){reference-type="eqref"
reference="eq:fick"} sean iguales y se conserve la cantidad de
neutrones:

$$\label{eq:continuidad-corrientes}
\vec{J}_{g}^{ij}
=
\Big[ D_g^i(\vec{x}) \cdot \text{grad} \left[\phi_g(\vec{x})\right] \Big]_{\vec{x} \in S_{ij}}
=
\Big[ D_g^j(\vec{x}) \cdot \text{grad} \left[\phi_g(\vec{x})\right] \Big]_{\vec{x} \in S_{ji}}
=
\vec{J}_{g}^{ji}$$

En este caso, aproximar el gradiente del flujo en la interfaz utilizando
los valores medios en los volúmenes vecinos arroja una pobre estimación,
como ilustramos en la
figura [1.10](#fig:discontinuo){reference-type="ref"
reference="fig:discontinuo"} (y en el problema resuelto en la
sección [\[sec:doszonas\]](#sec:doszonas){reference-type="ref"
reference="sec:doszonas"}). Además, necesitamos obtener un valor para el
gradiente a un lado de la interfaz y otro valor al otro lado de forma
tal de satisfacer la
ecuación [\[eq:continuidad-corrientes\]](#eq:continuidad-corrientes){reference-type="eqref"
reference="eq:continuidad-corrientes"}.

<figure id="fig:discontinuo">
<div class="center">
<img src="esquemas/discontinuo" style="width:12cm" />
</div>
<figcaption><span id="fig:discontinuo"
label="fig:discontinuo"></span>Idem figura <a href="#fig:continuo"
data-reference-type="ref" data-reference="fig:continuo">1.9</a> para una
interfaz material. La estimación de la derivada en la interfaz
utilizando valores medios (cuadrados) es pobre. Conviene estimar el
valor del flujo en la interfaz (cruz) y luego tomar derivadas a cada
lado de la superficie.</figcaption>
</figure>

Conviene entonces, evaluar el gradiente del flujo a un lado de la
superficie $S_{ij}$ partir del valor medio $\phi(\vec{x}_i)$ (cuadrado)
y de $\phi_g(\vec{x}_{ij})=\phi(\vec{x}_{ji})$ (cruz) y al otro
lado---que llamamos $S_{ji}$---a partir de $\phi_g(\vec{x}_j)$
(cuadrado) y de $\phi_g(\vec{x}_{ij})$ (cruz). Debido a que el
flujo $\phi_g(\vec{x})$ debe ser continuo en $\vec{x}$, el valor en la
superficie $\phi_g(\vec{x}_{ij})$ debe ser único tanto visto desde el
volumen $i$ como desde el volumen $j$.

<figure id="fig:gradiente-heterogeneo">
<div class="center">
<img src="esquemas/gradiente-heterogeneo" style="width:14cm" />
</div>
<figcaption><span id="fig:gradiente-heterogeneo"
label="fig:gradiente-heterogeneo"></span>Idem figura <a
href="#fig:gradiente" data-reference-type="ref"
data-reference="fig:gradiente">1.8</a> para el caso en que la
superficie <span
class="math inline"><em>S</em><sub><em>i</em><em>j</em></sub></span>
corresponda a una interfaz material. El punto <span
class="math inline"><em>x⃗</em><sub><em>i</em><em>j</em></sub></span> es
el baricentro de la superficie <span
class="math inline"><em>S</em><sub><em>i</em><em>j</em></sub></span>, y
no necesariamente está sobre la dirección <span
class="math inline"><em>x⃗</em><sub><em>j</em></sub> − <em>x⃗</em><sub><em>i</em></sub></span>.</figcaption>
</figure>

Proponemos entonces estimar el módulo del gradiente del flujo sobre la
superficie $S_{ij}$ ahora como

$$\label{eq:vol_mod_grad_het}
\Big\| \Dgrad {\big[ \phi_g(\vec{x}) \big]} \Big\|_{\vec{x} \in S_{ij}} \approx \frac{\phi_g(\vec{x}_{ij}) - \hat{\phi}_g^i}{ \| \vec{x}_{ij} - \vec{x}_i \|}$$
tomándolo en la dirección del vector $\vec{x}_{ij}-\vec{x}_i$ que une el
baricentro $\vec{x}_{ij}$ de la superficie $S_{ij}$ y el
baricentro $\vec{x}_i$ del volumen $i$
(figura [1.11](#fig:gradiente-heterogeneo){reference-type="ref"
reference="fig:gradiente-heterogeneo"}). En la
ecuación [\[eq:vol_mod_grad_het\]](#eq:vol_mod_grad_het){reference-type="eqref"
reference="eq:vol_mod_grad_het"} aparece el valor del flujo sobre la
cara $\phi(\vec{x}_{ij})$ (cruz), que no es parte de las incógnitas del
problema. Tenemos que estimarlo en función de los
valores $\hat{\phi}_g^i$ y $\hat{\phi}_g^j$ de tal manera de que se
satisfaga la continuidad de corrientes.

Llamemos $S_{ij}$ la superficie orientada cuya normal exterior da al
volumen $i$, y $S_{ji}$ la que da al volumen $j$. Podemos plantear una
ecuación de donde despejar $\phi_g(\vec{x}_{ij})$. En efecto, la
continuidad de corrientes requiere que

$$\begin{aligned}
 \int_{S_{ij}} \Big[ D_g(\vec{x}) \cdot \Dgrad{ \phi_g(\vec{x})} \Big]_i \cdot \vec{\hat{n}}_{ij} \, dS
&=
 - \int_{S_{ji}} \Big[ D_g(\vec{x}) \cdot \Dgrad{\phi_g(\vec{x})} \Big]_j \cdot \vec{\hat{n}}_{ji} \, dS
\\
\int_{S_{ij}} D_g^i(\vec{x}) \, dS \cdot \frac{\phi_g(\vec{x}_{ij}) - \hat{\phi}_g^i}{\| \vec{x}_{ij} - \vec{x}_i \|} \cos \theta_{ij}
&=
 - \int_{S_{ji}} D_g^j(\vec{x}) \, dS \cdot \frac{\phi(\vec{x}_{ji},g) - \hat{\phi}_g^j}{\| \vec{x}_{ji} - \vec{x}_j \|} \cos \theta_{ji}
\end{aligned}$$ donde entendemos que la integral sobre $S_{ij}$ se tiene
que realizar evaluando el coeficiente de difusión sobre el volumen $i$,
y viceversa escribiendo los subíndices $i$ y $j$ en el
símbolo $D_g(\vec{x})$. Para simplificar el despeje
de $\phi_g(\vec{x}_{ij})=\phi(\vec{x}_{ji},g)$ definimos los factores de
peso

$$\begin{aligned}
 w_{ij} &= \left( \int_{S_{ij}} D_g^i(\vec{x}) \, dS \right) \cdot \frac{(\vec{x}_{ij} - \vec{x}_i) \cdot \vec{\hat{n}}_{ij}}{\| \vec{x}_{ij} - \vec{x}_i \|^2} \label{eq:vol-peso-het-ij}
\\
 w_{ji} &= \left( \int_{S_{ji}} D_g^j(\vec{x}) \, dS \right) \cdot \frac{(\vec{x}_{ji} - \vec{x}_j) \cdot \vec{\hat{n}}_{ji}}{\| \vec{x}_{ji} - \vec{x}_j \|^2} \label{eq:vol-peso-het-ji}
\end{aligned}$$

Entonces

$$w_{ij} \Big[ \phi_g(\vec{x}_{ij}) - \hat{\phi}_g^i \Big] = -w_{ji} \Big[ \phi_g(\vec{x}_{ji}) - \hat{\phi}_g^j \Big]$$
y el flujo $\phi_g(\vec{x}_{ij})$ en la interfaz es aproximadamente

$$\label{eq:vol_phi_cruz}
 \phi_g(\vec{x}_{ij}) \approx \frac{w_{ij}}{w_{ij} + w_{ji}} \cdot \hat{\phi}_g^i + \frac{w_{ji}}{w_{ij} + w_{ji}} \cdot \hat{\phi}_g^j$$

Reemplazando la
ecuación [\[eq:vol_phi_cruz\]](#eq:vol_phi_cruz){reference-type="eqref"
reference="eq:vol_phi_cruz"} en la
expresión [\[eq:vol_mod_grad_het\]](#eq:vol_mod_grad_het){reference-type="eqref"
reference="eq:vol_mod_grad_het"} propuesta para el módulo del gradiente,
obtenemos

$$\Big\| \Dgrad {\big[ \phi_g(\vec{x}) \big]} \Big\|_{\vec{x} \in S_{ij}} \approx \left( \frac{w_{ji}}{w_{ij} + w_{ji}}\right) \cdot \left( \frac{\hat\phi_g^j - \hat{\phi}_g^i}{ \| \vec{x}_{ij} - \vec{x}_i \|} \right)$$

La tasa neta de cruce de neutrones sobre la superficie $S_{ij}$ cuando
ésta coincide con una interfaz material es aproximadamente

$$\begin{aligned}
\label{eq:vol-tasa-cruce-het}
& \int_{S_{ij}} \Big[ D_g(\vec{x}) \cdot \Dgrad {\big[\phi_g(\vec{x})\big]} \Big] \cdot \vec{\hat{n}}_{ij} \, dS \approx \nonumber \\
& \quad\quad\quad\quad
\left( \int_{S_{ij}} D_g(\vec{x}) \, dS \right) \cdot \frac{w_{ji}}{w_{ij} + w_{ji}} \cdot \frac{(\vec{x}_{ij} - \vec{x}_i) \cdot \vec{\hat{n}}_{ij}}{\| \vec{x}_{ij} - \vec{x}_i \|^2}  \cdot \Big[ \hat{\phi}_g^j - \hat{\phi}_g^i\Big]
\end{aligned}$$ donde la integral del coeficiente de difusión tiene que
tomarse sobre la cara orientada de $S_{ij}$ que da al volúmen $V_i$, es
decir, con las propiedades del material de la celda $i$, y los factores
de peso $w_{ij}$ y $w_{ji}$ están definidos en las
ecuaciones [\[eq:vol-peso-het-ij\]](#eq:vol-peso-het-ij){reference-type="eqref"
reference="eq:vol-peso-het-ij"}
y [\[eq:vol-peso-het-ji\]](#eq:vol-peso-het-ji){reference-type="eqref"
reference="eq:vol-peso-het-ji"}.

Si bien la
ecuación [\[eq:vol-tasa-cruce-het\]](#eq:vol-tasa-cruce-het){reference-type="eqref"
reference="eq:vol-tasa-cruce-het"} puede utilizarse aún cuando los
volúmenes $V_i$ y $V_j$ tengan el mismo material para estimar el término
de fugas, la
ecuación [\[eq:vol-tasa-cruce-hom\]](#eq:vol-tasa-cruce-hom){reference-type="eqref"
reference="eq:vol-tasa-cruce-hom"} es más precisa ya que la aproximación
para el gradiente dada por la
ecuación [\[eq:vol_mod_grad_hom\]](#eq:vol_mod_grad_hom){reference-type="eqref"
reference="eq:vol_mod_grad_hom"} es de orden $\Delta x^2$, mientras que
la aproximación del gradiente dada por la
ecuación [\[eq:vol_mod_grad_het\]](#eq:vol_mod_grad_het){reference-type="eqref"
reference="eq:vol_mod_grad_het"} es de orden $\Delta x$ ya que se basa
en estimar el flujo en el borde de los volúmenes, como ilustramos en la
figura [1.9](#fig:continuo){reference-type="ref"
reference="fig:continuo"}. Sin embargo, si $S_{ij}$ coincide con una
interfaz y el coeficiente de difusión es discontinuo, la
ecuación [\[eq:vol-tasa-cruce-het\]](#eq:vol-tasa-cruce-het){reference-type="eqref"
reference="eq:vol-tasa-cruce-het"} arroja mejores resultados ya que
tiene en cuenta el efecto mostrado en la
figura [1.10](#fig:discontinuo){reference-type="ref"
reference="fig:discontinuo"}. Luego, para minimizar el error cometido
por la discretización basada en el esquema de volúmenes finitos
propuesto, si $S_{ij}$ no define una interfaz, utilizamos la
ecuación [\[eq:vol-tasa-cruce-hom\]](#eq:vol-tasa-cruce-hom){reference-type="eqref"
reference="eq:vol-tasa-cruce-hom"} para calcular los coeficientes que
formarán parte de la matriz de remoción $R$. De otra manera, utilizamos
la
ecuación [\[eq:vol-tasa-cruce-het\]](#eq:vol-tasa-cruce-het){reference-type="eqref"
reference="eq:vol-tasa-cruce-het"}.

#### Condiciones de contorno nulas

Si la superficie $S_{ij}$ está en el borde del dominio, entonces debemos
calcular la integral de superficie

$$\int_{S_{ij}} \Big[ D_g(\vec{x}) \cdot \Dgrad {\big[\phi_g(\vec{x})\big]} \Big] \cdot \vec{\hat{n}} \, dS$$
teniendo en cuenta las condiciones de contorno del problema. Como
discutimos en la sección [\[sec:cc\]](#sec:cc){reference-type="ref"
reference="sec:cc"}, sólo se pueden dar condiciones de contorno
homogéneas. En particular, si la superficie $S_{ij}$ tiene una condición
de contorno de Dirichlet, como mencionamos en la
sección [\[sec:cc\]](#sec:cc){reference-type="ref" reference="sec:cc"},
ésta debe ser deflujo nulo. Luego, $\phi_g(\vec{x}_{ij}) = 0$ y

$$\Big\| \Dgrad {\big[ \phi_g(\vec{x}) \big]} \Big\|_{\vec{x} \in S_{ij}} \approx \frac{0 - \hat{\phi}_g^i}{ \| \vec{x}_{ij} - \vec{x}_i \|}$$

La tasa neta de cruce de neutrones sobre la superficie $S_{ij}$ cuando
ésta coincide con un borde del dominio con condición de contorno de
flujo nulo es

$$\label{eq:vol-tasa-cruce-flujo-nulo}
\int_{S_{ij}} \Big[ D_g(\vec{x}) \cdot \Dgrad {\big[\phi_g(\vec{x})\big]} \Big] \cdot \vec{\hat{n}}_{ij} \, dS \approx
\left( \int_{S_{ij}} D_g(\vec{x}) \, dS \right) \cdot \frac{(\vec{x}_{ij} - \vec{x}_i) \cdot \vec{\hat{n}}_{ij}}{\| \vec{x}_{ij} - \vec{x}_i \|^2}  \cdot \Big[ - \hat{\phi}_g^i\Big]$$

#### Condiciones de contorno espejo

Para especificar superficies de simetría, se debe una condición de
contorno de Neumann con derivada normal nula
(sección [\[sec:cc\]](#sec:cc){reference-type="ref"
reference="sec:cc"}). Si $S_{ij}$ coincide con una de estas superficies,
entonces el módulo del gradiente es cero y su integral también lo es.
Por lo tanto, la tasa neta de cruce de neutrones sobre la
superficie $S_{ij}$ es cero y

$$\label{eq:vol-tasa-cruce-derivada-nula}
\int_{S_{ij}} \Big[ D_g(\vec{x}) \cdot \Dgrad {\big[\phi_g(\vec{x})\big]} \Big] \cdot \vec{\hat{n}}_{ij} \, dS = 0$$

#### Condiciones de contorno de Robin

Si la superficie $S_{ij}$ pertenece a una zona de la frontera del
dominio $\partial U$ con condiciones de contorno de Robin
(sección [\[sec:cc\]](#sec:cc){reference-type="ref"
reference="sec:cc"}), entonces

$$\Big[ \Dgrad {\big[\phi_g(\vec{x})\big]} \cdot \vec{\hat{n}}\Big]_{\vec{x} \in \partial U} =  \frac{\partial \phi_g}{\partial n} \Big|_{\vec{x} \in \partial U} = \frac{a_g(\vec{x})}{D_g(\vec{x})} \cdot \phi_g(\vec{x})\Big|_{\vec{x} \in \partial U}$$

Asumiendo que $\phi_g(\vec{x})$ para $\vec{x}\in \partial U$ es
aproximadamente igual a $\hat{\phi}_g^i$, la tasa neta de cruce de
neutrones a través de la superficie $S_{ij}$ es

$$\label{eq:vol-tasa-cruce-robin}
\int_{S_{ij}} \Big[ D_g(\vec{x}) \cdot \Dgrad {\big[\phi_g(\vec{x})\big]} \Big] \cdot \vec{\hat{n}} \, dS \approx S_{ij} \cdot a_g(\vec{x}) \cdot \Big[ \hat{\phi}_g^i\Big]$$
donde $S_{ij}$ es el área de la superficie.

#### Condiciones de contorno

#### Formulación matricial

capaz que esto debería ir en implementación

::: algorithm
inicializar $R \gets 0, F \gets 0$
:::

## Elementos finitos {#sec:elementos}

### Difusión en elementos

### Ordenadas discretas en elementos

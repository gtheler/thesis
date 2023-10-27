# Conclusiones y trabajos futuros {#sec-conclusiones}

::::: {.chapterquote data-latex=""}
::: {lang=en-US}
> | A good hockey player plays where the puck is.
> | A great hockey player plays where the puck is going to be.
> |
> | _Wayne Gretzky_
:::

> Leí con incomprensión y fervor estas palabras que con minucioso pincel redactó un hombre de mi sangre:
>
> > Dejo a los varios porvenires (no a todos) mi jardín de senderos que se bifurcan.
>
> Devolví en silencio la hoja
>
> _Jorge Luis Borges, El jardín de senderos que se bifurcan, 1941_
:::::


Cloud first

importancia FOSS en ingenería

que no se quede en nada!

Trabajos futuros (de otros autores bajo la forma de tesis académicas o proyectos de ingeniería indsutriales)

 * comparar cuantitativamente difusión con ordenadas discretas
 * agregar otros conjuntos de cuadraturas
 * evitar o mitigar el efecto rayo
 * discretizar la coordenada angular con fuciones de forma
 * agregar otras formulaciones neutrónicas
   - P$_N$
   - SP$_N$
   - even parity
 * medir eficiencia y mejorar performance
   - aplicar data-oriented programming
 * estudiar métodos numéricos iterativos para S$_N$
   - $p$-AMG
 * escalabildiad por paralelización
   - multi-node MPI
 * desarrollo de interfaces y capas de abstracción
   - web
   - gráficas
   - APIs para lenguajes de scripting
   - clientes para cloud
 * refinamiento automático de malla
 * otras discretizaciones espaciales
   - galerkin discontinuo
   - volúmenes finitos
 * aplicación a problemas de optimización
   - recocido simulado
   - algoritmos genéticos
   - redes neuronales
 * evaluar el uso de otros frameworks de PETSc
   - DMplex
   - PetscFem
 * otras formas numéricas de poner condiciones multi-punto
   - multiplicadores de Lagrange
   - eliminación directa
 * evaluar la posiblidad de realizar cálculos de celda
   - probabilidad de colisiones
 * otras PDEs
   - elasticidad no lineal
   - electromagnetismo
   - acústica
   - CFD
 * mejorar la integración continua
   - agregar tests
   - medir la cobertura del código
 * crear una comunidad
 * estudiar  compatibilidad de las xs homogeneizadas en celdas estructuradas con su uso en el esquema multi-escala con mallas no estructuradas a nivel de núcleo
   - barras de control
   - nubes de boro
   

Aún quedan muchos aspectos por investigar e implementar, como por ejemplo

 * Esquemas espaciales basados en volúmenes finitos
 * Formulación de elementos finitos tipo Galerkin discontinuos
 * Otros esquemas de discretización débiles como mínimos cuadrados en lugar de Galerkin
 * Otras formulaciones neutrónicas
   - $P_L$
   - Even parity
   - Probabilidad de colisiones
 * Capacidad de refinamiento de malla automático^[Del inglés [*Automatic Mesh Refinement*]{lang=en-US}]
 * Elementos de alto orden y refinamiento tipo $p$
 * Esquemas de solución $p$-multigrid @brown2022performance
 * Transitorios neutrónicos
 * Acople con otros códigos de cálculo a través de memoria compartida
 * Medición y optimización de performance computacional
 * Optimización de utilización de comunicación MPI
 * Integración de GUIs basados en web
 * Integración con APIs tipo REST para control remoto

 
   
que quede en algo!

# Conclusiones {#sec-conclusiones}

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
> Devolví en silencio la hoja.
>
> _Jorge Luis Borges, El jardín de senderos que se bifurcan, 1941_
:::::


 * why
 * how
 * what
 
 

Cloud first

unix


UNfair advantage

 1. programatic
 2. unstructured grids
 3. sn
 4. mpi
 
 

importancia FOSS en ingeniería



## Trabajos futuros

Es mi deseo que esta tesis dispare un jardín de senderos que se bifurquen para que las ideas y/o las implementaciones discutidas a lo largo de estos cientos de páginas (físicas en la Biblioteca Falicov, lógicas en su versión PDF o web en su versión HTML) no caigan en el ostracismo. En principio, muchos de las tareas pendientes pueden ser encaradas como trabajos académicos y/o proyectos de ingeniería industriales. En algún sentido, el trabajo "futuro" relacionado al gerenciamiento (sea académico o industrial) es más desafiante que los trabajos técnicos listados a continuación ya no sólo que involucran el [management]{lang=en-US} de los tres vértices del tradicional triángulo de proyectos

 - costos
 - alcance
 - calidad
 
sino también, en proyeectos nucleares también hay que lidiar con

 - recursos humanos especialmente particulares
 - gigantezcas inercias organizacionales
 - impredecibles limitaciones políticas
  
todos con sus con sus egos y complicaciones, usualmente fruto del hecho de que la industria nuclear extremandamente inestable ya que depende casi exclusivamente de financiamiento y/o incentivos gubernamentales, tanto a nivel local como global:

 * comparación cualitativa de difusión con ordenadas discretas
   - en trabajos académicos de investigación
   - en modelos de interés industrial
   - incorporación de FeenoX en cadenas de cálculo existentes
 * evaluación de otros conjuntos de cuadraturas no necesariamente de nivel simétrico
 * estudios de formas de evitar o mitigar el efecto rayo
 * discretización de la coordenada angular con funciones de forma tipo elementos finitos
 * incorporación de otras formulaciones neutrónicas
   - P$_N$
   - SP$_N$
   - [even parity]{lang=en-US}
   - probabilidad de colisiones para cálculo de celda
 * instrumentación del código para evaluar su eficiencia y mejorar su performance tanto en CPU como en memoria
   - evaluación de la posibilidad de aplicar el paradigma [data-oriented programming]{lang=en-US}
 * estudio de factibilidad de utilizar métodos numéricos iterativos para S$_N$
   - [$p$-assisted algebraic multi-grid]{lang=en-US} @brown2022performance
   - [PCPATCH]{lang=en-US} @pcpatch
 * mejoramiento de la escalabilidad por paralelización
   - optimización de [multi-node MPI]{lang=en-US}
   - análisis de algoritmos de descomposición de dominio para aplicaciones en reactores nucleares
   - evaluación de la utilización de DMPLEX para la distribución
 * desarrollo de interfaces y capas de abstracción
   - plataforma web 
   - interfaces gráficas de usuario (GUIs)
   - APIs para lenguajes de scripting (Python, Julia, etc.)
   - ["thin clients"]{lang=en-US} para ejecución en la nube 
 * refinamiento automático de malla^[Del inglés [*Automatic Mesh Refinement*]{lang=en-US}]
 * investigación de otras discretizaciones espaciales
   - elementos de alto orden
   - formulaciones mixtas
   - Galerkin discontinuo
   - volúmenes finitos
   - basada en PetscFE @kirby2004
 * aplicaciones a problemas de optimización
   - recocido simulado
   - algoritmos genéticos
   - redes neuronales
   - optimización topológica @perezwinter
 * implementación de otras formas numéricas de prescribir condiciones de contorno de Dirichlet multi-punto
   - multiplicadores de Lagrange
   - eliminación directa
 * otras ecuaciones
   - elasticidad no lineal
   - electromagnetismo
   - mecánica de fluidos
   - termohidráulica 1D
   - CFD
   - aplicaciones a biotecnología
   - acústica
   - etc.
 * mejoramiento de la integración continua
   - agregar tests
   - medir la cobertura del código
   - analizar sistemáticamente el código con analizadores de memoria
 * análisis y estudio de compatibilidad de las secciones eficaces homogeneizadas en celdas estructuradas con su uso en el esquema multi-escala con mallas no estructuradas a nivel de núcleo
   - ensambles de elementos combustibles
   - barras de control
   - nubes de boro en inyección de emergencia
 * acoplamiento con otros códigos de cálculo
   - comunicadores MPI 
   - memoria compartida
   - sockets TCP
   - archivo intermedios en almacenamiento tipo RAM-disks
 * creación de comunidades libres y abiertas
   - académica
   - industrial

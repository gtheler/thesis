# Implementación computacional {#sec-implementacion}

```{=latex}
\begin{chapterquote}
```
::: {lang=en-US}
A good hockey player plays where the puck is.  
A great hockey player plays where the puck is going to be.

\smallskip

_Wayne Gretzky_
:::
```{=latex}
\end{chapterquote}
```

resumir el SDS/SRS

centrarme en PDEs, no tanto en cloud

sí en virtual methods y eso, un directorio por PDEs

error handling: check returned values, do not raise exceptions

## [FeenoX, a cloud-first free no-fee no-X uniX-like finite-element(ish) computational engineering tool]{lang=en-US}

Third-system effect.
Como Unix^[A principios de 1960 llegaron a desarrollar un sistema operativo que funcionaba bien, así que decidieron encarar MULTICS. Como terminó siendo una monstruosidad, empezaron UNIX que es lo que quedó bien.]
y C^[A fines de 1960 llegaron a desarrollar un un lenguaje de programación A que funcionaba bien, así que decidieron encarar B. Como terminó siendo una monstruosidad, empezaron C que es lo que quedó bien.], FeenoX es un "efecto de tercer sistema"^[Del inglés [_third-system effect_]{lang=en-US}].


### Arquitectura del código fuente

PETSc: TS, SNES, KSP, PC

Discusión del lenguaje.

Virtual methods vs. function pointers.

no tenemos virtual methods en C, pero es turing complete
tenemos

 * punteros a funciones
 * lenguajes de macro

`autogen.sh` + entry points

macros/wrappers para `gsl_cblas_dgemmv()` = `MatAtBA()`


LTO. Macro para single-pde.

## Tipos de problemas en estado estacionario

### Problemas lineales

### Problemas no lineales

### Problemas de autovalores


## Formulaciones elementales arbitrarias a partir de apuntadores a funciones

### Matrices de rigidez y masa

### Vectores de condiciones de contorno naturales

### Condiciones de contorno esenciales

### Optimización del código mediante expansión en linea 



## El operador de Laplace escalar

## Difusión de neutrones multigrupo

## Transporte multigrupo con ordenadas discretas



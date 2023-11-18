```{=latex}
% \vspace{-1cm}
```

# [Abstract]{lang=en-US} {.unnumbered  .unlisted}

```{=latex}
% \vspace{0.25cm plus 0.25cm}
```


### [{{< meta title-en >}}]{lang=en-US} {.unnumbered  .unlisted}

```{=latex}
% \vspace{0.15cm plus 0.15cm}
```

::: {lang=en-US}

Traditional core-level neutronic computational tools are focused on solving the multigroup neutron diffusion equation over structured hexahedral grids. 
While this approach might be reasonable for light-water power reactors, cores where the moderator is separated from the coolant---such as heavy-water power plants and some research reactors---cannot be represented accurately with structured grids.
In this work, we show how a free and open-source cloud-first large-scale parallel computational tool aimed at solving partial differential equations spatially discretized using the finite element method can be used to solve core-level neutronics using the multigroup discrete ordinates S$_N$ angular scheme.
This tool, named FeenoX and developed from scratch using the Unix programming philosophy, can solve generic PDEs by providing a mechanism based on arbitrary entry points using C function pointers which build the elemental objects for the FEM formulation.
It also allows to scale in parallel using the MPI standard in a way suitable to be launched over several cloud servers.
This way, in principle, arbitrarily large problems can be split into several hosts using domain decomposition techniques, overcoming the usual RAM limitations.
Two of the PDEs that the initial version of the code can solve include multigroup neutron diffusion and neutron transport using the discrete ordinates method.

This thesis explains the mathematics of the neutron transport equation, how the diffusion approximation can be derived from the former and one of the many possible numerical discretizations in angle and space for both of these equations. It also discusses the design and implementation of FeenoX that fulfills a fictitious (but plausible) set of requirement specifications (SRS) by proposing a design specifications document (SDS) explaining how the developed tool addresses each of the tender requirements.
In the results chapter, ten neutronic problems are solved. All of them need at least one of the unfair advantages that FeenoX's features configure: 1. programmatic simulation (that derives from the Unix philosophy); 2. unstructured grids; 3. discrete ordinates; 4. parallelization using MPI.
This work sets a basis for further numerical studies comparing S$_N$ and diffusion schemes for advanced core-level reactor analysis.

---
comment: |
  * state the problem
  * say why it's an interesting problem
  * say what your solution achieves
  * say what follows from your solution
...

:::

```{=latex}
\vspace{\fill}
```


::: {lang=en-US}

Keywords

:   {{< meta keywords >}}


Revision

:   {{< meta git_hash >}}

:::

```{=latex}
%\vspace{0.5cm plus 0.5cm minus 0.5cm}
```

```{=latex}
\begin{centering}
```

![](by){width=1.25cm} Thesis licensed under a [Creative Commons Attribution 4.0 International License](http://creativecommons.org/licenses/by/4.0/")

```{=latex}
\end{centering}
```



\newpage
\renewcommand*\contentsname{Tabla de contenidos}
\tableofcontents
\mainmatter

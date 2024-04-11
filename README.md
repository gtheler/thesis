# Neutron transport in the cloud

A PhD in Nuclear Engineering thesis written in markdown and tracked with Git which generates

 * [PDF](https://seamplex.com/thesis/pdf/)
 * [HTML](https://seamplex.com/thesis/html/)
 * [ePub](https://seamplex.com/thesis/epub/) (best viewed with [KOReader](https://koreader.rocks/))

The hash and date of the Git commit use to compile the document goes into

 * the [abstract page](https://seamplex.com/thesis/html/front/abstract.html) in all formats
 * each of the PDF's page footers
 * the name of the file in PDF and ePub formats

> [!NOTE]
> This is a PhD Thesis for an [Argentinian university](https://www.ib.edu.ar/english_version/Instituto_Balseiro.php).
> It is legally required to be written in Spanish.
> The Abstract and the appendices are in English, though.

 * See the main publication in JOSS: <https://doi.org/10.21105/joss.05846>
 * Check out the FeenoX webpage: <https://www.seamplex.com/feenox/>


## Abstract


_by Jeremy Theler_


Traditional core-level neutronic computational tools are focused on solving the multigroup neutron diffusion equation over structured hexahedral grids. 
While this approach might be reasonable for light-water power reactors, cores where the moderator is separated from the coolant---such as heavy-water power plants and some research reactors---cannot be represented accurately with structured grids, especially if the control rods are slanted.
In this work, we show how a free and open-source cloud-first large-scale parallel computational tool aimed at solving partial differential equations spatially discretized using the finite element method can be used to solve core-level neutronics using the multigroup discrete ordinates S$_N$ angular scheme.
This tool, named FeenoX and developed from scratch using the Unix programming philosophy, can solve generic PDEs by providing a mechanism based on arbitrary entry points using C function pointers which build the elemental objects for the FEM formulation.
It also allows to scale in parallel using the MPI standard in a way which is suitable to be launched on several cloud servers.
This way, in principle, large problems can be split into several hosts using domain decomposition techniques overcoming the usual RAM limitations.
Two of the PDEs that the initial version of the code can solve include multigroup neutron diffusion and neutron transport using the discrete ordinates method.

This thesis explains the mathematics of the neutron transport equation, how the diffusion approximation can be derived from the former and two of the many possible numerical discretizations in angle and space for both equations. It also discusses the design and implementation of the tool FeenoX, that fulfills a fictitious (but plausible) set of requirement specifications (SRS) by proposing a design document (SDS) explaining how the developed tool addresses each of the tender requirements.
In the results chapter, ten neutronic problems are solved. All of them need at least one of the unfair advantages that FeenoX's features configure: 1. programmatic simulation (that derives from the Unix philosophy); 2. unstructured grids; 3. discrete ordinates; 4. parallelization using MPI.
This work sets a basis for further numerical studies comparing S$_N$ and diffusion schemes for advanced core-level reactor analysis.

## Compilation

To compile, the following dependencies are needed

 * Git
 * Quarto 
 * Pandoc
 * XeLaTeX (make sure you also install the language package for hyphenation patterns, in this case `texlive-lang-spanish`)
 * Inkscape

> [!NOTE]
> Recent Quarto versions do not work.
> Use version 1.3.450
>
> ```
> $ wget https://github.com/quarto-dev/quarto-cli/releases/download/v1.3.450/quarto-1.3.450-linux-amd64.deb
> $ sudo gdebi quarto-1.3.450-linux-amd64.deb
> $ quarto --version
> 1.3.450
> $
> ``` 
 
 
Compile to PDF, HTML and/or epub with make

```
make pdf
make html
make epub
```

 
## License
 
Shield: [![CC BY 4.0][cc-by-shield]][cc-by]

This work is licensed under a
[Creative Commons Attribution 4.0 International License][cc-by].

[![CC BY 4.0][cc-by-image]][cc-by]

[cc-by]: http://creativecommons.org/licenses/by/4.0/
[cc-by-image]: https://i.creativecommons.org/l/by/4.0/88x31.png
[cc-by-shield]: https://img.shields.io/badge/License-CC%20BY%204.0-lightgrey.svg 

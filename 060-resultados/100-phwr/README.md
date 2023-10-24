
# PHWR de siete canales y tres barras de control inclinadas {#sec-phwr}

> **TL;DR:** Mallas no estructuradas, dependencias espaciales no triviales, escalabilidad.

mostrar que KSP es mucho más barato que EPS

convergencia de malla: keff vs. dofs en difusion, s2 y s4



difusion 2do orden
```
jtheler@LIN54Z7SQ3:~/thesis/060-resultados/100-phwr$ for i in 1 2 4 8 12; do mpirun -n $i feenox phwr-dif.fee; done
size = 256964   time = 138.8 s   memory = 6.5 Gb
[0/1 LIN54Z7SQ3] local memory = 6.5 Gb
size = 256964   time = 91.1 s    memory = 7.8 Gb
[0/2 LIN54Z7SQ3] local memory = 4.3 Gb
[1/2 LIN54Z7SQ3] local memory = 3.6 Gb
size = 256964   time = 70.6 s    memory = 9.9 Gb
[0/4 LIN54Z7SQ3] local memory = 3.0 Gb
[1/4 LIN54Z7SQ3] local memory = 2.4 Gb
[2/4 LIN54Z7SQ3] local memory = 2.2 Gb
[3/4 LIN54Z7SQ3] local memory = 2.2 Gb
size = 256964   time = 76.1 s    memory = 12.8 Gb
[0/8 LIN54Z7SQ3] local memory = 1.6 Gb
[1/8 LIN54Z7SQ3] local memory = 1.9 Gb
[2/8 LIN54Z7SQ3] local memory = 1.6 Gb
[3/8 LIN54Z7SQ3] local memory = 1.6 Gb
[4/8 LIN54Z7SQ3] local memory = 1.5 Gb
[5/8 LIN54Z7SQ3] local memory = 1.6 Gb
[6/8 LIN54Z7SQ3] local memory = 1.6 Gb
[7/8 LIN54Z7SQ3] local memory = 1.4 Gb
size = 256964   time = 67.4 s    memory = 14.9 Gb
[0/12 LIN54Z7SQ3] local memory = 1.5 Gb
[1/12 LIN54Z7SQ3] local memory = 1.3 Gb
[2/12 LIN54Z7SQ3] local memory = 1.2 Gb
[3/12 LIN54Z7SQ3] local memory = 1.3 Gb
[4/12 LIN54Z7SQ3] local memory = 1.3 Gb
[5/12 LIN54Z7SQ3] local memory = 1.1 Gb
[6/12 LIN54Z7SQ3] local memory = 1.1 Gb
[7/12 LIN54Z7SQ3] local memory = 1.1 Gb
[8/12 LIN54Z7SQ3] local memory = 1.0 Gb
[9/12 LIN54Z7SQ3] local memory = 1.1 Gb
[10/12 LIN54Z7SQ3] local memory = 1.4 Gb
[11/12 LIN54Z7SQ3] local memory = 1.6 Gb
jtheler@LIN54Z7SQ3:~/thesis/060-resultados/100-phwr$ 
```

s2 primer orden
```
Info    : Done meshing 3D (Wall 0.376522s, CPU 0.372091s)
Info    : 16120 nodes 109387 elements
Info    : Writing 'phwr.msh'...
Info    : Done writing 'phwr.msh'
Info    : Stopped on Tue Oct 24 19:45:11 2023 (From start: Wall 0.691222s, CPU 0.684064s)
jtheler@LIN54Z7SQ3:~/thesis/060-resultados/100-phwr$ feenox phwr-sn.fee --progress
...........................^Cpid 28350: signal #2 caught, finnishing...
jtheler@LIN54Z7SQ3:~/thesis/060-resultados/100-phwr$ for i in 1 2 4 8; do mpirun -n $i feenox phwr-s2.fee; done
size = 257920   time = 415.6 s   memory = 20.1 Gb
[0/1 LIN54Z7SQ3] local memory = 20.1 Gb
size = 257920   time = 294.6 s   memory = 25.6 Gb
[0/2 LIN54Z7SQ3] local memory = 11.4 Gb
[1/2 LIN54Z7SQ3] local memory = 14.1 Gb
size = 257920   time = 295.8 s   memory = 27.7 Gb
[0/4 LIN54Z7SQ3] local memory = 7.5 Gb
[1/4 LIN54Z7SQ3] local memory = 6.4 Gb
[2/4 LIN54Z7SQ3] local memory = 6.9 Gb
[3/4 LIN54Z7SQ3] local memory = 6.9 Gb
size = 257920   time = 208.9 s   memory = 36.6 Gb
[0/8 LIN54Z7SQ3] local memory = 6.0 Gb
[1/8 LIN54Z7SQ3] local memory = 4.9 Gb
[2/8 LIN54Z7SQ3] local memory = 4.5 Gb
[3/8 LIN54Z7SQ3] local memory = 4.0 Gb
[4/8 LIN54Z7SQ3] local memory = 3.7 Gb
[5/8 LIN54Z7SQ3] local memory = 4.3 Gb
[6/8 LIN54Z7SQ3] local memory = 4.4 Gb
[7/8 LIN54Z7SQ3] local memory = 4.8 Gb
jtheler@LIN54Z7SQ3:~/thesis/060-resultados/100-phwr$ 
``` 


```
Info    : 3147 nodes 21982 elements
Info    : Writing 'phwr0.msh'...
Info    : Done writing 'phwr0.msh'
Info    : Stopped on Tue Oct 24 20:07:35 2023 (From start: Wall 0.38859s, CPU 0.393357s)
jtheler@LIN54Z7SQ3:~/thesis/060-resultados/100-phwr$ Qt: Session management error: networkIdsList argument is NULL
bg
bash: bg: job 1 already in background
jtheler@LIN54Z7SQ3:~/thesis/060-resultados/100-phwr$ for i in 1 2 4; do mpirun -n $i feenox phwr-s4.fee; done
```

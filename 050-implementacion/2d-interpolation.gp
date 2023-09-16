#!/usr/bin/gnuplot -persist

set xlabel "x" 
set ylabel "y" 
unset colorbox
set ticslevel 0
unset key
set size ratio 2.0/3.0

# TODO! dar vueltas esto, primero la interpolacion y despues el paraboloide
set terminal svg
set output "f.svg"
set zlabel "f" 
splot "2d-interpolation.dat" u 1:2:3 w l palette, "hyperbolic-paraboloid.dat" pt 52 ps 2 palette

set output "g.svg"
set zlabel "g" 
splot "2d-interpolation.dat" u 1:2:4 w l palette, "hyperbolic-paraboloid.dat" pt 52 ps 2 palette

set output "h.svg"
set zlabel "h" 
splot "2d-interpolation.dat" u 1:2:5 w l palette, "hyperbolic-paraboloid.dat" pt 52 ps 2 palette

set output "f-topology.svg"
set zlabel "f" 
splot "2d-interpolation-topology.dat" u 1:2:3 w l palette, "hyperbolic-paraboloid-topology.dat" pt 52 ps 2 palette

set output "f-modified.svg"
set zlabel "f" 
splot "2d-interpolation-topology-modified.dat" u 1:2:3 w l palette



set terminal png
set xrange [-1:3]
set yrange [-1:2]

set output "f.png"
plot "2d-interpolation.dat" u 1:2:3 w image

set output "g.png"
plot "2d-interpolation.dat" u 1:2:4 w image

set output "h.png"
plot "2d-interpolation.dat" u 1:2:5 w image

set output "f-topology.png"
plot "2d-interpolation-topology.dat" u 1:2:3 w image

set output "f-modified.png"
plot "2d-interpolation-topology-modified.dat" u 1:2:3 w image

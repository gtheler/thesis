set palette defined ( 0 0.65 0.65 0.25, 0.25 0.75 0.9 0.75, 1 0.75 0.25 0.25 )
unset colorbox
unset key
set xlabel "coeficiente de reactividad del combustible [1/K]"
set ylabel "coeficiente de reactividad del refrigerante [1/K]"
set xrange [-50e-5:+50e-5]
set yrange [-50e-5:+50e-5]
set cbrange [0:4]
set size square
set terminal png size 800,800
set output "map.png"
plot "point.dat" palette pt 44, "xaxis" w l lt 9, "yaxis" w l lt 9

set terminal svg size 750,600 font "Arial,14"
set output "map.svg"
plot "point.dat" palette pt 50 ps 0.5, "xaxis" w l lt 9, "yaxis" w l lt 9

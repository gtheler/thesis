load "style.gnuplot"

set output "tres-pescaditos-siman.pdf"

plot "pescaditos-fijos.dat"  w  p pt 59 ps 1.0 lt 7          ti "",\
     "./tres-pescaditos-siman.dat" every ::::1 ps 1.5 palette pt 4 ti "fish #3 initial position",\
     "./tres-pescaditos-siman.dat" w lp pt 2  ps 0.5 palette       ti "fish #3 intermediate steps",\
     "< tail -n 1 ./tres-pescaditos-siman.dat" ps 1.0 lt 7 pt 6    ti "fish #3 simmualted annealing optimal position"
     
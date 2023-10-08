load "style.gnuplot"

set terminal pdf size 14cm,10cm
set output "tres-pescaditos-ele.pdf"

set label 1 "pescadito 1" at 10,-6.5 center
set label 2 "pescadito 2" at  0,-9.0 center

plot "pescaditos-fijos-elements.dat"  w  p pt 59 ps 1.0 lt 3          ti "",\
     "./tres-pescaditos-elements.dat" every ::::1 ps 1.5 palette pt 4 ti "posicion inicial pescadito 3",\
     "./tres-pescaditos-elements.dat" w lp pt 2  ps 0.5 palette       ti "pasos intermedios pescadito 3",\
     "< tail -n 1 ./tres-pescaditos-elements.dat" ps 1.0 lt 3 pt 6    ti "posicion optima pescadito 3"
     

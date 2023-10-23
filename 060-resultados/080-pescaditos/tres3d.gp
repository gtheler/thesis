set view 70, 130, 1, 1
set size ratio 0 1,1
set ztics  norangelimit 0.002
set cbtics  norangelimit 0.004
set xlabel "x" 
set xrange [ -50.0000 : 50.0000 ] noreverse writeback
set ylabel "y" 
set y2label "" 
set y2label  font "" textcolor lt -1 rotate
set yrange [ -50.0000 : 50.0000 ] noreverse writeback
set ticslevel 0

set terminal svg size 800,600
set output "tres3d-1.svg"
splot "tres.csv" w lp palette ti ""

set view 55, 240, 1, 1

set terminal svg size 800,600
set output "tres3d-2.svg"
replot

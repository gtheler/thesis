set size square
set xlabel "x"
set ylabel "y"
set cblabel "reactivity [PCM]"
set xrange [-32:32]
set yrange [-32:32]
set cbrange [-2200:-3410]
set border 3

set tics scale 0.2
set tics nomirror
set cbtics 200
set xtics 20
set ytics 20
set key bottom

set xzeroaxis
set yzeroaxis
#set palette defined (0 "green", 1 "blue", 2 "red")
set palette defined (0 "green", 0.5 "yellow", 1 "red")

set label 1 "fish #1" at 10,-7.5 center
set label 2 "fish #2" at  0,-10 center

set terminal pdf size 14cm,10cm

#!/bin/bash

for i in gnu intel; do

 if [ "x$i" = "xintel" ]; then
  . /opt/intel/oneapi/setvars.sh
 fi

 for j in dif-src dif s2-src s2 s4-src s4; do
  for n in 1 2 4 8; do
   echo $i $j $n
   mpiexec -n ${n} ~/feenox/feenox-${i} phwr-${j}.fee | tee ${i}-phwr-${j}-${n}.out
  done 
 done
done

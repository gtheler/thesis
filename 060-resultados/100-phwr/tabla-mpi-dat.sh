#!/bin/bash

for i in gnu intel; do

 for j in dif-src dif s2-src s2 s4-src s4; do
  rm -f ${i}-phwr-${j}-mpi.dat
  for n in 1 2 4 8; do
   cat ${i}-phwr-${j}-${n}.out | head -1 | awk -vn=${n} '{print n, $10/n, $6, $10}' >> ${i}-phwr-${j}-mpi.dat
  done 
 done
done

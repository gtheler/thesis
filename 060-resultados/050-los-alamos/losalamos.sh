#!/bin/bash

for p in $(ls la-*.fee | grep -v IN); do
 rm -f tmp
 for c in 1 0.75 0.65 0.60 0.55 0.5; do
  gmsh -v 0 -3 $(basename ${p} .fee).geo -clscale ${c}   
  for N in 2 4 6 8; do
   feenox ${p} $N | tee -a tmp
  done
 done
 sort -g tmp > $(basename ${p} .fee).csv
done


#!/bin/bash

for p in \
la-p10-PUb-H2O_10-1-0-CY \
 ; do
 rm -f tmp
 for c in 1 0.75 0.65 0.60 0.55 0.5; do
  gmsh -v 0 -3 ${p}.geo -clscale ${c}   
  for N in 2 4 6 8; do
   feenox ${p}.fee $N | tee -a tmp
  done
 done
 sort -g tmp > ${p}.csv
done


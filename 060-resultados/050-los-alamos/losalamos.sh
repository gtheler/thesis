#!/bin/bash

for p in \
la-p02-PUa-1-0-SL \
la-p03-PUa-H2O_1-1-0-SL \
la-p04-PUa-H2O_0.5-1-0-SL \
la-p06-PUb-1-0-SL \
la-p07-PUb-1-0-CY \
la-p08-PUb-1-0-SP \
la-p09-PUb-H2O_1-1-0-CY \
la-p10-PUb-H2O_10-1-0-CY \
la-p48-U-2-0-SL \
la-p49-U-2-0-SP \
la-p51-UAl-2-0-SL \
la-p52-UAl-2-0-SP \
la-p71-URRa-2-1-SL \
 ; do
 rm -f tmp
 for c in 1 0.75 0.65; do
  gmsh -v 0 -3 ${p}.geo -clscale ${c}   
  for N in 2 4 6; do
   feenox ${p}.fee $N | tee -a tmp
  done
 done
 sort -g tmp > ${p}.csv
done


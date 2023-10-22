#!/bin/bash

rm -f *IN.csv
for p in la-p01-PUa-1-0-IN  \
         la-p47-U-2-0-IN    \
         la-p70-URRa-2-1-IN \
         la-p05-PUb-1-0-IN  \
         la-p50-UAl-2-0-IN; do
 for N in 2 4 6 8; do
  feenox ${p}.fee $N >> ${p}.csv
 done
done

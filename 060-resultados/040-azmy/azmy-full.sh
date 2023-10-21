#!/bin/bash

thetas="0 15 30 45"
cs="4 3 2 1.5 1"
sns="4 6 8 10 12"

for theta in ${thetas}; do
 echo "angle = ${theta};" > azmy-angle-${theta}.geo
 for c in ${cs}; do
  gmsh -v 0 -2 azmy-angle-${theta}.geo azmy-full.geo -clscale ${c} -o azmy-full-${theta}.msh
  for sn in ${sns}; do
   if [ ! -e azmy-full-${theta}-${sn}-${c}.dat ]; then
     echo ${theta} ${c} ${sn}
     feenox azmy-full.fee ${theta} ${sn} ${c} --progress
   fi
  done
 done
done


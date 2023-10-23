#!/bin/bash

A=50   # radio del reactor
a=2    # radio del pescadito

rm -f tmp
for r in $(feenox steps.fee 3 47 64); do
 cat << EOF > vars.geo 
A = ${A};
a = ${a};
r = ${r};
EOF
 gmsh -2 -v 0 dos-pescaditos.geo
 feenox dos-pescaditos.fee | tee -a tmp
done
sort -g tmp > dos-pescaditos.csv

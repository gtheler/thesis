#!/bin/bash

A=50   # radio del reactor
a=2    # radio del pescadito

rm -f dos-pescaditos.csv
for r in $(seq 3 1 47); do
 cat << EOF > vars.geo 
A = ${A};
a = ${a};
r = ${r};
EOF
 gmsh -2 -v 0 dos-pescaditos.geo
 feenox dos-pescaditos.fee | tee -a dos-pescaditos.csv
done

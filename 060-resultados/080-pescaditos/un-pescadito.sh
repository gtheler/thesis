#!/bin/bash

A=50   # radio del reactor
a=2    # radio del pescadito

rm -f un-pescadito.csv
for r in $(seq 0 1 47); do
 cat << EOF > vars.geo 
A = ${A};
a = ${a};
r = ${r};
EOF
 gmsh -2 -v 0 un-pescadito.geo
 feenox un-pescadito.fee | tee -a un-pescadito.csv
done

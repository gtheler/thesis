#!/bin/bash

A=50   # radio del reactor
a=2    # radio del pescadito

for r in $(seq 0 5 45); do
 cat << EOF > vars.geo 
A = ${A};
a = ${a};
r = ${r};
EOF
 gmsh -2 -v 0 un-pescadito.geo
 feenox un-pescadito.fee | tee -a un-pescadito.csv
done

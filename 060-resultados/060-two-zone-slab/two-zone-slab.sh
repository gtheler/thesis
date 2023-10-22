#!/bin/bash

b="100"   # ancho adimensional del slab
if [ -z $1 ]; then
  n="10"    # número de elementos
else
  n=$1
fi

rm -rf two-zone-slab-*-${n}.dat

# barremos a (posición de la interfaz)
for a in $(seq 35 57); do
  cat << EOF > ab.geo
a = ${a};
b = ${b};
n = ${n};
lc = b/n;
EOF
  for p in i ii; do
    gmsh -1 -v 0 two-zone-slab-${p}.geo
    feenox two-zone-slab.fee ${p} | tee -a two-zone-slab-${p}-${n}.dat
  done
done


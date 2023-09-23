#!/bin/bash -e

# si no nos dieron una expresión, usamos esta
if [ -z "$1" ]; then
 f="1 + x*sqrt(y) + 2*log(1+y+z) + cos(x*z)*exp(y*z)"
fi

# verificamos que los binarios necesarios estén
for i in gmsh feenox /usr/bin/time; do
 if [ -z "$(which ${i})" ]; then
  echo "error: ${i} not installed"
  exit 1
 fi
done

# rango para n
min=10
max=50
step=10

echo "generando mallas"
echo
echo " \$n\$ |    elementos   |     nodos      | tiempo de mallado [s] | tiempo de rellenado [s] "
echo   ":---:|:--------------:|:--------------:|:---------------------:|:-----------------------:"
# esta tabla tiene puntos como separador de miles y coma como separador de decimales
export LC_NUMERIC="es_AR.utf8"

for n in $(seq ${min} ${step} ${max}); do
 /usr/bin/time -o time_creation${n} -f "%e" gmsh -v 0 -3 -clmax $(echo PRINT 1/${n} | feenox -) cube.geo -o cube-${n}.msh
 /usr/bin/time -o time_population${n} -f "%e" feenox create.fee "${f}" ${n}
 echo " ${n}  |  $(printf "%'d" $(feenox cells.fee cube-${n}.msh)) | $(printf "%'d" $(feenox nodes.fee cube-${n}.msh)) | $(cat time_creation${n} | tr . ,) | $(cat time_population${n} | tr . ,)"
done


echo
echo "interpolando..."
for src in $(seq ${min} ${step} ${max}); do
 for dst in $(seq ${min} ${step} ${max}); do
  echo "de ${src} a ${dst}... "
  /usr/bin/time -o time_interp_${src}_${dst} -f "%e" feenox interpolate.fee ${src} ${dst}
 done
 echo
done


echo
echo "calculando errores"
echo
echo " \$n_1\$ | \$n_2\$ | error \$L_2\$ | error \$L_\infty\$ | tiempo [s] "
echo     ":-----:|:-----:|:-------------:|:------------------:|:----------:"

for src in $(seq ${min} ${step} ${max}); do
 for dst in $(seq ${min} ${step} ${max}); do
  feenox error.fee "${f}" ${src} ${dst} | sed 's/\(-\?[0-9].\?[0-9]*\)e\(-\?[0-9].\?[0-9]*\)/$\1 \\times 10^{\2}$/g' | sed 's/-0/-/g'
  echo $(cat time_interp_${src}_${dst})
 done
done

#!/bin/bash

bc="dirichlet"
algo="delaunay"
elems="tet4 tet10"

declare -A cs

cs["tet4"]="20 24 28 36 40 44 48 54 60 64"
cs["tet10"]="12 16 20 24 28 32 36 40 44 48"

# set this flag to 1 if you want to create one VTK for each run
vtk=1
for i in feenox gmsh maxima tr m4; do
 if [ -z "$(which ${i})" ]; then
  echo "error: ${i} not installed"
  exit 1
 fi
done

. styles.sh


# primero leemos el flujo y las XSs del input de FeenoX
phi1_mms=$(grep "phi1_mms(x,y,z) =" neutron-bunny.fee | sed 's/=/:=/')
D1=$(grep "D1(x,y,z) =" neutron-bunny.fee | sed 's/=/:=/')
Sigma_a1=$(grep "Sigma_a1(x,y,z) =" neutron-bunny.fee | sed 's/=/:=/')

# y después le pedimos a maxima que haga las cuentas por nosotros
maxima --very-quiet << EOF > /dev/null
${phi1_mms};
${D1};
${Sigma_a1};
s1(x,y,z) := -(diff(D1(x,y,z) * diff(phi1_mms(x,y,z), x), x) + diff(D1(x,y,z) * diff(phi1_mms(x,y,z), y), y) + diff(D1(x,y,z) * diff(phi1_mms(x,y,z), z), z)) + Sigma_a1(x,y,z)*phi1_mms(x,y,z);
stringout("neutron-bunny-s1.txt", s1(x,y,z));
tex(s1(x,y,z), "neutron-bunny-s1.tex");
EOF


## read back the string with phi_mms(x) and store it in a FeenoX input
s1=$(cat neutron-bunny-s1.txt | tr -d ';\n')
cat << EOF > neutron-bunny-s.fee
S1(x,y,z) = ${s1}
EOF

# report what we found
cat << EOF
# manufactured solution (input)
${phi1_mms};
${D1};
${Sigma_a1};

# source term (output)
S1(x,y,z) = ${s1}
EOF

# exit


rm -f neutron-bunny-fits.ppl
echo "plot \\" > neutron-bunny-einf.ppl
echo "plot \\" > neutron-bunny-e2.ppl

 for elem in ${elems}; do
    dat="neutron_bunny_${elem}"
    rm -f ${dat}.dat
    echo ${dat}
    echo "--------------------------------------------------------"
     
    for c in ${cs[${elem}]}; do
  
     name="neutron_bunny_${elem}-${c}"
   
     # prepare mesh
     if [ ! -e bunny-${elem}-${c}.msh ]; then
       lc=$(echo "PRINT 1/${c}" | feenox -)
       gmsh -v 0 -3 bunny.geo ${elem}.geo -clscale ${lc} -o bunny-${elem}-${c}.msh || exit 1
     fi
     
     # run feenox
     feenox neutron-bunny.fee ${elem} ${c} ${vtk} | tee -a ${dat}.dat

    done
  
    feenox fit.fee ${dat} >> neutron-bunny-fits.ppl
  
    cat << EOF >> neutron-bunny-einf.ppl
     "${dat}.dat"                              u (exp(\$1)):(exp(\$2)) w lp pt ${pt[${elem}]} lw 1 lt 2 color ${co[${bc}${algo}]}  ti "${bc}-${elem}= " + e_inf_neutron_bunny_${elem}_title,\\
EOF
    cat << EOF >> neutron-bunny-e2.ppl
     "${dat}.dat"                              u (exp(\$1)):(exp(\$3)) w lp pt ${pt[${elem}]} lw 1 lt 2 color ${co[${bc}${algo}]}  ti "${bc}-${elem} = " + e_inf_neutron_bunny_${elem}_title,\\
EOF

 done

cat << EOF >> neutron-bunny-einf.ppl
 1e-6*x**2    w l lt 2 lw 4 color gray ti "\$10^{-6} \\cdot h^2\$",\\
 3e-7*x**3    w l lt 3 lw 4 color gray ti "\$3 \\cdot 10^{-7} \\cdot h^3\$"
EOF

cat << EOF >> neutron-bunny-e2.ppl
 1e-6*x**2    w l lt 2 lw 4 color gray ti "\$10^{-6} \\cdot h^2\$",\\
 3e-7*x**3    w l lt 3 lw 4 color gray ti "\$3 \\cdot 10^{-7} \\cdot h^3\$"
EOF

cat << EOF > neutron-bunny-results.md

 element type | order of convergence
--------------|:----------------------:
EOF
grep ^# neutron-bunny-fits.ppl | tr -d \# | sed s/neutron_bunny_// | sed 's/_/ | /g' >> neutron-bunny-results.md


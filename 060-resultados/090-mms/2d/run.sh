#!/bin/bash -e
# 
bcs="dirichlet neumann"
elems="tri3 tri6 quad4 quad8"
algos="struct frontal"

# bcs="neumann"
# elems="tri3"
# algos="struct"

declare -A cs

cs["tri3"]="4 6 12 16 20"
cs["quad4"]="4 6 12 16 20"

cs["tri6"]="4 6 8 10 12"
cs["quad8"]="4 6 8 10 12"
cs["quad9"]="4 6 8 10 12"


# set this flag to 1 if you want to create one VTK for each run
vtk=0
if [ "x${1}" = "xvtk" ]; then
  vtk=1  
fi

. styles.sh


for i in feenox gmsh maxima tr; do
 if [ -z "$(which ${i})" ]; then
  echo "error: ${i} not installed"
  exit 1
 fi
done

# compute the appropriate neutron source
## first read flux and XS from FeenoX inputp
phi1=$(grep "phi1_mms(x,y) =" neutron-square.fee | sed 's/phi1_mms(x,y)//' | sed 's/=//')
phi1_mms=$(grep "phi1_mms(x,y) =" neutron-square.fee | sed 's/=/:=/')

phi2=$(grep "phi2_mms(x,y) =" neutron-square.fee | sed 's/phi2_mms(x,y)//' | sed 's/=//')
phi2_mms=$(grep "phi2_mms(x,y) =" neutron-square.fee | sed 's/=/:=/')

# TODO: bash array
D1=$(grep "D1(x,y) =" neutron-square.fee | sed 's/=/:=/')
Sigma_a1=$(grep "Sigma_a1(x,y) =" neutron-square.fee | sed 's/=/:=/')
Sigma_s1_2=$(grep "Sigma_s1_2(x,y) =" neutron-square.fee | sed 's/=/:=/')

D2=$(grep "D2(x,y) =" neutron-square.fee | sed 's/=/:=/')
Sigma_a2=$(grep "Sigma_a2(x,y) =" neutron-square.fee | sed 's/=/:=/')
Sigma_s2_1=$(grep "Sigma_s2_1(x,y) =" neutron-square.fee | sed 's/=/:=/')

## then ask maxima to compute the sources and currents
maxima --very-quiet << EOF > /dev/null
${phi1_mms};
${phi2_mms};
${D1};
${Sigma_a1};
${Sigma_s1_2};
${D2};
${Sigma_a2};
${Sigma_s2_1};
s1(x,y) := -(diff(D1(x,y) * diff(phi1_mms(x,y), x), x) + diff(D1(x,y) * diff(phi1_mms(x,y), y), y)) + Sigma_a1(x,y)*phi1_mms(x,y) - Sigma_s2_1(x,y)*phi2_mms(x,y);
s2(x,y) := -(diff(D2(x,y) * diff(phi2_mms(x,y), x), x) + diff(D2(x,y) * diff(phi2_mms(x,y), y), y)) + Sigma_a2(x,y)*phi2_mms(x,y) - Sigma_s1_2(x,y)*phi1_mms(x,y);
stringout("neutron-square-s1.txt", s1(x,y));
stringout("neutron-square-s2.txt", s2(x,y));
stringout("neutron-square-j1x.txt", -D1(x,y) * diff(phi1_mms(x,y),x));
stringout("neutron-square-j1y.txt", -D1(x,y) * diff(phi1_mms(x,y),y));
stringout("neutron-square-j2x.txt", -D2(x,y) * diff(phi2_mms(x,y),x));
stringout("neutron-square-j2y.txt", -D2(x,y) * diff(phi2_mms(x,y),y));
EOF



## read back the string with phi_mms(x) and store it in a FeenoX input
s1=$(cat neutron-square-s1.txt | tr -d ';\n')
j1x=$(cat neutron-square-j1x.txt | tr -d ';\n')
j1y=$(cat neutron-square-j1y.txt | tr -d ';\n')

s2=$(cat neutron-square-s2.txt | tr -d ';\n')
j2x=$(cat neutron-square-j2x.txt | tr -d ';\n')
j2y=$(cat neutron-square-j2y.txt | tr -d ';\n')

cat << EOF > neutron-square-s.fee
S1(x,y) = ${s1}
S2(x,y) = ${s2}

Jx1_mms(x,y) = ${j1x}
Jy1_mms(x,y) = ${j1y}
Jx2_mms(x,y) = ${j2x}
Jy2_mms(x,y) = ${j2y}
EOF

# report what we found
cat << EOF
# manufactured solution (input)
${phi1_mms};
${phi2_mms};
${D1};
${Sigma_a1};
${Sigma_s1_2};
${D2};
${Sigma_a2};
${Sigma_s2_1};

# source terms (output)
S1(x,y) = ${s1}
S2(x,y) = ${s2}
J1x(x,y) = ${j1x}
J1y(x,y) = ${j1y}
J2x(x,y) = ${j2x}
J2y(x,y) = ${j2y}
EOF


rm -f neutron-square-fits.ppl
echo "plot \\" > neutron-square-einf.ppl
echo "plot \\" > neutron-square-e2.ppl

for bc in ${bcs}; do
 for elem in ${elems}; do
  for algo in ${algos}; do
  
    dat="neutron_square_${bc}_${elem}_${algo}"
    rm -f ${dat}.dat
    echo ${dat}
    echo "--------------------------------------------------------"
     
    for c in ${cs[${elem}]}; do
  
     name="neutron_square_${bc}-${elem}-${algo}-${c}"
   
     # prepare mesh
     if [ ! -e square-${elem}-${algo}-${c}.msh ]; then
       lc=$(echo "PRINT 1/${c}" | feenox -)
       gmsh -v 0 -2 square.geo ${elem}.geo ${algo}.geo -clscale ${lc} -o square-${elem}-${algo}-${c}.msh
     fi
   
     # run feenox
     feenox neutron-square.fee ${bc} ${elem} ${algo} ${c} ${vtk} | tee -a ${dat}.dat
      
    done
 
    feenox fit.fee ${dat}  >> neutron-square-fits.ppl
  
    cat << EOF >> neutron-square-einf.ppl
     "${dat}.dat"                              u (exp(\$1)):(exp(\$2)) w lp pt ${pt[${elem}]} lw 1 lt 2 color ${co[${bc}${algo}]}  ti "${bc}-${elem}-${algo} = " + e_inf_neutron_square_${bc}_${elem}_${algo}_title,\\
e_inf_neutron_square_${bc}_${elem}_${algo}(x)        w l                    lw 2 lt 1 color ${co[${bc}${algo}]}  ti "",\\
EOF
#     cat << EOF >> neutron-square-e2.ppl
#      "${dat}.dat"                              u (exp(\$1)):(exp(\$3)) w lp pt ${pt[${elem}]} lw 1 lt 2 color ${co[${bc}${algo}]}  ti "${bc}-${elem}-${algo} = " + e_inf_neutron_square_${bc}_${elem}_${algo}_title,\\
#   e_2_neutron_square_${bc}_${elem}_${algo}(x)        w l                    lw 2 lt 1 color ${co[${bc}${algo}]}  ti "",\\
# EOF

    cat << EOF >> neutron-square-e2.ppl
     "${dat}.dat"                              u (exp(\$1)):(exp(\$3)) w lp pt ${pt[${elem}]} lw 1 lt 2 color ${co[${bc}${algo}]}  ti "${bc}-${elem}-${algo} = " + e_inf_neutron_square_${bc}_${elem}_${algo}_title,\\
EOF

  done
 done
done

cat << EOF >> neutron-square-einf.ppl
 x**2    w l lt 2 lw 4 color gray ti "\$h^2\$",\\
 x**3    w l lt 3 lw 4 color gray ti "\$ h^3\$"
EOF

cat << EOF >> neutron-square-e2.ppl
 x**2    w l lt 2 lw 4 color gray ti "\$h^2\$",\\
 x**3    w l lt 3 lw 4 color gray ti "\$ h^3\$"
EOF

cat << EOF > neutron-square-results.md

 boundary condition | element type | algorithm | order of convergence
--------------------|--------------|-----------|:----------------------:
EOF
grep ^# neutron-square-fits.ppl | tr -d \# | sed s/neutron_square_// | sed 's/_/ | /g' >> neutron-square-results.md


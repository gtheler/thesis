#!/bin/bash -e
# 
bcs="dirichlet neumann"
elems="tri3 tri6 quad4 quad8 quad9"
algos="struct frontal delaunay"
# cs="4 6 8 10 12 16 20 24 30 36 48"

bcs="dirichlet"
elems="quad4"
algos="struct"
cs="8 12 16"

# set this flag to 1 if you want to create one VTK for each run
vtk=1
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
## first read flux and XS from FeenoX input
phi=$(grep "phi_mms(x,y) =" neutron-square.fee | sed 's/phi_mms(x,y)//' | sed 's/=//')
phi_mms=$(grep "phi_mms(x,y) =" neutron-square.fee | sed 's/=/:=/')
D_mms=$(grep "D_mms(x,y) =" neutron-square.fee | sed 's/=/:=/')
SigmaA_mms=$(grep "SigmaA_mms(x,y) =" neutron-square.fee | sed 's/=/:=/')


## then ask maxima to compute s_mms(x)
maxima --very-quiet << EOF > /dev/null
${phi_mms};
${D_mms};
${SigmaA_mms};
s_mms(x,y) := -(diff(D_mms(x,y) * diff(phi_mms(x,y), x), x) + diff(D_mms(x,y) * diff(phi_mms(x,y), y), y)) + SigmaA_mms(x,y)*phi_mms(x,y);
stringout("neutron-square-s.txt", s_mms(x,y));
stringout("neutron-square-jx.txt", -D_mms(x,y) * diff(phi_mms(x,y),x));
stringout("neutron-square-jy.txt", -D_mms(x,y) * diff(phi_mms(x,y),y));
EOF

## read back the string with phi_mms(x) and store it in a FeenoX input
s=$(cat neutron-square-s.txt | tr -d ';\n')
jx=$(cat neutron-square-jx.txt | tr -d ';\n')
jy=$(cat neutron-square-jy.txt | tr -d ';\n')

cat << EOF > neutron-square-s.fee
s_mms(x,y) = ${s}
jx_mms(x,y) = ${jx}
jy_mms(x,y) = ${jy}
EOF

# report what we found
cat << EOF
# manufactured solution
${phi_mms}
${D_mms}
${SigmaA_mms}
# source terms
s_mms(x,y) = ${s}
jx_mms(x,y) = ${jx}
jy_mms(x,y) = ${jy}

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
     
    for c in ${cs}; do
  
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
    cat << EOF >> neutron-square-e2.ppl
     "${dat}.dat"                              u (exp(\$1)):(exp(\$3)) w lp pt ${pt[${elem}]} lw 1 lt 2 color ${co[${bc}${algo}]}  ti "${bc}-${elem}-${algo} = " + e_inf_neutron_square_${bc}_${elem}_${algo}_title,\\
  e_2_neutron_square_${bc}_${elem}_${algo}(x)        w l                    lw 2 lt 1 color ${co[${bc}${algo}]}  ti "",\\
EOF

  done
 done
done

cat << EOF >> neutron-square-einf.ppl
 x**2    w l lt 2 lw 4 color gray ti "\$h^2\$",\\
 x**3    w l lt 3 lw 4 color gray ti "\$h^3\$"
EOF

cat << EOF >> neutron-square-e2.ppl
 x**2    w l lt 2 lw 4 color gray ti "\$h^2\$",\\
 x**3    w l lt 3 lw 4 color gray ti "\$h^3\$"
EOF

cat << EOF > neutron-square-results.md

 boundary condition | element type | algorithm | order of convergence
--------------------|--------------|-----------|:----------------------:
EOF
grep ^# neutron-square-fits.ppl | tr -d \# | sed s/neutron_square_// | sed 's/_/ | /g' >> neutron-square-results.md


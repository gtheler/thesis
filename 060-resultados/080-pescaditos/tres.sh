cat << EOF > x3.geo 
x3 = $1;
y3 = $2;
EOF
gmsh -2 -v 0 tres-pescaditos.geo
feenox tres-pescaditos.fee

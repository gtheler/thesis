#!/bin/bash
dir=${HOME}/codigos/feenox


for i in ../100-srs/[1234]*.md; do
  ln -sf ${i}
done

for i in download; do
  cp ${dir}/${i}.md .
done

for i in sds why licensing transfer lorenz nafems-le10 mazes laplace nafems-le11 binary source git compilation unix history downloads debian binary source git freesw licensing windows pdes FAQ double-click; do
  cp ${dir}/doc/${i}.md .
done

for i in caeplex-ipad; do
  cp ${dir}/doc/${i}.jpg .
done

for i in cantilever-tet cantilever-hex nafems-le1-struct-metis nafems-le1-unstruct-metis two-squares-temperature two-squares-conductivity nureg cne caeplex-progress highlighting-kate highlighting-vim mechanical-square-temperature mechanical-square-uniform fins-temp utf8-kate utf8-shell thermal-square-temperature mechanical-square-temperature-from-msh nafems-le10 maze-homer maze12 maze3 gmsh-maze maze-sigma maze-delta maze-theta maze-big laplace-square-gmsh laplace-square-paraview nafems-le11-problem nafems-le11-temperature nafems-le11-sigmaz; do
  cp ${dir}/doc/${i}.png .
done 

# for i in cantilever-displacement fork-meshed fork wall-dofs-tet memory-dofs-tet two-squares-mesh nafems-t3 parallelepiped lorenz nafems-le10-problem-input; do
#   cp ${dir}/doc/${i}.svg .
#   svg2pdf.sh ${i}.svg
# done


for i in cantilever.sh hello fins.fee.m4 le10-calculix.inp le10-aster.comm le10-elmer.elm; do
  cp ${dir}/doc/${i} .
done

cp ${dir}/doc/*.fee .

sed -i 's_doc/__' *.md
sed -i 's/.svg//g' *.md
sed -i 's/ig:/ig-/g' *.md
sed -i 's/ec:/ec-/g' *.md
sed -i 's/tbl:/tbl-/g' *.md

sed 's/sds-appendices.md//' sds.md | grep -v "sec-download" | grep -vi "sec-le10-other" > tmp
mv tmp sds.md
# sed -i '/\n/!N;/\n.*\n/!N;/\n.*\n.*sds-appendices.md/{$d;N;N;d};P;D' sds.md
# sed -i -zE 's/([^\n]*\n){2}([^\n]*sds-appendices.md\n]*)(\n[^\n]*){3}/\2/g' sds.md


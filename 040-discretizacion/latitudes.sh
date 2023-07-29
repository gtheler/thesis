if [ -z "$1" ]; then
 echo "usage: $0 N";
 exit 1
fi

cd scripts
./latitudes.sh $1 > ../lats${1}.geo
cd ..

cat << EOF > lats${1}-svg.geo
Merge "octant.geo";
Merge "svg.geo";
Merge "lats${1}.geo";
Print "lats${1}.svg";
Exit;
EOF

gmsh lats${1}-svg.geo
awk -f nicer-lat-svg.awk lats${1}.svg > lats${1}-nice.svg
inkscape --export-area-drawing  --export-pdf=lats${1}-nice.pdf lats${1}-nice.svg

cat << EOF > lats${1}b-svg.geo
Merge "octant.geo";
Merge "svg-b.geo";
Merge "lats$1.geo";
Print "lats${1}b.svg";
Exit;
EOF

gmsh lats${1}b-svg.geo
awk -f nicer-lat-svg.awk lats${1}b.svg > lats${1}b-nice.svg
inkscape --export-area-drawing  --export-pdf=lats${1}b-nice.pdf lats${1}b-nice.svg

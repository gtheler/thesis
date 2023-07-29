if [ -z "$1" ]; then
 echo "usage: $0 N";
 exit 1
fi

cd scripts
./direcciones.sh $1 > ../dirs${1}.geo
cd ..

cat << EOF > dirs${1}-svg.geo
Merge "axes.geo";
Merge "svg.geo";
Merge "dirs${1}.geo";
Print "dirs${1}.svg";
Exit;
EOF

gmsh dirs${1}-svg.geo
awk -f nicer-dir-svg.awk dirs${1}.svg > dirs${1}-nice.svg
inkscape --export-area-drawing  --export-pdf=dirs${1}-nice.pdf dirs${1}-nice.svg


if [ -z "$1" ]; then
 echo "usage: $0 N";
 exit 1
fi

cd scripts
./direcciones2d.sh $1 > ../dirs2d${1}.ppl
cd ..

pyxplot dirs2d${1}.ppl

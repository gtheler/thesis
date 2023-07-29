cat << EOF > sn2d.c
#define WASORA_RUNTIME_ERROR -1
#define WASORA_RUNTIME_OK    0
#include <stdlib.h>
#include <gsl/gsl_math.h>
EOF

grep -v include $HOME/codigos/wasora-suite/milonga/src/discretizations/sn.c | grep -v wasora_push_error >> sn2d.c

sed -i s/milonga\\.// sn2d.c
sed -i s/void/int\ dimensions,\ int\ directions,\ int\ SN/ sn2d.c

gcc -c sn2d.c
gcc -c direcciones2d.c
gcc -o direcciones2d direcciones2d.c sn2d.o

./direcciones2d $1


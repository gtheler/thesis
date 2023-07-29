cat << EOF > sn.c
#define WASORA_RUNTIME_ERROR -1
#define WASORA_RUNTIME_OK    0
#include <stdlib.h>
#include <gsl/gsl_math.h>
EOF

grep -v include $HOME/codigos/wasora-suite/milonga/src/discretizations/sn.c | grep -v wasora_push_error >> sn.c

sed -i s/milonga\\.// sn.c
sed -i s/void/int\ dimensions,\ int\ directions,\ int\ SN/ sn.c

gcc -c sn.c
gcc -c direcciones.c
gcc -o direcciones direcciones.c sn.o

./direcciones $1


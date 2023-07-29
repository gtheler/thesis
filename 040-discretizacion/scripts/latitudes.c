#include <stdio.h>
#include <stdlib.h>

extern int sn_init_weights(int dimensions, int directions, int SN);
extern double **Omega;
extern double *w;

int main(int argc, char **argv) {
  
  int dimensions;
  int SN;
  int directions;
  
  int n, d;
  
  dimensions = 3;
  
  if (argc != 2) {
    SN = 2;
  } else {
    SN = atoi(argv[1]);
  }
  
  directions = SN*(SN+2);
  sn_init_weights(dimensions, directions, SN);
  
  printf("// Merge \"octant.geo\";\n\n");
  
  for (n = 0; n < directions/8; n++) {
    printf("// S%d - n = %d\n", SN, n);
    printf("x = %e;\n", Omega[n][0]);
    printf("y = %e;\n", Omega[n][1]);
    printf("z = %e;\n", Omega[n][2]);
    printf("\n");
    printf("\
Point(%d) = {x, y, z, lc};\n\
\n\
Point(%d) = {x, 0, 0, lc};\n\
Point(%d) = {x, Sqrt(1-x^2), 0, lc};\n\
Point(%d) = {x, 0, Sqrt(1-x^2), lc};\n\
Circle(%d) = {%d, %d, %d};\n\
\n\
Point(%d) = {0, y, 0, lc};\n\
Point(%d) = {0, y, Sqrt(1-y^2), lc};\n\
Point(%d) = {Sqrt(1-y^2), y, 0, lc};\n\
Circle(%d) = {%d, %d, %d};\n\
\n\
Point(%d) = {0, 0, z, lc};\n\
Point(%d) = {0, Sqrt(1-z^2), z, lc};\n\
Point(%d) = {Sqrt(1-z^2), 0, z, lc};\n\
Circle(%d) = {%d, %d, %d};\n\
\n\
Line(%d) = {%d, %d};\n\n\n",
           100*(n+1)+1,
           100*(n+1)+2, 100*(n+1)+3, 100*(n+1)+4,
           100*(n+1)+1, 100*(n+1)+4, 100*(n+1)+2, 100*(n+1)+3,
           100*(n+1)+5, 100*(n+1)+6, 100*(n+1)+7,
           100*(n+1)+2, 100*(n+1)+6, 100*(n+1)+5, 100*(n+1)+7,
           100*(n+1)+8, 100*(n+1)+9, 100*(n+1)+10,
           100*(n+1)+3, 100*(n+1)+10, 100*(n+1)+8, 100*(n+1)+9,
           100*(n+1)+4, 1, 100*(n+1)+1);
  }
  
  return 0;
}
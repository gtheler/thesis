#include <stdio.h>
#include <stdlib.h>

extern int sn_init_weights(int dimensions, int directions, int SN);
extern double **Omega;
extern double *w;

int main(int argc, char **argv) {
  
  double deltax, deltay, deltaz;
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
  
  printf("// Merge \"axes.geo\";\n\n");
  
  for (n = 0; n < directions; n++) {
    printf("// S%d - n = %d\n", SN, n);
    printf("Point(%d) = {%e, %e, %e, lc};\n", 10*(n+1), Omega[n][0], Omega[n][1], Omega[n][2]);
    printf("Line(%d) = {1, %d};\n\n", 10*(n+1), 10*(n+1));
  }

  printf("View \"comments\" {\n");
  for (n = 0; n < directions; n++) {
    deltax = (Omega[n][0]>0)?0.1:-0.1;
    deltay = (Omega[n][1]>0)?0.075:-0.075;
    deltaz = (Omega[n][2]>0)?0.05:-0.05;
    
    printf("T3(%e, %e, %e, TextAttributes(\"Align\", \"Center\", \"Font\", \"Times-Italic\")){ \"%d\" };\n",
      Omega[n][0]+deltax, Omega[n][1]+deltay, Omega[n][2]+deltaz, n+1);
  }
  printf("};\n");
  
  return 0;
}

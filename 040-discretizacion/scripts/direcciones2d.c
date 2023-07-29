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
  
  dimensions = 2;
  
  if (argc != 2) {
    SN = 2;
  } else {
    SN = atoi(argv[1]);
  }
  
  directions = SN*(SN+2)/2;
  sn_init_weights(dimensions, directions, SN);
  
  printf("set multiplot; set nodisplay\n");
  printf("w=8*unit(cm); set terminal pdf\nset width w\nset size ratio 1\n");
  
  for (n = 0; n < directions; n++) {
    printf("arrow from 0.5*w,0.5*w to 0.5*w*(1+%e),0.5*w*(1+%e) with color blue lw 2\n", Omega[n][0], Omega[n][1]);
    printf("text r\"$%d$\" at (0.5+%e)*w*(1+%e),(0.5+%e)*w*(1+%e)\n", (Omega[n][0]>0)?0.02:-0.08, Omega[n][0],
                                                                      (Omega[n][1]>0)?0.02:-0.08, Omega[n][1], n+1);
  }

  printf("set axis x twowayarrow atzero\nset axis y twowayarrow atzero\nset nomxtics\nset nomytics\nunset key\n");
  printf("set xtics 0\nset ytics 0\n");
//   printf("set xlabel \"$x$\" offset 3cm\n");
//   printf("set ylabel \"$y$\" offset 0.5*w\n");
  printf("text r\"$x$\" at 0.95*w,0.47*w\n");
  printf("text r\"$y$\" at 0.48*w,0.95*w rotate 90\n");
  printf("set output 'direcciones2ds%d.pdf'\n", SN);
  printf("set xrange [-1:1]\n");
  printf("set yrange [-1:1]\n");  
  printf("plot 0 w l lw 0 ti ''\n");
  
  printf("set display; refresh\n");
    
  return 0;
}

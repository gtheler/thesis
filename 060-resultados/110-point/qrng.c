#include <stdio.h>
#include <gsl/gsl_qrng.h>

int main (int argc, char **argv) {
  // gsl_qrng * q = gsl_qrng_alloc(gsl_qrng_sobol, 2);
  // gsl_qrng * q = gsl_qrng_alloc(gsl_qrng_niederreiter_2, 2);
  // gsl_qrng * q = gsl_qrng_alloc(gsl_qrng_halton, 2);
  gsl_qrng * q = gsl_qrng_alloc(gsl_qrng_halton, 2);

  double v[2];
  for (unsigned int i = 0; i < 1024; i++) {
    gsl_qrng_get (q, v);
    printf ("%.6f %.6f\n", v[0], v[1]);
  }
  
  printf("# %s\n", gsl_qrng_name(q));
  gsl_qrng_free (q);
  
  return 0;
}


#include <stdio.h>
#include <math.h>

double feenox_mesh_dot(const double *a, const double *b) {
  return a[0]*b[0] + a[1]*b[1] + a[2]*b[2];
}

void feenox_mesh_subtract(const double *a, const double *b, double *c) {
  c[0] = b[0] - a[0];
  c[1] = b[1] - a[1];
  c[2] = b[2] - a[2];
  return;
}

void feenox_mesh_cross(const double *a, const double *b, double *c) {
  c[0] = a[1]*b[2] - a[2]*b[1];
  c[1] = a[2]*b[0] - a[0]*b[2];
  c[2] = a[0]*b[1] - a[1]*b[0];
  return;
}

void feenox_mesh_normalized_cross(const double *a, const double *b, double *c) {
  double norm;
  c[0] = a[1]*b[2] - a[2]*b[1];
  c[1] = a[2]*b[0] - a[0]*b[2];
  c[2] = a[0]*b[1] - a[1]*b[0];
  norm = sqrt(c[0]*c[0] + c[1]*c[1] + c[2]*c[2]);
  if (norm != 0) {
    c[0] /= norm;
    c[1] /= norm;
    c[2] /= norm;
  }

  return;
}

int main(void) {
 
  double x1[3] = {0.5, 0.5, 0.5};
  double x2[3] = {2.5, 3, 1};
  double x3[3] = {1.5, 2.5, 2};
  double a[3];
  double b[3];
  double n[3];

  feenox_mesh_subtract(x1, x2, a);
  feenox_mesh_subtract(x1, x3, b);
  feenox_mesh_normalized_cross(a, b, n);
  
  // the versor in the z direction
  double e_z[3] = {0, 0, 1};

  double t[3];
  feenox_mesh_cross(n, e_z, t);
  double k = 1/(1+feenox_mesh_dot(n, e_z));
  
/*
(%i4) T:matrix([0, -t2, t1],[t2, 0, -t0],[-t1, t0, 0]);
                           [  0    - t2   t1  ]
                           [                  ]
(%o4)                      [  t2    0    - t0 ]
                           [                  ]
                           [ - t1   t0    0   ]
(%i5) T . T;
                 [     2     2                           ]
                 [ - t2  - t1      t0 t1        t0 t2    ]
                 [                                       ]
(%o5)            [                  2     2              ]
                 [    t0 t1     - t2  - t0      t1 t2    ]
                 [                                       ]
                 [                               2     2 ]
                 [    t0 t2        t1 t2     - t1  - t0  ]
*/    

  double R[3][3] = {{ 1     + k * (-t[2]*t[2] - t[1]*t[1]),
                      -t[2] + k * (t[0]*t[1]),
                      +t[1] + k * (t[0]*t[2])},
                    {
                      +t[2] + k * (t[0]*t[1]),
                      1     + k * (-t[2]*t[2] - t[0]*t[0]),
                      -t[0] + k * (t[1]*t[2])},
                    {
                      -t[1] + k * (t[0]*t[2]),
                      +t[0] + k * (t[1]*t[2]),
                      1     + k * (-t[1]*t[1] - t[0]*t[0])
                    }};

  double C[3][3] = {{x1[0], x2[0], x3[0]},
                    {x1[1], x2[1], x3[1]}, 
                    {x1[2], x2[2], x3[2]}};
  double C_prime[3][3];
  
  for (int i = 0; i < 3; i++) {
    for (int j = 0; j < 3; j++) {
      C_prime[i][j] = 0;
      for (int k = 0; k < 3; k++) {
        C_prime[i][j] += R[i][k] * C[k][j];
      }
    }
  }
  
  for (int i = 0; i < 3; i++) {
    for (int j = 0; j < 3; j++) {
      printf("%g\t", C_prime[i][j]);
    }
    printf("\n");
  }
  
  return 0;
  
}

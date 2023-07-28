#include <stdio.h>
#include <stdlib.h>
#include <math.h>

int **init_sn(int N);

int main(int argc, char **argv) {

  int N = 2;
  if (argc > 1) {
    N = atoi(argv[1]);
  }
  int **weights = init_sn(N);
}

int **init_sn(int N) {
  
  int **A = calloc(N/2, sizeof(int *));
  int **B = calloc(N/2, sizeof(int *));
  int **C = calloc(N/2, sizeof(int *));
  int **D = calloc(N/2, sizeof(int *));
  int **E = calloc(N/2, sizeof(int *));
  int **F = calloc(N/2, sizeof(int *));
  for (int i = 0; i < N/2; i++) {
    A[i] = calloc(N/2, sizeof(int));
    B[i] = calloc(N/2, sizeof(int));
    C[i] = calloc(N/2, sizeof(int));
    D[i] = calloc(N/2, sizeof(int));
    E[i] = calloc(N/2, sizeof(int));
    F[i] = calloc(N/2, sizeof(int));
  }
  int *weights = calloc(N*(N+1)/2, sizeof(int));

  int k = 1;
  for (int i = N/2-1; i >= 0; i--) {
    for (int j = 0; j < i+1; j++) {
      A[i][j] = k;
      k++;
    }
  }

/*  
  printf("A =\n");
  for (int i = 0; i < N/2; i++) {
    for (int j = 0; j < i+1; j++) {
      printf("%d ", A[i][j]);
    }
    printf("\n");
  }
*/
  
  // --------
  
  for (int i = 0; i < N/2; i++) {
    for (int j = 0; j < i+1; j++) {
      B[i][i-j] = A[i][j];
    }
  }
  

/*  
  printf("B =\n");
  for (int i = 0; i < N/2; i++) {
    for (int j = 0; j < i+1; j++) {
      printf("%d ", B[i][j]);
    }
    printf("\n");
  }
*/
  
  // ----------------------

  for (int i = 0; i < N/2; i++) {
    for (int j = 0; j < i+1; j++) {
      C[i][j] = B[N/2-i-1 + j][j];
    }
  }
  
/*  
  printf("C =\n");
  for (int i = 0; i < N/2; i++) {
    for (int j = 0; j < i+1; j++) {
      printf("%d ", C[i][j]);
    }
    printf("\n");
  }
*/
  
  // ----------------------

  for (int i = 0; i < N/2; i++) {
    for (int j = 0; j < i+1; j++) {
      D[i][j] = A[N/2-j-1][N/2-i-1];
    }
  }
  
/*  
  printf("D =\n");
  for (int i = 0; i < N/2; i++) {
    for (int j = 0; j < i+1; j++) {
      printf("%d ", D[i][j]);
    }
    printf("\n");
  }
*/
  

  // ----------------------

  for (int i = 0; i < N/2; i++) {
    for (int j = 0; j < i+1; j++) {
      E[i][j] = D[N/2-i-1 + j][j];
    }
  }
  
/*  
  printf("E =\n");
  for (int i = 0; i < N/2; i++) {
    for (int j = 0; j < i+1; j++) {
      printf("%d ", E[i][j]);
    }
    printf("\n");
  }
*/

  // ----------------------

  for (int i = 0; i < N/2; i++) {
    for (int j = 0; j < i+1; j++) {
      F[i][j] = A[N/2-i-1 + j][j];
    }
  }
  
/*  
  printf("F =\n");
  for (int i = 0; i < N/2; i++) {
    for (int j = 0; j < i+1; j++) {
      printf("%d ", F[i][j]);
    }
    printf("\n");
  }
*/
  
  // ---------------------
//  printf("posta =\n");
  for (int i = 0; i < N/2; i++) {
    for (int j = 0; j < i+1; j++) {
      int min = N;
      if (A[i][j] < min) {
        min = A[i][j];
      }
      if (B[i][j] < min) {
        min = B[i][j];
      }
      if (C[i][j] < min) {
        min = C[i][j];
      }
      if (D[i][j] < min) {
        min = D[i][j];
      }
      if (E[i][j] < min) {
        min = E[i][j];
      }
      if (F[i][j] < min) {
        min = F[i][j];
      }
      
      weights[min] = 1;
    }
  }
  
  for (int i = 0; i < N/2; i++) {
    for (int j = 0; j < N/2-1-i; j++) {
      printf(" ");
    }
    for (int j = 0; j < i+1; j++) {
      int min = N;
      if (A[i][j] < min) {
        min = A[i][j];
      }
      if (B[i][j] < min) {
        min = B[i][j];
      }
      if (C[i][j] < min) {
        min = C[i][j];
      }
      if (D[i][j] < min) {
        min = D[i][j];
      }
      if (E[i][j] < min) {
        min = E[i][j];
      }
      if (F[i][j] < min) {
        min = F[i][j];
      }
      
      int w = 1;
      for (int k = 0; k < min; k++) {
        w += weights[k] != 0;
      }
      printf("%d ", w);
    }
    printf("\n");
  }
  

  for (int i = 0; i < N/2; i++) {
    free(A[i]);
    free(B[i]);
    free(C[i]);
    free(D[i]);
    free(E[i]);
    free(F[i]);
  }
  free(A);
  free(B);
  free(C);
  free(D);
  free(E);
  free(F);
  
  return 0;

}

#include <stdio.h>
#include <stdlib.h>

int main(void) {

  int N = 8;
  int **A = calloc(N/2, sizeof(int *));
  int **B = calloc(N/2, sizeof(int *));
  for (int i = 0; i < N/2; i++) {
    A[i] = calloc(N/2, sizeof(int));
    B[i] = calloc(N/2, sizeof(int));
  }

  int k = 0;
  for (int i = 0; i < N/2; i++) {
    for (int j = 0; j < i+1; j++) {
      int p = 0.5*(i+1)*i;
      int w = 1+p + j;
      A[i][j] = w;
      int iB = N/2-i-1;
      int jB = N/2-p-j-1;
      B[iB][jB] = w;
      printf("%d %d %d %d = %d\n", i, j, iB, jB, w);
      // printf("%d ", 1+k++);
    }
    printf("\n");
  }

  printf("A =\n");
  for (int i = 0; i < N/2; i++) {
    for (int j = 0; j < i+1; j++) {
      printf("%d ", A[i][j]);
    }
    printf("\n");
  }

  printf("B =\n");
  for (int i = 0; i < N/2; i++) {
    for (int j = 0; j < i+1; j++) {
      printf("%d ", B[i][j]);
    }
    printf("\n");
  }

  return 0;

}

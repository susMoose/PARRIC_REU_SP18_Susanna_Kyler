#include <stdio.h>		//host c code // then pass arguments to device code 
#include <unistd.h>
#include <string.h>
#include <math.h>
#include <stdlib.h>
#include <sys/time.h>
#define min(x,y) ( ((x) < (y))? (x) : (y))


__global__
void kernel_syr2k(int N, int M, double *C, double *A, double *B){
  //int i, j, k;

  // for (k = 0; k < M; k++) {
    // for (i = 0; i < N; i++) {
	  // for (j = 0; j < min (N,i); j++) {
		// C[i][j] += A[j][k] * B[i][k] + B[j][k] * A[i][k];
	  // }
    // }
  // }
}


void init_array(int N, int M,  double *C,  double *A, double *B){
  int i, j;

  for (i = 0; i < N; i++)
    for (j = 0; j < M; j++) {
      A[i][j] = (double) (i*j%N) / N;
      B[i][j] = (double) (i*j%M) / M;
    }
  for (i = 0; i < N; i++)
    for (j = 0; j < N; j++)
      C[i][j] = (double) (i*j%N) / M;
}



void print_array(int N,
   double C[N][N])
{
  int i, j;

  fprintf(stderr, "==BEGIN DUMP_ARRAYS==\n");
  fprintf(stderr, "begin dump: %s", "C");
  for (i = 0; i < N; i++)
    for (j = 0; j < N; j++) {
 if ((i * N + j) % 20 == 0) fprintf (stderr, "\n");
 fprintf (stderr, "%0.2lf ", C[i][j]);
    }
  fprintf(stderr, "\nend   dump: %s\n", "C");
  fprintf(stderr, "==END   DUMP_ARRAYS==\n");
}


int main(int argc, char** argv)
{
  int N;
  int M;

  
  struct timeval t_start;
  struct timeval t_end;
  double etime;

  double* C;
  double* A;
  double* B;
  

  if (argc < 3) {
    printf("usage ./syr2k N M\n");
    return 0;
  }

  N = atoi(argv[1]);
  M = atoi(argv[2]);

  //cudaMallocManaged(&C, N*N * sizeof(double));		//cuda allocation of unified Memory  
  //cudaMallocManaged(&A, N*M * sizeof(double));
  //cudaMallocManaged(&B, N*M * sizeof(double));
   C1 = (double*)malloc(N*N * sizeof(double));
   A1 = (double*)malloc(N*M * sizeof(double));
   B1 = (double*)malloc(N*M * sizeof(double));

  init_array (N, M, *((double(*)[N][N])C1), *((double(*)[N][M])A1), *((double(*)[N][M])B1));
  gettimeofday (&t_start, NULL);

  cudaMallocManaged(&C, N*N * sizeof(double));		//cuda allocation of unified Memory  
  cudaMallocManaged(&A, N*M * sizeof(double));
  cudaMallocManaged(&B, N*M * sizeof(double));  
  
	
	int k = 0;
	for (int i = 0; i < N; i++){
		for (int j = 0; j < M; j++){
			A[k++] = A1[i, j];
			B[k++] = B1[i, j];
        }
	}
    int f = 0;
	for (int i = 0; i < N; i++){
		for (int j = 0; j < N; j++){
			C[f++] = C1[i, j];

		}
	}
	
  
  kernel_syr2k<<<1,256>>>(N, M, *((double(*)[N])C), *((double(*)[N])A), *((double(*)[N])B));
  cudaDeviceSynchronize();
  gettimeofday (&t_end, NULL);

  etime = t_end.tv_sec - t_start.tv_sec + 
        (t_end.tv_usec - t_start.tv_usec) * 1.0e-6;

  print_array(N, *((double(*)[N][N])C));

  printf("execution time=%lf\n", etime);

  cudaFree(C);		//freeing cuda data
  cudaFree(A);
  cudaFree(B);

  return 0;
}

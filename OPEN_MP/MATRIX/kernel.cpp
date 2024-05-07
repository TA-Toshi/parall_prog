#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <iostream>
#include <omp.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <string.h>


int* alloc_matrix(int size) {
	int* matrix = (int*)malloc(size * size * sizeof(int));
	return matrix;
}


void del_matrix(int* matrix) {
	free(matrix);
}


int main() {

	int i, j, k;

	int THR = 16;

	omp_set_dynamic(0);
	omp_set_num_threads(THR);

	int N = 1233;

	int* A = alloc_matrix(N);
	int* B = alloc_matrix(N);
	int* C = alloc_matrix(N);

	int rand_num;

	srand(time(NULL));

	for (int i = 0; i < N; i++) {
		for (int j = 0; j < N; j++) {
			A[i + j * N] = rand() % 5;
			B[i + j * N] = rand() % 5;
		}
	}
	unsigned int start = clock();

  
#pragma omp parallel for shared(A, B, C, N) private(i, j, k)

	for (i = 0; i < N; i++) {
		for (k = 0; k < N; k++) {
			for (j = 0; j < N; j++) {			
				C[i + j * N] += A[i + k * N] * B[k + j * N];
			}
		}
	}
	printf("Number of streams: %d\n", THR);
	printf("Time: %d\n", (clock() - start)/1000, "sec.");
	return 0;
}
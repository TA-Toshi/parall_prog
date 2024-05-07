#include "cuda_runtime.h"
#include "device_launch_parameters.h"

#include <iostream>
#include <string>
#include <stdio.h>
#include <iostream>
#include <cstdlib>
#include <windows.h>

using namespace std;

__global__ void matrixMult(const int* A, const int* B, int* C, int matrix)
{
    int i = matrix * (blockDim.y * blockIdx.y + threadIdx.y);
    int j = blockDim.x * blockIdx.x + threadIdx.x;
    int sum = 0;

    for (int k = 0; k < matrix; k++)
        sum += A[i + k] * B[k * matrix + j];

    int ind = matrix * (blockDim.y * blockIdx.y + threadIdx.y) + blockDim.x * blockIdx.x + threadIdx.x;
    C[ind] = sum;
}

int main(int argc, char** argv) {

    SetConsoleOutputCP(CP_UTF8);


    int matrix = 9543;
    int threads = 16;

    size_t size = matrix * matrix * sizeof(int);

    int* a = (int*)malloc(size);
    int* b = (int*)malloc(size);
    int* c = (int*)malloc(size);

    for (int i = 0; i < matrix; i++) {
        for (int j = 0; j < matrix; j++) {
            a[i * matrix + j] = i * j;
            b[i * matrix + j] = i * j;
        }
    }

    cudaEvent_t start, stop;
    cudaEventCreate(&start);
    cudaEventCreate(&stop);

    int* calcA = NULL;
    cudaMalloc((void**)&calcA, size);

    int* calcB = NULL;
    cudaMalloc((void**)&calcB, size);

    int* calcC = NULL;
    cudaMalloc((void**)&calcC, size);

    cudaMemcpy(calcA, a, size, cudaMemcpyHostToDevice);
    cudaMemcpy(calcB, b, size, cudaMemcpyHostToDevice);

    cout << "Старт" << endl;

    dim3 threadsPerBlock = dim3(threads, threads);
    dim3 blocksPerGrid = dim3(matrix / threads, matrix / threads);

    cudaEventRecord(start, 0);
    matrixMult << < blocksPerGrid, threadsPerBlock >> > (calcA, calcB, calcC, matrix);

    cudaEventRecord(stop, 0);
    cudaEventSynchronize(stop);
    float kernelTime;
    cudaEventElapsedTime(&kernelTime, start, stop);
    double time = kernelTime;
    cout << " Количество потоков: " << threads
        << "; Время: " << kernelTime / 1000 << " секунд" << endl;
    cudaMemcpy(c, calcC, size, cudaMemcpyDeviceToHost);

    cudaFree(calcA);
    cudaFree(calcB);
    cudaFree(calcC);
    free(a);
    free(b);
    free(c);
    cudaEventDestroy(start);
    cudaEventDestroy(stop);

    return 0;
}
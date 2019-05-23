
#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#include <stdio.h>
#include <iostream>
#include <fstream>
#define Num_elements 10000
#define Num_threads 100
using namespace std;
__global__ void addKernel(int *a, int *b, int *c)
{
	int i = blockIdx.x*blockDim.x + threadIdx.x;
	c[i] = a[i] + b[i];
}

void add(int *a, int *b, int *c)
{
	int *dev_a = 0;
	int *dev_b = 0;
	int *dev_c = 0;
	cudaMalloc((void**)&dev_a, Num_elements * sizeof(int));
	cudaMalloc((void**)&dev_b, Num_elements * sizeof(int));
	cudaMalloc((void**)&dev_c, Num_elements * sizeof(int));
	cudaMemcpy(dev_a, a, Num_elements * sizeof(int), cudaMemcpyHostToDevice);
	cudaMemcpy(dev_b, b, Num_elements * sizeof(int), cudaMemcpyHostToDevice);
	addKernel << <(Num_elements + (Num_threads - 1))/ Num_threads, Num_threads >> > (dev_a, dev_b, dev_c);
	cudaDeviceSynchronize();
	cudaMemcpy(c, dev_c, Num_elements * sizeof(int), cudaMemcpyDeviceToHost);
}



int main()
{
	ofstream out;
	out.open("C:\\tasks_cuda\\task_1_2.txt", ios::out);
	int a[Num_elements], b[Num_elements], c[Num_elements];

	for (int i = 0; i < Num_elements; i++) {
		a[i] = -i;
		b[i] = i * i;
	}

	add(a, b, c);
	if (out.is_open()) {
		for (int i = 0; i < Num_elements; i++) {
			out << a[i] << ' ' << b[i] << ' ' << c[i] << '\n';
		}
	}

	return 0;
}



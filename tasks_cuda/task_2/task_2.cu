
#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#include <stdio.h>
#include <iostream>
#include <fstream>
#define Num_elements 20
#define Num_threads_x 5
#define Num_threads_y 5
using namespace std;
__global__ void addKernel(int *a, int *b, int *c)
{
	int i = blockIdx.x*blockDim.x + threadIdx.x;
	int j = blockIdx.y*blockDim.y + threadIdx.y;
	c[i*Num_elements+j] = a[i*Num_elements+j] + b[i*Num_elements+j];
}

void add(int *a, int *b, int *c)
{
	int *dev_a;
	int *dev_b;
	int *dev_c;
	cudaMalloc((void**)&dev_a, Num_elements * Num_elements * sizeof(int));
	cudaMalloc((void**)&dev_b, Num_elements * Num_elements * sizeof(int));
	cudaMalloc((void**)&dev_c, Num_elements * Num_elements * sizeof(int));
	cudaMemcpy(dev_a, a, Num_elements * Num_elements * sizeof(int), cudaMemcpyHostToDevice);
	cudaMemcpy(dev_b, b, Num_elements * Num_elements * sizeof(int), cudaMemcpyHostToDevice);
	dim3 blocks(Num_elements / Num_threads_x, Num_elements / Num_threads_y);
	dim3 threads(Num_threads_x, Num_threads_y);
	addKernel << <blocks, threads>> > (dev_a, dev_b, dev_c);
	cudaDeviceSynchronize();
	cudaMemcpy(c, dev_c, Num_elements * Num_elements * sizeof(int), cudaMemcpyDeviceToHost);
}



int main()
{
	ofstream out;
	out.open("C:\\tasks_cuda\\task_2.txt", ios::out);
	int *a = new int[Num_elements*Num_elements];
	int *b = new int[Num_elements*Num_elements];
	int *c = new int[Num_elements*Num_elements];

	for (int i = 0; i < Num_elements; i++) {
		for (int j = 0; j < Num_elements; j++) {
			a[i*Num_elements+j] = -i;
			b[i*Num_elements+j] = j;
		}

	}

	add(a, b, c);
	if (out.is_open()) {
		for (int i = 0; i < Num_elements; i++) {
			for (int j = 0; j < Num_elements; j++)
				out << c[i*Num_elements + j] << ' ';
			out << '\n';
		}
	}
	delete[] a;
	delete[] b;
	delete[] c;
	return 0;
}



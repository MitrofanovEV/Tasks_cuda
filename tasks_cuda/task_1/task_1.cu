
#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#include <stdio.h>
#include <fstream>
#include <iostream>
#define N 10
using namespace std;
__global__ void addKernel(int *a, int *b, int *c)
{
	int i = blockIdx.x;
	//int i = threadIdx.x;
	c[i] = a[i] + b[i];
}

void add(int *a, int *b, int *c)
{
	int *dev_a = 0;
	int *dev_b = 0;
	int *dev_c = 0;
	cudaMalloc((void**)&dev_a, N * sizeof(int));
	cudaMalloc((void**)&dev_b, N * sizeof(int));
	cudaMalloc((void**)&dev_c, N * sizeof(int));
	cudaMemcpy(dev_a, a, N * sizeof(int), cudaMemcpyHostToDevice);
	cudaMemcpy(dev_b, b, N * sizeof(int), cudaMemcpyHostToDevice);
	addKernel << <N, 1 >> > (dev_a, dev_b, dev_c);
	//addKernel << <1, N >> > (dev_a, dev_b, dev_c);
	cudaDeviceSynchronize();
	cudaMemcpy(c, dev_c, N * sizeof(int), cudaMemcpyDeviceToHost);
}



int main()
{
	ofstream out;
	out.open("C:\\tasks_cuda\\task_1.txt", ios::out);
	int a[N], b[N], c[N];
	for (int i = 0; i < N; i++) {
		a[i] = -i;
		b[i] = i * i;
	}

	add(a, b, c);
	if (out.is_open()) {
		for (int i = 0; i < N; i++) {
			out << a[i] << ' ' << b[i] << ' ' << c[i] <<'\n';
		}
	}
	else
		cout << "error";
	return 0;
}



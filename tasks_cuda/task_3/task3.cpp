#include "pch.h"
#include <omp.h>
#include <stdlib.h>
#include <fstream>
#include <iostream>
#define N 10
using namespace std;

int main() {
	ofstream out;
	out.open("C:\\tasks_cuda\\task_3.txt", ios::out);
	double sum;
	int i, j, k;
	double *A = new double[N*N];
	double *B = new double[N*N];
	double *C = new double[N*N];
	for (int i = 0; i < N; i++) {
		for (int j = 0; j < N; j++) {
			if (i == j)
				A[i*N + j] = 1;
			else
				A[i*N + j] = 0;
			B[i*N + j] = i + j;
		}
	}
#pragma omp parallel for private(j,k,sum)
	for (i = 0; i < N; i++) {
		for (k = 0; k < N; k++) {
			sum = 0;
			for (j = 0; j < N; j++) {
				sum += A[i*N + j] * B[j*N + k];
			}
			C[i*N + k] = sum;
		}
	}
	if (out.is_open()) {
		for (int i = 0; i < N; i++) {
			for (int j = 0; j < N; j++) {
				out << C[i*N + j] << ' ';
			}
			out << '\n';
		}
	}
	else {
		cout << "error";
	}
	out.close();
	delete[] A;
	delete[] B;
	delete[] C;
	return 0;
}
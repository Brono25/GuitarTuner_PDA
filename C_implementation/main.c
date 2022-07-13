

#include <string.h>
#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <math.h>



#define CHUNK 1024 


void print_arr(float *arr, int length);
void sqaures(float *xs, float *signal, int len);
float sum(float *x, int len);
void arm_dot_prod_f32(float *x1, float *x2, int len, float *result);
void xcorr(float *signal, float **r,  int LEN);
int find_peak(float *signal, int LEN);
void NSDF(float *signal, float *n, int LEN);
float parabolic_interpolation(int xp, float a, float b, float c);
float mpm (float *signal, int length);






int main(int argc, char *argv[])
{
	float f = atof(argv[1]);

	float data[CHUNK]; 
	float t = 0;
	for (int i = 0; i < CHUNK; i++)
	{
		data[i] = cos(2*M_PI*f*t);
		
		t += 0.000025;
	}

	//float d[5] = {1,2,3,4,5};
	//------------XCORR TEST--------------------
	//float *n = malloc(sizeof(float) * CHUNK - 1);
	
	float pitch = mpm(&data[0], CHUNK);
	printf("%f\n", pitch);
	//--------------

/*
	float pitch = 0;
	pitch = mpm(&data[0], CHUNK);*/
	

}











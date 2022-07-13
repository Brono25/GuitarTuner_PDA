

#include <string.h>
#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <math.h>
#include "main.h"







void print_arr(float *arr, int length)
{
	for (int i = 0; i < length; i++)
	{
		printf("%f \n", arr[i]);
	}
	printf("end\n");
}



int main(int argc, char *argv[])
{
	float f = atof(argv[1]);

	float data[BLOCK_SIZE]; 
	float t = 0;
	for (int i = 0; i < BLOCK_SIZE; i++)
	{
		data[i] = cos(2*M_PI*f*t);
		
		t += 0.000025;
	}

	//float d[5] = {1,2,3,4,5};
	//------------XCORR TEST--------------------
	//float *n = malloc(sizeof(float) * BLOCK_SIZE - 1);
	float pitch_estimate = 0;
	mpm_mcleod_pitch_method_f32(&data[0], BLOCK_SIZE, &pitch_estimate);
	printf("%f\n", pitch_estimate);
	//--------------

/*
	float pitch = 0;
	pitch = mpm(&data[0], BLOCK_SIZE);*/
	

}













#include <string.h>
#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <math.h>
#include "main.h"




int main(void)
{
	
	
	/*float data[BLOCK_SIZE];
	float t = 0;
	for (float f = 0; f < 400; f += 50)
	{
		
		float pitch_estimate = 0;
		mpm_mcleod_pitch_method_f32(&data[0], &pitch_estimate);
		printf("%f ~ %f\n", f, pitch_estimate);

	}*/

	

	float pitch_estimate = 0;
	float data[BLOCK_SIZE];
	
	float f = 101;
	float t = 0;
	for (int i = 0; i < BLOCK_SIZE; i++)
	{
		data[i] = cos(2*M_PI*f*t);
		
		t += 0.000025;
	}
	mpm_mcleod_pitch_method_f32(&data[0], &pitch_estimate);
	printf("%f ~ %f\n", f, pitch_estimate);

/*	f = 51;
	t = 0;
	for (int i = 0; i < BLOCK_SIZE; i++)
	{
		data[i] = cos(2*M_PI*f*t);
		
		t += 0.000025;
	}
	mpm_mcleod_pitch_method_f32(&data[0], &pitch_estimate);
	printf("%f ~ %f\n", f, pitch_estimate);
*/
/*
	f = 100;
	t = 0;
	for (int i = 0; i < BLOCK_SIZE; i++)
	{
		data[i] = cos(2*M_PI*f*t);
		
		t += 0.000025;
	}
	mpm_mcleod_pitch_method_f32(&data[0], &pitch_estimate);
	printf("%f ~ %f\n", f, pitch_estimate);

	f = 330;
	t = 0;
	for (int i = 0; i < BLOCK_SIZE; i++)
	{
		data[i] = cos(2*M_PI*f*t);
		
		t += 0.000025;
	}
	mpm_mcleod_pitch_method_f32(&data[0], &pitch_estimate);
	printf("%f ~ %f\n", f, pitch_estimate);



	f = 400;
	t = 0;
	for (int i = 0; i < BLOCK_SIZE; i++)
	{
		data[i] = cos(2*M_PI*f*t);
		
		t += 0.000025;
	}
	mpm_mcleod_pitch_method_f32(&data[0], &pitch_estimate);
	printf("%f ~ %f\n", f, pitch_estimate);
*/

	//--------------

/*
	float pitch = 0;
	pitch = mpm(&data[0], BLOCK_SIZE);*/
	

}











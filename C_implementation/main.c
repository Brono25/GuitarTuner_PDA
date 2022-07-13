

#include <string.h>
#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <math.h>
#include "main.h"




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

	float pitch_estimate = 0;
	mpm_mcleod_pitch_method_f32(&data[0], &pitch_estimate);
	printf("%f ~ %f\n", f, pitch_estimate);
}











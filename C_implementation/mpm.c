



#include <stdio.h>
#include <string.h>
#include <stdint.h>
#include <stdlib.h>
#include <math.h>



void print_arr(float *arr, int length)
{
	for (int i = 0; i < length; i++)
	{
		printf("%f \n", arr[i]);
	}
	printf("end\n");
}

void sqaures(float *xs, float *signal, int len)
{	
	for (int i = 0; i < len; i++)
	{
		 xs[i] = signal[i] * signal[i];
	}
}


float sum(float *x, int len)
{	
	float sum = 0;
	for (int i = 0; i < len; i++)
	{
		 sum += x[i];
	}
	return sum;
}


float dot_prod(float *x1, float *x2, int len)
{	
	float sum = 0;
	for (int i = 0; i < len; i++)
	{
		 sum += x1[i] * x2[i];
	}
	return sum;
}



void xcorr(float *signal, float **r, int LEN)
{

	int PAD_LEN = 3 * LEN - 2;
	int XCORR_LEN = 2 * LEN - 1;

	float *sigx   = malloc((XCORR_LEN) * sizeof(float));
	float *padded  = malloc(PAD_LEN * sizeof(float));
	

	memset(padded , 0, PAD_LEN * sizeof(float));
	memmove(&padded [LEN - 1], &signal[0], LEN * sizeof(float));

	float *x1 = &padded [LEN - 1];
	float *x2 = &padded [2 * LEN - 2];

	for (int i = 0; i < XCORR_LEN; i++)
	{
		sigx[i] = dot_prod(x1, x2, LEN);
		x2--;
	}
	
	*r = &sigx[LEN - 1];

	free(padded);
}


int find_peak(float *signal, int LEN)
{
	int flag = 0;
	int valid_peak_flag = 0;
	float peak_value = 0;
	int tau = 0;
	float threshold = 0.9;

	for (int i = 0; i < LEN - 1; i++)
    {    
       if (flag == 0 && signal[i] < 0)
       {
           flag = 1;

       }
       if (flag == 1)
       {

       		if (signal[i] > peak_value && signal[i] > threshold) 
       		{
				peak_value = signal[i];
              	tau = i;
                valid_peak_flag = 1;
                
       		} else if (valid_peak_flag == 1)
       		{
       			return tau;
       		}        
       }    
    }
    return 0;
}


void NSDF(float *signal, float *n, int LEN)
{
	
	float *r = NULL;
	xcorr(&signal[0], &r,  LEN);

	float xs[LEN];
	float xs1, xs2;

	sqaures(&xs[0], &signal[0], LEN);
	xs1 = sum(&xs[0], LEN);
	xs2 = xs1;


	for (int tau = 0; tau < LEN ; tau++)
	{
		n[tau] = 2 * r[tau] / (xs1 + xs2);
		xs1 = xs1 - xs[LEN - tau - 1];
		xs2 = xs2 - xs[tau];
		
	}	
}



float parabolic_interpolation(int xp, float a, float b, float c)
{
	a = 20*log10(a);
   b = 20*log10(b);
   c = 20*log10(c);

   float p = 0.5 * (a - c) / (1 - 2.0*b + c);

   return xp + p;

}


float mpm (float *signal, int LEN)
{

	float *n = NULL;
	n = malloc(sizeof(float[LEN]));
	if (n == NULL)
	{
		return 1;
	}

	NSDF(signal, n, LEN);

	int tau = find_peak(n, LEN);
	


	int xp = tau;
	float a = n[tau - 1];
	float b = n[tau];
	float c = n[tau + 1];

	float tau_interp = parabolic_interpolation(xp, a, b, c);


	float pitch = 40000.0 / tau_interp;



	return pitch;
}















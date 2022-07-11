


#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <math.h>


#define BUFFER 2048
#define XCORR_BUFFER 2 * BUFFER - 1
#define HLF_BUFFER BUFFER / 2
#define MID_POINT BUFFER - 1





void print_arr(float *arr, int length)
{
	for (int i = 0; i < length; i++)
	{
		printf("%f \n", arr[i]);
	}
	printf("\n");
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



void xcorr(float *signal, float *sigx,  int LEN)
{
	

	float xcorr[3 * BUFFER - 1] = {0};

	for (int i = 0; i < LEN; i++)
	{
		xcorr[BUFFER + i - 1] = signal[i];
	}

	float *x1 = &xcorr[BUFFER - 1];
	float *x2 = &xcorr[0];
	for (int i = 0; i < 2 * LEN; i++)
	{
		sigx[i] = dot_prod(x1, x2, BUFFER);
		x2++;
	}


}



int find_peak(float *signal, int LEN)
{
	int flag = 0;
	int valid_peak_flag = 0;
	float peak_value = 0;
	int tau = 0;
	float threshold = 0.9;

	for (int i = 0; i < BUFFER - 1; i++)
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


void NSDF(float *signal, float *n)
{
	
	float *sigx = malloc(sizeof(signal[XCORR_BUFFER]));
	xcorr(&signal[0], sigx,  BUFFER);

	float *r = &sigx[MID_POINT];
	float xs[BUFFER];
	float xs1, xs2;

	sqaures(&xs[0], &signal[0], BUFFER);
	xs1 = sum(&xs[0], BUFFER);
	xs2 = xs1;


	for (int tau = 0; tau < BUFFER - 1; tau++)
	{
		xs1 = xs1 - xs[BUFFER - tau - 1];
		xs2 = xs2 - xs[tau];
		n[tau] = 2 * r[tau] / (xs1 + xs2);
	}
	free(sigx);
}



float parabolic_interpolation(int xp, float a, float b, float c)
{
	a = 20*log10(a);
    b = 20*log10(b);
    c = 20*log10(c);

    float p = 0.5 * (a - c) / (1 - 2.0*b + c);

    return xp + p;

}


float mpm (float *signal)
{

	

	float *n = malloc(sizeof(float[BUFFER]));
	NSDF(signal, n);


	int tau = find_peak(signal, BUFFER);
	


	int xp = tau;
    float a = n[tau - 1];
    float b = n[tau];
    float c = n[tau + 1];

	float tau_interp = parabolic_interpolation(xp, a, b, c);


	float pitch = 40000 / tau_interp;

	printf("%f\n", pitch);


	free(n);

	return pitch;


}















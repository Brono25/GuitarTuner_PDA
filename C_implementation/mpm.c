



#include <stdio.h>
#include <string.h>
#include <stdint.h>
#include <stdlib.h>
#include <math.h>
#include "main.h"


#define PEAK_THRESHOLD 0.9

float32_t mpm_reserved_memory[2 * BLOCK_SIZE] = {0};



void print_arr(float *arr, uint16_t length)
{
	for (uint16_t i = 0; i < length; i++)
	{
		printf("%f \n", arr[i]);
	}
	printf("end\n");
}










void arm_mult_f32(float32_t *pSrcA, uint16_t srcALEN,  float32_t *pSrcB, uint16_t srcBLEN, float32_t *pDst)
{	
	for (uint16_t i = 0; i < srcALEN; i++)
	{
		 pDst[i] = pSrcA[i] * pSrcB[i];
	}
}


void mpm_sum_f32(float32_t *pSrc, uint16_t scrLen, float32_t *pRes)
{	
	*pRes = 0;
	for (uint16_t i = 0; i < scrLen; i++)
	{
		 *pRes += *pSrc;
		 pSrc++;
	}
}


void arm_dot_prod_f32(float32_t *x1, float32_t *x2, uint16_t len, float32_t *result)
{	
	*result = 0;
	for (uint16_t i = 0; i < len; i++)
	{
		 *result += x1[i] * x2[i];
	}
}



void arm_correlate_f32(float32_t *srcA, uint16_t srcALen, float32_t *srcB, uint16_t srcBLen, float32_t *pDst)
{
	uint16_t PAD_LEN = 3 * srcALen - 2;
	uint16_t XCORR_LEN = 2 * srcALen - 1;

	float32_t *padded  = malloc(PAD_LEN * sizeof(float32_t));
	
	memset(padded , 0, PAD_LEN * sizeof(float32_t));
	memmove(&padded [srcALen - 1], &srcA[0], srcALen * sizeof(float32_t));

	float32_t *x1 = &padded [srcALen - 1];
	float32_t *x2 = &padded [2 * srcALen - 2];

	float32_t result = 0;
	for (uint16_t i = 0; i < XCORR_LEN; i++)
	{
		arm_dot_prod_f32(x1, x2, srcALen, &result);
		*pDst = result;
		pDst++;	
		x2--;
	}	
	free(padded);
}


void mpm_find_peak_f32(float32_t *pSrc, uint16_t *tau)
{
	uint16_t flag = 0;
	uint16_t valid_peak_flag = 0;
	float32_t peak_value = 0;

	for (uint16_t i = 0; i < BLOCK_SIZE; i++)
    {  
       
       if (flag == 0 && *pSrc < 0)
       {
           flag = 1;

       }
       if (flag == 1)
       {
       		if (*pSrc > peak_value && *pSrc > PEAK_THRESHOLD) 
       		{
				peak_value = *pSrc;
              	*tau = i;
                valid_peak_flag = 1;
                
       		} else if (valid_peak_flag == 1)
       		{
       			return;
       		}        
       }   
       pSrc++; 
    }
}


void mpm_NSDF_f32(float32_t *pSrc, float32_t **pDst)
{
	
	float32_t *xcorr = &mpm_reserved_memory[1];
	

	arm_correlate_f32(&pSrc[0], BLOCK_SIZE , NULL, 0, xcorr);


	float32_t *r = &xcorr[BLOCK_SIZE - 1];
	*pDst = r;
	
	float32_t *xs = &mpm_reserved_memory[0];
	float32_t *p_xs1 = &xs[0];
	float32_t *p_xs2 = &xs[BLOCK_SIZE - 1];
	float32_t xs1, xs2;

	arm_mult_f32(&pSrc[0], BLOCK_SIZE,  &pSrc[0], BLOCK_SIZE, &xs[0]);
	mpm_sum_f32(&xs[0], BLOCK_SIZE, &xs1);
	xs2 = xs1;
	

	for (uint16_t tau = 0; tau < BLOCK_SIZE  ; tau++)
	{

		*r = 2 * (*r) / (xs1 + xs2);

		xs1 = xs1 - (*p_xs1);
		xs2 = xs2 - (*p_xs2);

		r++;
		p_xs1++;
		p_xs2--;
	}	
}



void mpm_parabolic_interpolation_f32(uint16_t x_pos, float32_t a, float32_t b, float32_t c, float32_t *delta_tau)
{
	a = 20*log10(a);
   b = 20*log10(b);
   c = 20*log10(c);

   float32_t delta_pos = 0.5 * (a - c) / (1 - 2.0*b + c);

   *delta_tau = x_pos + delta_pos;
}


void mpm_mcleod_pitch_method_f32(float32_t *pData, float32_t *pitch_estimate)
{


	float32_t *p_ncorr;

	mpm_NSDF_f32(pData, &p_ncorr);
	uint16_t tau = 1;
   mpm_find_peak_f32(p_ncorr, &tau);

 	

   if (tau > BLOCK_SIZE - 2)
   {
   	tau = BLOCK_SIZE - 2;
   }

	uint16_t xp = tau;
	float32_t a = p_ncorr[tau - 1];
	float32_t b = p_ncorr[tau];
	float32_t c = p_ncorr[tau + 1];

	float32_t delta_tau = 0;
	mpm_parabolic_interpolation_f32(xp, a, b, c, &delta_tau);


	*pitch_estimate = FS / delta_tau;

}














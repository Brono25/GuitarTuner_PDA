


#define BLOCK_SIZE 2048
#define FS 40000


typedef float float32_t;

void print_arr(float *arr, uint16_t length);
void arm_mult_f32(float *pSrcA, uint16_t srcALEN,  float *pSrcB, uint16_t srcBLEN, float *pDst);
void mpm_sum_f32(float32_t *pSrc, uint16_t scrLen, float32_t *pRes);
void arm_dot_prod_f32(float *x1, float *x2, uint16_t len, float *result);
void arm_correlate_f32(float *srcA, uint16_t srcALen, float *srcB, uint16_t srcBLen, float *r);
void mpm_find_peak_f32(float32_t *pSrc, uint16_t *tau);
void mpm_NSDF_f32(float32_t *pSrc, float32_t **pDst);
void mpm_parabolic_interpolation_f32(uint16_t x_pos, float32_t a, float32_t b, float32_t c, float32_t *delta_tau);
void mpm_mcleod_pitch_method_f32(float32_t *pSrc, float32_t *pitch_estimate);



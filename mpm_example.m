


t = linspace(0,0.0512,2048);
x = sin(2*pi*80*t);
[nsdf, pitch] = mpm_matlab(x);

disp(pitch)







% tau is the lag corresponding to the pitch
function [np, pitch] = Mcleod_pitch_method(signal)

  
    np = NSDF(signal);
   
    tau = find_peak(np)
    
    if (tau <= 1)
        
        pitch = 0;
        return;
    end
    
    xp = tau;
    a = np(tau - 1);
    b = np(tau);
    c = np(tau + 1);
    
    tau_interp = parabolic_interpolation(xp, a, b, c);
    
    pitch = round(40000 / tau_interp, 2);
   
end

%Normalised Square Difference Formula
function n = NSDF(signal)

    W = length(signal);
    n = zeros(1 , W/4);
    m = zeros(1 , W);
    
    [sigx, ~] = xcorr(signal, signal);

    r = sigx(W  : end); % ignore negative lags.

    for tau = 0 : W - 1
        sum = 0;
        for j = 1 : W - tau
            sum = sum + signal(j)^2 + signal(j + tau)^2;
        end
        m(tau + 1) = sum;
    end 
    n = 2 * r ./ m;
    n = n(1 : W / 4);
end


function bin = find_peak(vector)
    
    flag = 0;
    peak = 0;
    bin = 0;
    for i = 1 : length(vector)
        
       if (flag == 0) && (vector(i) < 0)
           flag = 1;
       end
     
       if (flag == 1)
           
           if (vector(i) > peak)
               
               peak = vector(i);
               bin = i;
           end
       end
    end

end




function x_max = parabolic_interpolation(xp, a ,b ,c)
  
    a = 20*log10(a);
    b = 20*log10(b);
    c = 20*log10(c);
    
    p = 1/2 * (a - c) / (1 - 2*b + c);
    
  
    x_max = xp + p;
 
end






% tau is the lag corresponding to the pitch
function [n, pitch] = Mcleod_pitch_method(signal)

    
    n = NSDF(signal);
    tau = find_peak(n);
    if (tau == 0) 
        pitch = 0;
        return
    end
    
    xp = tau;
    a = n(tau - 1);
    b = n(tau);
    c = n(tau + 1);
    
    tau_interp = parabolic_interpolation(xp, a, b, c);
    
    
    pitch = round(40000 / tau_interp, 2);
   
end

%Normalised Square Difference Formula
function n = NSDF(signal)

    W = length(signal);
    n = zeros(1 ,800);

    
    [sigx, ~] = xcorr(signal, signal);

    r = sigx(W  : end); % Start in the middle to ignore negative lags.
   
    xs = signal.^2;
    xs1 = sum(xs);
    xs2 = xs1;
    
    %fs/50Hz = 800. Bins pas 800 go below 50Hz wich we can ignore
    for tau = 0 : 800 

        xs1 = xs1 - xs(end - tau);
        xs2 = xs2 - xs(tau + 1);
        n(tau + 1) = 2 * r(tau + 1) / (xs1 + xs2);
    end
    
   
    n = n(1 : 800);
end


function tau = find_peak(vector)
    
    flag = 0;
    valid_peak = 0;
    peak = 0;
    tau = 0;
    threshold = 0.9;
    for i = 1 : 800 - 1
        
       if (flag == 0) && (vector(i) < 0)
           flag = 1; %wait until first zero crossing before starting
       end
     
       %then find first major peak which is over threshold
       if (flag == 1)
           
           if (vector(i) > peak) && (vector(i) > threshold) 
               
               peak = vector(i);
               tau = i;
               valid_peak = 1;
               
            
              
           elseif (valid_peak == 1)
             
               return;
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




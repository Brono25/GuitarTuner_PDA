

% tau is the lag corresponding to the pitch
function [np, pitch] = Mcleod_pitch_method(signal)

    
    n = NSDF(signal);
    np = remove_first_peak(n);
    np(np < 0.3) = 0;
    [~, tau] = max(np);
    
    if (tau <= 1)
        tau = 2;
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
    
   
    n = n(1 : W / 4);
end


% the intial peak at lag 0 is always the maximum.
% removing this will make finding the second maximum easier.
function nsdf = remove_first_peak(nsdf)  
    for i = 1 : length(nsdf)
        if (nsdf(i) < 0) 
            return;
        end  
        nsdf(i) = 0;
    end
   
end

function x_max = parabolic_interpolation(xp, a ,b ,c)
  
    a = 20*log10(a);
    b = 20*log10(b);
    c = 20*log10(c);
    
    p = 1/2 * (a - c) / (1 - 2*b + c);
    
  
    x_max = xp + p;
 
end




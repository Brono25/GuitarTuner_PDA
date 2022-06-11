

% tau is the lag corresponding to the pitch
function [np, tau_interp] = Mcleod_pitch_method(signal)

  
    np = NSDF(signal);
   
    tau = find_peak(np);
    

    if (tau <= 1)
        tau_interp = 0;
    end
    
    x1 = tau - 1;
    y1 = np(tau - 1);
    x2 = tau;
    y2 = np(tau);
    x3 = tau + 1;
    y3 = np(tau + 1);
    
    tau_interp = parabolic_interpolation(x1, y1, x2, y2, x3, y3);
   
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




function x_max = parabolic_interpolation2(x1, y1, x2, y2, x3, y3)
  
    a = 20*log10(y1);
    b = 20*log10(y2);
    c = 20*log10(y3);
    
    p = 1/2 * (1 - c) / (1 -2*b + c);
    x_max = x2 + p;
        
end




function x_max = parabolic_interpolation(x1, y1, x2, y2, x3, y3)
  
    X = [x1^2 x1 1; x2^2 x2 1; x3^2 x3 1];
    Y = [y1; y2; y3];
    A = inv(X) * Y;
    x_max = -A(2) /  (2 * A(1));
        
end




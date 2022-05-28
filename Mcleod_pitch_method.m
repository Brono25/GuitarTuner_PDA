

%do method
function n = Mcleod_pitch_method(signal)

    %x = resample(signal, 5, 1);
    n = NSDF(signal);
   
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
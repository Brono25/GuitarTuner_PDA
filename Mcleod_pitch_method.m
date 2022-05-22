

%do method
function pitch = Mcleod_pitch_method(signal)

    x = resample(signal, 5, 1);
    
    pitch = x;
end
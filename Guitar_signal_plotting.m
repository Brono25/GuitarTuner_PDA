



clc
clear all
format long g


load('Sensor_Data/guitar_data.mat'); % guitar signals  fs = 8kHz
load('Sensor_Data/test_data.mat');   % pure sin waves  fs = 8kHz
load('Sensor_Data/test_40k.mat');    % purse sin waves fs = 40kHz


fs = guitar.fs;
N = 1024 * 2; 
max_value = 4096/2; %peak value of adc signal after dc removed

signal1 = guitar.A.clean;
signal2 = test.A.clean;
signal3 = test40.y80;

signal = signal1; % use to change between type of signals


numFrames = length(signal) / N;
frameTime = N * 1/fs;
frame = zeros(1,N);

graph_signal = ''; 
graph_nsdf = '';
[graph_signal , graph_nsdf] = init_plot(frame, fs);
[b, a] = init_DC_Filter(fs);

for k = 1 : numFrames 
    
    frameCounter = (k - 1) * N + 1 : N * k;
    frame = [signal(frameCounter)];
    %subtract the DC bias of the MCU ADC
    frame = double(frame) - 2212;
    % further DC filtering
    xf = frame;
    %xf = filtfilt(b,a,frame);
    
    %
    %      Process Signal xf
    %-------------------------------------------------- 
  
 
    
   
     xf = thresholding(xf, 0.1 * max_value);
     n = Mcleod_pitch_method(xf);
    
    
 
    
    %-------------------------------------------------- 
    %
    %
    set(graph_signal, 'yData', xf)
    set(graph_nsdf, 'yData', n)
    drawnow
    pause(0.128 * 3)

end

function [graph_signal , graph_nsdf] = init_plot (frame, fs)
    
    W =  length(frame);
    time = linspace(0, W / fs, W);
    lags = linspace(0, W / 4, W / 4);
    

    figure(1)
    tiledlayout(1,2)
    nexttile
    %plotting time domain
    
    graph_signal = plot(time, frame);
    title('Guitar Signal', 'fontsize', 25);
    ylabel('ADC 12 Bit Value', 'fontsize', 20);
    xlabel('Time [sec]', 'fontsize', 20);
    axis tight
    ylim([-2048 2048])
    grid on
    
    %plotting NSDF
    nexttile
    graph_nsdf = plot(lags, zeros(1, W/4));
    title('NSDF Correlation', 'fontsize', 25);
    xlabel('Lag [\tau]', 'fontsize', 20);
    ylabel('n(\tau)', 'fontsize', 20);
    axis tight
    ylim([-1 1])
    xlim([0 512])
    grid on
end

function [b, a] = init_DC_Filter (fs)

    %DC filter
    fc = 20;
    fn = fc / (fs/2);
    order = 2;
    [b, a] = butter(order, fn, 'high');

end

function [out] = thresholding (x, THRESHOLD)

    x(abs(x) < THRESHOLD) = 0; 
    out = x;
  
end







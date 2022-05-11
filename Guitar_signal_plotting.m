



clc
clear all
format long g


load('Sensor_Data/guitar_data.mat'); % guitar signals  fs = 8kHz
load('Sensor_Data/test_data.mat');   % pure sin waves  fs = 8kHz
load('Sensor_Data/test_40k.mat');    % purse sin waves fs = 40kHz


fs = guitar.fs;
N = 4096; 


signal1 = guitar.B.clean;
signal2 = test.D.clean;
signal3 = test40.y80;

signal = signal2; % use to change between type of signals


numFrames = length(signal) / N;
frameTime = N * 1/fs;
frame = zeros(1,N);
graph = '';
graph = init_plot(frame);
[b, a] = init_DC_Filter(fs);

for k = 1 : numFrames 
    
    frameCounter = (k - 1) * N + 1 : N * k;
    frame = [signal(frameCounter)];
    %subtract the DC bias of the MCU ADC
    frame = double(frame) - 2212;
    % further DC filtering
    xf = filtfilt(b,a,frame);
    
    %
    %     V V Pitch Detection Function V V
    %-------------------------------------------------- 
  
 
    
    
    % do algorithm on xf
    Mcleod_pitch_method
    
    
    
    %-------------------------------------------------- 
    %
    %
    set(graph, 'yData', xf)
    drawnow
    pause(0.512)

end

function graph = init_plot (frame)

    %plotting
    figure(1)
    graph = plot(frame);
    axis tight
    ylim([-2048 2048])
    grid on
end

function [b, a] = init_DC_Filter (fs)

    %DC filter
    fc = 55;
    fn = fc / (fs/2);
    order = 1;
    [b, a] = butter(order, fn, 'high');

end






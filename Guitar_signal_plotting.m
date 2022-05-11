



%
clc
clear all
%load('Sensor_Data/PickupData/pickup_data.mat');
load('Sensor_Data/guitar_data.mat');
% load('Sensor_Data/guitar_data.mat');
% load('Sensor_Data/test_data.mat');
% load('Sensor_Data/test_40k.mat');
format long g

fs = guitar.fs;
N = 4096;

%signal = test.E.fast;
signal = guitar.e.clean;



numFrames = length(signal) / N;
frameTime = N * 1/fs;
frame = zeros(1,N);

%plotting
figure(1)
graph = plot(frame);
axis tight
ylim([-2048 4096])

%DC filter
fc = 55;
fn = fc / (fs/2);
order = 1;
[b, a] = butter(order, fn, 'high');


for k = 1 : numFrames 
    
    frameCounter = (k - 1) * N + 1 : N * k;
    frame = [signal(frameCounter)];
    %subtract the DC bias of the MCU ADC
    frame = double(frame) - 2212;
    % further DC filtering
    xf = filtfilt(b,a,frame);
    
    %
    %      PDA Functions
    %-------------------------------------------------- 
  
    
    %-------------------------------------------------- 
    %
    %
    set(graph, 'yData', xf)
    drawnow
    pause(0.25)

end

function init_plot 




end





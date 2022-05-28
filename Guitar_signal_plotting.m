

clc

load('Sensor_Data/guitar_data.mat'); % guitar signals  fs = 8kHz
load('Sensor_Data/test_data.mat');   % pure sin waves  fs = 8kHz
load('Sensor_Data/test_40k.mat');    % purse sin waves fs = 40kHz


fs = guitar.fs;

max_value = 4096/2; %peak value of adc signal after dc removed.
DC_bias = 2212; %adc values are from [0 4096]. Adjust to [-2048 2048]

signal1 = guitar.B.clean;   %guitar test signals
signal2 = test.B.clean;     %pure tone test signals
signal3 = test40.y80;

signal = signal2; % use to change between type of signals



% Test signals are broken into frames of size N and processed. This is to
% emulate a real time ADC buffer.
N = 2048 * 2; 
numFrames = length(signal) / N;
frameTime = N * 1/fs;
ADC_buffer_frame = zeros(1, N);

[graph_signal , graph_nsdf] = init_plot(ADC_buffer_frame, fs);
[b, a] = init_DC_Filter(fs);


for k = 1 : numFrames 
    
    frameCounter = (k - 1) * N + 1 : N * k;
    ADC_buffer_frame = signal(frameCounter);
    ADC_buffer_frame = double(ADC_buffer_frame) - DC_bias;
    %
    %              Process Frame
    %-------------------------------------------------- 
  

     frame_thrsh = thresholding(ADC_buffer_frame, 0.05 * max_value);
     [n, tau, xy] = Mcleod_pitch_method(frame_thrsh);
    
     pitch = round(fs / tau, 2);
     
 
    
    %-------------------------------------------------- 
    %
    %
   
    set(graph_signal, 'yData', ADC_buffer_frame);
    set(graph_nsdf, 'yData', n);
    drawnow
    
    
    leg_str = sprintf('Pitch Estimate: %.2f Hz\n',pitch);
    legend(leg_str, 'fontsize', 20);
	fprintf('        %.2f Hz\n',pitch);
    
    
    
    
    pause(0.256 * 40)
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
    xlim([0 200])
    grid on
    
    E2 = 97;
    A2 = 73;
    D3 = 54;
    G3 = 41;
    B3 = 32;
    E4 = 24;
    light_red = [1 0.5 0.5];
    yl = get(gca, 'YLim');
    line( [E2 E2],  yl, 'Color',light_red,'LineStyle','--');
    line( [A2 A2],  yl, 'Color',light_red,'LineStyle','--');
    line( [D3 D3],  yl, 'Color',light_red,'LineStyle','--');
    line( [G3 G3],  yl, 'Color',light_red,'LineStyle','--');
    line( [B3 B3],  yl, 'Color',light_red,'LineStyle','--');
    line( [E4 E4],  yl, 'Color',light_red,'LineStyle','--');
    
    text(98, -0.9, 'E_2','FontSize',15);
    text(74, -0.9, 'A_3','FontSize',15);
    text(55, -0.9, 'D_3','FontSize',15);
    text(42, -0.9, 'G_3','FontSize',15);
    text(33, -0.9, 'B_3','FontSize',15);
    text(25, -0.9, 'E_4','FontSize',15);
    
   
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

function init_frequencies()
   
    E2_Hz = 82.41;
    A2_Hz = 110.00;
    D3_Hz = 146.83;
    G3_Hz = 196.00;
    B3_Hz = 246.94;
    E4_Hz = 329.63;

end





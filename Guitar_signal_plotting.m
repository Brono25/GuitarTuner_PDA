



clc

load('Sensor_Data/guitar_data.mat'); % guitar signals  fs = 8kHz
load('Sensor_Data/test_data.mat');   % pure sin waves  fs = 8kHz
load('Sensor_Data/test_40k.mat');    % purse sin waves fs = 40kHz


%fs = guitar.fs;
fs = 40e3;

max_value = 4096/2; %peak value of adc signal after dc removed.
DC_bias = 2212; %adc values are from [0 4096]. Adjust to [-2048 2048]

signal1 = guitar.E.clean;   %guitar test signals
signal2 = test.B.clean;     %pure tone test signals
signal3 = test40.y350;


signal = signal1; % use to change between type of signals
signal = resample(double(signal), 5, 1);



% Test signals are broken into frames of size N and processed. This is to
% emulate a real time ADC buffer.
N = 1024; 
numFrames = length(signal) / N;
frameTime = N * 1/fs;
ADC_buffer_frame = zeros(1, N);
frame1 = ADC_buffer_frame;
frame2 = zeros(1, N);
frame3 = zeros(1, N);
frame4 = zeros(1, N);
process_frame = zeros(1, 4 * N);

[graph_signal , graph_nsdf] = init_plot(process_frame, fs);
[b1 a1] = filter_init(fs);
[b2 a2] = init_DC_Filter (fs);

for k = 1 : numFrames 
    
    frameCounter = (k - 1) * N + 1 : N * k;
    ADC_buffer_frame = signal(frameCounter);
    ADC_buffer_frame = double(ADC_buffer_frame) - DC_bias;
    
    frame4 = frame3;
    frame3 = frame2;
    frame2 = frame1;
    frame1 = ADC_buffer_frame;
    
    
    
    
    process_frame = [frame4 frame3 frame2 frame1];
  
    
    %
    %              Process Frame
    %-------------------------------------------------- 
  

	frame_thrsh = thresholding(process_frame, 0.25 * max_value);
   % frame_filtered = filter(b1, a1, frame_thrsh);
    frame_filtered = filter(b2, a2,  frame_thrsh);
    
    
    %bits = digitizer(process_frame, 0.25 * max_value);
    
	[n, tau] = Mcleod_pitch_method(frame_filtered);
    
	pitch = round(fs / tau, 2);


    %-------------------------------------------------- 
    %
    %
    
    
   
    set(graph_signal, 'yData', process_frame);
    set(graph_nsdf,'YData',n)
    drawnow
    
  
    
    if isnan(pitch) == 0
        leg_str = sprintf('Pitch Estimate: %.2f Hz\n',pitch);
        legend(leg_str, 'fontsize', 20);
        fprintf('        %.2f Hz\n',pitch);
    end
    
    pause(0.128)
end


function [graph_signal , graph_nsdf] = init_plot (frame, fs)
    
    W = length(frame);
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
    %xlim([0 1000])
    grid on
    
    E2_Hz = 82.41;
    A2_Hz = 110.00;
    D3_Hz = 146.83;
    G3_Hz = 196.00;
    B3_Hz = 246.94;
    E4_Hz = 329.63;

    E2 = round(fs / E2_Hz);
    A2 = round(fs / A2_Hz);
    D3 = round(fs / D3_Hz);
    G3 = round(fs / G3_Hz);
    B3 = round(fs / B3_Hz);
    E4 = round(fs / E4_Hz);
    

    light_red = [1 0.5 0.5];
    
    yl = get(gca, 'YLim');
    line( [E2 E2],  yl, 'Color',light_red,'LineStyle','--');
    line( [A2 A2],  yl, 'Color',light_red,'LineStyle','--');
    line( [D3 D3],  yl, 'Color',light_red,'LineStyle','--');
    line( [G3 G3],  yl, 'Color',light_red,'LineStyle','--');
    line( [B3 B3],  yl, 'Color',light_red,'LineStyle','--');
    line( [E4 E4],  yl, 'Color',light_red,'LineStyle','--');
    
    text(E2 + 1, -0.9, 'E_2','FontSize',15);
    text(A2 + 1, -0.9, 'A_3','FontSize',15);
    text(D3 + 1, -0.9, 'D_3','FontSize',15);
    text(G3 + 1, -0.9, 'G_3','FontSize',15);
    text(B3 + 1, -0.9, 'B_3','FontSize',15);
    text(E4 + 1, -0.9, 'E_4','FontSize',15);
    
   
end


function [out] = thresholding (x, THRESHOLD)

    x(abs(x) < THRESHOLD) = 0; 
    out = x;
end

function [b a] = filter_init(fs)
    
    fc = 350;
    fn = fc / (fs/2);
    order = 2;
    stop_band_ripple_dB = 0.5;
    [b, a] = butter(order, fn);

end


function [b, a] = init_DC_Filter (fs)

    %DC filter
    fc = 20;
    fn = fc / (fs/2);
    order = 4;
    [b, a] = butter(order, fn, 'high');

end



function bits = digitizer(x, threshold)

    for i = 1 : length(x)
        if x(i) >=  threshold
            
            x(i) = 1;
        else   
             x(i) = 0;
        end    
    end
    bits = x;
end






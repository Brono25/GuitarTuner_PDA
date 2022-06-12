



clc

% Device i/o setup
fs = 40000;
N = 2048;
deviceReader = audioDeviceReader(fs,N, ...
                                'Device', 'Wireless Stereo Headset'...
                                , 'OutputDataType', 'int16');   
setup(deviceReader);



max_value = 4096/2; %peak value of adc signal after dc removed.
DC_bias = 2212; %adc values are from [0 4096]. Adjust to [-2048 2048]


t = linspace(0,1/fs * N, N);
frame = zeros(1,N);
[graph_signal , graph_nsdf] = init_plot(frame, fs);
[b a] = filter_init(fs);

pitch_table = zeros(1,11);

tic
disp('You are live...')
while toc < 30
    
    frame = [deviceReader()];
    %
    %              Process Frame
    %-------------------------------------------------- 
  

	frame_thrsh = thresholding(1.5 * frame, 0.05 * max_value);
    frame_filtered = filter(b, a, frame_thrsh);
	[n, pitch_estimate] = Mcleod_pitch_method(frame_filtered );
    
    
	if isnan(pitch_estimate) == 0
        pitch_table = [pitch_table pitch_estimate];
        pitch_table = pitch_table(2:end);
    end
    
    pitch = median(pitch_table);
    

   
    %-------------------------------------------------- 
    %
    %
   
    set(graph_signal, 'yData', frame_filtered);
    h1 = set(graph_nsdf, 'yData', n);
    h2 = copyobj(h1, graph_nsdf); 
    %set(h2,'XData',xy(1),'YData',xy(2),'Color','r')
    drawnow
    
    
    
    
    if isnan(pitch) == 0 && pitch ~= 0
        leg_str = sprintf('Pitch Estimate: %.2f Hz\n',pitch);
        legend(leg_str, 'fontsize', 20);
        fprintf('        %.2f Hz\n',pitch);
    end
    
    
end


release(deviceReader)






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
   % xlim([0 1000])
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



%==================================================================
% 1. Transmitter
%==================================================================
[y, Fs] = audioread('music.mp3'); % You can change this for the sound/music name
sound(y, Fs);

if size(y, 2) > 1
    y_mono = y(:, 1); 
else
    y_mono = y;
end

n = length(y_mono);
t = linspace(0, (n-1)/Fs, n);

figure('Name', 'Transmitter Stage');
subplot(2, 1, 1);
plot(t, y_mono);
title('Time Domain: Original Signal');
xlabel('Time (s)'); ylabel('Amplitude');

X = fft(y_mono, n);
x_mag = abs(X);
x_shift = fftshift(x_mag);
f = linspace(-Fs/2, Fs/2, n);

subplot(2, 1, 2);
plot(f, x_shift);
title('Frequency Domain: Original Signal');
xlabel('Frequency (Hz)'); ylabel('Magnitude');

%==================================================================
% 2. Channel Simulation
%==================================================================
% Channel 1: Delta function
h_impulse = 1;
y_channel_1 = conv(y_mono, h_impulse);
t_out_1 = t;

figure('Name', 'Channel Outputs Comparison');
subplot(4, 2, 1);
plot(t_out_1, y_channel_1);
title('Time Domain: Delta Channel Output');

Y_1 = fft(y_channel_1, n);
Y_mag = abs(Y_1);
Y_shift = fftshift(Y_mag);
subplot(4, 2, 2);
plot(f, Y_shift);
title('Frequency Domain: Delta Channel Output');

% Channel 2: exp(-2pi*5000t)
t_h = 0:1/Fs:0.5;
h2 = exp(-2*pi*5000*t_h);
y_channel_2 = conv(y_mono, h2);
n_t2 = length(h2) + n - 1;
t_out_2 = (0:n_t2-1)/Fs;

subplot(4, 2, 3);
plot(t_out_2, y_channel_2);
title('Time Domain: exp(-2\pi*5000t) Output');

Y_2 = fft(y_channel_2, n_t2);
Y_shift2 = fftshift(abs(Y_2));
f_2 = linspace(-Fs/2, Fs/2, n_t2);
subplot(4, 2, 4);
plot(f_2, Y_shift2);
title('Frequency Domain: exp(-2\pi*5000t) Output');

% Channel 3: exp(-2pi*1000t)
h3 = exp(-2*pi*1000*t_h);
y_channel_3 = conv(y_mono, h3);
n_t3 = length(h3) + n - 1;
t_out_3 = (0:n_t3-1)/Fs;

subplot(4, 2, 5);
plot(t_out_3, y_channel_3);
title('Time Domain: exp(-2\pi*1000t) Output');

Y_3 = fft(y_channel_3, n_t3);
Y_shift3 = fftshift(abs(Y_3));
f_3 = linspace(-Fs/2, Fs/2, n_t3);
subplot(4, 2, 6);
plot(f_3, Y_shift3);
title('Frequency Domain: exp(-2\pi*1000t) Output');

% Channel 4: Multipath Impulse Response (Echo)
h4 = zeros(1, Fs+1); 
h4(1) = 2;
h4(end) = 0.5;
y_channel_4 = conv(y_mono, h4);
n_t4 = length(h4) + n - 1;
t_out_4 = (0:n_t4-1)/Fs;

subplot(4, 2, 7);
plot(t_out_4, y_channel_4);
title('Time Domain: Channel Impulse Response Output');

Y_4 = fft(y_channel_4, n_t4);
Y_shift4 = fftshift(abs(Y_4));
f_4 = linspace(-Fs/2, Fs/2, n_t4);
subplot(4, 2, 8);
plot(f_4, Y_shift4);
title('Frequency Domain: Channel Impulse Response Output');

% Menu Selection
i = 0;
while i == 0
    fprintf('\nEnter the type of channel:\n1. Delta function\n2. exp(-2\\pi*5000t)\n3. exp(-2\\pi*1000t)\n4. Channel impulse response\n');
    Channel_sel = input('Your choice: ');
    switch Channel_sel
        case 1
            t_out = t_out_1; channel = y_channel_1; i = 1;
        case 2
            t_out = t_out_2; channel = y_channel_2; i = 1;
        case 3
            t_out = t_out_3; channel = y_channel_3; i = 1;
        case 4
            t_out = t_out_4; channel = y_channel_4; i = 1;
        otherwise
            i = 0;
            fprintf('Invalid choice! Please try again.\n'); % FIXED: 'print' to 'fprintf'
    end
end

filtered_playback = input('Do you want to play the channel version? y/n: ', "s");
if strcmpi(filtered_playback, 'y')
    clear sound;
    sound(channel, Fs);
end

%==================================================================
% 3. Noise Channel (AWGN)
%==================================================================
sigma = input('\nEnter the value of sigma (Noise level): ');
z_t = sigma * randn(length(channel), 1); % FIXED: Ensured vector dimension consistency
y_noisy = channel(:) + z_t(:);

figure('Name', 'Noisy Signal Analysis');
subplot(2, 1, 1);
plot(t_out, y_noisy);
title('Time Domain: Add Noise To Channel Output');
xlabel('Time (s)');

n_fft = length(channel);
Y_noisy = fft(y_noisy, n_fft);
Y_shift_noisy = fftshift(abs(Y_noisy));
f_noise = linspace(-Fs/2, Fs/2, n_fft);

subplot(2, 1, 2);
plot(f_noise, Y_shift_noisy);
title('Frequency Domain: Add Noise To Channel Output');
xlabel('Frequency (Hz)');

filtered_playback = input('Do you want to play the noisy version? y/n: ', "s");
if strcmpi(filtered_playback, 'y')
    clear sound;
    % FIXED: We play the real-time noisy signal (y_noisy), NOT the raw frequency spectrum (Y_noisy)
    sound(real(y_noisy), Fs); 
end

%==================================================================
% 4. Receiver (Ideal LPF)
%==================================================================
f_rx = linspace(-Fs/2, Fs/2, n_fft);
fc = 3400;
H_filter = abs(f_rx) <= fc;
H_filter = ifftshift(H_filter);

Y_filtered_freq = Y_noisy(:) .* H_filter(:);
y_final = real(ifft(Y_filtered_freq));

figure('Name', 'Receiver Stage Output');
subplot(2, 1, 1);
plot(t_out, y_final);
title('Time Domain: After Ideal LPF (3.4kHz)');
xlabel('Time (s)');

subplot(2, 1, 2);
plot(f_rx, fftshift(abs(Y_filtered_freq)));
title('Frequency Domain: After Ideal LPF (3.4kHz)');
xlabel('Frequency (Hz)');

filtered_playback = input('Do you want to play the filtered version? y/n: ', "s");
if strcmpi(filtered_playback, 'y') 
    clear sound;
    sound(y_final, Fs);
end
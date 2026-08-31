% =========================================================================
% Digital Signal Processing Laboratory
% Analysis of DTFT Properties, FFT, and Convolution Methods
% Author: Pouria Amiri
% =========================================================================
clear; clc; close all;

%% Experiment 1 & 2: Discrete-Time Fourier Transform (DTFT)
figure('Name', 'DTFT Magnitude and Phase');
w = -4*pi : 8*pi/511 : 4*pi;
x_seq = [1 3 5 7 9 11 13 15 17];
h_dtft = freqz(x_seq, 1, w);

subplot(2,1,1);
plot(w/pi, abs(h_dtft), 'LineWidth', 1.5); grid on;
title('Magnitude Spectrum |H(e^{j\omega})|');
xlabel('Normalized Frequency (\omega/\pi)'); ylabel('Magnitude');

subplot(2,1,2);
plot(w/pi, angle(h_dtft), 'LineWidth', 1.5); grid on;
title('Phase Spectrum arg[H(e^{j\omega})]');
xlabel('Normalized Frequency (\omega/\pi)'); ylabel('Phase (radians)');

%% Experiment 3: Time Reversal Property
figure('Name', 'Time Reversal Property');
x_rev = [3 4 6 7 8 5 2 3 1];
x_rev_flipped = fliplr(x_rev);

h_orig = freqz(x_rev, 1, w);
h_flipped = freqz(x_rev_flipped, 1, w);

subplot(2,2,1); plot(w/pi, abs(h_orig)); grid on;
title('Magnitude: Original Sequence'); xlabel('\omega/\pi'); ylabel('Magnitude');

subplot(2,2,2); plot(w/pi, abs(h_flipped)); grid on;
title('Magnitude: Time-Reversed Sequence'); xlabel('\omega/\pi'); ylabel('Magnitude');

subplot(2,2,3); plot(w/pi, angle(h_orig)); grid on;
title('Phase: Original Sequence'); xlabel('\omega/\pi'); ylabel('Phase (rad)');

subplot(2,2,4); plot(w/pi, angle(h_flipped)); grid on;
title('Phase: Time-Reversed Sequence'); xlabel('\omega/\pi'); ylabel('Phase (rad)');
% Observation: Magnitude remains identical, phase is inverted.

%% Experiment 4: Fast Fourier Transform (FFT) Length Effects
figure('Name', 'Effect of FFT Length (Zero-Padding)');
n = 0:100;
x_sin = cos(2*pi*0.1*n) + sin(2*pi*0.2*n);
N = length(x_sin);

% Case 1: L = N (Exact length)
L1 = N; 
H1 = fft(x_sin, L1);
k1 = 0:L1-1;

% Case 2: L > N (Zero-padding for higher resolution)
L2 = 256; 
H2 = fft(x_sin, L2);
k2 = 0:L2-1;

subplot(2,1,1);
stem(k1, abs(H1), 'filled'); grid on;
title(['FFT Magnitude Spectrum (L = N = ', num2str(L1), ')']);
xlabel('Frequency Index k'); ylabel('Magnitude');

subplot(2,1,2);
stem(k2, abs(H2), 'filled'); grid on;
title(['FFT Magnitude Spectrum with Zero Padding (L = ', num2str(L2), ')']);
xlabel('Frequency Index k'); ylabel('Magnitude');

%% Experiment 5: Linear Convolution using FFT
x1 = [1 2 3 4 5];
x2 = [2 2 0 1 1];

% To perform linear convolution via FFT, sequences must be zero-padded 
% to length L = N1 + N2 - 1
L_conv = length(x1) + length(x2) - 1;

x1_padded = [x1, zeros(1, L_conv - length(x1))];
x2_padded = [x2, zeros(1, L_conv - length(x2))];

X1_fft = fft(x1_padded);
X2_fft = fft(x2_padded);

% Multiplication in frequency domain
Y_fft = X1_fft .* X2_fft;

% Inverse FFT to return to time domain
y_conv_fft = real(ifft(Y_fft));
y_conv_direct = conv(x1, x2);

disp('--- Linear Convolution Comparison ---');
disp('Linear convolution using FFT (Zero-Padded):');
disp(y_conv_fft);
disp('Direct linear convolution (conv function):');
disp(y_conv_direct);
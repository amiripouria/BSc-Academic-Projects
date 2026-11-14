clear; clc; close all;

%% Determining FIR Filter Order

% Part 1 & 2: Using kaiserord for Lowpass Filter
disp('--- Experiment 6-1: kaiserord for Lowpass ---');
fs1 = 10000; fp1 = 2000; fss1 = 2500; Rp1 = 0.005; Rs1 = 0.005;
[n1, Wn1, beta1, ftype1] = kaiserord([fp1 fss1], [1 0], [Rp1 Rs1], fs1);
fprintf('Order (n1): %d\n', n1);
fprintf('Normalized Cutoff (Wn): %.4f\n', Wn1);
fprintf('Beta: %.4f\n', beta1);
fprintf('Filter Type: %s\n\n', ftype1);

% Part 4: kaiserord with different parameter definitions
disp('--- Experiment 6-1: kaiserord with alternative parameters ---');
Fs2 = 40000; Fp2 = 4000; Fs_stop2 = 8000; Rp2 = 0.5; Rs2 = 40;
[n2, Wn2, beta2, ftype2] = kaiserord([Fp2 Fs_stop2], [1 0], [(10^(Rp2/20)-1) (10^(-Rs2/20))], Fs2);
fprintf('Order (N2): %d\n\n', n2);

%% FIR Filter Design

% Part 7: FIR Lowpass using Kaiser Window
disp('--- Experiment 6-2: FIR Lowpass using Kaiser Window ---');
fs = 10000;
f = [2000 2500];
a = [1 0];
dev = [0.005 0.005];

[n, Wn, beta, ftype] = kaiserord(f, a, dev, fs);
b_kaiser = fir1(n, Wn, 'low', kaiser(n+1, beta));

disp('Filter coefficients (b_kaiser):');
disp(b_kaiser.');

% Frequency response
figure('Name', 'Kaiser Window FIR');
freqz(b_kaiser, 1, 1024, fs);
title('Frequency Response of FIR Lowpass Filter (Kaiser)');

% Ripple and Attenuation Checking
[g, w] = freqz(b_kaiser, 1, 2048, fs);
mag = abs(g);

% Passband ripple (0 - 2 kHz)
pb = mag(w <= (2000/fs)*2*pi); % Adjusted logic for normalized angular freq
pb_ripple = max(pb) - min(pb);

% Stopband attenuation (>= 2.5 kHz)
sb = mag(w >= (2500/fs)*2*pi);
sb_att = max(sb);

fprintf('Order of the filter: %d\n', n);
fprintf('Passband ripple = %.6f (desired < %.6f)\n', pb_ripple, dev(1));
fprintf('Stopband max magnitude = %.6f (desired < %.6f)\n\n', sb_att, dev(2));

% Part 8: Comparison with Hanning and Blackman Windows
disp('--- Experiment 6-2: Hanning vs Blackman Windows ---');

% Hanning window
b_hann = fir1(n, Wn, 'low', hanning(n+1));
figure('Name', 'Hanning Window FIR');
freqz(b_hann, 1, 1024, fs);
title('Lowpass FIR using Hanning Window');

% Blackman window
b_black = fir1(n, Wn, 'low', blackman(n+1));
figure('Name', 'Blackman Window FIR');
freqz(b_black, 1, 1024, fs);
title('Lowpass FIR using Blackman Window');

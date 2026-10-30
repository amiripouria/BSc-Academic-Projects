% Digital Signal Processing - Highpass Filter
% Authors: Pouria Amiri
% Description: Z-transform analysis, filter properties, and system stability[cite: 2, 3, 4, 5, 6, 7].

clear; clc; close all;

%% Experiment 4-1: Z-transform poles and zeros
figure('Name', 'Experiment 4-1: Pole-Zero Plot', 'Position', [100, 100, 800, 400]);

% Part 1: Using direct coefficients
a1 = [2 5 9 5 3]; %[cite: 2]
b1 = [5 45 2 1 1]; %[cite: 2]
subplot(1, 2, 1);
zplane(a1, b1); %[cite: 2]
title('Pole-Zero Plot (Direct Coefficients)');
grid on;

% Part 2: Using tf2zp
a2 = [2 5 5 3]; %[cite: 2]
b2 = [5 45 2 1 1]; %[cite: 2]
[zeros_val, poles_val, gain_val] = tf2zp(a2, b2); %[cite: 2]
subplot(1, 2, 2);
zplane(zeros_val, poles_val); %[cite: 2]
title('Pole-Zero Plot (Using tf2zp)');
grid on;

%% Experiment 4-2: System properties and filter types
figure('Name', 'Experiment 4-2: Filter Stem Plot');
fc = 0.45; %[cite: 3]
n = -9.5:1:10.5; %[cite: 3]
y = 2 * fc * sinc(2 * fc * n); %[cite: 3]
k = n + 9.5; %[cite: 3]

stem(k, y, 'filled'); %[cite: 3]
title('N = 20'); %[cite: 4]
axis([0 20 -1 1]); %[cite: 4]
xlabel('Time index n'); %[cite: 4]
ylabel('Amplitude'); %[cite: 4]
grid on; %[cite: 4]

%% Experiment 4-3: Gain of a Highpass Filter
figure('Name', 'Experiment 4-3: Highpass Filter Gain');
M = 5; %[cite: 5]
num = ((-1).^(0:M-1)) / M; %[cite: 5]

% Note: 'gain' function in the original report is substituted with standard 'freqz'
[h, w] = freqz(num, 1, 256);
g = 20 * log10(abs(h)); % Convert to dB

plot(w/pi, g, 'LineWidth', 1.5); %[cite: 5]
grid on; %[cite: 5]
axis([0 1 -50 0.5]); %[cite: 5]
xlabel('\omega/\pi'); %[cite: 5]
ylabel('Gain in dB'); %[cite: 5]
title(['Highpass Filter, M = ', num2str(M)]); %[cite: 5]

%% Experiment 4-4: Pole-zero plots for stability
figure('Name', 'Experiment 4-4: Stability Analysis', 'Position', [150, 150, 800, 400]);

% System 1
den1 = [1 -1.848 0.85]; %[cite: 5]
subplot(1, 2, 1); %[cite: 5]
zplane(1, den1); %[cite: 5]
title('Poles and Zeros of System H1(z)'); %[cite: 5]
grid on; %[cite: 5]

% System 2
den2 = [1 -1.851 0.85]; %[cite: 6]
subplot(1, 2, 2); %[cite: 6]
zplane(1, den2); %[cite: 6]
title('Poles and Zeros of System H2(z)'); %[cite: 6]
grid on; %[cite: 6]

% Stability check display
disp('--- Stability Analysis ---');
disp('System 1 Poles:');
disp(roots(den1));
disp('System 2 Poles:');
disp(roots(den2));

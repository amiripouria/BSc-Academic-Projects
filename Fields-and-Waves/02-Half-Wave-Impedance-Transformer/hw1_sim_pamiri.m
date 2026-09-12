%% Initialization
clc;
clear;
close all;
%% Parameter Definition
f = 72e9; % Frequency
freq = linspace(50.4e9, 93.6e9); % Frequency range
tan_delta = 0.0048; % Loss Tangent
eps_r = 3.2; % Relative Permittivity
d = 1.16e-3; % Thickness of the Slab in meters
w = 2*pi*freq; % Angular frequency [rad/s]
u0 = 4*pi*1e-7; % Permeability of free space [H/m]
eps_0 = 8.854e-12; % Permittivity of free space [F/m]
%% Lossless Form (sigma = 0)
% Region 1
beta1 = w .* sqrt(eps_0 .* u0); % [rad/m]
gamma1 = 1i .* beta1;
eta1 = sqrt(u0 ./ eps_0);
% Region 2
beta2 = w .* sqrt(u0 .* eps_0 .* eps_r);
gamma2_lossless = 1i .* beta2;
eta2_lossless = sqrt(u0 ./ (eps_0 .* eps_r));
% Region 3
beta3 = beta1;
gamma3 = gamma1;
eta3 = eta1;
% Reflection Coefficients
Gamma12_lossless = (eta2_lossless - eta1) ./ (eta2_lossless + eta1);
Gamma23_lossless = (eta3 - eta2_lossless) ./ (eta3 + eta2_lossless);
% Transmission Coefficients
T12_lossless = (2 .* eta2_lossless) ./ (eta2_lossless + eta1);
T23_lossless = (2 .* eta3) ./ (eta3 + eta2_lossless);
% Slab Coefficients
Gamma_Slab_lossless = (Gamma12_lossless + (Gamma23_lossless .* exp(-2 .* gamma2_lossless .* d))) ./ ...
    (1 + Gamma12_lossless .* Gamma23_lossless .* exp(-2 .* gamma2_lossless .* d));
T_Slab_lossless = (T12_lossless .* T23_lossless .* exp(-gamma2_lossless .* d) .* exp(gamma3 .* d)) ./ ...
    (1 + Gamma12_lossless .* Gamma23_lossless .* exp(-2 .* gamma2_lossless .* d));
%% Lossy Form (sigma > 0)
% Region 2 (Regions 1 & 3 remain the same)
eps_prime = eps_0 .* eps_r;
sigma = tan_delta .* w .* eps_prime;
gamma2_lossy = sqrt(1i .* w .* u0 .* (1i .* w .* eps_prime + sigma));
eta2_lossy = sqrt((1i .* w .* u0) ./ (1i .* w .* eps_prime + sigma));
% Reflection Coefficients
Gamma12_lossy = (eta2_lossy - eta1) ./ (eta2_lossy + eta1);
Gamma23_lossy = (eta3 - eta2_lossy) ./ (eta3 + eta2_lossy);
% Transmission Coefficients
T12_lossy = (2 .* eta2_lossy) ./ (eta2_lossy + eta1);
T23_lossy = (2 .* eta3) ./ (eta3 + eta2_lossy);
% Slab Coefficients
Gamma_Slab_lossy = (Gamma12_lossy + (Gamma23_lossy .* exp(-2 .* gamma2_lossy .* d))) ./ ...
    (1 + Gamma12_lossy .* Gamma23_lossy .* exp(-2 .* gamma2_lossy .* d));
T_Slab_lossy = (T12_lossy .* T23_lossy .* exp(-gamma2_lossy .* d) .* exp(gamma3 .* d)) ./ ...
    (1 + Gamma12_lossy .* Gamma23_lossy .* exp(-2 .* gamma2_lossy .* d));
%% Plotting
figure;
subplot(2,2,1);
plot(freq/1e9, abs(T_Slab_lossless), 'b', 'LineWidth', 1.5);
xline(72, 'k--', 'LineWidth', 1.5);
text(72.2, 0.05, 'f = 72 GHz', 'FontSize', 11, 'FontName', 'Times New Roman', 'Color', 'k');
title('Transmission Coefficient (Lossless)', 'FontName', 'Times New Roman');
xlabel('Frequency (GHz)', 'FontName', 'Times New Roman');
ylabel('|T|', 'FontName', 'Times New Roman');
grid on;
subplot(2,2,2);
plot(freq/1e9, abs(T_Slab_lossy), 'r', 'LineWidth', 1.5);
xline(72, 'k--', 'LineWidth', 1.5);
text(72.2, 0.05, 'f = 72 GHz', 'FontSize', 11, 'FontName', 'Times New Roman', 'Color', 'k');
title('Transmission Coefficient (Lossy)', 'FontName', 'Times New Roman');
xlabel('Frequency (GHz)', 'FontName', 'Times New Roman');
ylabel('|T|', 'FontName', 'Times New Roman');
grid on;
subplot(2,2,3);
plot(freq/1e9, abs(Gamma_Slab_lossless), 'b', 'LineWidth', 1.5);
xline(72, 'k--', 'LineWidth', 1.5);
text(72.2, 0.05, 'f = 72 GHz', 'FontSize', 11, 'FontName', 'Times New Roman', 'Color', 'k');
title('Reflection Coefficient (Lossless)', 'FontName', 'Times New Roman');
xlabel('Frequency (GHz)', 'FontName', 'Times New Roman');
ylabel('|\Gamma|', 'FontName', 'Times New Roman');
grid on;
subplot(2,2,4);
plot(freq/1e9, abs(Gamma_Slab_lossy), 'r', 'LineWidth', 1.5);
xline(72, 'k--', 'LineWidth', 1.5);
text(72.2, 0.05, 'f = 72 GHz', 'FontSize', 11, 'FontName', 'Times New Roman', 'Color', 'k');
title('Reflection Coefficient (Lossy)', 'FontName', 'Times New Roman');
xlabel('Frequency (GHz)', 'FontName', 'Times New Roman');
ylabel('|\Gamma|', 'FontName', 'Times New Roman');
grid on;
sgtitle('Transmission and Reflection Coefficients (Lossy vs Lossless)', 'FontName', 'Times New Roman');
%% Import from CST
Reflection_Result = readtable('Reflection.txt');
f_R_CST = Reflection_Result{:,1} * 1e9;   % Convert GHz to Hz
Gamma_CST = Reflection_Result{:,2};    % Already magnitude
Transmission_Result = readtable('Transmission.txt');
f_T_CST = Transmission_Result{:,1} * 1e9; % Convert GHz to Hz
T_CST = Transmission_Result{:,2};         % Already in magnitude
% Interpolate your theoretical values to CST frequency range
Gamma_los_interp = interp1(freq, abs(Gamma_Slab_lossy), f_R_CST, 'linear', 'extrap');
T_los_interp = interp1(freq, abs(T_Slab_lossy), f_T_CST, 'linear', 'extrap');
%% Comparison Plot for Reflection
figure('Name','CST vs Theoretical (Lossy Reflection)', 'Color', 'w', 'Position', [200 200 800 400]);
plot(f_R_CST/1e9, Gamma_CST, 'r', 'LineWidth', 2);
hold on;
plot(f_R_CST/1e9, Gamma_los_interp, 'b--', 'LineWidth', 2);
xline(72, 'k--', 'LineWidth', 1.5);
text(72.2, 0.05, 'f = 72 GHz', 'FontSize', 11, 'FontName', 'Times New Roman', 'Color', 'k');
xlabel('Frequency (GHz)', 'FontSize', 12, 'FontName', 'Times New Roman');
ylabel('|\Gamma|', 'FontSize', 12, 'FontName', 'Times New Roman');
title('Comparison: Reflection Coefficient (Lossy)', 'FontSize', 14, 'FontWeight', 'bold', 'FontName', 'Times New Roman');
legend('CST Simulation', 'Theoretical (Lossy)', 'Location', 'northeast', 'FontName', 'Times New Roman');
grid on;
xlim([min(f_R_CST)/1e9 max(f_R_CST)/1e9]);
ylim([0 1]);
set(gca, 'FontSize', 11, 'FontName', 'Times New Roman');
%% Comparison Plot for Transmission
figure('Name','CST vs Theoretical (Lossy Transmission)', 'Color', 'w', 'Position', [300 300 800 400]);
plot(f_T_CST/1e9, T_CST, 'r', 'LineWidth', 2);
hold on;
plot(f_T_CST/1e9, T_los_interp, 'b--', 'LineWidth', 2);
xline(72, 'k--', 'LineWidth', 1.5);
text(72.2, 0.05, 'f = 72 GHz', 'FontSize', 11, 'FontName', 'Times New Roman', 'Color', 'k');
xlabel('Frequency (GHz)', 'FontSize', 12, 'FontName', 'Times New Roman');
ylabel('|T|', 'FontSize', 12, 'FontName', 'Times New Roman');
title('Comparison: Transmission Coefficient (Lossy)', 'FontSize', 14, 'FontWeight', 'bold', 'FontName', 'Times New Roman');
legend('CST Simulation', 'Theoretical (Lossy)', 'Location', 'southeast', 'FontName', 'Times New Roman');
grid on;
xlim([min(f_T_CST)/1e9 max(f_T_CST)/1e9]);
ylim([0.8 1]);  % Adjusted to zoom in on 0.8 to 1
set(gca, 'FontSize', 11, 'FontName', 'Times New Roman');
%% Thin Slab Approximation vs Limiting Case
% Define very small thickness
c = 3e8;
lambda_min = c / max(freq); % wavelength at highest frequency
d_thin = lambda_min / 100; % d ≈ 0.1 mm
% Recalculate slab coefficients with thin d
gamma2_lossy_thin = gamma2_lossy; % same gamma, thinner d
eta2_lossy_thin = eta2_lossy;
Gamma12_thin = Gamma12_lossy;
Gamma23_thin = Gamma23_lossy;
T12_thin = T12_lossy;
T23_thin = T23_lossy;
Gamma_Slab_thin = (Gamma12_thin + Gamma23_thin .* exp(-2 .* gamma2_lossy_thin .* d_thin)) ./ ...
    (1 + Gamma12_thin .* Gamma23_thin .* exp(-2 .* gamma2_lossy_thin .* d_thin));
T_Slab_thin = (T12_thin .* T23_thin .* exp(-gamma2_lossy_thin .* d_thin) .* exp(gamma3 .* d_thin)) ./ ...
    (1 + Gamma12_thin .* Gamma23_thin .* exp(-2 .* gamma2_lossy_thin .* d_thin));
%% Plot Thin Slab vs Original Lossy vs Limiting Case
figure('Name','Thin Slab Limit vs Lossy Slab', 'Color', 'w', 'Position', [200 200 1000 500]);
% Transmission
subplot(1,2,1);
plot(freq/1e9, abs(T_Slab_lossy), 'r', 'LineWidth', 2);
hold on;
plot(freq/1e9, abs(T_Slab_thin), 'b--', 'LineWidth', 2);
yline(1, 'k:', 'LineWidth', 1.5);
xlabel('Frequency (GHz)', 'FontSize', 12, 'FontName', 'Times New Roman');
ylabel('|T|', 'FontSize', 12, 'FontName', 'Times New Roman');
title('Transmission Coefficient (Thin Slab Limit)', 'FontSize', 14, 'FontName', 'Times New Roman');
legend('Lossy (d = 1.16mm)', 'Thin Slab', 'T = 1 (limiting)', 'Location', 'southwest');
ylim([0.8 1.02]);
grid on;
set(gca, 'FontSize', 11, 'FontName', 'Times New Roman');
% Reflection
subplot(1,2,2);
plot(freq/1e9, abs(Gamma_Slab_lossy), 'r', 'LineWidth', 2);
hold on;
plot(freq/1e9, abs(Gamma_Slab_thin), 'b--', 'LineWidth', 2);
yline(0, 'k:', 'LineWidth', 1.5);
xlabel('Frequency (GHz)', 'FontSize', 12, 'FontName', 'Times New Roman');
ylabel('|\Gamma|', 'FontSize', 12, 'FontName', 'Times New Roman');
title('Reflection Coefficient (Thin Slab Limit)', 'FontSize', 14, 'FontName', 'Times New Roman');
legend('Lossy (d = 1.16mm)', 'Thin Slab', '\Gamma = 0 (limiting)', 'Location', 'northeast');
ylim([0 0.2]);
grid on;
set(gca, 'FontSize', 11, 'FontName', 'Times New Roman');
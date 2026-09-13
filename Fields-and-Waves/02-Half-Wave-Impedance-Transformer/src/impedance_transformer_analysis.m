% =========================================================================
% Electromagnetic Fields and Waves
% Analysis of a Half-Wavelength Dielectric Impedance Transformer
% =========================================================================
clear; clc; close all;

%% 1. Physical and Dielectric Parameters
f_center = 72e9;                         % Operating Frequency: 72 GHz
BW = 0.30 * f_center;                    % 30% Bandwidth
freq = linspace(f_center - BW/2, f_center + BW/2, 500); % 61.2 GHz to 82.8 GHz
tan_delta = 0.0048;                      % Loss Tangent of PEEK
eps_r = 3.2;                             % Relative Permittivity
d = (3e8 / f_center) / sqrt(eps_r) / 2;  % Exact Slab Thickness (Half-wavelength) [m]

w = 2 * pi * freq;                       % Angular frequency [rad/s]
u0 = 4 * pi * 1e-7;                      % Free space permeability [H/m]
eps_0 = 8.854e-12;                       % Free space permittivity [F/m]

%% 2. Lossless Slab Formulation (sigma = 0)
beta0 = w .* sqrt(eps_0 .* u0);          
eta0 = sqrt(u0 ./ eps_0);                

beta2_ll = w .* sqrt(u0 .* eps_0 .* eps_r);
gamma2_ll = 1i .* beta2_ll;
eta2_ll = sqrt(u0 ./ (eps_0 .* eps_r));

Gamma12_ll = (eta2_ll - eta0) ./ (eta2_ll + eta0);
Gamma23_ll = (eta0 - eta2_ll) ./ (eta0 + eta2_ll);
T12_ll = (2 .* eta2_ll) ./ (eta2_ll + eta0);
T23_ll = (2 .* eta0) ./ (eta0 + eta2_ll);

Gamma_Slab_ll = (Gamma12_ll + (Gamma23_ll .* exp(-2 .* gamma2_ll .* d))) ./ ...
    (1 + Gamma12_ll .* Gamma23_ll .* exp(-2 .* gamma2_ll .* d));
T_Slab_ll = (T12_ll .* T23_ll .* exp(-gamma2_ll .* d) .* exp(1i .* beta0 .* d)) ./ ...
    (1 + Gamma12_ll .* Gamma23_ll .* exp(-2 .* gamma2_ll .* d));

%% 3. Lossy Slab Formulation (sigma > 0)
eps_prime = eps_0 .* eps_r;
sigma = tan_delta .* w .* eps_prime;

gamma2_lossy = sqrt(1i .* w .* u0 .* (1i .* w .* eps_prime + sigma));
eta2_lossy = sqrt((1i .* w .* u0) ./ (1i .* w .* eps_prime + sigma));

Gamma12_lossy = (eta2_lossy - eta0) ./ (eta2_lossy + eta0);
Gamma23_lossy = (eta0 - eta2_lossy) ./ (eta0 + eta2_lossy);
T12_lossy = (2 .* eta2_lossy) ./ (eta2_lossy + eta0);
T23_lossy = (2 .* eta0) ./ (eta0 + eta2_lossy);

Gamma_Slab_lossy = (Gamma12_lossy + (Gamma23_lossy .* exp(-2 .* gamma2_lossy .* d))) ./ ...
    (1 + Gamma12_lossy .* Gamma23_lossy .* exp(-2 .* gamma2_lossy .* d));
T_Slab_lossy = (T12_lossy .* T23_lossy .* exp(-gamma2_lossy .* d) .* exp(1i .* beta0 .* d)) ./ ...
    (1 + Gamma12_lossy .* Gamma23_lossy .* exp(-2 .* gamma2_lossy .* d));

%% 4. Import CST Full-Wave Simulation Data
try
    Ref_Data = readtable('Reflection.txt');
    f_CST = Ref_Data{:,1} * 1e9; 
    Gamma_CST_dB = Ref_Data{:,2};
    
    Trans_Data = readtable('Transmission.txt');
    T_CST_dB = Trans_Data{:,2};
catch
    disp('CST data files not found in the current directory.');
end

%% 5. Thin Slab Limit Approximation 
d_thin = 1e-9; % Approaching zero thickness limit

Gamma_Slab_thin = (Gamma12_lossy + (Gamma23_lossy .* exp(-2 .* gamma2_lossy .* d_thin))) ./ ...
    (1 + Gamma12_lossy .* Gamma23_lossy .* exp(-2 .* gamma2_lossy .* d_thin));
T_Slab_thin = (T12_lossy .* T23_lossy .* exp(-gamma2_lossy .* d_thin) .* exp(1i .* beta0 .* d_thin)) ./ ...
    (1 + Gamma12_lossy .* Gamma23_lossy .* exp(-2 .* gamma2_lossy .* d_thin));

%% 6. Visualizations
% --- Figure 1: Theoretical Lossless & Lossy Coefficients ---
figure('Name', 'Theoretical Coefficients (Lossless vs. Lossy)', 'Position', [100, 100, 800, 600]);

subplot(2,2,1); 
plot(freq/1e9, abs(Gamma_Slab_ll), 'b', 'LineWidth', 1.5); 
title('Reflection Coefficient (Lossless)'); xlabel('Frequency (GHz)'); ylabel('|\Gamma|'); grid on;

subplot(2,2,2); 
plot(freq/1e9, abs(Gamma_Slab_lossy), 'r', 'LineWidth', 1.5); 
title('Reflection Coefficient (Lossy)'); xlabel('Frequency (GHz)'); ylabel('|\Gamma|'); grid on;

subplot(2,2,3); 
plot(freq/1e9, abs(T_Slab_ll), 'b', 'LineWidth', 1.5); 
title('Transmission Coefficient (Lossless)'); xlabel('Frequency (GHz)'); ylabel('|T|'); grid on;

subplot(2,2,4); 
plot(freq/1e9, abs(T_Slab_lossy), 'r', 'LineWidth', 1.5); 
title('Transmission Coefficient (Lossy)'); xlabel('Frequency (GHz)'); ylabel('|T|'); grid on;

% --- Figure 2: MATLAB vs CST Comparison (in dB) ---
if exist('f_CST', 'var')
    figure('Name', 'Analytical vs. CST Full-Wave Simulation', 'Position', [150, 150, 900, 400]);
    Gamma_Theory_dB = 20 * log10(abs(Gamma_Slab_lossy) + eps);
    T_Theory_dB = 20 * log10(abs(T_Slab_lossy) + eps);
    
    % Plot Reflection Comparison
    subplot(1,2,1);
    plot(freq/1e9, Gamma_Theory_dB, 'r-', 'LineWidth', 2); hold on;
    plot(f_CST/1e9, Gamma_CST_dB, 'k--', 'LineWidth', 2);
    title('Reflection Comparison (S_{11})'); xlabel('Frequency (GHz)'); ylabel('|\Gamma| (dB)');
    legend('MATLAB (Theoretical)', 'CST (Simulation)', 'Location', 'SouthEast'); grid on;
    ylim([-80 5]); % Adjust y-axis limits to clearly visualize the resonance dip
    
    % Plot Transmission Comparison
    subplot(1,2,2);
    plot(freq/1e9, T_Theory_dB, 'b-', 'LineWidth', 2); hold on;
    plot(f_CST/1e9, T_CST_dB, 'k--', 'LineWidth', 2);
    title('Transmission Comparison (S_{21})'); xlabel('Frequency (GHz)'); ylabel('|T| (dB)');
    legend('MATLAB (Theoretical)', 'CST (Simulation)', 'Location', 'SouthEast'); grid on;
    ylim([-5 1]);
end

% --- Figure 3: Thin Slab Limit Approximation ---
figure('Name', 'Thin Slab Limit Approximation', 'Position', [200, 200, 900, 400]);

subplot(1,2,1);
plot(freq/1e9, abs(Gamma_Slab_thin), 'm', 'LineWidth', 2);
title('Reflection Coefficient (d \approx 0)'); xlabel('Frequency (GHz)'); ylabel('|\Gamma|'); grid on; 
ylim([-0.1 1.1]);

subplot(1,2,2);
plot(freq/1e9, abs(T_Slab_thin), 'g', 'LineWidth', 2);
title('Transmission Coefficient (d \approx 0)'); xlabel('Frequency (GHz)'); ylabel('|T|'); grid on; 
ylim([-0.1 1.1]);
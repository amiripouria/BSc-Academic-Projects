% =========================================================================
% Electromagnetic Fields and Waves
% Analysis of a Half-Wavelength Dielectric Impedance Transformer
% =========================================================================
clear; clc; close all;

%% 1. Physical and Dielectric Parameters
f_center = 72e9;                         % Operating Frequency: 72 GHz
freq = linspace(50.4e9, 93.6e9, 500);    % Frequency range
tan_delta = 0.0048;                      % Loss Tangent of the dielectric
eps_r = 3.2;                             % Relative Permittivity
d = 1.16e-3;                             % Slab Thickness (Half-wavelength) [m]

w = 2 * pi * freq;                       % Angular frequency [rad/s]
u0 = 4 * pi * 1e-7;                      % Free space permeability [H/m]
eps_0 = 8.854e-12;                       % Free space permittivity [F/m]

%% 2. Lossless Slab Formulation (sigma = 0)
% Region 1 & 3 (Free Space)
beta0 = w .* sqrt(eps_0 .* u0);          % Phase constant [rad/m]
eta0 = sqrt(u0 ./ eps_0);                % Intrinsic impedance

% Region 2 (Dielectric Slab - Lossless)
beta2_ll = w .* sqrt(u0 .* eps_0 .* eps_r);
gamma2_ll = 1i .* beta2_ll;
eta2_ll = sqrt(u0 ./ (eps_0 .* eps_r));

% Interface Coefficients (Lossless)
Gamma12_ll = (eta2_ll - eta0) ./ (eta2_ll + eta0);
Gamma23_ll = (eta0 - eta2_ll) ./ (eta0 + eta2_ll);
T12_ll = (2 .* eta2_ll) ./ (eta2_ll + eta0);
T23_ll = (2 .* eta0) ./ (eta0 + eta2_ll);

% Total Slab Coefficients (Lossless)
Gamma_Slab_ll = (Gamma12_ll + (Gamma23_ll .* exp(-2 .* gamma2_ll .* d))) ./ ...
    (1 + Gamma12_ll .* Gamma23_ll .* exp(-2 .* gamma2_ll .* d));
T_Slab_ll = (T12_ll .* T23_ll .* exp(-gamma2_ll .* d) .* exp(1i .* beta0 .* d)) ./ ...
    (1 + Gamma12_ll .* Gamma23_ll .* exp(-2 .* gamma2_ll .* d));

%% 3. Lossy Slab Formulation (sigma > 0)
eps_prime = eps_0 .* eps_r;
sigma = tan_delta .* w .* eps_prime;

gamma2_lossy = sqrt(1i .* w .* u0 .* (1i .* w .* eps_prime + sigma));
eta2_lossy = sqrt((1i .* w .* u0) ./ (1i .* w .* eps_prime + sigma));

% Interface Coefficients (Lossy)
Gamma12_lossy = (eta2_lossy - eta0) ./ (eta2_lossy + eta0);
Gamma23_lossy = (eta0 - eta2_lossy) ./ (eta0 + eta2_lossy);
T12_lossy = (2 .* eta2_lossy) ./ (eta2_lossy + eta0);
T23_lossy = (2 .* eta0) ./ (eta0 + eta2_lossy);

% Total Slab Coefficients (Lossy)
Gamma_Slab_lossy = (Gamma12_lossy + (Gamma23_lossy .* exp(-2 .* gamma2_lossy .* d))) ./ ...
    (1 + Gamma12_lossy .* Gamma23_lossy .* exp(-2 .* gamma2_lossy .* d));
T_Slab_lossy = (T12_lossy .* T23_lossy .* exp(-gamma2_lossy .* d) .* exp(1i .* beta0 .* d)) ./ ...
    (1 + Gamma12_lossy .* Gamma23_lossy .* exp(-2 .* gamma2_lossy .* d));

%% 4. Import CST Full-Wave Simulation Data
% Assuming Reflection.txt and Transmission.txt are in the same directory
try
    Ref_Data = readtable('Reflection.txt');
    f_CST = Ref_Data{:,1} * 1e9; % Hz
    Gamma_CST = Ref_Data{:,2};
    
    Trans_Data = readtable('Transmission.txt');
    T_CST = Trans_Data{:,2};
    
    % Interpolate theoretical data for direct error comparison
    Gamma_los_interp = interp1(freq, abs(Gamma_Slab_lossy), f_CST, 'linear', 'extrap');
    T_los_interp = interp1(freq, abs(T_Slab_lossy), f_CST, 'linear', 'extrap');
catch
    disp('CST data files not found. Skipping comparison plots.');
end

%% 5. Thin Slab Limit Approximation (Surface Impedance)
c = 3e8;
d_thin = (c / max(freq)) / 100; % d ~ 0.03 mm (electrically very thin)

Gamma_Slab_thin = (Gamma12_lossy + Gamma23_lossy .* exp(-2 .* gamma2_lossy .* d_thin)) ./ ...
    (1 + Gamma12_lossy .* Gamma23_lossy .* exp(-2 .* gamma2_lossy .* d_thin));
T_Slab_thin = (T12_lossy .* T23_lossy .* exp(-gamma2_lossy .* d_thin) .* exp(1i .* beta0 .* d_thin)) ./ ...
    (1 + Gamma12_lossy .* Gamma23_lossy .* exp(-2 .* gamma2_lossy .* d_thin));

%% 6. Visualizations
figure('Name', 'Theoretical Coefficients', 'Position', [100, 100, 900, 600]);
subplot(2,2,1); plot(freq/1e9, abs(T_Slab_ll), 'b', 'LineWidth', 1.5); title('Transmission (Lossless)'); grid on;
subplot(2,2,2); plot(freq/1e9, abs(T_Slab_lossy), 'r', 'LineWidth', 1.5); title('Transmission (Lossy)'); grid on;
subplot(2,2,3); plot(freq/1e9, abs(Gamma_Slab_ll), 'b', 'LineWidth', 1.5); title('Reflection (Lossless)'); grid on;
subplot(2,2,4); plot(freq/1e9, abs(Gamma_Slab_lossy), 'r', 'LineWidth', 1.5); title('Reflection (Lossy)'); grid on;
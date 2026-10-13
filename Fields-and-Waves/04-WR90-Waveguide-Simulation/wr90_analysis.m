% =========================================================================
% Electromagnetic Fields and Waves
% Modal Analysis of WR-90 Rectangular Waveguide
% =========================================================================
clear; clc; close all;

%% 1. Physical Constants and Operating Frequency
c = 3e8;                 % Speed of light in vacuum [m/s]
mu0 = 4 * pi * 1e-7;     % Free space permeability [H/m]
eps0 = 8.854e-12;        % Free space permittivity [F/m]
eta0 = sqrt(mu0 / eps0); % Intrinsic impedance of free space [Ohm]

f_op = 15e9;             % Operating frequency [Hz] (15 GHz)
omega = 2 * pi * f_op;   % Angular frequency [rad/s]
k = omega * sqrt(mu0 * eps0); % Free space wavenumber [rad/m]

%% 2. WR-90 Waveguide Dimensions
a = 0.02286;             % Broad wall dimension (width) [m]
b = 0.01016;             % Narrow wall dimension (height) [m]

%% 3. Modal Analysis Setup (m, n)
modes = [0 1; 1 0; 1 1; 2 0; 2 1];
num_modes = size(modes, 1);

% Preallocate arrays for results
fc_GHz = zeros(num_modes, 1);
beta   = zeros(num_modes, 1);
Z_TE   = zeros(num_modes, 1);
Z_TM   = zeros(num_modes, 1);

%% 4. Computations for Each Mode
fprintf('=======================================================================\n');
fprintf('| Mode  | Cutoff Freq (GHz) | Beta (rad/m) | Z_TE (Ohm) | Z_TM (Ohm) |\n');
fprintf('=======================================================================\n');

for i = 1:num_modes
    m = modes(i, 1);
    n = modes(i, 2);
    
    % Cutoff Wavenumber (kc)
    kc = sqrt((m * pi / a)^2 + (n * pi / b)^2);

    % Cutoff Frequency (fc)
    fc = kc / (2 * pi * sqrt(mu0 * eps0));
    fc_GHz(i) = fc / 1e9;
    
    % Propagation Constant (beta) and Wave Impedances
    if f_op > fc
        beta(i) = sqrt(k^2 - kc^2);
        Z_TE(i) = (k * eta0) / beta(i);
        Z_TM(i) = (beta(i) * eta0) / k;
        
        % Print active modes
        fprintf('| TE%d%d  | %17.3f | %12.2f | %10.2f | %10.2f |\n', ...
            m, n, fc_GHz(i), beta(i), Z_TE(i), Z_TM(i));
    else
        % Mode is cut off (evanescent)
        beta(i) = NaN;
        Z_TE(i) = NaN;
        Z_TM(i) = NaN;
        
        % Print cutoff modes
        fprintf('| TE%d%d  | %17.3f | %12s | %10s | %10s |\n', ...
            m, n, fc_GHz(i), 'Cutoff', '-', '-');
    end
end
fprintf('=======================================================================\n');
fprintf('Note: Dominant mode for WR-90 is TE10.\n');
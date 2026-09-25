% =========================================================================
% Electromagnetic Fields and Waves
% Analytical Modeling of RG-187A/U Coaxial Cable Parameters
% =========================================================================
clear; clc; close all;

%% 1. Operating Parameters & Material Properties
f = 1e9;                 % Operating Frequency [Hz]
omega = 2 * pi * f;      % Angular frequency [rad/s]
mu_0 = 4 * pi * 1e-7;    % Free space permeability [H/m]
eps_0 = 8.854e-12;       % Free space permittivity [F/m]

sigma_c = 5.8e7;         % Conductivity of Copper [S/m]
eps_r = 2.3;             % Relative permittivity of PTFE dielectric
sigma_d = 0;             % Dielectric conductivity (lossless assumption)

%% 2. Cable Geometry (RG-187A/U)
a = 0.0003;              % Inner conductor radius [m]
b = 0.0016;              % Outer conductor inner radius [m]

%% 3. Per-Unit-Length Parameters Calculation
% Skin depth of copper at operating frequency
delta = sqrt(2 / (omega * mu_0 * sigma_c));

% Resistance per unit length [Ohm/m]
R = (1 / (2 * pi * delta * sigma_c)) * (1/a + 1/b);

% Inductance per unit length [H/m]
L = (mu_0 / (2 * pi)) * log(b / a);

% Capacitance per unit length [F/m]
eps = eps_r * eps_0;
C = (2 * pi * eps) / log(b / a);

% Conductance per unit length [S/m]
G = (2 * pi * sigma_d) / log(b / a);

%% 4. Transmission Line Characteristics
% Characteristic Impedance [Ohm]
Z0 = sqrt((R + 1i * omega * L) ./ (G + 1i * omega * C));

% Complex Propagation Constant
gamma = sqrt((R + 1i * omega * L) .* (G + 1i * omega * C));
alpha = real(gamma);     % Attenuation constant [Np/m]
beta = imag(gamma);      % Phase constant [rad/m]

%% 5. Output Results
fprintf('--- RG-187A/U Coaxial Cable Analytical Results ---\n');
fprintf('Per-Unit-Length Parameters:\n');
fprintf('  L = %.2e H/m\n', L);
fprintf('  C = %.2e F/m\n', C);
fprintf('\nTransmission Characteristics:\n');
fprintf('  Characteristic Impedance (Z0) = %.2f Ohm\n', abs(Z0));
fprintf('  Attenuation Constant (alpha) = %.4f Np/m\n', alpha);
fprintf('  Phase Constant (beta) = %.2f rad/m\n', beta);
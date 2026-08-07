% =========================================================================
% Fourier Integral Representation of a Non-Periodic Signal
% =========================================================================

% --- 1. Define Parameters and Domain ---
% We define a fine grid for the frequency domain (w) to ensure a smooth 
% calculation of the integral. The problem asks for -25 <= w <= 25, but 
% since the Fourier integral formula typically integrates over positive w, 
% we will visualize the frequency spectrum A(w) and B(w) over the requested 
% range, and reconstruct the signal x(t).

w_max = 25;           % Maximum frequency for numerical integration
dw = 0.05;            % Frequency step size
w = 0:dw:w_max;       % Frequency vector for integration (positive frequencies)

% Define the time/spatial domain for visualizing the reconstructed signal
x_plot = linspace(-2*pi, 3*pi, 1000);
f_reconstructed = zeros(size(x_plot));

% --- 2. Define the Ideal Signal for Comparison ---
f_ideal = zeros(size(x_plot));
% The signal is cos(x) for 0 < x < pi, and 0 otherwise.
f_ideal((x_plot > 0) & (x_plot < pi)) = cos(x_plot((x_plot > 0) & (x_plot < pi)));

% --- 3. Compute the Fourier Transform (Continuous Spectrum) ---
% Using the analytical results from the derivation (to avoid symbolic math
% overhead in the numerical script).
% A(w) = (1/pi) * int_0^pi (cos(x) * cos(w*x)) dx
% B(w) = (1/pi) * int_0^pi (cos(x) * sin(w*x)) dx

A_w = zeros(size(w));
B_w = zeros(size(w));

for i = 1:length(w)
    omega = w(i);
    % Handle the singularity at omega = 1 (L'Hopital's rule or direct integration)
    if abs(omega - 1) < 1e-6
        A_w(i) = 0;           % int_0^pi cos^2(x) dx = pi/2. So A(1) = (1/pi)*(0) = 0? Wait.
                              % Actually, int_0^pi cos(x)cos(x) dx = pi/2 -> A(1) = 0 (since it's a pulse, wait. Let's use numerical integration to be safe and robust)
    end
    
    % Robust numerical calculation of coefficients for each frequency
    % This mirrors what the integral formulas are doing, but numerically.
    integrand_A = @(x) cos(x) .* cos(omega * x);
    integrand_B = @(x) cos(x) .* sin(omega * x);
    
    A_w(i) = (1/pi) * integral(integrand_A, 0, pi);
    B_w(i) = (1/pi) * integral(integrand_B, 0, pi);
end


% --- 4. Reconstruct the Signal using the Fourier Integral ---
% f(x) = int_0^infty [A(w)cos(wx) + B(w)sin(wx)] dw
% We approximate the infinite integral by summing up to w_max = 25.

for k = 1:length(x_plot)
    x_val = x_plot(k);
    
    % The integrand for the inverse transform at a specific x
    reconstruction_integrand = A_w .* cos(w * x_val) + B_w .* sin(w * x_val);
    
    % Numerical integration over w (using trapezoidal rule)
    f_reconstructed(k) = trapz(w, reconstruction_integrand);
end

% --- 5. Visualization ---
figure('Name', 'Fourier Integral Analysis', 'Position', [100, 100, 900, 600]);

% Subplot 1: The Continuous Frequency Spectrum
subplot(2, 1, 1);
plot(w, A_w, 'b', 'LineWidth', 1.5); hold on;
plot(w, B_w, 'r', 'LineWidth', 1.5);
grid on;
title('Continuous Fourier Coefficients (Frequency Spectrum)', 'FontSize', 12);
xlabel('\omega (rad/s)');
ylabel('Amplitude');
legend('A(\omega)', 'B(\omega)');
xlim([0, w_max]);

% Subplot 2: Signal Reconstruction
subplot(2, 1, 2);
plot(x_plot, f_ideal, 'k--', 'LineWidth', 2, 'DisplayName', 'Ideal Signal f(x)'); hold on;
plot(x_plot, f_reconstructed, 'g', 'LineWidth', 1.5, 'DisplayName', 'Reconstructed via Integral (\omega \in [0, 25])');
grid on;
title('Signal Reconstruction via Fourier Integral', 'FontSize', 12);
xlabel('x');
ylabel('f(x)');
legend('Location', 'northeast');
ylim([-1.5, 1.5]);
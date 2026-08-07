% =========================================================================
% Exponential Fourier Series Approximation of a Square Wave
% =========================================================================

% --- 1. Define Parameters ---
N = 25;                 % Maximum harmonic number (-25 <= n <= 25)
T = 2;                  % Fundamental period
w0 = 2 * pi / T;        % Fundamental angular frequency (w0 = pi)
t = linspace(-1.5, 2.5, 2000); % High-resolution time vector for smooth plotting

% --- 2. Initialize Reconstructed Signal ---
x_reconstructed = zeros(size(t));

% --- 3. Compute Fourier Series Summation ---
for n = -N:N
    % Calculate the Fourier Coefficient (c_n)
    if n == 0
        cn = 0; % DC component is zero for a symmetric zero-mean square wave
    else
        % Derived formula for c_n of the given square wave
        cn = (1 - (-1)^n) / (1i * n * pi);
    end
    
    % Add the n-th harmonic to the summation
    x_reconstructed = x_reconstructed + cn * exp(1i * n * w0 * t);
end

% Since the original signal is purely real, the imaginary parts from the 
% summation of conjugate pairs should cancel out. We take the real() part 
% to eliminate any residual floating-point noise.
x_reconstructed = real(x_reconstructed);

% --- 4. Define the Ideal Square Wave for Comparison (Optional) ---
x_ideal = sign(sin(pi * t)); 
% Adjusting boundaries to match exactly the definition in the problem:
x_ideal(x_ideal == 0) = 1; % Handle the exact zero crossings if needed

% --- 5. Visualization ---
figure('Name', 'Exponential Fourier Series', 'Position', [150, 150, 800, 450]);

% Plot ideal signal as background reference
plot(t, x_ideal, '--k', 'LineWidth', 1, 'Color', [0.7 0.7 0.7]);
hold on;

% Plot the reconstructed signal
plot(t, x_reconstructed, 'b', 'LineWidth', 1.5);
hold off;

% Formatting the plot
grid on;
title(sprintf('Exponential Fourier Series Approximation (N = \\pm %d)', N), 'FontSize', 14);
xlabel('Time (t)', 'FontSize', 12);
ylabel('Amplitude x(t)', 'FontSize', 12);
legend('Ideal Square Wave', 'Fourier Approximation (Gibbs Phenomenon)', 'Location', 'northeast');
ylim([-1.5, 1.5]);
xlim([-1.5, 2.5]);
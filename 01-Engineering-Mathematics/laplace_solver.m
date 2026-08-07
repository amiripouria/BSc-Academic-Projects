% =========================================================================
% Numerical Solution of Laplace's Equation (Finite Difference Method)
% =========================================================================

% 1. Define Domain and Parameters
a = 2; b = 2;           % Outer domain dimensions
x0 = 0.5; y0 = 0.5;     % Inner conductor offset
c = 1; d = 1;           % Inner conductor dimensions
V0 = 100;               % Potential of the inner conductor (Volts)
nx = 101; ny = 101;     % Number of grid points

% Calculate grid spacing
dx = a / (nx - 1);
dy = b / (ny - 1);

% 2. Initialize the Grid
V = zeros(nx, ny);

% Determine grid indices for the inner conductor
x_start = round(x0 / dx) + 1;
x_end = round((x0 + c) / dx) + 1;
y_start = round(y0 / dy) + 1;
y_end = round((y0 + d) / dy) + 1;

% Set the initial boundary condition for the inner conductor
V(x_start:x_end, y_start:y_end) = V0;

% 3. Iterative Numerical Solution (Jacobi Method)
iterative_number = 1000;

% Note: A vectorized approach is used here for professional MATLAB performance
for iter = 1:iterative_number
    % Update potential for all interior points
    V(2:end-1, 2:end-1) = 0.25 * (V(3:end, 2:end-1) + V(1:end-2, 2:end-1) + ...
                                  V(2:end-1, 3:end) + V(2:end-1, 1:end-2));
                                  
    % Re-enforce the fixed potential of the inner conductor
    V(x_start:x_end, y_start:y_end) = V0;
end

% 4. Visualization
X_axis = linspace(0, a, nx);
Y_axis = linspace(0, b, ny);
[X, Y] = meshgrid(X_axis, Y_axis);
V_plot = V'; 

% Figure 1: 2D Contour Plot
figure('Name', '2D Potential Distribution', 'Position', [100, 100, 600, 500]);
contourf(X, Y, V_plot, 20, 'LineColor', 'none');
colormap('parula');
colorbar;
title('2D Equipotential Contours');
xlabel('X-axis'); ylabel('Y-axis');

% Figure 2: 3D Surface Plot
figure('Name', '3D Potential Surface', 'Position', [750, 100, 600, 500]);
surf(X, Y, V_plot, 'EdgeColor', 'none', 'FaceAlpha', 0.8);
colormap('parula');
colorbar;
title('3D Potential Surface');
xlabel('X-axis'); ylabel('Y-axis'); zlabel('Potential (V)');
view(45, 30);

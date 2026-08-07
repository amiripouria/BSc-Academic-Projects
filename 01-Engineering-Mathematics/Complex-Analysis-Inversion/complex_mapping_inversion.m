% =========================================================================
% Complex Analysis: Inversion Mapping w = 1/z
% =========================================================================

% --- 1. Define the Grids for Z-plane and W-plane ---
% We create grids for both planes to visualize the original circle 
% and its transformed image properly.
grid_points = linspace(-10, 10, 600);
[X, Y] = meshgrid(grid_points, grid_points);
[U, V] = meshgrid(grid_points, grid_points);

% Complex variables
Z = X + 1i * Y;
W = U + 1i * V;

% --- 2. Original Circle in Z-plane ---
% Equation: (x + 2)^2 + (y - 2)^2 = 8
Z_circle = (X + 2).^2 + (Y - 2).^2 - 8;

% --- 3. Transformed Image in W-plane ---
% Under the mapping w = 1/z, the inverse is z = 1/w.
% We substitute z = 1/w into the original circle's equation.
Z_from_W = 1 ./ W;
W_image = (real(Z_from_W) + 2).^2 + (imag(Z_from_W) - 2).^2 - 8;

% --- 4. Visualization ---
figure('Name', 'Complex Inversion Mapping', 'Position', [100, 100, 1000, 500]);

% Subplot 1: Original Circle in Z-plane
subplot(1, 2, 1);
contour(X, Y, Z_circle, [0 0], 'b', 'LineWidth', 2);
grid on; axis equal;
title('Z-Plane: Original Circle', 'FontSize', 14);
xlabel('Real(z)'); ylabel('Imaginary(z)');
xlim([-8, 4]); ylim([-4, 8]);
xline(0, 'k-', 'LineWidth', 1); yline(0, 'k-', 'LineWidth', 1);

% Subplot 2: Transformed Shape in W-plane
subplot(1, 2, 2);
contour(U, V, W_image, [0 0], 'r', 'LineWidth', 2);
grid on; axis equal;
title('W-Plane: Transformed Image (w = 1/z)', 'FontSize', 14);
xlabel('Real(w)'); ylabel('Imaginary(w)');
xlim([-2, 2]); ylim([-2, 2]);
xline(0, 'k-', 'LineWidth', 1); yline(0, 'k-', 'LineWidth', 1);
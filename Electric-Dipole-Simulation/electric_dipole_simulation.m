%% Coded by Pouria Amiri (40115973) and Hamidreza Abedini (40120633)

clc; 
clear;
close all;

%% initialization  
k = 8.99e9;
eps_r = 1;
charge_order = 1e-9;
u = k / (4*pi*eps_r); % u hamoon const

%% Grid 
Nx = 101;
Ny = 101;

x = (1:Nx)-51;
y = (1:Ny)-51;
[xMesh, yMesh] = meshgrid(x, y);

%% Electric fields and Voltage Initialization 
E_f = zeros(Ny, Nx);
v = zeros(Ny, Nx);
Ex = zeros(Ny, Nx);
Ey = zeros(Ny, Nx);

%% Computing r, Ex, Ey, V for an electric dipole

% Charge 1
r_1 = sqrt((xMesh - 10).^2 + yMesh.^2);
Ex1 = Ex + u * charge_order * (xMesh - 10) ./ r_1.^3;
Ey1 = Ey + u * charge_order * yMesh ./ r_1.^3;
v1 = u * charge_order ./ r_1;

% Charge 2
r_2 = sqrt((xMesh + 10).^2 + yMesh.^2);
Ex2 = Ex - u * charge_order * (xMesh + 10) ./ r_2.^3;
Ey2 = Ey - u * charge_order * yMesh ./ r_2.^3;
v2 = -u * charge_order ./ r_2;

Ex = Ex1 + Ex2;
Ey = Ey1 + Ey2;
v = v1 + v2;
E_f = sqrt(Ex.^2 + Ey.^2);

E_f_norm = max(sqrt(Ex.^2 + Ey.^2));
Ex_norm = Ex ./ E_f_norm;
Ey_norm = Ey ./ E_f_norm;
E_f2 = sqrt(Ex_norm.^2 + Ey_norm.^2);

%% Plotting 
figure(1); 
quiver(xMesh, yMesh, Ex_norm, Ey_norm);
title('Electric Field');
xlabel('x');
ylabel('y');
axis([-15 15 -15 15])

figure(2);
contour(xMesh, yMesh, E_f2, 10, 'linewidth', 0.5);
title('E-Field Strength Contour');
xlabel('x');
ylabel('y');
axis([-15 15 -15 15])

figure(3);
surf(xMesh, yMesh, v);
title('Electric Potential Surface');
xlabel('x');
ylabel('y');
zlabel('Voltage');
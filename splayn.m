clc; clear; close all;

L1 = 200;
R  = 600;
V  = 28;
t  = 3;
Lc = V*t;
L2 = 250;

N_st  = 200;
N_cl  = 500;
N_arc = 1000;

A0 = sqrt(R*Lc);
alpha = deg2rad(20);
beta  = deg2rad(90);

delta = Lc/(2*R);

xcl  = @(s) s - (s.^5)/(40*A0^4) + (s.^9)/(3456*A0^8);
ycl  = @(s) (s.^3)/(6*A0^2) - (s.^7)/(336*A0^6) + (s.^11)/(42240*A0^10);

rot2 = @(ang) [cos(ang), -sin(ang); sin(ang), cos(ang)];

u1 = linspace(0, L1, N_st);
x1 = u1*cos(alpha);
y1 = u1*sin(alpha);

xA = x1(end);
yA = y1(end);

s = linspace(0, Lc, N_cl);

P2_local = [xcl(s); -ycl(s)];
P2 = rot2(alpha) * P2_local;

x2 = xA + P2(1,:);
y2 = yA + P2(2,:);

xB = x2(end);
yB = y2(end);

psi1 = alpha - delta;

Cx = xB + R*sin(psi1);
Cy = yB - R*cos(psi1);

phi0 = psi1 + pi/2;
th = linspace(0, beta, N_arc);

x3 = Cx + R*cos(phi0 - th);
y3 = Cy + R*sin(phi0 - th);

xD = x3(end);
yD = y3(end);

psi2 = psi1 - beta;

s4 = linspace(0, Lc, N_cl);

u = cos(delta) * (xcl(Lc) - xcl(Lc - s4)) + ...
    sin(delta) * (ycl(Lc) - ycl(Lc - s4));

v = cos(delta) * (ycl(Lc) - ycl(Lc - s4)) - ...
    sin(delta) * (xcl(Lc) - xcl(Lc - s4));

P4 = rot2(psi2) * [u; v];

x4 = xD + P4(1,:);
y4 = yD + P4(2,:);

xE = x4(end);
yE = y4(end);

psi3 = psi2 - delta;

u5 = linspace(0, L2, N_st);
x5 = xE + u5*cos(psi3);
y5 = yE + u5*sin(psi3);

xmin = min([x1 x2 x3 x4 x5]);
ymin = min([y1 y2 y3 y4 y5]);

x1 = x1 - xmin; y1 = y1 - ymin;
x2 = x2 - xmin; y2 = y2 - ymin;
x3 = x3 - xmin; y3 = y3 - ymin;
x4 = x4 - xmin; y4 = y4 - ymin;
x5 = x5 - xmin; y5 = y5 - ymin;

figure('Position',[100 100 1000 700]);
hold on; grid on; axis equal;
xlabel('x'); ylabel('y');
title('Straight -> Clothoid -> Arc -> Clothoid -> Straight');

plot(x1, y1, 'b', 'LineWidth', 2, 'DisplayName','Straight-1');
plot(x2, y2, 'g', 'LineWidth', 2, 'DisplayName','Clothoid-in');
plot(x3, y3, 'r', 'LineWidth', 2, 'DisplayName','Arc');
plot(x4, y4, 'c', 'LineWidth', 2, 'DisplayName','Clothoid-out');
plot(x5, y5, 'm', 'LineWidth', 2, 'DisplayName','Straight-2');

legend;
hold off;

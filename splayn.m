
L1 = 200;
R = 600;
V = 28;
t = 3;
Lc = V * t;
L2 = 250;
N_cl = 500;
N_arc = 1000;
N_st = 200;

A0 = sqrt(R * Lc);

%% ----------------------------
% Քլոթոիդի մոտարկումներ
x_cl = @(s) s - (s.^5)/(40*A0^4) + (s.^9)/(3456*A0^8);
y_cl = @(s) (s.^3)/(6*A0^2) - (s.^7)/(336*A0^6) + (s.^11)/(42240*A0^10);


% straight 1
x_st1 = linspace(0, L1, N_st);
y_st1 = zeros(size(x_st1));

% clothoid 1
s = linspace(0, Lc, N_cl);
x_c1 = x_st1(end) + x_cl(s);
y_c1 = y_st1(end) + y_cl(s);

k_end = 1/R;
a = k_end / Lc;
theta_c1_end = 0.5 * a * Lc^2;

x1_end = x_c1(end);
y1_end = y_c1(end);

% Arc
cx = x1_end - R*sin(theta_c1_end);
cy = y1_end + R*cos(theta_c1_end);

phi0 = theta_c1_end - pi/2;
arc_angle = deg2rad(90);

phi = linspace(phi0, phi0 + arc_angle, N_arc);
x_arc = cx + R*cos(phi);
y_arc = cy + R*sin(phi);

x_arc_end = x_arc(end);
y_arc_end = y_arc(end);
theta_arc_end = phi(end) + pi/2;

% clothoid 2
s2 = linspace(Lc, 0, N_cl);
x_tmp = x_cl(s2);
y_tmp = -y_cl(s2);

x_tmp = x_tmp - x_tmp(1);
y_tmp = y_tmp - y_tmp(1);

dx = x_tmp(2) - x_tmp(1);
dy = y_tmp(2) - y_tmp(1);
theta0 = atan2(dy, dx);

rot = theta_arc_end - theta0;
Rmat = [cos(rot), -sin(rot); sin(rot), cos(rot)];
pts = Rmat * [x_tmp; y_tmp];

x_c2 = pts(1,:) + x_arc_end;
y_c2 = pts(2,:) + y_arc_end;

% straight 2
theta_end_c2 = atan2(y_c2(end)-y_c2(end-1), x_c2(end)-x_c2(end-1));
tvec = linspace(0, L2, N_st);
x_st2 = x_c2(end) + tvec*cos(theta_end_c2);
y_st2 = y_c2(end) + tvec*sin(theta_end_c2);

X_all = [x_st1, x_c1, x_arc, x_c2, x_st2];
Y_all = [y_st1, y_c1, y_arc, y_c2, y_st2];


angle_deg = -20;
angle = deg2rad(angle_deg);
Rm = [cos(angle), -sin(angle); sin(angle), cos(angle)];
pts = Rm * [X_all; Y_all];
X_rot = pts(1,:);
Y_rot = pts(2,:);

Y_rot = -Y_rot;


X_rot = X_rot - min(X_rot);
Y_rot = Y_rot - min(Y_rot);

figure('Position',[100 100 1000 700]);
hold on; grid on; axis equal;
xlabel('x'); ylabel('y');
title('Straight → Clothoid → Arc → Clothoid → Straight');

N1 = N_st;
N2 = N_cl;
N3 = N_arc;
N4 = N_cl;
N5 = N_st;

plot(X_rot(1:N1), Y_rot(1:N1), 'b', 'LineWidth', 2, 'DisplayName','Straight-1');
plot(X_rot(N1+1:N1+N2), Y_rot(N1+1:N1+N2), 'g', 'LineWidth', 2, 'DisplayName','Clothoid-in');
plot(X_rot(N1+N2+1:N1+N2+N3), Y_rot(N1+N2+1:N1+N2+N3), 'r', 'LineWidth', 2, 'DisplayName','Arc');
plot(X_rot(N1+N2+N3+1:N1+N2+N3+N4), Y_rot(N1+N2+N3+1:N1+N2+N3+N4), 'c', 'LineWidth', 2, 'DisplayName','Clothoid-out');
plot(X_rot(end-N5+1:end), Y_rot(end-N5+1:end), 'm', 'LineWidth', 2, 'DisplayName','Straight-2');

legend;
hold off;
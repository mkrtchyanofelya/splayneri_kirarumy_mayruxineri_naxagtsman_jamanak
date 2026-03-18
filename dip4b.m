
k  = 0.2;
R0 = 100;
L  = 400;

R1   = 90;              
phi1 = 13*pi/180;       
phi2 = 20*pi/180;      

x0 = 0;
y0 = 0;
alpha0 = -6*pi/180;     

p = (1-k)/k;


f = @(beta) (L./(k.*beta)) .* (sin(beta)).^p - R0;

Nscan  = 6000;
a_scan = 1e-4;
b_scan = pi/2 - 1e-4;

beta_scan = linspace(a_scan, b_scan, Nscan);
f_scan = arrayfun(f, beta_scan);

idx = 0;
for i = 1:length(f_scan)-1
    if f_scan(i)*f_scan(i+1) < 0
        idx = i;
        break;
    end
end

if idx == 0
    error('beta0-ի իրական լուծում չգտնվեց');
end

a = beta_scan(idx);
b = beta_scan(idx+1);

fa = f(a);
fb = f(b);

if fa*fb > 0
    error('Կիսման մեթոդի համար ճիշտ միջակայք չի գտնվել');
end

tol = 1e-12;
maxIter = 1000;

for iter = 1:maxIter
    c = (a + b)/2;
    fc = f(c);

    if fa*fc < 0
        b = c;
        fb = fc;
    else
        a = c;
        fa = fc;
    end

    if abs(b-a) < tol
        break;
    end
end

beta0 = (a + b)/2;
A0    = L / (k * beta0);

R_check = A0 * (sin(beta0)).^p;
L_check = A0 * k * beta0;

xc1 = x0 - R1*sin(alpha0);
yc1 = y0 + R1*cos(alpha0);

theta1_start = atan2(y0 - yc1, x0 - xc1);

N1 = 900;
theta1 = linspace(theta1_start, theta1_start + phi1, N1);

xA1 = xc1 + R1*cos(theta1);
yA1 = yc1 + R1*sin(theta1);

x1 = xA1(end);
y1 = yA1(end);
alpha1 = alpha0 + phi1;


Nk = 4000;
beta = linspace(0, beta0, Nk);

Fx = cos(beta) .* (sin(beta)).^p;
Fy = sin(beta) .* (sin(beta)).^p;

xK_local = zeros(1, Nk);
yK_local = zeros(1, Nk);

for i = 2:Nk
    db = beta(i) - beta(i-1);

    xK_local(i) = xK_local(i-1) + 0.5*db*(Fx(i-1) + Fx(i));
    yK_local(i) = yK_local(i-1) + 0.5*db*(Fy(i-1) + Fy(i));
end

xK_local = A0 * xK_local;
yK_local = A0 * yK_local;

xK = zeros(1, Nk);
yK = zeros(1, Nk);

for i = 1:Nk
    xK(i) = x1 + xK_local(i)*cos(alpha1) - yK_local(i)*sin(alpha1);
    yK(i) = y1 + xK_local(i)*sin(alpha1) + yK_local(i)*cos(alpha1);
end


x2 = xK(end);
y2 = yK(end);

alpha2 = alpha1 + beta0;

xc2 = x2 - R0*sin(alpha2);
yc2 = y2 + R0*cos(alpha2);

theta2_start = atan2(y2 - yc2, x2 - xc2);

N2 = 1000;
theta2 = linspace(theta2_start, theta2_start + phi2, N2);

xA2 = xc2 + R0*cos(theta2);
yA2 = yc2 + R0*sin(theta2);


figure('Color','w','Position',[100 100 1150 650]);
hold on; grid on; box on; axis equal;

plot(xA1, yA1, 'k', 'LineWidth', 2.5);
plot(xK,  yK,  'b', 'LineWidth', 2.7);
plot(xA2, yA2, 'r', 'LineWidth', 2.5);


xlabel('x', 'FontSize', 12);
ylabel('y', 'FontSize', 12);
title('Աղեղ \rightarrow K-աձև կոր \rightarrow Աղեղ', 'FontSize', 14);

legend('Սկզբնական աղեղ', 'K-աձև կոր', 'Վերջնական աղեղ', ...
       'Location', 'northwest', 'FontSize', 10);



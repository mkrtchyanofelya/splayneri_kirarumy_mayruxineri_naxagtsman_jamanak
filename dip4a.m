
k   = 0.2;              
R0  = 100;             
L   = 400;              
phi = 30*pi/180;        

Ls     = 25;           
alpha0 = 5*pi/180;      

p = (1-k)/k;


f = @(beta) (L./(k.*beta)) .* (sin(beta)).^p - R0;

a_scan = 1e-4;
b_scan = pi/2 - 1e-4;
Nscan  = 6000;

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

    if abs(b - a) < tol
        break;
    end
end

beta0 = (a + b)/2;
A0    = L/(k*beta0);


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

Ns = 300;
s = linspace(0, Ls, Ns);

xS = s*cos(alpha0);
yS = s*sin(alpha0);

x1 = xS(end);
y1 = yS(end);


xK = zeros(1, Nk);
yK = zeros(1, Nk);

for i = 1:Nk
    xK(i) = x1 + xK_local(i)*cos(alpha0) - yK_local(i)*sin(alpha0);
    yK(i) = y1 + xK_local(i)*sin(alpha0) + yK_local(i)*cos(alpha0);
end


x2 = xK(end);
y2 = yK(end);

alpha1 = alpha0 + beta0;    

xc = x2 - R0*sin(alpha1);
yc = y2 + R0*cos(alpha1);

theta_start = atan2(y2 - yc, x2 - xc);

Nc = 1200;
theta = linspace(theta_start, theta_start + phi, Nc);

xC = xc + R0*cos(theta);
yC = yc + R0*sin(theta);


figure('Color','w','Position',[100 100 1100 600]);
hold on; grid on; box on; axis equal;

plot(xS, yS, 'k', 'LineWidth', 2.2);
plot(xK, yK, 'b', 'LineWidth', 2.6);
plot(xC, yC, 'r', 'LineWidth', 2.6);

xlabel('x', 'FontSize', 12);
ylabel('y', 'FontSize', 12);
title('Թեք ուղիղ -> K-աձև կոր -> Աղեղ', 'FontSize', 13);
legend('Ուղիղ', 'K-աձև կոր', 'Աղեղ', 'Location', 'best');

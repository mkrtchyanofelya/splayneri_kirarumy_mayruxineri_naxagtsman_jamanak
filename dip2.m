
x = [4 9 12 16 20];
y = [4 7 3 11 13];

n = numel(x);

h = zeros(1,n-1);
for i = 1:n-1
    h(i) = x(i+1) - x(i);
end

A = zeros(n);
r = zeros(n,1);

A(1,1) = 1;
A(end,end) = 1;

for i = 2:n-1
    A(i,i-1) = h(i-1);
    A(i,i)   = 2*(h(i-1) + h(i));
    A(i,i+1) = h(i);
    r(i) = 6*((y(i+1)-y(i))/h(i) - (y(i)-y(i-1))/h(i-1));
end

M = A\r;

a = zeros(n-1,1);
b = zeros(n-1,1);
c = zeros(n-1,1);
d = zeros(n-1,1);

for i = 1:n-1
    a(i) = y(i);
    c(i) = M(i)/2;
    d(i) = (M(i+1) - M(i)) / (6*h(i));
    b(i) = (y(i+1) - y(i))/h(i) - h(i)*(2*M(i) + M(i+1))/6;
end

tg_alpha = b(1);
tg_beta  = b(end) + 2*c(end)*h(end) + 3*d(end)*h(end)^2;

alpha = atan(tg_alpha);
beta  = atan(tg_beta);

alpha_deg = alpha * 180 / pi;
beta_deg  = beta  * 180 / pi;

fig = figure('Name','Spline Graph','NumberTitle','off','Color','w');
hold on;

for i = 1:n-1
    step = (x(i+1) - x(i)) / 299;
    xx = x(i):step:x(i+1);
    yy = a(i) + b(i)*(xx - x(i)) + c(i)*(xx - x(i)).^2 + d(i)*(xx - x(i)).^3;
    plot(xx, yy, 'LineWidth', 2);
end

step_left = (x(1) - 0) / 199;
x_left = 0:step_left:x(1);
y_left = y(1) + tg_alpha*(x_left - x(1));
plot(x_left, y_left, '--r', 'LineWidth', 2);

step_right = 8 / 199;
x_right = x(end):step_right:(x(end)+8);
y_right = y(end) + tg_beta*(x_right - x(end));
plot(x_right, y_right, '--b', 'LineWidth', 2);

plot(x, y, 'ko', 'MarkerFaceColor','w', 'MarkerSize',8);

grid on;
xlabel('x');
ylabel('y');
title('Cubic Spline');
axis([0 28 0 14]);

hold off;

disp('Matrix A =');
disp(A)

disp('Vector r =');
disp(r)

disp('Vector M =');
disp(M)

disp('h =');
disp(h')

disp('a =');
disp(a)

disp('b =');
disp(b)

disp('c =');
disp(c)

disp('d =');
disp(d)

disp('tan(alpha) =');
disp(tg_alpha)

disp('alpha (degrees) =');
disp(alpha_deg)

disp('tan(beta) =');
disp(tg_beta)

disp('beta (degrees) =');
disp(beta_deg)

clear; clc; close all;

P0 = [0 0];
P1 = [100 20];
P2 = [200 0];

A = [50 15];
B = [80 20];

C = 2*P1 - B;
D = A - 2*B + 2*C;

t = linspace(0,1,800).';
u = 1 - t;

B1 = (u.^3)*P0 + 3*(u.^2).*t*A + 3*u.*(t.^2)*B + (t.^3)*P1;
B2 = (u.^3)*P1 + 3*(u.^2).*t*C + 3*u.*(t.^2)*D + (t.^3)*P2;

fig = figure('Color','w','Units','pixels','Position',[100 100 1000 450]);
ax = axes(fig);
hold(ax,'on'); grid(ax,'on'); box(ax,'on');

h1 = plot(ax, B1(:,1), B1(:,2), 'LineWidth', 3);
h2 = plot(ax, B2(:,1), B2(:,2), 'LineWidth', 3);

plot(ax, [P0(1) A(1) B(1) P1(1)], [P0(2) A(2) B(2) P1(2)], '--', 'LineWidth', 1.2);
plot(ax, [P1(1) C(1) D(1) P2(1)], [P1(2) C(2) D(2) P2(2)], '--', 'LineWidth', 1.2);

scatter(ax, [P0(1) P1(1) P2(1)], [P0(2) P1(2) P2(2)], 90, 'filled');
scatter(ax, [A(1) B(1) C(1) D(1)], [A(2) B(2) C(2) D(2)], 70, 'filled');

xmin = min([P0(1),A(1),B(1),P1(1),C(1),D(1),P2(1)]);
xmax = max([P0(1),A(1),B(1),P1(1),C(1),D(1),P2(1)]);
ymin = min([P0(2),A(2),B(2),P1(2),C(2),D(2),P2(2)]);
ymax = max([P0(2),A(2),B(2),P1(2),C(2),D(2),P2(2)]);

xlim(ax, [xmin-10, xmax+10]);
ylim(ax, [ymin-15, ymax+15]);
axis(ax, 'equal');

ax.FontSize = 12;
ax.LineWidth = 1.0;
xlabel(ax,'x','FontSize',13);
ylabel(ax,'y','FontSize',13);

legend(ax, [h1 h2], {'B_1(t)','B_2(t)'}, ...
    'Location','southoutside','Orientation','horizontal');

labelPoint(ax, P0, 'P_0(0,0)',    [-8 -12]);
labelPoint(ax, A,  'A(50,15)',    [ 6   8]);
labelPoint(ax, B,  'B(80,20)',    [-18 -10]);
labelPoint(ax, P1, 'P_1(100,20)', [ 6  -2]);
labelPoint(ax, C,  'C(120,20)',   [ 6   8]);
labelPoint(ax, D,  'D(130,15)',   [ 6  -12]);
labelPoint(ax, P2, 'P_2(200,0)',  [ 6  -12]);

segments = {
    P0, A, B, P1;
    P1, C, D, P2
};

for i = 1:size(segments,1)
    Q0 = segments{i,1};
    Q1 = segments{i,2};
    Q2 = segments{i,3};
    Q3 = segments{i,4};

    [ax0, ax1, ax2, ax3] = bezierPolyCoeffs(Q0(1), Q1(1), Q2(1), Q3(1));
    [ay0, ay1, ay2, ay3] = bezierPolyCoeffs(Q0(2), Q1(2), Q2(2), Q3(2));

    fprintf('%d) Բեզյեի կոր.\n', i);
    fprintf('x%d(t) = %s\n', i, polyToString(ax0, ax1, ax2, ax3));
    fprintf('y%d(t) = %s\n', i, polyToString(ay0, ay1, ay2, ay3));
    fprintf('B%d(t) = (%s, %s)\n\n', i, ...
        polyToString(ax0, ax1, ax2, ax3), ...
        polyToString(ay0, ay1, ay2, ay3));
end

function [a0,a1,a2,a3] = bezierPolyCoeffs(q0,q1,q2,q3)
    a0 = q0;
    a1 = -3*q0 + 3*q1;
    a2 = 3*q0 - 6*q1 + 3*q2;
    a3 = -q0 + 3*q1 - 3*q2 + q3;
end

function s = polyToString(a0,a1,a2,a3)
    c = [a0 a1 a2 a3];
    p = {'','t','t^2','t^3'};
    idx = c ~= 0;
    if ~any(idx)
        s = '0';
    else
        s = strjoin(arrayfun(@(k) sprintf('%+g%s', c(k), p{k}), find(idx), ...
            'UniformOutput', false), ' ');
        s = regexprep(s, '^\+', '');
    end
end

function labelPoint(ax, P, txt, offset)
    text(ax, P(1)+offset(1), P(2)+offset(2), txt, ...
        'FontSize',12, 'FontWeight','bold', 'Interpreter','tex');
end

clear; clc; close all;

P0 = [0 0];
P1 = [100 20];
P2 = [200 0];

A = [50 15];
B = [80 20];

C = 2*P1 - B;          
D = A - 2*B + 2*C;     

t  = linspace(0,1,800);
B1 = cubicBezier(P0, A, B, P1, t);
B2 = cubicBezier(P1, C, D, P2, t);

fig = figure('Color','w','Units','pixels','Position',[100 100 1000 450]);
ax = axes(fig); hold(ax,'on'); grid(ax,'on'); box(ax,'on');

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

legend(ax, [h1 h2], {'B_1(t)','B_2(t)'}, 'Location','southoutside','Orientation','horizontal');

labelPoint(ax, P0, 'P_0(0,0)',      [-8 -12]);
labelPoint(ax, A,  'A(50,15)',      [ 6   8]);
labelPoint(ax, B,  'B(80,20)',      [-18 -10]);
labelPoint(ax, P1, 'P_1(100,20)',   [ 6  -2]);
labelPoint(ax, C,  'C(120,20)',     [ 6   8]);
labelPoint(ax, D,  'D(130,15)',     [ 6  -12]);
labelPoint(ax, P2, 'P_2(200,0)',    [ 6  -12]);

exportgraphics(fig, 'bezier_highway.pdf', 'ContentType','vector');      
exportgraphics(fig, 'bezier_highway.png', 'Resolution',600);            



function P = cubicBezier(P0, P1, P2, P3, t)
    t = t(:);
    u = 1 - t;
    P = (u.^3)*P0 + 3*(u.^2).*t*P1 + 3*u.*(t.^2)*P2 + (t.^3)*P3;
end

function labelPoint(ax, P, txt, offset)
    % offset in data units: [dx dy]
    text(ax, P(1)+offset(1), P(2)+offset(2), txt, ...
        'FontSize',12, 'FontWeight','bold', 'Interpreter','tex');
end
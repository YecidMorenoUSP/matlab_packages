clc
clearvars

load_my_utils

fig = figure(87538);
fig.Renderer = 'painters';
fig.GraphicsSmoothing = 'on';
fig.Color = 'w';
figRatio = fig.Position(3)/fig.Position(4);

clf

t = linspace(0,10,10*200);
y = [
        rand(1,length(t))*.1-.05;
        sin(2*pi*1.*t);
        cos(2*pi*1.*t);
        (sin(2*pi*1.*t+(pi*3/2))+cos(2*pi*4.*t))/2;
    ];

axM = axes();
axM.Position = [.1 .8 .8 .1];
axM.NextPlot = 'add';
axM.YLim = [-1 1]*1.5;
grid minor
grid on
plot(t,y,'Parent',axM);

% za = ginput(2);
% recZoom = [za(1,1) za(1,2) za(2,1)-za(1,1) za(2,2)-za(1,2) ];

recZoom = [3 -1.5 1 3];
posZoom = [.7 .1 .2 .2*figRatio];
za = ots.zoomAxes(axM,recZoom,posZoom);
ots.ax2norm(axM,[1 3]);
za.posZoom(1) = .1;
za.update()
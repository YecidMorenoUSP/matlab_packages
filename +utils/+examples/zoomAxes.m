clc
clear all

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

recZoom = [3 -1.5 1 3] + [0 0 0 0];

posZoom = [.7 .1 .2 .2*figRatio];

za = utils.zoom.zoomAxes(axM,recZoom,posZoom);

% 
% za2 = zoomAxes(axM,recZoom,posZoom + [.4 0 0 0]);
% 
% za3 = zoomAxes(axM,recZoom,posZoom + [.4 .5 0 0]);
% 
% za4 = zoomAxes(axM,recZoom,posZoom + [.2 .2 0 0]);
% 
% za5 = zoomAxes(axM,recZoom,posZoom + [.0 .5 0 0]);
% za5.title.String = "Hola";
% set(findall(za5.ax,'type','line'),'linewidth',4);
% za5.update();

% za.recZoom = [3 -1.5 1 3];
% za.axImg.Position(1) = .1;
% za.update()
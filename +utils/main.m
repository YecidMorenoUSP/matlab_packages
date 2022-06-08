clc
clear all
% close all

fig = figure(87538);
fig.Renderer = 'painters';
fig.GraphicsSmoothing = 'on';



% fig.Position = [1921          31        1920         973];
% fig.Position = [1921          31        900         900];
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
axM.Position = [.1 .7 .8 .2];
axM.NextPlot = 'add';
axM.YLim = [-1 1]*1.5;
grid minor
grid on
plot(t,y,'Parent',axM);

recZoom = [3 -1.5 1 3] + [0 0 0 0];
posZoom = [.1 .1 .2 .2*figRatio];

ax = copyobj(axM,gcf);
ax.Position = posZoom;
ax.XLim = recZoom(1) + [0 recZoom(3)];
ax.YLim = recZoom(2) + [0 recZoom(4)];
sc = getframe(ax);
delete(ax)

alphaCircle = ones(size(sc.cdata(:,:,1)));
centerCircle = round(size(alphaCircle)/2);
radiusCircle = min(centerCircle);
for i = 1:size(alphaCircle,1)
    for j = 1:size(alphaCircle,2)
        if(((i-centerCircle(1))^2/ radiusCircle^2 + (j-centerCircle(2))^2 /  radiusCircle^2) > 1 )
            alphaCircle(i,j) = 0;
        end
    end
end

axImg = axes();
axImg.Position = posZoom;
img = imagesc(sc.cdata,'Parent',axImg,'AlphaData',alphaCircle);
axImg.Visible = 'off';

delete(findall(gcf,'UserData','circle'))
annotation('ellipse',axImg.Position,'UserData','circle','LineWidth',1);


delete(findall(gcf,'UserData','line1'))

[xy1] = axis2norm(axImg,centerCircle);
[xy2] = axis2norm(axM,recZoom(1:2) + recZoom(3:4)/2);
x1 = xy1(1);y1 = xy1(2);x2 = xy2(1);y2 = xy2(2);
angle = (atan2((y2-y1),(x2-x1)*figRatio));
[xy1] = axis2norm(axImg,centerCircle + [cos(angle) sin(angle)]*radiusCircle);
x1 = xy1(1);y1 = xy1(2);x2 = xy2(1);y2 = xy2(2);

annotation('arrow', [ x1 x2 ], [ y1 y2 ],'UserData','line1')

annotation('textbox',[posZoom(1:2)+[posZoom(3) 0]./2 0 0],'String',"",...
           'UserData','line1','HorizontalAlignment','center','VerticalAlignment','top',...
           'FontSize',14)

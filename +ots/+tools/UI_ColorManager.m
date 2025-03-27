
function UI_ColorManager(varargin)

import ots.*


if nargin == 1
    cm = ots.graphics.ColorManager(varargin{1});
else
    cm = ots.graphics.ColorManager();
end

figName = "UI_ColorManager";
fig = findobj('Type', 'figure', 'Name', figName);

if isempty(fig)
    fig = figure('Name', figName, 'NumberTitle', 'off');
else
    figure(fig); clf(fig); % reutiliza y limpia
end

fig.ToolBar = 'none';

N = numel(cm.Colors);
w = (floor(sqrt(N))+1)+4;

ax = axes('NextPlot','add','YDir','reverse',Parent=fig);
ax.Position = [0 0 1 1];
axis off 
% axis image
drawnow


i = 0;
j = 0;

dxy = [0.05 0.05];



for n = 1:N
    c = cm.Colors(n);

    rec = rectangle("Position",[i+dxy(1),j+dxy(2), 1-dxy(1)*2,0.9-dxy(2)*2  ],"FaceColor",c.HTML,"EdgeColor","none");
    rec.ButtonDownFcn = @(~,~)clipboard("copy",sprintf('cm.getColor("%s");',c.Name));

    % text(i+.5,j+dxy(2),0,c.Name, ...
    %     "VerticalAlignment","bottom", ...
    %     "HorizontalAlignment","center", ...
    %     "FontSize",10)

    drawnow
    
    i = i+1;
 
    
    if mod(i,w) == 0
        i = 0;
        j = j + 1;
    end
    
end

xlim([0 w]);
ylim([0 j+1]);
end
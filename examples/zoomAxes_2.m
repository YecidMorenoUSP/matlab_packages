function zoomAxes_2
    clc
    clearvars
    
    load_my_utils
    
    fig = createFigure();


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
    lines = plot(t,y,'Parent',axM,'DisplayName','Hola');
    names = {'rand' , 'Sin 1','Sin 2','Sin 1+2'};
    for idx = 1:numel(names)
        set(lines(idx),'displayName',names{idx},'UserData',"Line"+idx)
    end

    findall(gcf,'type','line')
    % za = ginput(2);
    % recZoom = [za(1,1) za(1,2) za(2,1)-za(1,1) za(2,2)-za(1,2) ];
    
    recZoom = [3 -1.5 1 3];
    posZoom = [.7 .1 .2 .2];
    za1 = ots.zoomAxes(axM,recZoom ,posZoom - [.5 0 0 0], ...
        'style',@style_1,'shape','circle');

    za2 = ots.zoomAxes(axM,recZoom+ [2 0 0 0],posZoom , ...
        'style',@style_2,'shape','square', ...
        'posLine',[0 1]);

    assignin('base','za1',za1)
    assignin('base','za2',za2)
    assignin('base','fig',fig)
    


function fig = createFigure
    fig = figure(87538);
    fig.Renderer = 'painters';
    fig.GraphicsSmoothing = 'on';
    fig.Color = 'w';

function style_1(ax)
    
    colors = {[255,204,128]/255 
              [255,204,128]/255
              [255,204,128]/255
              [255,204,128]/255};
    
    lines = findall(ax,'type','line');
    
    set(findall(ax,'type','line'),'linewidth',4)
    
    set(lines(1),'linewidth',1)
    drawnow

function style_2(ax)
    set(findall(ax,'type','line'),'color','r')
    set(findall(ax,'type','line'),'linewidth',4)
    set(findall(ax,'UserData','Line1'),'color','b')
    set(findall(ax,'UserData','Line2'),'color','g')
    set(findall(ax,'UserData','Line3'),'color','r')
    set(findall(ax,'UserData','Line4'),'color','y')
    drawnow


classdef zoomAxes
    %ZOMAXES 
    % 
    properties
        sc
        ax
        axM
        img
        fig
        axImg
        shape
        title
        style
        edge
        circle2
        recZoom
        posLine
        posZoom
        posZoomO
        figRatio
        lineArrow
        ajustRatio
        alphaCircle
        centerCircle
        radiusCircle
    end
    
    methods
        function obj = zoomAxes(axM,recZoom,posZoom,varargin)

            defaultShape = 'circle';
            expectedShapes = {'circle','square'};

            defaultAjustRatio = 'on';
            expectedAjustRatio = {'on','off'};
            
            p = inputParser;
            p.addRequired('axM',@(x)isa(x,'matlab.graphics.axis.Axes'));
            p.addRequired('recZoom',@(x)validateattributes(x,{'numeric'},{'numel',4}));
            p.addRequired('posZoom',@(x)validateattributes(x,{'numeric'},{'numel',4}));
            addParameter(p,'shape',defaultShape,...
                           @(x) any(validatestring(x,expectedShapes)));
            addParameter(p,'ajustRatio',defaultAjustRatio,...
                           @(x) any(validatestring(x,expectedAjustRatio)));
            
            addParameter(p,'style',@(ax)[],@(x)true);
            addParameter(p,'posLine',[1,1],@(x)validateattributes(x,{'numeric'},{'numel',2}));

            
            p.parse(axM,recZoom,posZoom,varargin{:});

            obj.axM = p.Results.axM;
            obj.recZoom = p.Results.recZoom;
            obj.shape = p.Results.shape;
            obj.posZoom = p.Results.posZoom;
            obj.style = p.Results.style;
            obj.ajustRatio = p.Results.ajustRatio;
            obj.posLine = p.Results.posLine;


            obj.fig = obj.axM.Parent;
            obj.axImg = axes();
            obj.axImg.Visible = 'off';

            obj.lineArrow = annotation('arrow',[0 .1],[0 .1],'UserData','line1');
            obj.title = annotation('textbox',[0 0 0 0],'String',"",...
                       'UserData','line1','HorizontalAlignment','center','VerticalAlignment','top',...
                       'FontSize',14);
            obj.edge = annotation('ellipse',[0 0 .1 .1],'UserData','circle','LineWidth',1,'tag','edge');           
            obj.circle2 = annotation('ellipse',[0 0 .1 .1]+.1,'UserData','circle2','LineWidth',1);           
            obj.circle2.Visible = 'off';
            obj.edge.Visible = 'off';
            obj.lineArrow.Visible = 'off';
            
            obj = obj.update();
        end
        
        function obj = show(obj)
            
            curFig = gcf;
            
            obj.figRatio = obj.fig.Position(3)/obj.fig.Position(4);
            obj.posZoomO = obj.posZoom;
%             obj.ajustRatio
            if isequal(obj.ajustRatio,'on')
                obj.posZoomO = obj.posZoom.*[1 1 1 obj.figRatio];
            end
            
            obj.ax = copyobj(obj.axM,gcf);
            obj.ax.Position = obj.posZoomO;
            obj.ax.XLim = obj.recZoom(1) + [0 obj.recZoom(3)];
            obj.ax.YLim = obj.recZoom(2) + [0 obj.recZoom(4)];
            obj.style(obj.ax);
            obj.sc = getframe(obj.ax);

%             obj.style(obj.ax)
            drawnow
            set(0,'CurrentFigure',curFig);

            

        end
        
        function obj = drawCircle(obj)

            delete(obj.ax)
            obj.alphaCircle = ones(size(obj.sc.cdata(:,:,1)));
            obj.centerCircle = round(size(obj.alphaCircle)/2);
            obj.radiusCircle = min(obj.centerCircle);
            
            for i = 1:size(obj.alphaCircle,1)
                for j = 1:size(obj.alphaCircle,2)
                    if(((i-obj.centerCircle(1))^2/ obj.radiusCircle^2 + (j-obj.centerCircle(2))^2 /  obj.radiusCircle^2) > 1 )
                        obj.alphaCircle(i,j) = 0;
                    end
                end
            end
            
            obj.axImg.Position = obj.posZoomO;
            obj.img = imagesc(obj.sc.cdata,'Parent',obj.axImg,'AlphaData',obj.alphaCircle);
            obj.axImg.Visible = 'off';
        end

        function obj = drawSquare(obj)
        end

        function obj = update(obj)
            obj = obj.show();
            
             [xy2] = ots.ax2norm(obj.axM,obj.recZoom(1:2) + obj.recZoom(3:4)/2);
             x1 = obj.ax.Position(1) + obj.ax.Position(3)*obj.posLine(1);
             y1 = obj.ax.Position(2) + obj.ax.Position(4)*obj.posLine(2);
             x2 = xy2(1);y2 = xy2(2);
            
            if isequal(obj.shape,'circle')
                obj = obj.drawCircle();
                delete(obj.edge)
                obj.edge = annotation('ellipse',obj.axImg.Position,'UserData','circle','LineWidth',1,'tag','edge');           
                [xy1] = ots.ax2norm(obj.axImg,obj.centerCircle);
                [xy2] = ots.ax2norm(obj.axM,obj.recZoom(1:2) + obj.recZoom(3:4)/2);
                x1 = xy1(1);y1 = xy1(2);x2 = xy2(1);y2 = xy2(2);
                angle = (atan2((y2-y1),(x2-x1)*obj.figRatio));
                [xy1] = ots.ax2norm(obj.axImg,obj.centerCircle + [cos(angle) sin(angle)]*obj.radiusCircle);
                x1 = xy1(1);y1 = xy1(2);x2 = xy2(1);y2 = xy2(2);
                
                [xy12] = ots.ax2norm(obj.axM,obj.recZoom(1:2));
                [xy22] = ots.ax2norm(obj.axM,obj.recZoom(1:2) + obj.recZoom(3:4));

                obj.lineArrow.X = [ x1 x2 ];
                obj.lineArrow.Y = [ y1 y2 ];
            else
                obj = obj.drawSquare();
                delete(obj.edge)
                obj.edge = annotation('rectangle',obj.ax.Position,'UserData','circle','LineWidth',1,'tag','edge');           
                obj.lineArrow.X = [ x1 x2 ];
                obj.lineArrow.Y = [ y1 y2 ];
            end


            obj.edge.Visible = 'on';
            obj.lineArrow.Visible = 'on';
            
%             [xy1] = ots.ax2norm(obj.axImg,obj.centerCircle);
%             [xy2] = ots.ax2norm(obj.axM,obj.recZoom(1:2) + obj.recZoom(3:4)/2);
%             x1 = xy1(1);y1 = xy1(2);x2 = xy2(1);y2 = xy2(2);
%             angle = (atan2((y2-y1),(x2-x1)*obj.figRatio));
%             [xy1] = ots.ax2norm(obj.axImg,obj.centerCircle + [cos(angle) sin(angle)]*obj.radiusCircle);
%             x1 = xy1(1);y1 = xy1(2);x2 = xy2(1);y2 = xy2(2);
%             
%             [xy12] = ots.ax2norm(obj.axM,obj.recZoom(1:2));
%             [xy22] = ots.ax2norm(obj.axM,obj.recZoom(1:2) + obj.recZoom(3:4));
% 
%             obj.lineArrow.X = [ x1 x2 ];
%             obj.lineArrow.Y = [ y1 y2 ];
%             obj.circle.Position = obj.axImg.Position;
%             obj.circle2.Position = [xy12(1) xy12(2) xy22(1)-xy12(1) xy22(2)-xy12(2)];
%             obj.title.Position = [obj.posZoomO(1:2)+[obj.posZoomO(3) 0]./2 0 0];
        end

    end
end


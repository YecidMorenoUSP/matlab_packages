classdef zoomAxes
    %ZOOMAXES Summary of this class goes here
    %   Detailed explanation goes here
    %Yecid Moreno
    %GitHub: yecidmoreno
    properties
        sc
        ax
        axM
        img
        fig
        axImg
        title
        circle
        circle2
        recZoom
        posZoom
        figRatio
        lineArrow
        alphaCircle
        centerCircle
        radiusCircle
    end
    
    methods
        function obj = zoomAxes(axM,recZoom,posZoom)
            obj.axM = axM;
            obj.recZoom = recZoom;
            obj.posZoom = posZoom;

            obj.fig = obj.axM.Parent;
            obj.figRatio = obj.fig.Position(3)/obj.fig.Position(4);

            obj.axImg = axes();

            obj.lineArrow = annotation('arrow',[0 .1],[0 .1],'UserData','line1');
            obj.title = annotation('textbox',[0 0 0 0],'String',"",...
                       'UserData','line1','HorizontalAlignment','center','VerticalAlignment','top',...
                       'FontSize',14);
            obj.circle = annotation('ellipse',[0 0 .1 .1],'UserData','circle','LineWidth',1);           
            obj.circle2 = annotation('ellipse',[0 0 .1 .1]+.1,'UserData','circle2','LineWidth',1);           
%             obj.circle2.Visible = 'off';
            obj.circle.Visible = 'off';
            obj.lineArrow.Visible = 'off';
            
            obj = obj.update();
        end
        
        function obj = draw(obj)
            
            curFig = gcf;
            
            obj.ax = copyobj(obj.axM,gcf);
            obj.ax.Position = obj.posZoom;
            obj.ax.XLim = obj.recZoom(1) + [0 obj.recZoom(3)];
            obj.ax.YLim = obj.recZoom(2) + [0 obj.recZoom(4)];
            obj.circle.Visible = 'off';
            obj.lineArrow.Visible = 'off';
            obj.sc = getframe(obj.ax);
            obj.circle.Visible = 'on';
            obj.lineArrow.Visible = 'on';
            set(findall(obj.ax,'type','line'),'linewidth',4);
            delete(obj.ax)
%             obj.ax.Visible = 'off';

            set(0,'CurrentFigure',curFig);

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
            
            obj.axImg.Position = obj.posZoom;
            obj.img = imagesc(obj.sc.cdata,'Parent',obj.axImg,'AlphaData',obj.alphaCircle);
            obj.axImg.Visible = 'off';
            

        end

        function obj = update(obj)
            obj = obj.draw();

            [xy1] = utils.ax2norm(obj.axImg,obj.centerCircle);
            [xy2] = utils.ax2norm(obj.axM,obj.recZoom(1:2) + obj.recZoom(3:4)/2);
            x1 = xy1(1);y1 = xy1(2);x2 = xy2(1);y2 = xy2(2);
            angle = (atan2((y2-y1),(x2-x1)*obj.figRatio));
            [xy1] = utils.ax2norm(obj.axImg,obj.centerCircle + [cos(angle) sin(angle)]*obj.radiusCircle);
            x1 = xy1(1);y1 = xy1(2);x2 = xy2(1);y2 = xy2(2);
            
            [xy12] = utils.ax2norm(obj.axM,[obj.recZoom(1:2)]);
            [xy22] = utils.ax2norm(obj.axM,[obj.recZoom(1:2) + obj.recZoom(3:4)]);

            obj.lineArrow.X = [ x1 x2 ];
            obj.lineArrow.Y = [ y1 y2 ];
            obj.circle.Position = obj.axImg.Position;
            obj.circle2.Position = [xy12(1) xy12(2) xy22(1)-xy12(1) xy22(2)-xy12(2)];
            obj.title.Position = [obj.posZoom(1:2)+[obj.posZoom(3) 0]./2 0 0];
        end

    end
end


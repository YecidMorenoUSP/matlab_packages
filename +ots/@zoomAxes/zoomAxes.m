classdef zoomAxes
    %ZOOMAXES: Creates a zoomed-in view of an axis with annotations.

    properties
        sc
        ax
        axM
        img
        fig
        axImg
        shape = 'circle'
        title
        style
        edge
        circle2
        recZoom
        posLine = [1,1]
        posZoom
        posZoomO
        figRatio
        lineArrow
        ajustRatio = 'on'
        alphaCircle
        centerCircle
        radiusCircle
        anchor = 'center' % 'center', 'top-left', 'top-right', etc.
    end

    methods
        function obj = zoomAxes(axM, recZoom, posZoom, varargin)
            % Parse inputs
            p = inputParser;
            p.addRequired('axM', @(x) isa(x, 'matlab.graphics.axis.Axes'));
            p.addRequired('recZoom', @(x) isnumeric(x) && numel(x) == 4);
            p.addRequired('posZoom', @(x) isnumeric(x) && numel(x) == 4);
            p.addParameter('shape', 'circle', @(x) any(validatestring(x, {'circle', 'square'})));
            p.addParameter('ajustRatio', 'on', @(x) any(validatestring(x, {'on', 'off'})));
            p.addParameter('style', @(ax) [], @(x) true);
            p.addParameter('posLine', [1, 1], @(x) isnumeric(x) && numel(x) == 2);
            p.addParameter('anchor', 'center', @(x) ischar(x) || isstring(x));
            
            p.parse(axM, recZoom, posZoom, varargin{:});

            % Assign properties
            obj.axM        = p.Results.axM;
            obj.recZoom    = p.Results.recZoom;
            obj.posZoom    = p.Results.posZoom;
            obj.shape      = p.Results.shape;
            obj.ajustRatio = p.Results.ajustRatio;
            obj.style      = p.Results.style;
            obj.posLine    = p.Results.posLine;
            obj.anchor     = p.Results.anchor;

            obj.fig     = obj.axM.Parent;
            obj.axImg   = axes('Visible', 'off');
            obj.lineArrow = annotation('arrow', [0 .1], [0 .1], 'UserData', 'line1','HeadStyle','ellipse', ...
                'HeadLength',2,'HeadWidth',2);
            obj.title     = annotation('textbox', [0 0 0 0], 'String', '', 'UserData', 'line1', ...
                                        'HorizontalAlignment', 'center', 'VerticalAlignment', 'top', 'FontSize', 14);
            obj.edge      = annotation('ellipse', [0 0 .1 .1], 'UserData', 'circle', 'LineWidth', 1, 'Tag', 'edge');
            obj.circle2   = annotation('ellipse', [0 0 .1 .1]+.1, 'UserData', 'circle2', 'LineWidth', 1);

            obj.recZoom = [p.Results.recZoom(1)-p.Results.recZoom(3)/2 p.Results.recZoom(2)-p.Results.recZoom(4)/2  p.Results.recZoom(3) p.Results.recZoom(4)];

            % Set initial visibility
            obj.edge.Visible      = 'off';
            obj.circle2.Visible   = 'off';
            obj.lineArrow.Visible = 'off';

            obj = obj.update();
        end

        function obj = show(obj)
            curFig = gcf;
            obj.figRatio = obj.fig.Position(3) / obj.fig.Position(4);
            obj.posZoomO = obj.posZoom;

            if strcmp(obj.ajustRatio, 'on')
                obj.posZoomO = obj.posZoom .* [1 1 1 obj.figRatio];
            end

            obj.ax = copyobj(obj.axM, gcf);
            obj.ax.Title.String = "";
            obj.ax.Position = obj.posZoomO;
            obj.ax.XLim = obj.recZoom(1) + [0 obj.recZoom(3)];
            obj.ax.YLim = obj.recZoom(2) + [0 obj.recZoom(4)];
            obj.style(obj.ax);
            obj.sc = getframe(obj.ax);
            drawnow;
            set(0, 'CurrentFigure', curFig);
        end

        function obj = drawCircle(obj)
            delete(obj.ax);
            obj.alphaCircle = ones(size(obj.sc.cdata(:,:,1)));
            obj.centerCircle = round(size(obj.alphaCircle) / 2);
            obj.radiusCircle = min(obj.centerCircle);

            for i = 1:size(obj.alphaCircle,1)
                for j = 1:size(obj.alphaCircle,2)
                    if (((i - obj.centerCircle(1))^2 / obj.radiusCircle^2) + ...
                        ((j - obj.centerCircle(2))^2 / obj.radiusCircle^2)) > 1
                        obj.alphaCircle(i,j) = 0;
                    end
                end
            end

            obj.axImg.Position = obj.posZoomO;
            obj.img = imagesc(obj.sc.cdata, 'Parent', obj.axImg, 'AlphaData', obj.alphaCircle);
            obj.axImg.Visible = 'off';
        end

        function obj = drawSquare(obj)
            % Placeholder for square drawing logic
        end

        function anchorPos = computeAnchor(obj)
            % Compute the anchor point in normalized units based on obj.anchor
            pos = obj.ax.Position;
            switch lower(obj.anchor)
                case 'center'
                    anchorPos = [pos(1) + pos(3)/2, pos(2) + pos(4)/2];
                case 'top-left'
                    anchorPos = [pos(1), pos(2) + pos(4)];
                case 'top-right'
                    anchorPos = [pos(1) + pos(3), pos(2) + pos(4)];
                case 'bottom-left'
                    anchorPos = [pos(1), pos(2)];
                case 'bottom-right'
                    anchorPos = [pos(1) + pos(3), pos(2)];
                otherwise
                    anchorPos = [pos(1) + pos(3)/2, pos(2) + pos(4)/2];
            end
        end

        function obj = update(obj)
            obj = obj.show();

            [xy2] = ots.ax2norm(obj.axM, obj.recZoom(1:2) + obj.recZoom(3:4)/2);
            anchor = obj.computeAnchor();
            x1 = anchor(1);
            y1 = anchor(2);
            x2 = xy2(1);
            y2 = xy2(2);

            if strcmp(obj.shape, 'circle')
                obj = obj.drawCircle();
                delete(obj.edge);
                obj.edge = annotation('ellipse', obj.axImg.Position, 'UserData', 'circle', 'LineWidth', 1, 'Tag', 'edge');

                [xy1] = ots.ax2norm(obj.axImg, obj.centerCircle);
                angle = atan2((y2 - xy1(2)), (x2 - xy1(1)) * obj.figRatio);
                [xy1] = ots.ax2norm(obj.axImg, obj.centerCircle - [-cos(angle), sin(angle)] * obj.radiusCircle);
                x1 = xy1(1); y1 = xy1(2);

                obj.lineArrow.X = [x1 x2];
                obj.lineArrow.Y = [y1 y2];
            else
                obj = obj.drawSquare();
                delete(obj.edge);
                obj.edge = annotation('rectangle', obj.ax.Position, 'UserData', 'circle', 'LineWidth', 1, 'Tag', 'edge');
                obj.lineArrow.X = [x1 x2];
                obj.lineArrow.Y = [y1 y2];
            end
            uistack(obj.lineArrow, 'bottom');
            obj.edge.Visible = 'on';
            obj.lineArrow.Visible = 'on';
        end
    end
end
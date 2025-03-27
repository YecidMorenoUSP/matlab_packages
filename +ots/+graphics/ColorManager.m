classdef ColorManager < handle
    properties
        Colors = struct('Name', {}, 'HTML', {}, 'RGB', {}, 'RGBA', {});
    end

    methods
        function obj = ColorManager(varargin)
            
            if(nargin == 1)
                fileName = varargin{1};
            else
                fileName = 'ColorManager.mat';
            end
            
            obj.loadFile(fileName);
        end

        function obj = addColor(obj, name, html)

            rgb = sscanf(char(extractAfter(html, 1)), '%2x%2x%2x', [1 3]) / 255;
            rgba = [rgb, 1];

                
            idx = find(strcmpi(cellstr({obj.Colors.Name}), name), 1);
            if isempty(idx)
                idx = numel(obj.Colors)+1;
            end
            obj.Colors(idx) = struct('Name', name, 'HTML', html, 'RGB', rgb, 'RGBA', rgba);
        end

        function color = getColor(obj, name)
            idx = find(strcmpi(cellstr({obj.Colors.Name}), name), 1);
            if isempty(idx)
                color = [];
            else
                color = obj.Colors(idx);
            end
        end

        function saveToFile(obj,varargin)

            if(nargin == 2)
                fileName = varargin{1};
            else
                fileName = 'ColorManager.mat';
            end

            Colors = obj.Colors;
            save(fileName, 'Colors');
        end

        function loadFile(obj,fileName)
                try
                data = load(fileName);
                catch
                    return
                end
                if isfield(data, 'Colors')
                    for c = data.Colors
                        obj = obj.addColor(c.Name,c.HTML);
                    end
                end
            
        end
    end
end


function test_varing(ax,recZoom,posZoom,varargin)
%TEST_VARING Summary of this function goes here
%   Detailed explanation goes here
% out = struct(varargin{:});
% assert(isa(ax,'matlab.graphics.axis.Axes'),'Product is not type Axes.')
% validateattributes(recZoom,{'numeric'},{'numel',4})
% validateattributes(posZoom,{'numeric'},{'numel',4})

defaultShape = 'circle';
expectedShapes = {'circle','square'};

p = inputParser;
p.addRequired('ax',@(x)isa(x,'matlab.graphics.axis.Axes'));
p.addRequired('recZoom',@(x)validateattributes(x,{'numeric'},{'numel',4}));
p.addRequired('posZoom',@(x)validateattributes(x,{'numeric'},{'numel',4}));
addParameter(p,'shape',defaultShape,...
               @(x) any(validatestring(x,expectedShapes)));

p.parse(ax,recZoom,posZoom,varargin{:});

p.Results

if nargin>=3
    
end

end


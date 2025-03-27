% figSize = [21.59 27.94].*[1 1];

function setFigSize(fig, figSize)
    set(fig, 'Units', 'centimeters');
    fig.Position(3:4) = figSize;
    pause(.1)
    set(fig, 'PaperUnits', 'centimeters', 'PaperSize', figSize, ...
             'PaperPosition', [0 0 figSize]);
    drawnow

end
% https://www.materialpalette.com/colors

clc
clearvars
 
import ots.*
cm = ots.graphics.ColorManager();

data = jsondecode(fileread('scripts/colors.json'));

names = fieldnames(data)';

for name = names
    
    tints = fieldnames(data.(name{1}))';
    for tint = tints
        data.(name{1}).(tint{1});
        fullname = sprintf("%s_%s",name{1},tint{1});
        code = data.(name{1}).(tint{1});
        cm.addColor(fullname, code);

    end

end

cm.saveToFile("ColorManager.mat")
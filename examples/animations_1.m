function animations_1
    clc
    close(gcf)
    fig = gcf;

    load_my_utils
    
    axis off
    t = linspace(0.1,.9,5);
    txt_obj(9) = text;
    t_obj = [];
    colors = {'r','g','b'};
    style = {'FontUnits','normalized','FontSize',.05,'HorizontalAlignment','center'};
    
    
%     for i = 1:3
%         for j = 1:3
%             txt_obj((i-1)*3+j) = text(i/4 , j/4,sprintf('txt(%d,%d)',i,j),style{:});
%             
%             if i == 1
%                 t_obj   = [ t_obj ots.animations.typing(txt_obj((i-1)*3+j) , (i+1)*.2  , true,'')];
%             end
% 
%             if i == 2
%                 t_obj   = [ t_obj ots.animations.blink(txt_obj((i-1)*3+j) ,colors , (i+1)*.5  , true)];
%             end
%             if i == 3
%                 t_obj   = [ t_obj ots.animations.size(txt_obj((i-1)*3+j),@(x)(sin(x/10)+1)*.1*.5 , (i+1)/20  , true)];
%             end
%         end
%     end

    

    for i = linspace(0.1,.9,5)
        txt_obj = [ txt_obj text(.1 , i,['Hola ' num2str(i)],'HorizontalAlignment','center',style{:})];
        t_obj   = [ t_obj ots.animations.typing(txt_obj(end) , (i+1)*.2  , true,'')];
    end

    for i = linspace(0.1,.9,5)
        txt_obj = [ txt_obj text(.5 , i,['Hola' num2str(i)],'HorizontalAlignment','center',style{:})];
        t_obj   = [ t_obj ots.animations.blink(txt_obj(end),colors , (i+1)*.5  , true)];
    end

    for i = linspace(0.1,.9,5)
        txt_obj = [ txt_obj text(.9 , i,['Hola' num2str(i)],'HorizontalAlignment','center',style{:})];
        t_obj   = [ t_obj ots.animations.size(txt_obj(end),@(x)(sin(x/10)+1)*.1*.5 , (i+1)/20  , true)];
    end
    
    fig.CloseRequestFcn = @closeFnc;
     
    function closeFnc(~,~)
        try
            stop(t_obj)
            delete(t_obj)
        catch
        end
        delete(timerfind)
        closereq        
    end
end
function t = typing(control,varargin)
    counter = 1;
    init = false;
    time = 1;
    cursor = '|';
    
    if nargin>=2
        time = varargin{1};
    end
    if nargin>=3
        init = varargin{2};
    end
    if nargin>=4
        cursor = varargin{3};
    end
    
    txt = [' ' get(control,'String')];
    len = length(txt);
    t = timer("TimerFcn",{@run,control},'Period',time,'ExecutionMode','fixedRate');
    if(init)
        t.start()
    end

    function run(~,~,control)
        txt_show = txt( 1 : (mod(counter,len)+1) );
        if mod(counter,2) == 0
            txt_show = [txt_show cursor];
        end
        set(control,'String',txt_show)
        counter = counter + 1;
    end

end
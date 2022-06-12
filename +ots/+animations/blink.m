function t = blink(control,colors,varargin)
    counter = 1;
    init = false;
    time = 1;
    len = numel(colors);
    if nargin>=1
        time = varargin{1};
    end
    if nargin>=2
        init = varargin{1};
    end
    
    t = timer("TimerFcn",{@run,control},'Period',time,'ExecutionMode','fixedRate');
    if(init)
        t.start()
    end
    
    function run(~,~,control)
        c = colors{mod(counter,len)+1};
        set(control,'Color',c)
        counter = counter + 1;
    end

end
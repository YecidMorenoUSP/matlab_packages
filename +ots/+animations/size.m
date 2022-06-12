function t = size(control,fnc,varargin)
    counter = 1;
    init = false;
    time = 1;
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
        set(control,'FontSize',fnc(counter))
        counter = counter + 1;
    end

end
classdef Heat
    %HEAT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        cond_ref
        cap_ref
    end
    
    methods
        function obj = Elec(options)
            arguments
                options.cond_ref double
                options.cap_ref double
            end
            obj.cond_ref = options.cond_ref;
            obj.cap_ref = options.cap_ref;
        end
        
        function cond = cond(obj,T)
            n= size(T,1); m = size(T,2);
            cond = obj.cond_ref * ones(n,m);
        end

        function cap = cap(obj,T)
            n= size(T,1); m = size(T,2);
            cap = obj.cap_ref * ones(n,m);
        end
    end
end


classdef Geom
    %GEOM Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        g
        p
        e
        t
        b
    end
    
    methods
        function obj = Geom(file,h_max)
            %read file
            data = readmatrix(file);
            assert(size(data,1) > 0);
            assert(size(data,2) == 4);
            mask = any(isnan(data), 2).';
            starts = strfind([1,mask], [1,0]);
            ends = strfind([mask,1],[0,1]);
            loops = arrayfun(@(s,e)data(s:e,:), starts, ends, 'UniformOutput',0);
            assert(~isempty(loops));
            n = sum(cellfun(@(l)size(l,1), loops));
            obj.g = zeros(10,n);
            obj.b = zeros(1,n);
            i = 1;
            for loop = loops
                l = loop{1};
                inc = size(l,1);
                r = l(:,3); %radius
                obj.g(1,i:i+inc-1) = (r == 0) + 1;
                cw = r >= 0;
                ccw = r < 0;
                s_x = l(:,1);%start_x
                e_x = circshift(l(:,1),-1);%end_x
                s_y = l(:,2);%start_y
                e_y = circshift(l(:,2),-1);%end_y
                obj.g(2,i:i+inc-1) = ccw.*s_x + cw.*e_x;
                obj.g(3,i:i+inc-1) = ccw.*e_x + cw.*s_x;
                obj.g(4,i:i+inc-1) = ccw.*s_y + cw.*e_y;
                obj.g(5,i:i+inc-1) = ccw.*e_y + cw.*s_y;
                obj.g(6,i:i+inc-1) = ccw;%seg_L
                obj.g(7,i:i+inc-1) = cw;%seg_R
            
                d_y = (e_x-s_x)/2;
                d_x = (s_y-e_y)/2;
                d2 = d_x.*d_x + d_y.*d_y;
                k = sign(-r) .* sqrt(max(r.*r./d2,1)-1);
                
                c_x = (s_x+e_x)/2 + k.*d_x;%center_x
                c_x(r == 0) = 0;
                obj.g(8,i:i+inc-1) = c_x;
            
                c_y = (s_y+e_y)/2 + k.*d_y;%center_y
                c_y(r == 0) = 0;
                obj.g(9,i:i+inc-1) = c_y;
               
                obj.g(10,i:i+inc-1) = abs(r);%radius
            
                obj.b(i:i+inc-1) = l(:,4);
            
                i = i + inc;
            end

            % mesh
            [obj.p,obj.e,obj.t] = initmesh(obj.g,"Hmax",h_max);
        end
        
        function obj = refine(obj)
            %geom.refine()
            %   Detailed explanation goes here
            [obj.p,obj.e,obj.t] = refinemesh(obj.g,obj.p,obj.e,obj.t);
        end

        function plot_geometry(obj)
            pdegplot(obj.g,'FaceLabels','on','EdgeLabels','on');
            pause
        end

        function plot_mesh(obj)
            pdemesh(obj.p,obj.e,obj.t);
            pause
        end
        
        function plot_pw(obj,f)
            assert(size(f,2)==1);
            pdeplot(obj.p,obj.e,obj.t,'XYData',f,'ZData',f,'ColorMap','jet'); %,'Mesh','on'
            grid on; title('uh'); asp = daspect; asp(1:2) = mean(asp(1:2)); daspect(asp);
            pause
        end

        function plot_ew(obj,f)
            assert(size(f,1)==1);
            pdeplot(obj.p,obj.e,obj.t,'XYData',f,'XYStyle','flat','ZData',f,'ZStyle','discontinuous','ColorMap','jet');
            grid on; title('dp'); asp = daspect; asp(1:2) = mean(asp(1:2)); daspect(asp);
            pause
        end
    end
end


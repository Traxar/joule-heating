classdef Heat
    %HEAT Summary of this class goes here
    %   Detailed explanation goes here
    properties (Constant)
        stefan_boltzmann = 5.670*10^-8; %for radiation
        Celsius = 273.15
        T_ref = 20 + Celsius
    end
    properties
        cond_ref %conductivity
        capa_ref %capacity
        capa_alpha %capacity 1st order temperature dependence
        capa_beta %capacity 2nd order temperature dependence
        emis_ref %emissivity
        conv_ref %convection

    end
    
    methods
        function obj = Heat(options)
            arguments
                options.cond_ref double
                options.capa_ref double
                options.capa_alpha double
                options.capa_beta double
                options.emis_ref double
                options.conv_ref double
            end
            obj.cond_ref = options.cond_ref;
            obj.capa_ref = options.capa_ref;
            obj.capa_alpha = options.capa_alpha;
            obj.capa_beta = options.capa_beta;
            obj.emis_ref = options.emis_ref;
            obj.conv_ref = options.conv_ref;
        end
        
        function cond = cond(obj,T)
            cond = obj.cond_ref * ones(size(T));
        end

        function capa = capa(obj,T)
            Tdiff = T-obj.T_ref;
            capa = capaTref*(1+Tdiff.*(obj.capa_alpha+obj.capa_beta*Tdiff));
        end

        function [emis, demis] = emis(obj,T)
            emis = obj.emis_ref * ones(size(T));
            demis= zeros(size(T));
        end

        function [conv, dconv] = conv(obj,T)
            conv = obj.conv_ref * ones(size(T));
            dconv = zeros(size(T));
        end

        function [cool, dcool] = cool(obj,T,T_env,emis_env)
            [conv, dconv] = obj.conv(T);
            [emis, demis] = obj.conv(T);
            
            t = T-T_env;
            c = conv.*t;
            e = 1./((1./emis)+(1./emis_env)-1);
            d4 = T.^4-T_env.^4;
            r = obj.stefan_boltzmann*e.*d4;
            cool = c + r;

            dc = dconv.*t + conv;
            de = demis.*(e./emis).^2;
            dr = obj.stefan_boltzmann*(de.*d4 + 4*e.*T.^3);
            dcool = dc + dr;
        end

    end
end


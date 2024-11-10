classdef Elec
    %ELEC Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        T_ref
        rho_ref
        rho_alpha
        rho_beta
    end
    
    methods
        function obj = Elec(options)
            arguments
                options.rho20 double
                options.alpha double
                options.beta double
            end
            obj.T_ref = 20;
            obj.rho_ref = options.rho20;
            obj.rho_alpha = options.alpha;
            obj.rho_beta = options.beta;
        end
        
        function rho = rho(obj,T)
            n= size(T,1); m = size(T,2);
            rhoTref=obj.rho_ref*ones(n,m);
            Tref=obj.T_ref*ones(n,m);
            alpha=obj.rho_alpha*ones(n,m);
            beta=obj.rho_beta*ones(n,m);
            Tdiff = T-Tref;
            rho = rhoTref.*(1+Tdiff.*(alpha+beta.*Tdiff));
        end

        function T = T(obj,rho,rho_ref)
            assert(isscalar(rho))
            assert(isscalar(rho_ref))
            r = rho/rho_ref;
            if obj.rho_beta==0
                assert(obj.rho_alpha~=0);
                T = obj.T_ref+(r-1)/obj.rho_alpha;
            else
                d = obj.rho_alpha*obj.rho_alpha - 4*obj.rho_beta*(1-r);
                d = max(d,0);%in case of numerical errors
                s = sign(obj.rho_alpha);
                if s==0
                    s = sign(obj.rho_beta);
                end
                T = obj.T_ref+(-obj.rho_alpha+s*sqrt(d))/(2*obj.rho_beta);
            end
        end

        function [R,phi,loss] = calc(elec,geom,Dx,Dy,ut)            
            % conductivity
            cond = 1./elec.rho(ut);
            
            % potential
            pen = 1E10;%penalisation of dirichlet bound
            [K,~,F] = myassema(geom.p,geom.t,cond,0,0);
            e0 = geom.b(geom.e(5,:))==0;
            e2 = geom.b(geom.e(5,:))==2; 
            [R0,G0] = myassemr(geom.p,geom.e(:,e0),pen,0);
            [R2,G2] = myassemr(geom.p,geom.e(:,e2),pen,pen*1);%1V test voltage
            
            A = K+R0+R2;
            b = F+G0+G2;
            
            phi = A\b;
            
            % resistance
            P = phi'*K*phi; %P=U*I=U^2/R
            R = 1/P;
            
            % losses
            dx = (Dx * phi)';
            dy = (Dy * phi)';
            loss = cond.*(dx.*dx + dy.*dy);
        end
    end
end


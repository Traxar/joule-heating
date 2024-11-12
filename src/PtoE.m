classdef PtoE
    %PTOE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        dx
        dy
        avg
        a
    end
    
    methods
        function obj = PtoE(geom)
            % [DX, DY, A]=myassema_tb(p,t)
            % assemble matrices for taking derivatives
            % input:  p ... 2 x np array with point coordinates
            %         t ... 4 x nt array with element info
            % output: Dx ... np x nt x component of derivation
            %         Dy ... np x nt y component of derivation
            %         DA ... 1 x nt area of triangle
            %         PE ... np x nt pointwise function to element wise
            
            np=size(geom.p,2); nt=size(geom.t,2);
            
            % unify coefficients
            elDx=zeros(3,nt); elDy=zeros(3,nt); obj.a=zeros(1,nt);
            for k=1:nt % loop over elements
                t1=geom.t(1,k);  t2=geom.t(2,k);  t3=geom.t(3,k); 
                p1=geom.p(:,t1); p2=geom.p(:,t2); p3=geom.p(:,t3);
                B=[p2-p1,p3-p1]; iBt=inv(B)'; Ak=0.5*abs(det(B));
                dphih=[-1,1,0; -1,0,1]; dphi=iBt*dphih;
                % derivatives
                elDx(:,k) = dphi(1,:);
                elDy(:,k) = dphi(2,:);
                % area
                obj.a(k)=Ak;
            end
            
            % now assemble at once
            t1=geom.t(1,:); t2=geom.t(2,:); t3=geom.t(3,:);
            ii=[1:nt;1:nt;1:nt]; 
            jj=[t1;t2;t3];
            %
            obj.dx=sparse(ii(:),jj(:),elDx(:),nt,np)';
            obj.dy=sparse(ii(:),jj(:),elDy(:),nt,np)';
            obj.avg=sparse(ii(:),jj(:),1/3,nt,np)';
        end
    end
end


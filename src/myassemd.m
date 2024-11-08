function [Dx, Dy, DA, PE]=myassemd(p,t)
% [DX, DY, A]=myassema_tb(p,t)
% assemble matrices for taking derivatives
% input:  p ... 2 x np array with point coordinates
%         t ... 4 x nt array with element info
% output: Dx ... nt x np x component of derivation
%         Dy ... nt x np y component of derivation
%         DA ... 1 x nt area of triangle
%         PE ... nt x np pointwise function to element wise

np=size(p,2); nt=size(t,2);

% unify coefficients
elDx=zeros(3,nt); elDy=zeros(3,nt); DA=zeros(1,nt);
for k=1:nt % loop over elements
    t1=t(1,k);  t2=t(2,k);  t3=t(3,k); 
    p1=p(:,t1); p2=p(:,t2); p3=p(:,t3);
    B=[p2-p1,p3-p1]; iBt=inv(B)'; Ak=0.5*abs(det(B));
    dphih=[-1,1,0; -1,0,1]; dphi=iBt*dphih;
    % derivatives
    elDx(:,k) = dphi(1,:);
    elDy(:,k) = dphi(2,:);
    % area
    DA(k)=Ak;
end

% now assemble at once
t1=t(1,:); t2=t(2,:); t3=t(3,:);
ii=[1:nt;1:nt;1:nt]; 
jj=[t1;t2;t3]; 
%
Dx=sparse(ii(:),jj(:),elDx(:),nt,np);
Dy=sparse(ii(:),jj(:),elDy(:),nt,np);
PE=sparse(ii(:),jj(:),1/3,nt,np);


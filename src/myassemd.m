function [DX, DY, A]=myassemd(p,t)
% [DX, DY, A]=myassema_tb(p,t)
% assemble matrices for taking derivatives
% input:  p ... 2 x np array with point coordinates
%         t ... 4 x nt array with element info
% output: DX ... nt x np x component of derivation
%         DY ... nt x np y component of derivation
%         A ... nt area of triangle
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

np=size(p,2); nt=size(t,2);

% unify coefficients
%
elDX=zeros(3,nt); elDY=zeros(3,nt); A=zeros(nt,1);
for k=1:nt % loop over elements
    t1=t(1,k);  t2=t(2,k);  t3=t(3,k); 
    p1=p(:,t1); p2=p(:,t2); p3=p(:,t3);
    B=[p2-p1,p3-p1]; iBt=inv(B)'; Ak=0.5*abs(det(B));
    dphih=[-1,1,0; -1,0,1]; dphi=iBt*dphih;
    %
    % area
    A(k)=Ak;
    %
    % derivatives
    elDX(:,k) = dphi(1,:);
    elDY(:,k) = dphi(2,:);
end

% now assemble at once
t1=t(1,:); t2=t(2,:); t3=t(3,:);
ii=[1:nt;1:nt;1:nt]; 
jj=[t1;t2;t3]; 
%
DX=sparse(ii(:),jj(:),elDX(:),nt,np);
DY=sparse(ii(:),jj(:),elDY(:),nt,np);


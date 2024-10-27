function [K,M,F]=myassema(p,t,a,c,f)
% [K,M,F]=myassema_tb(p,t,a,c,f)
% assemble finite element matrices
% input:  p ... 2 x np array with point coordinates
%         t ... 4 x nt array with element info
%         a ... 4 x nt array with coefficients
%         c ... 1 x nt array with coefficients
%         f ... 1 x nt array with coefficients
% output: K ... np x np sparse stiffness matrix 
%         M ... np x np sparse mass matrix 
%         F ... np x np sparse load vector
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

np=size(p,2); nt=size(t,2);

% unify coefficients
if length(a)==1, a=a*ones(1,nt); end
if size(a,1)==4 && size(a,2)==1, a=a*ones(1,nt); end
if size(a,1)==1, a=[a;0*a;0*a;a]; end
%
if length(c)==1, c=c*ones(1,nt); end
if length(f)==1, f=f*ones(1,nt); end
%
elK=zeros(9,nt); elM=zeros(9,nt); elF=zeros(3,nt);
for k=1:nt % loop over elements
    t1=t(1,k);  t2=t(2,k);  t3=t(3,k); 
    p1=p(:,t1); p2=p(:,t2); p3=p(:,t3);
    B=[p2-p1,p3-p1]; iBt=inv(B)'; Jk=abs(det(B));
    %
    % stiffness
    dphih=[-1,1,0; -1,0,1]; dphi=iBt*dphih;
    ah=reshape(a(:,k),2,2);
    elmat=dphi'*(ah*dphi)*Jk*0.5;
    elK(:,k)=elmat(:);
    %
    % mass matrix
    elmat=zeros(3,3);
    xi=[0.5,0.5,0]; yi=[0,0.5,0.5]; wi=[1,1,1]/6;
    for l=1:length(wi)
      xl=xi(l); yl=yi(l); wl=wi(l);  
      phi=[1-xl-yl, xl, yl]; 
      elmat = elmat + phi'*phi*wl;
    end
    elmat=elmat*c(k)*Jk;
    elM(:,k)=elmat(:);
    %
    % load vector
    xl=1/3; yl=1/3; wl=0.5;
    phi=[1-xl-yl, xl, yl]; 
    elvec = f(k)*phi'*wl*Jk;
    elF(:,k)=elvec(:);
end

% now assemble at once
t1=t(1,:); t2=t(2,:); t3=t(3,:);
ii=[t1;t2;t3;t1;t2;t3;t1;t2;t3]; 
jj=[t1;t1;t1;t2;t2;t2;t3;t3;t3]; 
%
K=sparse(ii(:),jj(:),elK(:),np,np);
M=sparse(ii(:),jj(:),elM(:),np,np);
%
ii=[t1;t2;t3]; 
F=accumarray(ii(:),elF(:),[np,1]);

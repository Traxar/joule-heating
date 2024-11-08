function [R,G]=myassemr(p,e,d,g)
% [R,G]=myassemr_tb(p,e,d,g)
% assemble finite element matrices
% input:  p ... 2 x np array with point coordinates
%         e ... 7 x ne array with edge info
%         d ... 1 x ne array with coefficients
%         g ... 1 x ne array with coefficients
% output: R ... np x np sparse boundary matrix 
%         G ... np x np sparse boundary vector

np=size(p,2); ne=size(e,2);

% unify coefficients
if isscalar(d), d=d*ones(1,ne); end
if isscalar(g), g=g*ones(1,ne); end
%
elR=zeros(4,ne); elG=zeros(2,ne);
for k=1:ne % loop over elements
    e1=e(1,k);  e2=e(2,k);  de=e2-e1;  Jk=norm(de,2);
    %
    % boundary matrix
    elmat=zeros(2,2);
    xi=[0.0,0.5,1]; wi=[1,4,1]/6;
    for l=1:length(wi)
      xl=xi(l); wl=wi(l);  
      phi=[1-xl, xl]; 
      elmat = elmat + phi'*phi*wl;
    end
    elmat=elmat*d(k)*Jk;
    elR(:,k)=elmat(:); 
    %
    % load vector
    xl=0.5; wl=1; phi=[1-xl, xl]; 
    elvec = g(k)*phi'*wl*Jk;
    elG(:,k)=elvec(:);
end

% now assemble at once
e1=e(1,:); e2=e(2,:); 
ii=[e1;e1;e2;e2]; jj=[e1;e2;e1;e2];
%
R=sparse(ii(:),jj(:),elR(:),np,np);
%
ii=[e1;e2]; 
G=accumarray(ii(:),elG(:),[np,1]);


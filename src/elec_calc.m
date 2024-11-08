function [R,phi] = elec_calc(p,e,t,b,cond)
% [R,phi] = elec_calc(p,e,t,b,cond)
% calculate resistance and potential
% input:    p ... 2 x np array with point coordinates
%           e ... 7 x ne array with edge info
%           t ... 4 x nt array with element info
%           b ... 1 x nb array with boundray info
%           cond ... 1 x nt array with conductivity
% output:   R ... total resistance
%           phi ... 1 x np array with potential with 1V total

pen = 1E10;%penalisation of dirichlet bound
[K,~,F] = myassema(p,t,cond,0,0);
e0 = b(e(5,:))==0;
e2 = b(e(5,:))==2; 
[R0,G0] = myassemr(p,e(:,e0),pen,0);
[R2,G2] = myassemr(p,e(:,e2),pen,pen*1);%1V test voltage

A = K+R0+R2;
b = F+G0+G2;

phi = A\b;

P = phi'*K*phi; %P=U*I=U^2/R
R = 1/P;


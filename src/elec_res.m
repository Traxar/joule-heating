function rho = elec_res(rhoTref,Tref,alpha,beta,T)
% rho = elec_resistivity(rhoTref,Tref,alpha,beta,T)
% resistivity at temperature
% rho = rho20*(1+alpha*(T-T20)+beta*(T-T20)^2)
% input:  rhoTref ... resistivity at reference temperature
%         Tref ... reference temperature
%         alpha ... linear temperature dependence
%         beta ... quadratic temperature dependence
%         Tref ... 1 x nt temperature
% output: rho ... 1 x nt resistivity

n= size(T,2);
if isscalar(rhoTref), rhoTref=rhoTref*ones(1,n); end
if isscalar(Tref), Tref=Tref*ones(1,n); end
if isscalar(alpha), alpha=alpha*ones(1,n); end
if isscalar(beta), beta=beta*ones(1,n); end
Tdiff = T-Tref;
rho = rhoTref.*(1+Tdiff.*(alpha+beta.*Tdiff));


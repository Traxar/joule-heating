function T = elec_measure_temp(rhoTref,Tref,alpha,beta,rho)
% T = elec_measure_temp(rhoTref,Tref,alpha,beta,rho)
% invert temperature dependency of resistivity
% input:  rhoTref ... resistivity at reference temperature
%         Tref ... reference temperature
%         alpha ... linear temperature dependence
%         beta ... quadratic temperature dependence
%         rho ... measured resistivity
% output: T ... temperature
if beta==0
    assert(a~=0);
    T = Tref+(rho-rhoTref)/(alpha*rhoTref);
else
    d = alpha*alpha - 4*beta*(1-rho/rhoTref);
    d = max(d,0);
    s = sign(alpha);
    if s==0
        s = sign(beta);
    end
    T = Tref+(-alpha+s*sqrt(d))/(2*beta);
end

% constants:
Celsius = 273.15;

% material:
% 1.4016
% https://www.trafitechsrl.com/syrtooph/2024/09/1.4016-A-430.pdf
elec = Elec(rho20 = 0.60*10^-6, alpha = 1.39*10^-3, beta = 0);
heat_cond_20 = 25;
heat_dens = 7700;
heat_cap_20 = 460;
heat_cap_alpha = 3.2*10^-4;
heat_cap_beta = 6.6*10^-7;

u0 = 20 + Celsius;

plates_series = 66;
plates_parallel = 1;
s = 0.003;

r_to_R = plates_series/(s*plates_parallel);

%geometry
geom = Geom('boundaries/big.csv',0.01);
for i = 1:0
    geom = geom.refine();
end
if 1
    geom.plot_mesh();
end
np = size(geom.p,2);
nt = size(geom.t,2);

%conversions
ptoe = PtoE(geom);

%resistance at 20C
[elec_r20,~,~] = elec.calc(geom,ptoe,elec.T_ref*ones(1,nt));
elec_R20 = elec_r20*r_to_R;
fprintf('R20 = %d\n',elec_R20);


%initial condition
u = u0 * ones(np,1);

%elementwise temperature
ut = u'*ptoe.avg;

%eval electricity
[elec_r,elec_pot,elec_loss] = elec.calc(geom,ptoe,ut);
elec_R = elec_r*r_to_R;
%measure temperature
T = elec.T(elec_R,elec_R20);


%misc outputs
fprintf('R = %d\n',elec_R);
fprintf('T = %d\n',T-Celsius);
if 0
    geom.plot_pw(elec_pot)
end

if 1
    elec_loss_capped =min(elec_loss, 2*sum(elec_loss.*A)/sum(A));
    geom.plot_ew(elec_loss_capped)
end

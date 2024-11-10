% constants
u0 = 100;

elec = Elec(rho20 = 0.60*10^-6, alpha = 1.39*10^-3, beta = 0);

plates_series = 66;
plates_parallel = 1;

heat_cond_20 = 25;
heat_dens = 7700;
heat_cap_20 = 460;
heat_cap_alpha = 0.15;
heat_cap_beta = 3*10^-4;

s = 0.003;

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

%misc
[Dx,Dy,A,PE] = myassemd(geom.p,geom.t);

%resistance at 20C

[elec_r20,~,~] = elec.calc(geom,Dx,Dy,20*ones(1,nt));
elec_R20 = elec_r20*plates_series/(s*plates_parallel);
fprintf('R20 = %d\n',elec_R20);


%initial condition
u = u0 * ones(np,1);

%elementwise temperature
ut = (PE * u)';

%eval electricity
[elec_r,elec_pot,elec_loss] = elec.calc(geom,Dx,Dy,ut);
elec_R = elec_r*plates_series/(s*plates_parallel);
%measure temperature
T = elec.T(elec_R,elec_R20);


%misc outputs
fprintf('R = %d\n',elec_R);
fprintf('T = %d\n',T);
if 0
    geom.plot_pw(elec_pot)
end

if 1
    elec_loss_capped =min(elec_loss, 2*sum(elec_loss.*A)/sum(A));
    geom.plot_ew(elec_loss_capped)
end

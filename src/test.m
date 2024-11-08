% constants
u0 = 20;
elec_rho20 = 0.60 * 10^-6;
elec_alpha = 1.39 * 10^-3;
elec_beta = 0;

elec_n_series = 66;
elec_n_parallel = 1;

s = 0.003;

%geometry
[g,b] = get_geometry('boundaries/big.csv');
if 1
    pdegplot(g,'FaceLabels','on','EdgeLabels','on');
    pause
end
[p,e,t] = initmesh(g,"Hmax",0.01);
for i = 1:0
    [p,e,t] = refinemesh(g,p,e,t);
end
if 1
    pdemesh(p,e,t);
    pause
end
np = size(p,2);

%initial condition
u = u0 * ones(np,1);

%conversions
[Dx,Dy,A,PE] = myassemd(p,t);

ut = (PE * u)';
cond = 1./elec_res(elec_rho20,20,elec_alpha,elec_beta,ut);
[r,phi] = elec_calc(p,e,t,b,cond);
R = r*elec_n_series/(s*elec_n_parallel);

fprintf('R = %d\n',R);
if 1
    pdeplot(p,e,t,'XYData',phi,'ZData',phi,'ColorMap','jet','Mesh','on');
    grid on; title('uh'); asp = daspect; asp(1:2) = mean(asp(1:2)); daspect(asp);
    pause
end

loss = elec_loss(cond,Dx,Dy,phi);
%fprintf('int(dp) = %d\n',sum(dp'*DA));
%pdeplot(p,e,t,'XYData',dx,'ZData',dx,'ZStyle','discontinuous','ColorMap','jet','Mesh','on');
%grid on; title('dx'); %daspect([1 1 1]);
%pause
%pdeplot(p,e,t,'XYData',dy,'ZData',dy,'ZStyle','discontinuous','ColorMap','jet','Mesh','on');
%grid on; title('dy'); %daspect([1 1 1]);
%pause
if 1
    loss_ =min(loss, 2*sum(loss.*A)/sum(A));
    pdeplot(p,e,t,'XYData',loss_,'XYStyle','flat','ZData',loss_,'ZStyle','discontinuous','ColorMap','jet');
    %pdeplot(p,e,t,'XYData',dp,'ZData',dp,'ZStyle','discontinuous','ColorMap','jet','Mesh','on');
    grid on; title('dp'); asp = daspect; asp(1:2) = mean(asp(1:2)); daspect(asp);
end

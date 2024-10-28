[g,b] = get_geometry('boundaries/big.csv');
pdegplot(g,'FaceLabels','on','EdgeLabels','on');
pause
[p,e,t] = initmesh(g,"Hmax",0.01);
for i = 1:1
    [p,e,t] = refinemesh(g,p,e,t);
end
pdemesh(p,e,t);
pause
[K,~,F] = myassema(p,t,1,1,0);
e0 = find(b(e(5,:))==0);
e2 = find(b(e(5,:))==2);
[R0,G0] = myassemr(p,e(:,e0),1,0);
[R2,G2] = myassemr(p,e(:,e2),1,1);
pen = 1E8;

A = K+pen*(R0+R2);
b = F+pen*(G0+G2);

u = A\b;

P = u'*K*u;
%fprintf('P = %d\n',P);
R = 1/P;
fprintf('R = %d\n',R);
pdeplot(p,e,t,'XYData',u,'ZData',u,'ColorMap','jet','Mesh','on');
grid on; title('uh'); asp = daspect; asp(1:2) = mean(asp(1:2)); daspect(asp);
pause
[DX,DY,DA] = myassemd(p,t);
dx = DX * u;
dy = DY * u;
dp = (dx.*dx + dy.*dy);
%fprintf('int(dp) = %d\n',sum(dp'*DA));
%pdeplot(p,e,t,'XYData',dx,'ZData',dx,'ZStyle','discontinuous','ColorMap','jet','Mesh','on');
%grid on; title('dx'); %daspect([1 1 1]);
%pause
%pdeplot(p,e,t,'XYData',dy,'ZData',dy,'ZStyle','discontinuous','ColorMap','jet','Mesh','on');
%grid on; title('dy'); %daspect([1 1 1]);
%pause
dp_ =min(dp, 5*P/sum(DA));
pdeplot(p,e,t,'XYData',dp_,'XYStyle','flat','ZData',dp_,'ZStyle','discontinuous','ColorMap','jet');
%pdeplot(p,e,t,'XYData',dp,'ZData',dp,'ZStyle','discontinuous','ColorMap','jet','Mesh','on');

grid on; title('dp'); asp = daspect; asp(1:2) = mean(asp(1:2)); daspect(asp);
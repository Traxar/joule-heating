[g,b] = get_geometry('boundaries/hole.csv');
pdegplot(g,'FaceLabels','on','EdgeLabels','on');
pause
[p,e,t] = initmesh(g,"Hmax",0.001);
pdemesh(p,e,t);
[K,~,F] = assema(p,t,1,1,0);
e0 = find(b(e(5,:))==0);
e2 = find(b(e(5,:))==2);
[R0,G0] = myassemr(p,e(:,e0),1,0);
[R2,G2] = myassemr(p,e(:,e2),1,1);
pen = 1E8;

A = K+pen*(R0+R2);
b = F+pen*(G0+G2);

u = A\b;

P = u'*K*u;
R = 1/P;
fprintf('R = %d',R);
pdeplot(p,e,t,'XYData',u,'ZData',u,'ColorMap','jet','Mesh','on');
grid on; title('uh'); daspect([1 1 100])
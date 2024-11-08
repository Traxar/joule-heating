function p = elec_loss(cond,Dx,Dy,phi)
%local loss
dx = (Dx * phi)';
dy = (Dy * phi)';
p = cond.*(dx.*dx + dy.*dy);


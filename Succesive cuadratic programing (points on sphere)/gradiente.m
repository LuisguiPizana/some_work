function [gf] = gradiente(fx,x0)
% Calcula por diferencias hacia adelante el gradiente de 
% fx: R^n --> R
% (gf)_k = parcial de fx / parcial x_k
% Código de clase
% Luis Guillermo Pizaña
% Sofía De la Mora
% (Proyecto 2, pscglobal)

n = length(x0);
gf = zeros(n,1);
ep = 1e-05;
f0 = feval(fx, x0);

for k = 1:n
    xk = x0; 
    xk(k) = xk(k) + ep;
    gf(k) = (feval(fx,xk)-f0)/ep;
end
end
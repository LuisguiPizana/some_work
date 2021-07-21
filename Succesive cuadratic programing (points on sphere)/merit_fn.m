function [phi] = merit_fn(fx, hx, x, Ck)
% funcion de merito L-1 
% Optimizacion numerica
% Proyeto 2
% pcs_global
% Luis Guillermo Pizaña
% Sofia De la Mora
phi = feval(fx,x) + Ck*norm( feval(hx,x),1 );
end
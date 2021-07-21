
function [x,iter] = miregion(fname,x0)
% In
%fname: string con nombre de función
%x0: vector inicial como vector renglon
%Out:
%x: vector que minimiza la función como vector columna
%iter: número de iteraciones antes de parar
%Parametros               %maxregion = 20 
%Deltamin = 10^-4         %tol = 10^-6
%Deltamax = 5             %ra = fname(x)-fname(x+p)
%nu = .25                 %rp = m(0)-m(p)
%maxiter = 100            %ro = ra/rp

%Resuelve el subproblema cuadrático para una delta dada usando el método
%doblez, avanza en esta dirección, ajusta el valor de delta para la 
%siguiente iteración. 

%Luis Guillermo Pizaña Vela
%------------------------------------------

%Parametros
%Los parametros podrían evitarse pero se dejan por claridad.
Deltamin = 1.e-4;
Deltamax = 5;
nu = .25;
maxiter = 100;
tol = 1.e-6;

x = x0;
Delta = 1; %Radio de busqueda
iter = 0;
g = gradiente(fname,x);  %Calculo de gradiente y mat. hess. en punto inical
B = hessian(fname,x);
while norm(g) >= tol && iter < maxiter %mientras no sea el optimo y menos de ciertas iteraciones
    p = doblez(B,g,Delta); % calcula el optimo del prob. restringido por delta.
    ro = (feval(fname,x)-feval(fname, x+p))/(feval(fname,x)-(1/2*(p'*B*p)+g'*p+feval(fname,x)));
    % evalua si es un avance significativo
    if ro >= nu %se modifica x
        x = x+p;
        %disp(x);
        if ro > (1-nu) % aumenta delta ya que se acercó
            Delta = min([Deltamax, 2*Delta]);
        end
        g = gradiente(fname,x);  %Calculo de grad y hess. para nueva x
        B = hessian(fname,x);
    else
        Delta = max([Deltamin, 1/2*Delta]); % Busca en una región mas pequeña
                                            % al rededor del mismo punto
    end
    iter = iter+1;  %Aumenta el número de iteraciones
end
end

function [x, k, Z]= mibfgs(f,x0)
% Método de búsqueda de línea para f: R^n --> R con actualización BFGS
%
% Análisis Aplicado
% ITAM
% 28 de octubre de 2020
%

% parámetros
tol = 1e-04;  % tolerancia  alas cnpo
kmax = 100;   % número máximo de iteraciones
c1 = 1e-02;   % primer condición de Wolfe
k = 0;        % contador de iterciones
Z = [];
% Valores iniciales
 n = length(x0);
 %B = eye(n);         % matriz inicial
 x = x0;
 gx = gradiente(f,x);  % gradiente de f en x
 B = norm(gx)*eye(n);
 while( norm(gx)> tol &&  k < kmax)
    % dirección de descenso: solucipon de/  B*p = -gx 
    p = -B\gx;
    % búsqueda de línea/ primer condición de Wolfe
    fx = feval(f,x);
    jmax = 10; j = 0;
    pen = c1*(gx'*p);
    alfa = 1;
    xn = x +alfa*p; 
    fxn = feval(f,xn);
    while( (fxn > fx + alfa*pen)  && j < jmax  )
       alfa = alfa/2;
       xn = x +alfa*p; 
       fxn = feval(f,xn);
       j = j+1;
    end
    
    
    xp = x + alfa*p;
    gxp = gradiente(f,xp);
    % Actualización de la matriz
    s = xp-x; y = gxp-gx;
    B = B - ((B*s*s'*B)/(s'*B*s)) + ((y*y')/(s'*y));  % fórmula BFGS
    flag = 1;
    if (cond(B) > 1e+04)
        B = eye(n);
        flag = 0;
    end
    
    
    % Actualizar valores
     x = xp;
     gx = gxp;
     k = k+1;
     Z = [Z; norm(gx)];
     fprintf('%2.0f %2.8f %2.0f %2.8f\n', k, norm(gx), flag, alfa) 
 end

end
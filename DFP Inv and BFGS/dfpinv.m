function [x, k, Z]= dfpinv(f,x0)
% Método de búsqueda de línea para f: R^n --> R aproximando la inversa de 
% la hessiana con actualización DFP
%
% Análisis Aplicado
% ITAM
% 
%Luis Antonio Rivera
%Luis Guillermo Pizaña

% parámetros
tol = 1e-04;  % tolerancia  alas cnpo
kmax = 270;   % número máximo de iteraciones
c1 = 1e-02;   % primer condición de Wolfe
k = 0;        % contador de iterciones
Z = [];
% Valores iniciales
 x = x0;
 n = length(x);
 gx = gradiente(f,x);  % gradiente de f en x
 B = speye(n);
 I = speye(n);
 while( (norm(gx)> tol) &&  (k < kmax) )
    % dirección de descenso
    p = -B*gx;
    % búsqueda de línea/ primer condición de Wolfe
    fx = feval(f,x);
    alfa = 1;
    xp = x +alfa*p; 
    m = c1*(gx'*p);
    while(feval(f,xp) > fx + alfa*m)
       alfa = alfa/2;
       xp = x +alfa*p; 
    end
    
    gxp = gradiente(f,xp);
    
    % Actualización de la matriz
    s = xp-x; y = gxp-gx;
    gamma = 1/(s'*y);
    % A la formula DPS le hicimos una modificación en el último termino.
    % Funciona mejor.
    % La formula debe satisfacer B*y = s
    B = ((I - (gamma*s*y'))*B*(I-(gamma*y*s'))) + (gamma*s*y');  
    flag = 1;
    if (cond(B) > 1e+06)
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
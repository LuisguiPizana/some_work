function fx = rosenbrock(x)
% función de Rosenbrock: f: R^2 --> R
%Minimo en [1,1]
%In
% x.- vector de longitud 2
% fx.- número real con el valor de la función.
%  
% ITAM
% Análisis Aplicado
% 12 de agosto de 2020
%---------------------------------------------

fx = 100*(x(2) - x(1)^2)^2 + (1 - x(1))^2;
end
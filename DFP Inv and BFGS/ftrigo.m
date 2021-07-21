function [fx] = ftrigo(x)
% Función f:R^^ --> R con la cosecha del trigo

t = [1:24]';   % línea del tiempo

% datos de la cosecha por año, por tonelada, por hectarea
y = [11.72 13.38 14.1 13.87 14.8 15.58 14.36 16.30 16.91 18.16 18.43 18.7 20.46]; 
y = [y 19.16 20.01 22.41 21.21 22.81 23.97 23.27 23.27 23.8 25.59 24.93 26.59];
y = y';

% función c(t) = x(3)/(1+x(2)*exp(-x(1)*t));

fx = 0;

a = x(1); b = x(2) ; c1 = x(3);

for k = 1:24
    nv = c1/(1+b*exp(-a*t(k)));     %Evaluamos la función
    nv = nv - y(k);                 %Obtenemos el error
    nv = nv*nv;                   %Elevamos al cuadrado
    fx = fx + nv;                   %Actualizamos la suma
end
fx = fx/2;

end
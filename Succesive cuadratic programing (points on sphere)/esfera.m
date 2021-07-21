
% Proyecto 2 Optimización Numérica
%Luis Guillermo Pizana
%Sofia De la Mora 
%Optimizacion Numerica
%Proyecto 2
%05 noviembre 2020
%Se resuelve el problema 'fesfera' sujeto a las restricciones 'hesfera'
%np = 21 puntos.
%Se fija el primer punto en u1 = (1, 0, 0)'
clc;clear all;close all;

% Datos de esfera
figure(1) %se abre la primera figura
n=50; %número de meridiano en la esfera
np=21; %puntos

%Dibujos

sphere(n);
axis equal
hold on

%Graficar puntos
P = randn(3,np); % matriz aleatoria %P(:,j) es vector en R^3
x0 = zeros(3*np,1);
for j=1:np %Normalizar puntos
    v= P(:,j); 
    nv= norm(v);
    P(:,j)=v/nv;
    x(3*(j-1)+1:3*j) = P(:,j);
    plot3(P(1,j), P(2,j), P(3,j), 'rd', 'Linewidth',3)
    hold on
end
title('Puntos en la esfera')

x0 = P(:);

% Llamar funciones
fx = 'fesfera';     % funcion objetivo 
hx = 'hesfera';     % restricciones 

%Llamamos al método 'pcsgblobal' para encontrar el minimo
atime = cputime;
[x,lambda,k] = pcsglobal(fx,hx,x0);
timeA = cputime - atime;

    % Graficamos la esfera y los resultados 
figure(2)
sphere(n) %esfera unitaria 
axis equal %para que plotee efericamente 
hold on %para añadir grafica
z = zeros(3, np);
for k =1:np
    z = x(3*(k-1)+1:3*k);
    plot3(z(1), z(2), z(3),'rd','Linewidth',3)
    hold on
end
title('Minimo obtenido con pcsglobal')


% Ahora la solución pero con Matlab
options.MaxFunctionEvaluations = 1.e+05;
options = optimset('Algorithm','sqp');
mtime = cputime;
[xf, fx, exitflag, output] = fmincon('fesfera',x,[],[],[],[],[],[],'hesfera_matlab');
timeM = cputime - mtime;

%El plot de la solucion de matlab
figure(3)
sphere(n) %esfera unitaria 
axis equal %para que plotee efericamente 
hold on %para añadir grafica
y = zeros(3, np);
for k =1:np
    y = xf(3*(j-1)+1:3*j);
    plot3(y(1), y(2), y(3),'rd','Linewidth',3)
    hold on
end
title('Minimo obtenido con matlab')
%Comparaciones entre pcs_global y fmincon

fprintf('\n\t%s \t\t%s \t\t%s \t\t\t%s \t\t\t\t%s\n' ,'Método', 'Iteraciones','Tiempo', 'f(x)');
fprintf('\t-----------------------------------------------------------------------------------');
fprintf('\n\t%s \t\t%d \t\t\t%.4d  \t%.4d  \t\t%.4d', 'pcs_global', k, timeA, fesfera(x));
fprintf('\n\t%s \t\t%d \t\t\t\t%.4d  \t%.4d  \t\t%.4d', 'fmincon',  output.iterations, timeM,fx);
fprintf('\n');
fprintf('\t-----------------------------------------------------------------------------------');
fprintf('\n');






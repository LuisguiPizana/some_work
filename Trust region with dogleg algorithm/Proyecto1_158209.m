%Proyecto Región de confianza
%Luis Guillermo Pizaña
%158209
disp(" ")

format long;
fname = 'rosenbrock';
x0 = [3.5 4.5]';
tic;
[xf,iter] = miregion(fname,x0);
t2 = toc;
disp("Nombre de la función: ")
disp(fname)
disp(" ")
disp("Mínimo de la función: ")
disp(xf);
disp("Número de iteraciónes: ")
disp(iter);
disp("Tiempo de maquina: ")
disp(t2)



